Return-Path: <linux-kernel-owner+w=401wt.eu-S964893AbZLGSGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964893AbZLGSGF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 13:06:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964859AbZLGSGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 13:06:04 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:52131 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964858AbZLGSGD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 13:06:03 -0500
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [RFC][PATCH 03/10] arm: mxc: changes to common plat-mxc codeto add support for i.MX5
Date: Mon, 7 Dec 2009 11:06:14 -0700
Message-ID: <DE2504B3A515524BBE6934369EFDC0DA08C2A8A7@az33exm20.fsl.freescale.net>
In-Reply-To: <20091204083451.GG15126@pengutronix.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC][PATCH 03/10] arm: mxc: changes to common plat-mxc codeto add support for i.MX5
Thread-Index: Acp0vLRujxf6KpK8R2aUxhw4BZ7pHQCpKtDA
References: <cover.1259893118.git.amit.kucheria@canonical.com> <58eb7d14c6cf56cbc874657dff5789c47116b49e.1259893118.git.amit.kucheria@canonical.com> <DE2504B3A515524BBE6934369EFDC0DA08C2A56C@az33exm20.fsl.freescale.net> <20091204083451.GG15126@pengutronix.de>
From: "Herring Robert-RA7055" <ra7055@freescale.com>
To: "Sascha Hauer" <s.hauer@pengutronix.de>
Cc: "Amit Kucheria" <amit.kucheria@canonical.com>,
       "List Linux Kernel" <linux-kernel@vger.kernel.org>,
       <linux-arm-kernel@lists.infradead.org>, <valentin.longchamp@epfl.ch>,
       <daniel@caiaq.de>, <grant.likely@secretlab.ca>,
       "Nguyen Dinh-R00091" <R00091@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha,

> @@ -296,7 +299,7 @@ void __init mxc_timer_init(struct clk 
> *timer_clk, void __iomem *base, int irq)
>  	__raw_writel(0, timer_base + MXC_TCTL);
>  	__raw_writel(0, timer_base + MXC_TPRER); /* see 
> datasheet note */
>  
> -	if (cpu_is_mx3() || cpu_is_mx25())
> +	if (timer_is_v2())
>  		tctl_val = MX3_TCTL_CLK_IPG | MX3_TCTL_FRR | 
> MX3_TCTL_WAITEN | MXC_TCTL_TEN;

The timer clock input needs to be per_clk, not ipg_clk on MX51. It is
safe to always be set to per_clk because per_clk == ipg_clk on MX31/35
and MX27 IIRC. This makes the clock constant even with cpu and bus
scaling and allows disabling of PLLs.

#define MX3_TCTL_CLK_PER       (2 << 6)

       if (timer_is_v2())
               tctl_val = MX3_TCTL_CLK_PER | MX3_TCTL_FRR |
MX3_TCTL_WAITEN | MXC_TCTL_TEN;

Regards,
Rob
