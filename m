Return-Path: <linux-kernel-owner+w=401wt.eu-S1755783AbZBXMgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783AbZBXMgj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 07:36:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbZBXMg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 07:36:29 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:53407 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720AbZBXMg2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 07:36:28 -0500
From: "Woodruff, Richard" <r-woodruff2@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Paul Walmsley <paul@pwsan.com>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>
Date: Tue, 24 Feb 2009 06:35:37 -0600
Subject: RE: [PATCH E 11/14] OMAP clock: track child clocks
Thread-Topic: [PATCH E 11/14] OMAP clock: track child clocks
Thread-Index: AcmV0Ftn8oRp4YE8RiWXjwXY//VkKQAq5r2Q
Message-ID: <13B9B4C6EF24D648824FF11BE8967162037AF5CFFF@dlee02.ent.ti.com>
References: <20090128192551.29333.82943.stgit@localhost.localdomain>
 <20090128192756.29333.41541.stgit@localhost.localdomain>
 <20090129151401.GC18233@n2100.arm.linux.org.uk>
 <20090129220608.GJ18233@n2100.arm.linux.org.uk>
 <20090219121932.GL6407@n2100.arm.linux.org.uk>
 <13B9B4C6EF24D648824FF11BE896716203772C3680@dlee02.ent.ti.com>
 <20090223160349.GB27688@n2100.arm.linux.org.uk>
In-Reply-To: <20090223160349.GB27688@n2100.arm.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> From: Russell King - ARM Linux [mailto:linux@arm.linux.org.uk]
> Sent: Monday, February 23, 2009 10:04 AM
> To: Woodruff, Richard

> Ack?

Ack.

> diff --git a/arch/arm/plat-omap/clock.c b/arch/arm/plat-omap/clock.c
> index 08baa18..b2d9e1f 100644
> --- a/arch/arm/plat-omap/clock.c
> +++ b/arch/arm/plat-omap/clock.c
> @@ -144,12 +144,14 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
>               return ret;
>
>       spin_lock_irqsave(&clockfw_lock, flags);
> -     if (arch_clock->clk_set_parent)
> -             ret = arch_clock->clk_set_parent(clk, parent);
> -     if (ret == 0) {
> -             if (clk->recalc)
> -                     clk->rate = clk->recalc(clk);
> -             propagate_rate(clk);
> +     if (clk->usecount == 0) {
> +             if (arch_clock->clk_set_parent)
> +                     ret = arch_clock->clk_set_parent(clk, parent);
> +             if (ret == 0) {
> +                     if (clk->recalc)
> +                             clk->rate = clk->recalc(clk);
> +                     propagate_rate(clk);
> +             }
>       }
>       spin_unlock_irqrestore(&clockfw_lock, flags);
>

