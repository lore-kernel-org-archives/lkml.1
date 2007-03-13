Return-Path: <linux-kernel-owner+w=401wt.eu-S1030532AbXCMO5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030532AbXCMO5g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 10:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030581AbXCMO5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 10:57:35 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:24995 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030532AbXCMO5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 10:57:34 -0400
Message-ID: <45F6BEFF.5000109@sw.ru>
Date: Tue, 13 Mar 2007 18:10:55 +0300
From: Kirill Korotaev <dev@sw.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: en-us, en, ru
MIME-Version: 1.0
To: Herbert Poetzl <herbert@13thfloor.at>
CC: Pavel Emelianov <xemul@sw.ru>, Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.osdl.org, menage@google.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/7] RSS controller core
References: <45ED7DEC.7010403@sw.ru> <45ED80E1.7030406@sw.ru> <20070306140036.4e85bd2f.akpm@linux-foundation.org> <45F3F581.9030503@sw.ru> <20070311045111.62d3e9f9.akpm@linux-foundation.org> <20070312010039.GC21861@MAIL.13thfloor.at> <45F51709.1010409@sw.ru> <20070312211111.GB21258@MAIL.13thfloor.at>
In-Reply-To: <20070312211111.GB21258@MAIL.13thfloor.at>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>So what to do when virtual physical limit is hit?
>>OOM-kill current task?
> 
> 
> when the RSS limit is hit, but there _are_ enough
> pages left on the physical system, there is no
> good reason to swap out the page at all
> 
>  - there is no benefit in doing so (performance
>    wise, that is)
> 
>  - it actually hurts performance, and could
>    become a separate source for DoS
> 
> what should happen instead (in an ideal world :)
> is that the page is considered swapped out for
> the guest (add guest penality for swapout), and 
> when the page would be swapped in again, the guest
> takes a penalty (for the 'virtual' page in) and
> the page is returned to the guest, possibly kicking
> out (again virtually) a different page

great. I agree with that.
Just curious why current vserver code kills arbitrary
task in container then?


>>> - accounting and limits have to be consistent
>>>   and should roughly represent the actual used
>>>   memory/swap (modulo optimizations, I can go
>>>   into detail here, if necessary)
>>
>>This is true for current implementation for
>>booth - this patchset ang OpenVZ beancounters.
>>
>>If you sum up the physpages values for all containers
>>you'll get the exact number of RAM pages used.
> 
> 
> hmm, including or excluding the host pages?

depends on whether you will include beanocunter 0 usages or not :)

Kirill
