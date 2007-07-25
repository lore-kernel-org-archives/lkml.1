Return-Path: <linux-kernel-owner+w=401wt.eu-S1762923AbXGYHNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762923AbXGYHNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 03:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754159AbXGYHNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 03:13:09 -0400
Received: from gate.crashing.org ([63.228.1.57]:58731 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944AbXGYHNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 03:13:08 -0400
Subject: Re: [PATCH] powerpc: Pegasos keyboard detection
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Curry <pacman@theworld.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
In-Reply-To: <200707250128.l6P1SWSF1336935@shell01.TheWorld.com>
References: <200707250128.l6P1SWSF1336935@shell01.TheWorld.com>
Content-Type: text/plain
Date: Wed, 25 Jul 2007 17:12:45 +1000
Message-Id: <1185347565.5439.310.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-24 at 21:28 -0400, Alan Curry wrote:
> As of 2.6.22 the kernel doesn't recognize the i8042 keyboard/mouse controller
> on the PegasosPPC. This is because of a feature/bug in the OF device tree:
> the "device_type" attribute is an empty string instead of "8042" as the
> kernel expects. This patch (against 2.6.22.1) adds a secondary detection
> which looks for a device whose *name* is "8042" if there is no device whose
> *type* is "8042".
> 
> Signed-off-by: Alan Curry <pacman@world.std.com>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Note, if there's a volunteer, we could probably turn that code into a
nice table lookup.

Cheers,
Ben.

> --- arch/powerpc/kernel/setup-common.c.orig	2007-07-24 19:04:17.000000000 -0500
> +++ arch/powerpc/kernel/setup-common.c	2007-07-24 19:06:36.000000000 -0500
> @@ -487,6 +487,10 @@ int check_legacy_ioport(unsigned long ba
>  	switch(base_port) {
>  	case I8042_DATA_REG:
>  		np = of_find_node_by_type(NULL, "8042");
> +		/* Pegasos has no device_type on its 8042 node, look for the
> +		 * name instead */
> +		if (!np)
> +			np = of_find_node_by_name(NULL, "8042");
>  		break;
>  	case FDC_BASE: /* FDC1 */
>  		np = of_find_node_by_type(NULL, "fdc");
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev

