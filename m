Return-Path: <linux-kernel-owner+w=401wt.eu-S1755507AbXEFBIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbXEFBIe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 21:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755510AbXEFBIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 21:08:34 -0400
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:46496 "EHLO
	nlpi001.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755507AbXEFBId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 21:08:33 -0400
X-ORBL: [67.117.73.34]
Date: Sat, 5 May 2007 18:08:05 -0700
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH 4/10] ARM: OMAP: gpio init section cleanups
Message-ID: <20070506010804.GA7091@atomide.com>
References: <11761524713580-git-send-email-tony@atomide.com> <1176152483689-git-send-email-tony@atomide.com> <11761524911912-git-send-email-tony@atomide.com> <1176152494436-git-send-email-tony@atomide.com> <11761525022200-git-send-email-tony@atomide.com> <20070505100426.GA9943@flint.arm.linux.org.uk> <20070505102850.GA22729@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
In-Reply-To: <20070505102850.GA22729@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

* Russell King <rmk+lkml@arm.linux.org.uk> [070505 03:29]:
> On Sat, May 05, 2007 at 11:04:26AM +0100, Russell King wrote:
> > On Mon, Apr 09, 2007 at 05:01:06PM -0400, Tony Lindgren wrote:
> > > From: David Brownell <dbrownell@users.sourceforge.net>
> > > 
> > > Minor GPIO cleanups:  remove needless #include, and omap_gpio_init()
> > > should be __init, as well as all the board init code calling it.
> > > 
> > > Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> > > Signed-off-by: Tony Lindgren <tony@atomide.com>
> > 
> > I've applied 8 patches from this series by cherry picking it from your
> > git tree, minus this patch which git wouldn't apply due to fuzz in
> > arch/arm/plat-omap/gpio.c.

I wonder what causes the fuzz? Do you have your git tree somewhere
so I can update this patch against it?

> Incidentally, when doing a build after these patches, I'm seeing:
> 
> arch/arm/plat-omap/dma.c: In function `omap_get_dma_src_pos':
> arch/arm/plat-omap/dma.c:750: warning: 'offset' might be used uninitialized in this function
> arch/arm/plat-omap/dma.c: In function `omap_get_dma_dst_pos':
> arch/arm/plat-omap/dma.c:772: warning: 'offset' might be used uninitialized in this function
> 
> These look like they're valid warnings to me.

Thanks for letting me know, here's a patch to fix the wardning.

Regards,

Tony

--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="patch-fix-dma-addr-warning.txt"

Subject: ARM: OMAP: Fix warning in dma.c

Fix warning: 'offset' might be uninitialized

Signed-off-by: Tony Lindgren <tony@atomide.com>

--- a/arch/arm/plat-omap/dma.c
+++ b/arch/arm/plat-omap/dma.c
@@ -747,7 +747,7 @@ int omap_set_dma_callback(int lch,
  */
 dma_addr_t omap_get_dma_src_pos(int lch)
 {
-	dma_addr_t offset;
+	dma_addr_t offset = 0;
 
 	if (cpu_class_is_omap1())
 		offset = (dma_addr_t) (OMAP1_DMA_CSSA_L_REG(lch) |

--9amGYk9869ThD9tj--
