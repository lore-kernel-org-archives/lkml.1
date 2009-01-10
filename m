Return-Path: <linux-kernel-owner+w=401wt.eu-S1756055AbZAJWp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbZAJWp4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 17:45:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbZAJWps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 17:45:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35847 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599AbZAJWpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 17:45:47 -0500
Date: Sat, 10 Jan 2009 23:45:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Yinghai Lu <yinghai@kernel.org>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] irq: change references from NR_IRQS to nr_irqs
Message-ID: <20090110224523.GB17917@elte.hu>
References: <20090110223818.459493000@polaris-admin.engr.sgi.com> <20090110223818.636427000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090110223818.636427000@polaris-admin.engr.sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> Impact: preparation, cleanup

s/Impact: preparation, cleanup/Impact: preparation, cleanup, add printk

> @@ -160,9 +162,9 @@ struct irq_desc *irq_to_desc_alloc_cpu(u
>  	unsigned long flags;
>  	int node;
>  
> -	if (irq >= NR_IRQS) {
> -		printk(KERN_WARNING "irq >= NR_IRQS in irq_to_desc_alloc: %d %d\n",
> -				irq, NR_IRQS);
> +	if (irq >= nr_irqs) {
> +		printk(KERN_WARNING "irq >= nr_irqs in irq_to_desc_alloc: %d %d\n",
> +				irq, nr_irqs);
>  		WARN_ON(1);
>  		return NULL;

While at it, could you please also convert this to a WARN() construct 
instead? (in a separate commit)

	Ingo
