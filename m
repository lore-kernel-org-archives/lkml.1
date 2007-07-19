Return-Path: <linux-kernel-owner+w=401wt.eu-S1765274AbXGSKfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765274AbXGSKfN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:35:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964825AbXGSKYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 06:24:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52278 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938248AbXGSKX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 06:23:58 -0400
Date: Thu, 19 Jul 2007 12:23:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: tglx@linutronix.de, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [5/58] x86_64: Report the pending irq if available in
	smp_affinity
Message-ID: <20070719102350.GA10412@elte.hu>
References: <200707191154.642492000@suse.de> <20070719095449.15A2D14E04@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070719095449.15A2D14E04@wotan.suse.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@suse.de> wrote:

> -	int len = cpumask_scnprintf(page, count, irq_desc[(long)data].affinity);
> +	struct irq_desc *desc = irq_desc + (long)data;
> +	cpumask_t *mask = &desc->affinity;
> +	int len;
> +#ifdef CONFIG_GENERIC_PENDING_IRQ
> +	if (desc->status & IRQ_MOVE_PENDING)

small style nit: please put a newline after the type definitions.

	Ingo
