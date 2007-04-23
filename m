Return-Path: <linux-kernel-owner+w=401wt.eu-S1753000AbXDWPR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbXDWPR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 11:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753544AbXDWPR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 11:17:26 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57669 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752992AbXDWPRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 11:17:25 -0400
Date: Mon, 23 Apr 2007 08:09:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Juliusz Chroboczek <jch@pps.jussieu.fr>, Con Kolivas <kernel@kolivas.org>,
       ck list <ck@vds.kolivas.org>, Bill Davidsen <davidsen@tmr.com>,
       Willy Tarreau <w@1wt.eu>, William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [report] renicing X, cfs-v5 vs sd-0.46
In-Reply-To: <20070423024245.GA8378@elte.hu>
Message-ID: <alpine.LFD.0.98.0704230805510.9964@woody.linux-foundation.org>
References: <20070420140457.GA14017@elte.hu> <200704220155.20856.kernel@kolivas.org>
 <20070421160008.GA28783@elte.hu> <200704220959.34978.kernel@kolivas.org>
 <87647oblx5.fsf@pps.jussieu.fr> <alpine.LFD.0.98.0704221620310.9964@woody.linux-foundation.org>
 <20070423024245.GA8378@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 23 Apr 2007, Ingo Molnar wrote:
> 
> You are completely right in the case of traditional schedulers.

And apparently I'm completely right with CFS too.

> Using CFS-v5, with Xorg at nice 0, the context-switch rate is low:
> 
> procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu------
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
>  2  0      0 472132  13712 178604    0    0     0    32  113  170 83 17  0  0  0
>  2  0      0 472172  13712 178604    0    0     0     0  112  184 85 15  0  0  0
>  2  0      0 472196  13712 178604    0    0     0     0  108  162 83 17  0  0  0
>  1  0      0 472076  13712 178604    0    0     0     0  115  189 86 14  0  0  0

Around 170 context switches per second.

> Renicing X to -10 increases context-switching, but not dramatically so, 
> because it is throttled by CFS:
> 
> procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu------
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
>  4  0      0 475752  13492 176320    0    0     0    64  116 1498 85 15  0  0  0
>  4  0      0 475752  13492 176320    0    0     0     0  107 1488 84 16  0  0  0
>  4  0      0 475752  13492 176320    0    0     0     0  140 1514 86 14  0  0  0
>  4  0      0 475752  13492 176320    0    0     0     0  107 1477 85 15  0  0  0
>  4  0      0 475752  13492 176320    0    0     0     0  122 1498 84 16  0  0  0

Did you even *look* at your own numbers? Maybe you looked at "interrpts". 
The context switch numbers go from 170 per second, to 1500 per second!

If that's not "dramatically so", I don't know what is! Just how many 
orders of magnitude worse does it have to be, to be "dramatic"? Apparently 
one order of magnitude isn't "dramatic"?

So you were wrong. The fact that it was still "usable" is a good 
indication, but how about just admitting that you were wrong, and that 
renicing X is the *WRONG*THING*TO*DO*.

Just don't do it. It's wrong. It was wrong with the old schedulers, it's 
wrong with the new scheduler, it's just WRONG.

It was a hack, and it's a failed hack. And the fact that you don't seem to 
realize that it's a failure, even when your OWN numbers clearly show that 
it's failed, is a bit scary.

		Linus
