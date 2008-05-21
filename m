Return-Path: <linux-kernel-owner+w=401wt.eu-S935480AbYEURlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935480AbYEURlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 13:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932733AbYEURky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 13:40:54 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:53431 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936115AbYEURko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 13:40:44 -0400
Date: Wed, 21 May 2008 20:38:28 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Grant Likely <grant.likely@secretlab.ca>,
       Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@ozlabs.org, "Robert P. J. Day" <rpjday@crashcourse.ca>,
       linux-kernel@vger.kernel.org
Subject: [2.6 patch] powerpc/boot/Makefile CONFIG_ variable fixes
Message-ID: <20080521173828.GA15355@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch corrects the names of two CONFIG_ variables.

Note that the CONFIG_MPC86XADS fix uncovers another bug
(with mpc866_ads_defconfig) that will require fixing:

<--  snip  -->

...
arch/powerpc/boot/dtc -O dtb -o arch/powerpc/boot/mpc866ads.dtb -b 0  /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/powerpc/boot/dts/mpc866ads.dts
DTC: dts->dtb  on file "/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/powerpc/boot/dts/mpc866ads.dts"
  WRAP    arch/powerpc/boot/cuImage.mpc866ads
powerpc64-linux-ld: arch/powerpc/boot/cuboot-mpc866ads.o: No such file: No such file or directory
make[2]: *** [arch/powerpc/boot/cuImage.mpc866ads] Error 1

<--  snip  -->

Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
9a0137fa7d60e7ee62ae4e08e3e5b7d94b66debf diff --git a/arch/powerpc/boot/Makefile b/arch/powerpc/boot/Makefile
index 7822d25..cfb6983 100644
--- a/arch/powerpc/boot/Makefile
+++ b/arch/powerpc/boot/Makefile
@@ -221,8 +221,8 @@ image-$(CONFIG_WARP)			+= cuImage.warp
 image-$(CONFIG_YOSEMITE)		+= cuImage.yosemite
 
 # Board ports in arch/powerpc/platform/8xx/Kconfig
-image-$(CONFIG_PPC_MPC86XADS)		+= cuImage.mpc866ads
-image-$(CONFIG_PPC_MPC885ADS)		+= cuImage.mpc885ads
+image-$(CONFIG_MPC86XADS)		+= cuImage.mpc866ads
+image-$(CONFIG_MPC885ADS)		+= cuImage.mpc885ads
 image-$(CONFIG_PPC_EP88XC)		+= dtbImage.ep88xc
 image-$(CONFIG_PPC_ADDER875)		+= cuImage.adder875-uboot \
 					   dtbImage.adder875-redboot

