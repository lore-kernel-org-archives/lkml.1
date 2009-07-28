Return-Path: <linux-kernel-owner+w=401wt.eu-S1752137AbZG1TJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137AbZG1TJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 15:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbZG1TJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 15:09:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44877 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751320AbZG1TJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 15:09:39 -0400
Date: Tue, 28 Jul 2009 12:08:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
In-Reply-To: <20090728195651.3a402a31@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.01.0907281158120.3186@localhost.localdomain>
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk> <87bpn7mzli.fsf@devron.myhome.or.jp> <20090727115723.1e8de60e@lxorguk.ukuu.org.uk> <873a8iqqgv.fsf@devron.myhome.or.jp> <20090727142303.41096bf5@lxorguk.ukuu.org.uk> <877hxujkuv.fsf@devron.myhome.or.jp>
 <20090727145805.690afe5d@lxorguk.ukuu.org.uk> <87fxci6ub9.fsf@devron.myhome.or.jp> <20090727161424.GA4233@skywalker> <20090727174252.2d987830@lxorguk.ukuu.org.uk> <20090727171213.GB4233@skywalker> <87skgikjr8.fsf@devron.myhome.or.jp>
 <20090727222010.1a5efb7b@lxorguk.ukuu.org.uk> <87r5w19xsb.fsf@devron.myhome.or.jp> <20090728112203.7b70adba@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907280848090.3186@localhost.localdomain> <20090728174213.5e927428@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.01.0907280944150.3186@localhost.localdomain> <20090728180649.596c5412@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907281141070.3186@localhost.localdomain> <20090728195651.3a402a31@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 28 Jul 2009, Alan Cox wrote:
>
> In which case you need the write to be synchronous to the ldisc
> processing. Which is what tty->low_latency = 1 did. That provides your
> required causality.
> 
> So what exactly is the problem.

The problem is that you seem to be arguing against the _nicer_ fix, that 
also makes more conceptual sense, and that doesn't even depend on the 
whole low-latency hackery.

And I don't see why you argue that.

Furthermore, you have been CONTINUALLY arguing that emacs is buggy. 
Without any logic to back that up what-so-ever. You argued that just a few 
minutes ago. 

Why? Why are you making those outlandish claims? What I'm so unhappy about 
is that your whole reaction to it - from the beginning - was to blame 
anything but the patch that caused it, and that it was bisected down to.

Why? Why blame emacs? Why call user land buggy, when the bug was 
introduced by you, and was in the kernel? Why are you fighting it? Why did 
it take so long to admit that all the regressions were kernel problems? 
Why were you trying to dismiss the regression report as a user-land bug 
from the very beginning?

Let me quote one of your first emails as I got cc'd on this thread:

    > > See the thread starting here: ("possible regression with pty.c commit")
    > >    http://lkml.org/lkml/2009/7/11/125
    > 
    > Thanks for the pointer.
    > 
    > Well, I thought we were expected to avoid breaking existing user space, even
    > if that were buggy etc.

    I don't know where you got that idea from. Avoiding breaking user space
    unneccessarily is good but if its buggy you often can't do anything about
    it.

That was you talking to Rafael, who tracks regressions, and trying to
argue that it wasn't a kernel bug (both in the double quoted thing and
in the final one).

And no, that was not a fluke. TODAY, you sent out an email saying that 
EWOUDLBLOCK/EAGAIN would be "correct". Despite me having told you that it 
_clearly_ is not correct, and despite you knowing that it breaks user 
space.

WHY?

Quite frankly, I don't understand why I should even have to bring these 
issues up. You should have tried to fix the problem immediately, without 
arguing against fixing the kernel. Without blaming user space. Without 
making idiotic excuses for bad kernel behavior.

The fact is, breaking regular user applications is simply not acceptable. 
Trying to blame kernel breakage on the app being "buggy" is not ok. And 
arguing for almost a week against fixing it - that's just crazy.

		Linus
