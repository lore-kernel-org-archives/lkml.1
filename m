Return-Path: <linux-kernel-owner+w=401wt.eu-S932182AbXGKU5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182AbXGKU5N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 16:57:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932913AbXGKU4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 16:56:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58624 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932794AbXGKU4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 16:56:51 -0400
Date: Wed, 11 Jul 2007 22:55:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [patch] CFS scheduler, -v19
Message-ID: <20070711205556.GA27266@elte.hu>
References: <20070706173319.GA2356@elte.hu> <1184054902.12336.19.camel@Homer.simpson.net> <469512C1.6090406@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469512C1.6090406@tmr.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Bill Davidsen <davidsen@tmr.com> wrote:

> > I've taken mainline git tree (freshly integrated CFS!) out for a 
> > multimedia spin.  I tested watching movies and listenign to music in 
> > the presence of various sleep/burn loads, pure burn loads, and mixed 
> > loads. All was peachy here.. I saw no frame drops or sound skips or 
> > other artifacts under any load where the processor could possibly 
> > meet demand.
>
> I would agree with preliminary testing, save that if you get a lot of 
> processes updating the screen at once, there seems to be a notable 
> case of processes getting no CPU for 100-300ms, followed by a lot of 
> CPU.
> 
> I see this clearly with the "glitch1" test with four scrolling xterms 
> and glxgears, but also watching videos with little busy processes on 
> the screen. The only version where I never see this in test or with 
> real use is cfs-v13.

just as a test, does this go away if you:

	renice -20 pidof `Xorg`

i.e. is this connected to the way X is scheduled?

Another thing to check would be whether it goes away if you set the 
granularity to some really finegrained value:

    echo 0 > /proc/sys/kernel/sched_wakeup_granularity_ns
    echo 500000 > /proc/sys/kernel/sched_granularity_ns

this really pushes things - but it tests the theory whether this is 
related to granularity.

	Ingo
