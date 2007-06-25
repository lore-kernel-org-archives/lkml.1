Return-Path: <linux-kernel-owner+w=401wt.eu-S1756772AbXFYPCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbXFYPCR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 11:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755525AbXFYPCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 11:02:08 -0400
Received: from gateway-a.fh-trier.de ([143.93.54.181]:56607 "EHLO
	gateway-a.fh-trier.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754903AbXFYPCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 11:02:07 -0400
Message-ID: <467FD8E9.1000200@gentoo.org>
Date: Mon, 25 Jun 2007 17:02:01 +0200
From: Alexander Gabert <pappy@gentoo.org>
Organization: Hardened Gentoo Linux
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       Arjan van de Ven <arjan@infradead.org>, libc-alpha@sourceware.org,
       hardened@gentoo.org
Subject: Re: [PATCH] get_random_long() and AT_ENTROPY for auxv, kernel 2.6.21.5
References: <4675C678.3080807@gentoo.org> <1182128803.22999.9.camel@laptopd505.fenrus.org> <20070620203022.GO11166@waste.org> <467EADA0.9020101@gentoo.org> <20070625034508.GE11115@waste.org>
In-Reply-To: <20070625034508.GE11115@waste.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,
sorry for not answering your questions in the first place, i hope this 
did not mean to make a bad impression
Matt Mackall schrieb:
> On Sun, Jun 24, 2007 at 07:45:04PM +0200, Alexander Gabert wrote:
>   
>> Hi Linus,
>> hi LKML,
>>
>> i would like to thank LKML and especially Eric (thanks for the per_cpu 
>> macro tips and design guidelines!) and the other contributors to this idea.
>>
>> This time the patch is rather big because it also removes 
>> get_random_int() and introduces get_random_long() throughout the kernel.
>>     
>
> Stop right there. You still haven't answered my original question.
> What is the point of this exercise in the first place, please?
>
> Am I right in thinking you have three unrelated patches here?
>   
I don't think so but you may be right nonetheless if my opinion.
> - something to do with aux vector headers
>   
Adding the new field
> - something to do with get_random_int repeating itself
>   
Found while adding the new field and testing it.
> - sweeping change of get_random_int to get_random_long for no obvious reason
>   
It is needed for properly initializing a SSP guard which is (afaik) a 
long value.
> These should be three completely separate patches.
>   
Probably ... but bear in mind that the goal is still the same: allowing 
glibc to use SSP with /proc/self/auxv instead of fopen(/dev/urandom) as 
it is now.
Effectively saving three syscalls (open,read,close) and making life 
easier for glibc because randomization "generated" in the kernel does 
not deplete /dev/urandom too much for high coverage SSP userlands (i.e. 
Gentoo Hardened).

I can imagine that Redhat would do the same with the SSP implementation 
in glibc, i think if this patch moves into kernel, they will bring out a 
glibc patch that is checking for AT_ENTROPY and using the opening of 
/dev/urandom for retrieving randomized data as a fallback for machines 
where such a kernel is not available.  This is a win-win situation for 
both sides- the kernel wins because the pressure on /dev/urandom is 
released a bit (applicable to SSP environments) and the glibc wins 
because it has a reliable, fast, cheap and easy to use source for 
randomization.


Thank you,

Alex

