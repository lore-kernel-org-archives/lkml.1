Return-Path: <linux-kernel-owner+w=401wt.eu-S1764346AbXGYHkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764346AbXGYHkH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 03:40:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762316AbXGYHj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 03:39:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33537 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758347AbXGYHj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 03:39:56 -0400
Date: Wed, 25 Jul 2007 09:39:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Henri Hunnekens <henrihunnekens@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: TSC calibration sometimes not correct with RT patch.
Message-ID: <20070725073949.GB595@elte.hu>
References: <e9f486400707250025k163d34cdk97cf2722db739634@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9f486400707250025k163d34cdk97cf2722db739634@mail.gmail.com>
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


* Henri Hunnekens <henrihunnekens@gmail.com> wrote:

> I've seen that the calbration of the TSC timer was not always done 
> correctly, which resulted in incorrect timers.
> 
> I found out that local_irq_disable is used before the calibration is 
> started. However with the RT patch applied this does not mean that the 
> interrupts are disabled and therefore the calibration may fails when 
> it's interrupted by an interrupt. Correct me if I'm wrong.

local_irq_disable() still disables interrupts, even in PREEMPT_RT. So 
the problem should be elsewhere. Can you see similar problems on .22-rt 
too? The hrt code saw a number of updates there.

	Ingo
