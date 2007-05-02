Return-Path: <linux-kernel-owner+w=401wt.eu-S1754292AbXEBKlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbXEBKlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 06:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754385AbXEBKlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 06:41:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58327 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbXEBKlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 06:41:21 -0400
Date: Wed, 2 May 2007 12:40:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>, Balbir Singh <balbir@in.ibm.com>
Subject: Re: [patch] CFS scheduler, -v8
Message-ID: <20070502104038.GA11057@elte.hu>
References: <20070501212223.GA29867@elte.hu> <1178092794.8926.43.camel@Homer.simpson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1178092794.8926.43.camel@Homer.simpson.net>
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


* Mike Galbraith <efault@gmx.de> wrote:

> On Tue, 2007-05-01 at 23:22 +0200, Ingo Molnar wrote:
> >  - interactivity: precise load calculation and load smoothing
> 
> This seems to help quite a bit.

great :)

> (5 second top sample)
> 
>  2636 root      15  -5 19148  15m 5324 R   73  1.5   1:42.29 0 amarok_libvisua
>  5440 root      20   0  320m  36m 8388 S   18  3.6   3:28.55 1 Xorg
>  4621 root      20   0 22776  18m 4168 R   12  1.8   0:00.63 1 cc1
>  4616 root      20   0 19456  13m 2200 R    9  1.3   0:00.43 0 cc1
> 
> I no longer have to renice both X and Gforce to achieve a perfect 
> display when they are sharing my box with a make -j2.  X is displaying 
> everything it's being fed beautifully with no help.  I have to renice 
> Gforce (amarok_libvisual), but given it's very heavy CPU usage, that 
> seems perfectly fine.

ah! Besides OpenGL behavior and app startup performance i didnt 
originally have Xorg in mind with this change, but thinking about it, 
precise load calculations and load smoothing does have a positive effect 
on 'coupled' workloads where under the previous variant of CFS's load 
calculation one task component of the workload could become 'invisible' 
to another task and hence cause macro-scale scheduling artifacts not 
expected by humans. With smoothing these are dealt with more 
consistently. Xorg can be a quite strongly coupled workload.

> No regressions noticed so far.  Box is _very_ responsive under load, 
> seemingly even more so than with previous releases.  That is purely 
> subjective, but the first impression was very distinct.

yeah, make -jN workloads (and any mixture of non-identical scheduling 
patterns, which most real workloads consist of) should be handled more 
consistently too by -v8.

so your workload (and Gene's workload) were the ones in fact that i had 
hoped not to _hurt_ with -v8 (neither of you being the hardcore gamer 
type ;), and in reality -v8 ended up helping them too. These sorts of 
side-effects are always welcome ;-)

	Ingo
