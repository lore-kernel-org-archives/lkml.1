Return-Path: <linux-kernel-owner+w=401wt.eu-S1758881AbZE1Ebw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758881AbZE1Ebw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 00:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751039AbZE1Ebm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 00:31:42 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50419 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbZE1Ebl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 00:31:41 -0400
Date: Thu, 28 May 2009 14:31:38 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tony Lindgren <tony@atomide.com>, <linux-omap@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Russell King <rmk@arm.linux.org.uk>,
       Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: linux-next: manual merge of the omap tree with the arm tree
Message-Id: <20090528143138.2de9ad37.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the omap tree got a conflict in
arch/arm/Makefile between commit b4175b89921fefb2f352472fa6dccb0fc4fb37d9
("[ARM] sort machine- and plat- by CONFIG* name") from the arm tree and
commit 68394eae0fc4e801fc2ae33055b24a9754669a7b ("ARM: OMAP4: Add support
for 4430 SDP") from the omap tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/Makefile
index e97c21b,676d10d..0000000
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@@ -99,72 -99,65 +99,73 @@@ CHECKFLAGS	+= -D__arm_
  #Default value
  head-y		:= arch/arm/kernel/head$(MMUEXT).o arch/arm/kernel/init_task.o
  textofs-y	:= 0x00008000
 -
 - machine-$(CONFIG_ARCH_RPC)	   := rpc
 - machine-$(CONFIG_ARCH_EBSA110)	   := ebsa110
 - machine-$(CONFIG_FOOTBRIDGE)	   := footbridge
 - machine-$(CONFIG_ARCH_SHARK)	   := shark
 - machine-$(CONFIG_ARCH_SA1100)	   := sa1100
 -ifeq ($(CONFIG_ARCH_SA1100),y)
 +textofs-$(CONFIG_ARCH_CLPS711X) := 0x00028000
  # SA1111 DMA bug: we don't want the kernel to live in precious DMA-able memory
 - textofs-$(CONFIG_SA1111)	   := 0x00208000
 +ifeq ($(CONFIG_ARCH_SA1100),y)
 +textofs-$(CONFIG_SA1111) := 0x00208000
  endif
 - machine-$(CONFIG_ARCH_PXA)	   := pxa
 - machine-$(CONFIG_ARCH_MMP)	   := mmp
 -    plat-$(CONFIG_PLAT_PXA)	   := pxa
 - machine-$(CONFIG_ARCH_L7200)	   := l7200
 - machine-$(CONFIG_ARCH_INTEGRATOR) := integrator
 - machine-$(CONFIG_ARCH_GEMINI)     := gemini
 - textofs-$(CONFIG_ARCH_CLPS711X)   := 0x00028000
 - machine-$(CONFIG_ARCH_CLPS711X)   := clps711x
 - machine-$(CONFIG_ARCH_IOP32X)	   := iop32x
 - machine-$(CONFIG_ARCH_IOP33X)	   := iop33x
 - machine-$(CONFIG_ARCH_IOP13XX)	   := iop13xx
 -    plat-$(CONFIG_PLAT_IOP)	   := iop
 - machine-$(CONFIG_ARCH_IXP4XX)	   := ixp4xx
 - machine-$(CONFIG_ARCH_IXP2000)    := ixp2000
 - machine-$(CONFIG_ARCH_IXP23XX)    := ixp23xx
 - machine-$(CONFIG_ARCH_OMAP1)	   := omap1
 - machine-$(CONFIG_ARCH_OMAP2)	   := omap2
 - machine-$(CONFIG_ARCH_OMAP3)	   := omap2
 - machine-$(CONFIG_ARCH_OMAP4)	   := omap2
 -    plat-$(CONFIG_ARCH_OMAP)	   := omap
 - machine-$(CONFIG_ARCH_S3C2410)	   := s3c2410 s3c2400 s3c2412 s3c2440 s3c2442 s3c2443
 - machine-$(CONFIG_ARCH_S3C24A0)	   := s3c24a0
 -    plat-$(CONFIG_PLAT_S3C24XX)	   := s3c24xx s3c
 - machine-$(CONFIG_ARCH_S3C64XX)	   := s3c6400 s3c6410
 -    plat-$(CONFIG_PLAT_S3C64XX)	   := s3c64xx s3c
 - machine-$(CONFIG_ARCH_LH7A40X)	   := lh7a40x
 - machine-$(CONFIG_ARCH_VERSATILE)  := versatile
 - machine-$(CONFIG_ARCH_IMX)	   := imx
 - machine-$(CONFIG_ARCH_H720X)	   := h720x
 - machine-$(CONFIG_ARCH_AAEC2000)   := aaec2000
 - machine-$(CONFIG_ARCH_REALVIEW)   := realview
 - machine-$(CONFIG_ARCH_AT91)	   := at91
 - machine-$(CONFIG_ARCH_EP93XX)	   := ep93xx
 - machine-$(CONFIG_ARCH_PNX4008)	   := pnx4008
 - machine-$(CONFIG_ARCH_NETX)	   := netx
 - machine-$(CONFIG_ARCH_NS9XXX)	   := ns9xxx
 - machine-$(CONFIG_ARCH_DAVINCI)	   := davinci
 - machine-$(CONFIG_ARCH_KIRKWOOD)   := kirkwood
 - machine-$(CONFIG_ARCH_KS8695)     := ks8695
 -    plat-$(CONFIG_ARCH_MXC)	   := mxc
 - machine-$(CONFIG_ARCH_MX2)	   := mx2
 - machine-$(CONFIG_ARCH_MX3)	   := mx3
 - machine-$(CONFIG_ARCH_MX1)	   := mx1
 - machine-$(CONFIG_ARCH_ORION5X)	   := orion5x
 -    plat-$(CONFIG_PLAT_ORION)	   := orion
 - machine-$(CONFIG_ARCH_MSM)	   := msm
 - machine-$(CONFIG_ARCH_LOKI)       := loki
 - machine-$(CONFIG_ARCH_MV78XX0)    := mv78xx0
 - machine-$(CONFIG_ARCH_W90X900)    := w90x900
 +
 +# Machine directory name.  This list is sorted alphanumerically
 +# by CONFIG_* macro name.
 +machine-$(CONFIG_ARCH_AAEC2000)		:= aaec2000
 +machine-$(CONFIG_ARCH_AT91)		:= at91
 +machine-$(CONFIG_ARCH_CLPS711X)		:= clps711x
 +machine-$(CONFIG_ARCH_DAVINCI)		:= davinci
 +machine-$(CONFIG_ARCH_EBSA110)		:= ebsa110
 +machine-$(CONFIG_ARCH_EP93XX)		:= ep93xx
 +machine-$(CONFIG_ARCH_GEMINI)		:= gemini
 +machine-$(CONFIG_ARCH_H720X)		:= h720x
 +machine-$(CONFIG_ARCH_INTEGRATOR)	:= integrator
 +machine-$(CONFIG_ARCH_IOP13XX)		:= iop13xx
 +machine-$(CONFIG_ARCH_IOP32X)		:= iop32x
 +machine-$(CONFIG_ARCH_IOP33X)		:= iop33x
 +machine-$(CONFIG_ARCH_IXP2000)		:= ixp2000
 +machine-$(CONFIG_ARCH_IXP23XX)		:= ixp23xx
 +machine-$(CONFIG_ARCH_IXP4XX)		:= ixp4xx
 +machine-$(CONFIG_ARCH_KIRKWOOD)		:= kirkwood
 +machine-$(CONFIG_ARCH_KS8695)		:= ks8695
 +machine-$(CONFIG_ARCH_L7200)		:= l7200
 +machine-$(CONFIG_ARCH_LH7A40X)		:= lh7a40x
 +machine-$(CONFIG_ARCH_LOKI) 		:= loki
 +machine-$(CONFIG_ARCH_MMP)		:= mmp
 +machine-$(CONFIG_ARCH_MSM)		:= msm
 +machine-$(CONFIG_ARCH_MV78XX0)		:= mv78xx0
 +machine-$(CONFIG_ARCH_MX1)		:= mx1
 +machine-$(CONFIG_ARCH_MX2)		:= mx2
 +machine-$(CONFIG_ARCH_MX3)		:= mx3
 +machine-$(CONFIG_ARCH_NETX)		:= netx
 +machine-$(CONFIG_ARCH_NS9XXX)		:= ns9xxx
 +machine-$(CONFIG_ARCH_OMAP1)		:= omap1
 +machine-$(CONFIG_ARCH_OMAP2)		:= omap2
 +machine-$(CONFIG_ARCH_OMAP3)		:= omap2
++machine-$(CONFIG_ARCH_OMAP4)		:= omap2
 +machine-$(CONFIG_ARCH_ORION5X)		:= orion5x
 +machine-$(CONFIG_ARCH_PNX4008)		:= pnx4008
 +machine-$(CONFIG_ARCH_PXA)		:= pxa
 +machine-$(CONFIG_ARCH_REALVIEW)		:= realview
 +machine-$(CONFIG_ARCH_RPC)		:= rpc
 +machine-$(CONFIG_ARCH_S3C2410)		:= s3c2410 s3c2400 s3c2412 s3c2440 s3c2442 s3c2443
 +machine-$(CONFIG_ARCH_S3C24A0)		:= s3c24a0
 +machine-$(CONFIG_ARCH_S3C64XX)		:= s3c6400 s3c6410
 +machine-$(CONFIG_ARCH_SA1100)		:= sa1100
 +machine-$(CONFIG_ARCH_SHARK)		:= shark
 +machine-$(CONFIG_ARCH_STMP378X)		:= stmp378x
 +machine-$(CONFIG_ARCH_STMP37XX)		:= stmp37xx
 +machine-$(CONFIG_ARCH_U300)		:= u300
 +machine-$(CONFIG_ARCH_VERSATILE)	:= versatile
 +machine-$(CONFIG_ARCH_W90X900)		:= w90x900
 +machine-$(CONFIG_FOOTBRIDGE)		:= footbridge
 +
 +# Platform directory name.  This list is sorted alphanumerically
 +# by CONFIG_* macro name.
 +plat-$(CONFIG_ARCH_MXC)		:= mxc
 +plat-$(CONFIG_ARCH_OMAP)	:= omap
 +plat-$(CONFIG_PLAT_IOP)		:= iop
 +plat-$(CONFIG_PLAT_ORION)	:= orion
 +plat-$(CONFIG_PLAT_PXA)		:= pxa
 +plat-$(CONFIG_PLAT_S3C24XX)	:= s3c24xx s3c
 +plat-$(CONFIG_PLAT_S3C64XX)	:= s3c64xx s3c
 +plat-$(CONFIG_ARCH_STMP3XXX)	:= stmp3xxx
  
  ifeq ($(CONFIG_ARCH_EBSA110),y)
  # This is what happens if you forget the IOCS16 line.
