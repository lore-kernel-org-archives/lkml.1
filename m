Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729AbYFBSqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbYFBSqn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 14:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbYFBSqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 14:46:32 -0400
Received: from mailbox2.myri.com ([64.172.73.26]:2004 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751602AbYFBSqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 14:46:31 -0400
X-Greylist: delayed 1695 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Jun 2008 14:46:31 EDT
Message-ID: <4844395C.2010900@myri.com>
Date: Mon, 02 Jun 2008 14:18:04 -0400
From: Loic Prylli <loic@myri.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Brice Goglin <brice@myri.com>
CC: Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       "venkatesh.pallipadi@intel.com" <venkatesh.pallipadi@intel.com>
Subject: Re: howto use ioremap_wc?
References: <4841143E.5080003@myri.com> <20080531185424.1cd18220@infradead.org> <48441F73.5040005@myri.com>
In-Reply-To: <48441F73.5040005@myri.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2008 12:27 PM, Brice Goglin wrote:
> Arjan van de Ven wrote:
>   
>> Ok this leads to a question: since write combining is effectively an
>> extension (eg relaxation) to uncached, how much do you care if you
>> actually get uncached? Eg can you just use the "WC" function even for
>> the case where you get an uncached mapping ?
>>   
>>     
>
> WC is strictly required for our "wcfifo" path,




To be more accurate about the above statement, that codepath will still 
work correctly even if the mapping ends-up being uncached, but that 
could lead to a 16X slowdown on some machines, since that path was 
really designed for the WC case.


Anyway that codepath does not really matter as Brice mentioned 
afterwards :-)



>  but this path is actually
> not so important nowadays. It is disabled by default and might even be
> removed in the future. So, no, myri10ge itself does not really need to
> know whether the mapping is actually WC.
>   




Loic

