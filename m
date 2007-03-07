Return-Path: <linux-kernel-owner+w=401wt.eu-S1030791AbXCGJRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030791AbXCGJRA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 04:17:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030792AbXCGJRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 04:17:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34581 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030791AbXCGJQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 04:16:59 -0500
Date: Wed, 7 Mar 2007 10:16:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tsutomu OWA <tsutomu.owa@toshiba.co.jp>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [patch 4/6 -rt] powerpc 2.6.20-rt8: fix a runtime warnings for xmon
Message-ID: <20070307091638.GC1783@elte.hu>
References: <yyi8xe925vg.wl@toshiba.co.jp> <yyi3b4h25jj.wl@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yyi3b4h25jj.wl@toshiba.co.jp>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Tsutomu OWA <tsutomu.owa@toshiba.co.jp> wrote:

> @@ -342,6 +342,7 @@ static int xmon_core(struct pt_regs *reg
>  
>  	msr = mfmsr();
>  	mtmsr(msr & ~MSR_EE);	/* disable interrupts */
> +	preempt_disable();

i'm not an xmon expert, but maybe it might make more sense to first 
disable preemption, then interrupts - otherwise you could be preempted 
right after having disabled these interrupts (and be scheduled to 
another CPU, etc.). What is the difference between local_irq_save() and 
the above 'disable interrupts' sequence? If it's not the same and 
xmon_core() relied on having hardirqs disabled then it might make sense 
to do a local_irq_save() there, instead of a preempt_disable().

	Ingo
