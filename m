Return-Path: <linux-kernel-owner+w=401wt.eu-S1756993AbYB0K6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993AbYB0K6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 05:58:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbYB0K57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 05:57:59 -0500
Received: from cantor.suse.de ([195.135.220.2]:34858 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbYB0K56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 05:57:58 -0500
From: Olaf Hering <olaf@aepfle.de>
To: linux-kernel@vger.kernel.org
Subject: undefined reference to fixed_phy_add, from of_add_fixed_phys
Date: Wed, 27 Feb 2008 11:58:00 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802271158.00453.olaf@aepfle.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

can anyone explain why linking fails?
I dont see whats so special about fixed_phy_add(). 

olaf@lingonberry:/dev/shm/R/linux-2.6.25-rc3> time env LC_ALL=C make -kj8 O=../O-25 vmlinux
  GEN     /dev/shm/R/O-25/Makefile
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  Using /dev/shm/R/linux-2.6.25-rc3 as source for kernel
  CALL    /dev/shm/R/linux-2.6.25-rc3/scripts/checksyscalls.sh
  CHK     include/linux/compile.h
  CALL    /dev/shm/R/linux-2.6.25-rc3/arch/powerpc/kernel/systbl_chk.sh
  CC      arch/powerpc/sysdev/fsl_soc.o
/dev/shm/R/linux-2.6.25-rc3/arch/powerpc/sysdev/fsl_soc.c:153:2: warning: #warning fixed_phy_add
/dev/shm/R/linux-2.6.25-rc3/arch/powerpc/sysdev/fsl_soc.c:153:2: warning: #warning fixed_phy_add
  LD      arch/powerpc/sysdev/built-in.o
  CC      drivers/net/phy/fixed.o
/dev/shm/R/linux-2.6.25-rc3/drivers/net/phy/fixed.c:173:2: warning: #warning fixed_phy_add
/dev/shm/R/linux-2.6.25-rc3/drivers/net/phy/fixed.c:173:2: warning: #warning fixed_phy_add
  LD      drivers/net/phy/built-in.o
  LD      vmlinux.o
  MODPOST vmlinux.o
WARNING: modpost: Found 11 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
  GEN     .version
  CHK     include/linux/compile.h
  UPD     include/linux/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
arch/powerpc/sysdev/built-in.o: In function `of_add_fixed_phys':
(.text+0x124c): undefined reference to `fixed_phy_add'
make[1]: *** [.tmp_vmlinux1] Error 1
make[1]: Target `vmlinux' not remade because of errors.
make: *** [sub-make] Error 2
make: Target `vmlinux' not remade because of errors.

real    0m15.343s
user    0m6.341s
sys     0m3.135s

olaf@lingonberry:/dev/shm/R/linux-2.6.25-rc3> quilt diff
Index: linux-2.6.25-rc3/arch/powerpc/sysdev/fsl_soc.c
===================================================================
--- linux-2.6.25-rc3.orig/arch/powerpc/sysdev/fsl_soc.c
+++ linux-2.6.25-rc3/arch/powerpc/sysdev/fsl_soc.c
@@ -150,7 +150,8 @@ EXPORT_SYMBOL(get_baudrate);
 #endif /* CONFIG_CPM2 */
 
 #ifdef CONFIG_FIXED_PHY
-static int __init of_add_fixed_phys(void)
+#warning fixed_phy_add
+/* static */ int /* __init */ of_add_fixed_phys(void)
 {
        int ret;
        struct device_node *np;
@@ -177,7 +178,9 @@ static int __init of_add_fixed_phys(void
 
        return 0;
 }
+#if 0
 arch_initcall(of_add_fixed_phys);
+#endif
 #endif /* CONFIG_FIXED_PHY */
 
 static int __init gfar_mdio_of_init(void)
Index: linux-2.6.25-rc3/drivers/net/phy/fixed.c
===================================================================
--- linux-2.6.25-rc3.orig/drivers/net/phy/fixed.c
+++ linux-2.6.25-rc3/drivers/net/phy/fixed.c
@@ -170,6 +170,7 @@ int fixed_phy_set_link_update(struct phy
 }
 EXPORT_SYMBOL_GPL(fixed_phy_set_link_update);
 
+#warning fixed_phy_add
 int fixed_phy_add(unsigned int irq, int phy_id,
                  struct fixed_phy_status *status)
 {
