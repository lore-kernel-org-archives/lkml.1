Return-Path: <linux-kernel-owner+w=401wt.eu-S1759699AbYGPVrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759699AbYGPVrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 17:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756039AbYGPVr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 17:47:28 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:50253 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605AbYGPVr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 17:47:27 -0400
Date: Wed, 16 Jul 2008 16:47:23 -0500
From: Scott Wood <scottwood@freescale.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: linuxppc-dev@ozlabs.org, davej@redhat.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc/ep8248e: Fix compile problem if !CONFIG_FS_ENET
Message-ID: <20080716214722.GA6251@ld0162-tx32.am.freescale.net>
References: <Pine.LNX.4.64.0807160838520.14127@blarg.am.freescale.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0807160838520.14127@blarg.am.freescale.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 08:39:12AM -0500, Kumar Gala wrote:
> If we don't enable FS_ENET we get build issues:
> 
> arch/powerpc/platforms/built-in.o: In function `ep8248e_mdio_probe':
> arch/powerpc/platforms/82xx/ep8248e.c:129: undefined reference to `alloc_mdio_bitbang'
> arch/powerpc/platforms/82xx/ep8248e.c:143: undefined reference to `mdiobus_register'

How is this possible?  CONFIG_EP8248E selects CONFIG_MDIO_BITBANG.

> +#ifdef CONFIG_FS_ENET_MDIO_FCC
>  static void ep8248e_set_mdc(struct mdiobb_ctrl *ctrl, int level)
>  {
>  	if (level)
> @@ -164,6 +165,7 @@ static struct of_platform_driver ep8248e_mdio_driver = {
>  	.probe = ep8248e_mdio_probe,
>  	.remove = ep8248e_mdio_remove,
>  };
> +#endif

This is wrong -- ep8248e doesn't use the FS_ENET_MDIO_FCC code.

-Scott
