Return-Path: <linux-kernel-owner+w=401wt.eu-S1755070AbYC1RTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070AbYC1RTt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 13:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753829AbYC1RTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 13:19:40 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:40260 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719AbYC1RTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 13:19:40 -0400
Message-ID: <47ED289D.3020607@freescale.com>
Date: Fri, 28 Mar 2008 12:19:25 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: York Sun <yorksun@freescale.com>
CC: linux-fbdev-devel@lists.sourceforge.net, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       galak@kernel.crashing.org, a.p.zijlstra@chello.nl,
       Timur Tabi <timur@freescale.com>
Subject: Re: [PATCH 2/2 v4] Add DIU platform code for MPC8610HPCD
References: <12066720572512-git-send-email-yorksun@freescale.com> <12066720572314-git-send-email-yorksun@freescale.com> <1206672058321-git-send-email-yorksun@freescale.com>
In-Reply-To: <1206672058321-git-send-email-yorksun@freescale.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

York Sun wrote:
> +	np = of_find_compatible_node(NULL, NULL, "fsl,fpga-pixis");
> +	if (np) {
> +		of_address_to_resource(np, 0, &r);
> +		of_node_put(np);
> +		pixis_bdcfg0 = ioremap(r.start + 0x00000008, sizeof(u8));
> +		if (!pixis_bdcfg0) {
> +			printk(KERN_ERR "Err: can't map FPGA cfg register!\n");
> +			return;
> +		}
> +		pixis_arch = ioremap(r.start + 0x00000001, sizeof(u8));
> +		if (!pixis_arch) {
> +			printk(KERN_ERR "Err: can't map FPGA arch register!\n");
> +			return;
> +		}

Just of_iomap() the whole resource, rather than doing it a byte at a time.

> +int __init preallocate_diu_videomemory(void)
> +{
> +	pr_debug("diu_size=%lu\n", diu_ops.diu_size);
> +
> +	diu_ops.diu_mem = __alloc_bootmem(diu_ops.diu_size, 8, 0);
> +	if (!diu_ops.diu_mem) {
> +		printk(KERN_ERR "fsl-diu: cannot allocate %lu bytes\n",
> +			diu_ops.diu_size);
> +		return -ENOMEM;
> +	}
> +
> +	printk(KERN_INFO "%s: diu_mem=%p\n", __func__, diu_ops.diu_mem);

The pr_debug line is more useful information than the KERN_INFO line...

-Scott
