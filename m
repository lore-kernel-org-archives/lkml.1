Return-Path: <linux-kernel-owner+w=401wt.eu-S1755888AbYJUU7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbYJUU7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 16:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbYJUU7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 16:59:33 -0400
Received: from gate.crashing.org ([63.228.1.57]:56557 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047AbYJUU7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 16:59:32 -0400
Subject: Re: [PATCH] edac/cell: enable polling mode
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Jens Osterkamp <jens@linux.vnet.ibm.com>
Cc: Doug Thompson <dougthompson@xmission.com>,
       bluesmoke-devel@lists.sourceforge.net, cbe-oss-dev@ozlabs.org,
       arnd@arndb.de, linux-kernel@vger.kernel.org
In-Reply-To: <200810211607.22600.jens@linux.vnet.ibm.com>
References: <200810211607.22600.jens@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Date: Wed, 22 Oct 2008 07:58:54 +1100
Message-Id: <1224622734.7654.273.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-21 at 16:07 +0200, Jens Osterkamp wrote:
> From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> 
> The edac driver on cell turned out to be not enabled because of a missing op_state.
> This patch introduces it. Verified to work on top of Bens next branch.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Jens Osterkamp <jens@linux.vnet.ibm.com>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
> 
> Ben, can you please confirm this is the patch you wanted to send upstream ?

Yes.

> Index: linux-2.6/drivers/edac/cell_edac.c
> ===================================================================
> --- linux-2.6.orig/drivers/edac/cell_edac.c
> +++ linux-2.6/drivers/edac/cell_edac.c
> @@ -9,6 +9,7 @@
>   */
>  #undef DEBUG
>  
> +#include <linux/edac.h>
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/platform_device.h>
> @@ -164,6 +165,8 @@ static int __devinit cell_edac_probe(str
>  	if (regs == NULL)
>  		return -ENODEV;
>  
> +	edac_op_state = EDAC_OPSTATE_POLL;
> +
>  	/* Get channel population */
>  	reg = in_be64(&regs->mic_mnt_cfg);
>  	dev_dbg(&pdev->dev, "MIC_MNT_CFG = 0x%016lx\n", reg);
> ---
> 
> Gruß,
> 
> Jens
> 
> IBM Deutschland Entwicklung GmbH
> Vorsitzender des Aufsichtsrats: Martin Jetter
> Geschäftsführung: Erich Baier 
> Sitz der Gesellschaft: Böblingen
> Registergericht: Amtsgericht Stuttgart, HRB 243294

