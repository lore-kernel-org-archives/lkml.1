Return-Path: <linux-kernel-owner+w=401wt.eu-S1752950AbZHKNZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950AbZHKNZa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 09:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751509AbZHKNZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 09:25:30 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:50017 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbZHKNZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 09:25:29 -0400
Date: Tue, 11 Aug 2009 09:34:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, mingo@redhat.com, hpa@zytor.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] pci/intr_remapping: allocate irq_iommu on node -v2
Message-ID: <20090811073411.GB17476@elte.hu>
References: <4A785C17.3030104@kernel.org> <tip-94fb9a6b49d3a63831c4e752f6f0ab8da0a99eb5@git.kernel.org> <20090809104400.GA1087@elte.hu> <20090810092921.48c3123f@jbarnes-g45> <4A80E2E2.5000208@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A80E2E2.5000208@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

>  static struct irq_2_iommu *irq_2_iommu_alloc(unsigned int irq)
>  {
> -	return irq_2_iommu_alloc_node(irq, cpu_to_node(boot_cpu_id));
> +	int node;
> +
> +#ifdef CONFIG_SMP
> +	node = irq_to_desc(irq)->node;
> +#else
> +	node = cpu_to_node(boot_cpu_id);
> +#endif
> +
> +	return irq_2_iommu_alloc_node(irq, node);
>  }

To avoid the ifdef, shouldnt there be an new irq_node(irq) primitive 
that maps to desc->node on SMP and does the right thing on UP?

	Ingo
