Return-Path: <linux-kernel-owner+w=401wt.eu-S1752972AbXFNSD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972AbXFNSD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 14:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750915AbXFNSDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 14:03:19 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:50438 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771AbXFNSDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 14:03:18 -0400
X-Greylist: delayed 1613 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Jun 2007 14:03:18 EDT
Date: Thu, 14 Jun 2007 20:36:23 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
To: Olaf Hering <olaf@aepfle.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Antonino Daplas <adaplas@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: mach64 breakage in 2.6.22
Message-ID: <20070614173623.GA7950@sci.fi>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org> <20070614082528.GA10284@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070614082528.GA10284@aepfle.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 10:25:28AM +0200, Olaf Hering wrote:
> On Sat, May 05, Andrew Morton wrote:
> 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm1/
> 
> > +atyfb-reorganize-clock-init.patch
> 
> This change breaks the display on an ibook1 with 800x600 lcd.

Are you sure? I would expect
atyfb-halve-xclk-with-mobility-and-32bit-memory.patch to cause more
problems.

> It is commit b4e124c138558a0cff51398ddff9a8e44ed0b529 in 2.6.22-rc4.
> The used config is arch/powerpc/configs/pmac32_defconfig
> 
> It seems that the recognized display width is only 640, the remain space
> up to 800 is repeated with the content from colum 0. The chars around
> colum 640 are mostly garbage.
> 
> .....
> atyfb: using auxiliary register aperture
> atyfb: 3D RAGE Mobility L (Mach64 LN, AGP 2x) [0x4c4e rev 0x64]
> atyfb: 4M SDRAM (2:1) (32-bit), 14.31818 MHz XTAL, 230 MHz PLL, 70 Mhz MCLK, 27 MHz XCLK

This seems to confirm my suspicion.

Please try this patch:

---
 drivers/video/aty/atyfb_base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.22-rc2/drivers/video/aty/atyfb_base.c
===================================================================
--- linux-2.6.22-rc2.orig/drivers/video/aty/atyfb_base.c
+++ linux-2.6.22-rc2/drivers/video/aty/atyfb_base.c
@@ -2295,7 +2295,7 @@ static int __devinit aty_init(struct fb_
 	 * and set the frequency manually. */
 	if (machine_is_compatible("PowerBook2,1")) {
 		par->pll_limits.mclk = 70;
-		par->pll_limits.xclk = 53;
+		par->pll_limits.xclk = 106;
 	}
 #endif
 
-- 
Ville Syrjälä
syrjala@sci.fi
http://www.sci.fi/~syrjala/
