Return-Path: <linux-kernel-owner+w=401wt.eu-S1754284AbYIYKUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284AbYIYKUn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 06:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752910AbYIYKUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 06:20:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39994 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705AbYIYKUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 06:20:34 -0400
Date: Thu, 25 Sep 2008 12:20:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 3/3] x86/iommu: use __GFP_ZERO instead of memset for
	GART
Message-ID: <20080925102012.GA13631@elte.hu>
References: <1222337635-28285-1-git-send-email-joerg.roedel@amd.com> <1222337635-28285-4-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222337635-28285-4-git-send-email-joerg.roedel@amd.com>
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


* Joerg Roedel <joerg.roedel@amd.com> wrote:

>  #ifdef CONFIG_IOMMU_LEAK
>  	if (leak_trace) {
> -		iommu_leak_tab = (void *)__get_free_pages(GFP_KERNEL,
> +		iommu_leak_tab = (void *)__get_free_pages(GFP_KERNEL|__GFP_ZERO,
>  				  get_order(iommu_pages*sizeof(void *)));
> -		if (iommu_leak_tab)
> -			memset(iommu_leak_tab, 0, iommu_pages * 8);
>  		else
>  			printk(KERN_DEBUG
>  			       "PCI-DMA: Cannot allocate leak trace area\n");

hm, that looks broken.

	Ingo
