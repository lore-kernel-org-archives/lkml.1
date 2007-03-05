Return-Path: <linux-kernel-owner+w=401wt.eu-S933194AbXCEL7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933194AbXCEL7o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 06:59:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933236AbXCEL7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 06:59:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33878 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933194AbXCEL7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 06:59:43 -0500
Date: Mon, 5 Mar 2007 12:51:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc2-git3 soft lockup detected on CPU#0 (crash dump kernel)
Message-ID: <20070305115111.GA10675@elte.hu>
References: <1173022668.24738.141.camel@localhost.localdomain> <6bffcb0e0703040828j46a339c2ofabf7c0e20f6ae09@mail.gmail.com> <1173026442.24738.143.camel@localhost.localdomain> <6bffcb0e0703040847g1c04940bm4c22895ec2540bd1@mail.gmail.com> <1173027823.24738.156.camel@localhost.localdomain> <6bffcb0e0703040915h442b4d6cq8bb47cd961165916@mail.gmail.com> <20070305080824.GA20583@elte.hu> <1173090869.24738.198.camel@localhost.localdomain> <20070305103141.GA18404@elte.hu> <6bffcb0e0703050347j5169c672g19996d5c76707123@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bffcb0e0703050347j5169c672g19996d5c76707123@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> >also below is a softlockup-debug patch that might be useful, which adds
> >a tick/tock output so it spams the console once per second but can show
> >the dynamics of lockups (and other delays).
> 
> I have applied this patch
> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc2-git3-kdump/log3.txt

thanks. It seems that the 'BUG: soft lockup detected' message does not 
occur in this log though - and that there are bootup messages between 
the two sysrq outputs:

[  221.101833] skge eth1: disabling interface
[  228.740911] audit(1173094442.943:11): user pid=3245 uid=0 
auid=4294967295 subj=system_u:system_r:hwclock_t:s0 msg='changing system 
time: exe="/sbin/hwclock"
(hostname=?, addr=?, terminal=console res=success)'
[  233.148571] md: md1 in immediate safe mode

plus there's trouble with irq 10:

[  132.013194] irq 10: nobody cared (try booting with the "irqpoll" option)
[  132.072771] Disabling IRQ #10

that prompted you to enable irqpoll, right? So am i right that without 
irqpoll there's no lockup?

	Ingo
