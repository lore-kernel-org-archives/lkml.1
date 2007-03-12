Return-Path: <linux-kernel-owner+w=401wt.eu-S965369AbXCLJAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965369AbXCLJAI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 05:00:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965379AbXCLJAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 05:00:08 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:46678 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965369AbXCLJAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 05:00:06 -0400
Message-ID: <45F51709.1010409@sw.ru>
Date: Mon, 12 Mar 2007 12:02:01 +0300
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Herbert Poetzl <herbert@13thfloor.at>
CC: Andrew Morton <akpm@linux-foundation.org>, Kirill Korotaev <dev@sw.ru>,
       containers@lists.osdl.org, menage@google.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/7] RSS controller core
References: <45ED7DEC.7010403@sw.ru> <45ED80E1.7030406@sw.ru> <20070306140036.4e85bd2f.akpm@linux-foundation.org> <45F3F581.9030503@sw.ru> <20070311045111.62d3e9f9.akpm@linux-foundation.org> <20070312010039.GC21861@MAIL.13thfloor.at>
In-Reply-To: <20070312010039.GC21861@MAIL.13thfloor.at>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Maybe you have some ideas how we can decide on this?
>> We need to work out what the requirements are before we can 
>> settle on an implementation.
> 
> Linux-VServer (and probably OpenVZ):
> 
>  - shared mappings of 'shared' files (binaries 
>    and libraries) to allow for reduced memory
>    footprint when N identical guests are running

This is done in current patches.

>  - virtual 'physical' limit should not cause
>    swap out when there are still pages left on
>    the host system (but pages of over limit guests
>    can be preferred for swapping)

So what to do when virtual physical limit is hit?
OOM-kill current task?

>  - accounting and limits have to be consistent
>    and should roughly represent the actual used
>    memory/swap (modulo optimizations, I can go
>    into detail here, if necessary)

This is true for current implementation for
booth - this patchset ang OpenVZ beancounters.

If you sum up the physpages values for all containers
you'll get the exact number of RAM pages used.

>  - OOM handling on a per guest basis, i.e. some
>    out of memory condition in guest A must not
>    affect guest B

This is done in current patches.

Herbert, did you look at the patches before
sending this mail or do you just want to
'take part' in conversation w/o understanding
of hat is going on?

> HTC,
> Herbert
> 
>> Sigh.  Who is running this show?   Anyone?
>>
>> You can actually do a form of overcommittment by allowing multiple
>> containers to share one or more of the zones. Whether that is
>> sufficient or suitable I don't know. That depends on the requirements,
>> and we haven't even discussed those, let alone agreed to them.
>>
>> _______________________________________________
>> Containers mailing list
>> Containers@lists.osdl.org
>> https://lists.osdl.org/mailman/listinfo/containers
> 

