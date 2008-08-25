Return-Path: <linux-kernel-owner+w=401wt.eu-S1754799AbYHYHrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbYHYHrb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 03:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752935AbYHYHrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 03:47:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49755 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561AbYHYHrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 03:47:21 -0400
Date: Mon, 25 Aug 2008 09:47:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: let 64 bit to use 32 bit calibrate_apic_clock
Message-ID: <20080825074704.GA20698@elte.hu>
References: <1219642886-22030-1-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219642886-22030-1-git-send-email-yhlu.kernel@gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> Signed-of-by: Yinghai Lu <yhlu.kernel@gmail.com>

applied to tip/irq/sparseirq - thanks Yinghai.

btw., why was this bit needed:

> @@ -659,6 +575,7 @@ static int __init calibrate_APIC_clock(v
>  	delta = lapic_cal_t1 - lapic_cal_t2;
>  	apic_printk(APIC_VERBOSE, "... lapic delta = %ld\n", delta);
>  
> +#ifdef CONFIG_X86_PM_TIMER
>  	/* Check, if the PM timer is available */
>  	deltapm = lapic_cal_pm2 - lapic_cal_pm1;
>  	apic_printk(APIC_VERBOSE, "... PM timer delta = %ld\n", deltapm);
> @@ -687,6 +604,7 @@ static int __init calibrate_APIC_clock(v
>  		}
>  		pm_referenced = 1;
>  	}
> +#endif

wouldnt this be a (small) fix for the pre-unification 32-bit side as 
well, which we should put into tip/x86/urgent as well?

	Ingo
