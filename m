Return-Path: <linux-kernel-owner+w=401wt.eu-S1752366AbXCPCDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366AbXCPCDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 22:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428AbXCPCDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 22:03:30 -0400
Received: from inet-tsb5.toshiba.co.jp ([202.33.96.24]:55007 "EHLO
	inet-tsb5.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbXCPCD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 22:03:29 -0400
Message-Id: <200703160203.l2G23QGg021264@toshiba.co.jp>
MIME-Version: 1.0
Date: Fri, 16 Mar 2007 11:05:27 +0900
X-Mailer: Denshin 8 Go V32.1.4.5
X-My-Real-Login-Name: a_iguchi; 133.114.92.20
From: Akira Iguchi <akira2.iguchi@toshiba.co.jp>
To: bzolnier@gmail.com, torvalds@linux-foundation.org
Cc: Al Viro <viro@ftp.linux.org.uk>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [PATCH 1/2] scc_pata: dependency fix
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes:
* the dependency of scc_pata on BLK_DEV_IDEDMA_PCI
* incorrect link to ide-core
* move scc_pata from ide/ppc to ide/pci

Signed-off-by: Kou Ishizaki <kou.ishizaki@toshiba.co.jp>
Signed-off-by: Akira Iguchi <akira2.iguchi@toshiba.co.jp>
---

diff -Nrpu -X linux-2.6.21-rc3/Documentation/dontdiff linux-2.6.21-rc3/drivers/ide/Kconfig linux-2.6.21-rc3.mod/drivers/ide/Kconfig
--- linux-2.6.21-rc3/drivers/ide/Kconfig	2007-03-07 13:41:20.000000000 +0900
+++ linux-2.6.21-rc3.mod/drivers/ide/Kconfig	2007-03-16 18:49:04.000000000 +0900
@@ -769,6 +769,14 @@ config BLK_DEV_TC86C001
 	help
 	This driver adds support for Toshiba TC86C001 GOKU-S chip.
 
+config BLK_DEV_CELLEB
+	tristate "Toshiba's Cell Reference Set IDE support"
+	depends on PPC_CELLEB
+	help
+	  This driver provides support for the built-in IDE controller on
+	  Toshiba Cell Reference Board.
+	  If unsure, say Y.
+
 endif
 
 config BLK_DEV_IDE_PMAC
@@ -800,14 +808,6 @@ config BLK_DEV_IDEDMA_PMAC
 	  to transfer data to and from memory.  Saying Y is safe and improves
 	  performance.
 
-config BLK_DEV_IDE_CELLEB
-	bool "Toshiba's Cell Reference Set IDE support"
-	depends on PPC_CELLEB
-	help
-	  This driver provides support for the built-in IDE controller on
-	  Toshiba Cell Reference Board.
-	  If unsure, say Y.
-
 config BLK_DEV_IDE_SWARM
 	tristate "IDE for Sibyte evaluation boards"
 	depends on SIBYTE_SB1xxx_SOC
diff -Nrpu -X linux-2.6.21-rc3/Documentation/dontdiff linux-2.6.21-rc3/drivers/ide/Makefile linux-2.6.21-rc3.mod/drivers/ide/Makefile
--- linux-2.6.21-rc3/drivers/ide/Makefile	2007-03-07 13:41:20.000000000 +0900
+++ linux-2.6.21-rc3.mod/drivers/ide/Makefile	2007-03-16 18:48:02.000000000 +0900
@@ -37,7 +37,6 @@ ide-core-$(CONFIG_BLK_DEV_Q40IDE)	+= leg
 # built-in only drivers from ppc/
 ide-core-$(CONFIG_BLK_DEV_MPC8xx_IDE)	+= ppc/mpc8xx.o
 ide-core-$(CONFIG_BLK_DEV_IDE_PMAC)	+= ppc/pmac.o
-ide-core-$(CONFIG_BLK_DEV_IDE_CELLEB)	+= ppc/scc_pata.o
 
 # built-in only drivers from h8300/
 ide-core-$(CONFIG_H8300)		+= h8300/ide-h8300.o
diff -Nrpu -X linux-2.6.21-rc3/Documentation/dontdiff linux-2.6.21-rc3/drivers/ide/pci/Makefile linux-2.6.21-rc3.mod/drivers/ide/pci/Makefile
--- linux-2.6.21-rc3/drivers/ide/pci/Makefile	2007-03-07 13:41:20.000000000 +0900
+++ linux-2.6.21-rc3.mod/drivers/ide/pci/Makefile	2007-03-16 18:49:05.000000000 +0900
@@ -3,6 +3,7 @@ obj-$(CONFIG_BLK_DEV_AEC62XX)		+= aec62x
 obj-$(CONFIG_BLK_DEV_ALI15X3)		+= alim15x3.o
 obj-$(CONFIG_BLK_DEV_AMD74XX)		+= amd74xx.o
 obj-$(CONFIG_BLK_DEV_ATIIXP)		+= atiixp.o
+obj-$(CONFIG_BLK_DEV_CELLEB)		+= scc_pata.o
 obj-$(CONFIG_BLK_DEV_CMD64X)		+= cmd64x.o
 obj-$(CONFIG_BLK_DEV_CS5520)		+= cs5520.o
 obj-$(CONFIG_BLK_DEV_CS5530)		+= cs5530.o
