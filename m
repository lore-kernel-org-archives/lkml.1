Return-Path: <linux-kernel-owner+w=401wt.eu-S1755236AbZBRRqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbZBRRqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 12:46:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbZBRRqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 12:46:01 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58279 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449AbZBRRqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 12:46:00 -0500
Date: Wed, 18 Feb 2009 18:45:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       Fenghua Yu <fenghua.yu@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: use dev_printk in quirk message
Message-ID: <20090218174543.GA19314@elte.hu>
References: <20090218161957.12773.31822.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090218161957.12773.31822.stgit@bob.kio>
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


* Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> This patch changes a VIA PCI quirk to use dev_info() rather than printk().
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> ---
>  arch/x86/kernel/pci-dma.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
> index b254285..022833b 100644
> --- a/arch/x86/kernel/pci-dma.c
> +++ b/arch/x86/kernel/pci-dma.c
> @@ -290,8 +290,7 @@ fs_initcall(pci_iommu_init);
>  static __devinit void via_no_dac(struct pci_dev *dev)
>  {
>  	if ((dev->class >> 8) == PCI_CLASS_BRIDGE_PCI && forbid_dac == 0) {
> -		printk(KERN_INFO
> -			"PCI: VIA PCI bridge detected. Disabling DAC.\n");
> +		dev_info(&dev->dev, "disabling DAC on VIA PCI bridge\n");
>  		forbid_dac = 1;
>  	}
>  }

that's one for Jesse i think - Cc:-ed him.

	Ingo
