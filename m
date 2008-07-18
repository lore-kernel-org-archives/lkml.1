Return-Path: <linux-kernel-owner+w=401wt.eu-S1760251AbYGRMjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760251AbYGRMjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 08:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757330AbYGRMjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 08:39:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42746 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756725AbYGRMjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 08:39:12 -0400
Date: Fri, 18 Jul 2008 14:38:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: John Keller <jpk@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       takayoshi.kochi@gmail.com, Yinghai Lu <yhlu.kernel@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] x86: Allow MMCONFIG above 4GB on x86_64
Message-ID: <20080718123858.GR6875@elte.hu>
References: <20080709204127.1458.5727.77728@attica.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080709204127.1458.5727.77728@attica.americas.sgi.com>
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


* John Keller <jpk@sgi.com> wrote:

> SGI UV will have MMCFG base addresses that are greater than 4GB (32 
> bits).

> +++ linux-2.6/arch/x86/kernel/acpi/boot.c	2008-07-09 15:25:32.000000000 -0500
> @@ -200,6 +200,7 @@ int __init acpi_parse_mcfg(struct acpi_t
>  	}
>  
>  	memcpy(pci_mmcfg_config, &mcfg[1], config_size);
> +#ifndef CONFIG_X86_64
>  	for (i = 0; i < pci_mmcfg_config_num; ++i) {
>  		if (pci_mmcfg_config[i].address > 0xFFFFFFFF) {
>  			printk(KERN_ERR PREFIX
> @@ -209,6 +210,7 @@ int __init acpi_parse_mcfg(struct acpi_t
>  			return -ENODEV;
>  		}
>  	}
> +#endif

hm. If then it should be enabled very carefully and initially probably 
on a per system (i.e. DMI driven whitelist) basis.

	Ingo
