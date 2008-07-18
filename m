Return-Path: <linux-kernel-owner+w=401wt.eu-S1758778AbYGRWZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778AbYGRWZu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 18:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbYGRWZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 18:25:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36971 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbYGRWZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 18:25:41 -0400
Date: Sat, 19 Jul 2008 00:25:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Roman Mindalev <lists@r000n.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Bug #11035] System hangs on 2.6.26-rc8
Message-ID: <20080718222512.GD31073@elte.hu>
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik> <uBi7uNfg81L.A.xt.SzLcIB@albercik> <4878D259.7050403@r000n.net> <487CA8E5.8020208@r000n.net> <20080718071121.GB6875@elte.hu> <19f34abd0807180028y2be61c06ueab5fcc305956f80@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0807180028y2be61c06ueab5fcc305956f80@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> BTW, I didn't consider that argument (of continuing as far as 
> possible) before, but it's a good one; if we don't crash completely, 
> the user can still copy the log we have a better report of it. I guess 
> kerneloops.org is currently missing out a great deal of reports which 
> all shut down the machine immediately without a chance to go into the 
> log.

yes. There are two techniques to improve the 'yield' of kerneloops.org: 
1) make a better job of getting the logs off the box 2) make a better 
job of not crashing the box when we can do better.

For example lockdep tries very hard to never crash the box. It is a 
feature that warns about a chance of a lockup, not about a lockup itself 
- so crashing the box at the point of the bug detection is 
counter-productive.

The same applies to DEBUG_PAGEALLOC as well: technically nobody (but the 
buggy code itself) is hurt by accessing already freed data. So we could 
try and let it run.

(Btw., this might be a way to share a mechanism between kmemcheck and 
DEBUG_PAGEALLOC, and make kmemcheck more useful to the general kernel as 
a whole.)

	Ingo
