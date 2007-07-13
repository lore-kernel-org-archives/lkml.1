Return-Path: <linux-kernel-owner+w=401wt.eu-S1762230AbXGMQgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762230AbXGMQgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 12:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761847AbXGMQf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 12:35:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761713AbXGMQf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 12:35:58 -0400
Message-ID: <4697A9E9.3090502@redhat.com>
Date: Fri, 13 Jul 2007 12:35:53 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Etienne Lorrain <etienne_lorrain@yahoo.fr>
CC: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: x86 setup code rewrite in C - revised
References: <526073.18540.qm@web26902.mail.ukl.yahoo.com>
In-Reply-To: <526073.18540.qm@web26902.mail.ukl.yahoo.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2007 10:25 AM, Etienne Lorrain wrote:

[ Added back cc:'s]

> On Thu, 12 Jul 2007, Linus Torvalds wrote:
>> On Thu, 12 Jul 2007, Andrew Morton wrote:
>>> This code has been in -mm since 11 May, as git-newsetup.patch.  It has
>>> caused (for what it is) astonishingly few problems.  Maybe a couple of
>>> build glitches and one runtime failure, all quickly fixed.
>>>
>>> I'd say it's ready.
>> Ok. That makes it easy. I'll just merge it.
>>
>> 		Linus
> 
>  Have fun, this code:
>  - do not open the fast A20 gate before checking if the slow A20 gate is open or closed.
>  - uses in asm("") inputs which may or may not be set by the compiler in the stack,
>    after modifying the stack pointer in the asm block: at least has_eflag()
>  - The VGA recalc has the same bug as the assembly version where a VGA write protected
>    register is written (Overflow register) without setting the enable bit (see VGA docs).
>  - Does not save and restore %ds when printing a char on the screen (%ds is destroyed
>    only when the content of the screen scroll - only for some video cards)
>  - Has a "dn" for outl() which sliped in instead of "dN"
>  and probably few other problems - just seen those by reading the patches (the asm("")
>  are inlined in the C code - I find it more difficult to check).
> 
>  Also, I do not know if "m" is right in here:
> static inline u8 rdfs8(addr_t addr)
> {
> 	u8 v;
> 	asm("movb %%fs:%1,%0" : "=r" (v) : "m" (*(u8 *)addr));
> 	return v;
> }
> 
>   I may repeat me, but to find these kind of problems, it is very nice to have an ELF
>  file to do a readelf/objdump -D -m i8086 (even after final link).
