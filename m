Return-Path: <linux-kernel-owner+w=401wt.eu-S965780AbXEGQax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965780AbXEGQax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 12:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965764AbXEGQax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 12:30:53 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38683 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965760AbXEGQaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 12:30:52 -0400
Date: Mon, 7 May 2007 09:28:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Esben Nielsen <nielsen.esben@googlemail.com>
cc: Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v8
In-Reply-To: <Pine.LNX.4.64.0705071159530.14011@frodo.shire>
Message-ID: <alpine.LFD.0.98.0705070921390.3802@woody.linux-foundation.org>
References: <20070501212223.GA29867@elte.hu> <463854F3.3020403@linux.vnet.ibm.com>
 <20070502100545.GA6857@elte.hu> <46386F2B.9050307@linux.vnet.ibm.com>
 <20070502111742.GA18132@elte.hu> <Pine.LNX.4.64.0705051016420.12880@frodo.shire>
 <alpine.LFD.0.98.0705051040420.3819@woody.linux-foundation.org>
 <Pine.LNX.4.64.0705071159530.14011@frodo.shire>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 7 May 2007, Esben Nielsen wrote:
> 
> What is (long)(a-b) ? I have tried to look it up in the C99 standeard but I
> can't find it. Maybe it is in the referred LIA-1 standeard, which I can't find
> with google.

I don't worry about non-2's-complement machines (they don't exist, and 
likely won't exist in the future either).

So I worry about compilers rewriting my code.

So "(long)(a-b) < 0" (with "a" and "b" being unsigned long) is basically a 
portable way of testing the high bit of the result.

> I think the best would be to use "a-b > ULONG_MAX/2" when you mean "a<b" as
> that should be completely portable.

That certainly works too, but the difference is irrelevant, since Linux is 
unlikely to work on insane machines anyway (ie we do make a lot of other 
assumptions about the architecture, being two's-complement is the least of 
those).

So you basically shouldn't worry about hardware: everybody is pretty much 
the same. You should worry about *compilers* - that's where the 
differences show up.

So "(long)(a-b)" may be "implementation defined" (but since 
implementations are all 2's complement, we don't care), but a signed 
"(a-b)" that over/overflows is *undefined*, and that is much worse because 
it means that the compiler can do some funky stuff, and _that_ is a real 
practical worry.

And no, I also don't worry about porting Linux to 18-bit machines, or to 
ternary CPU's.  

			Linus
