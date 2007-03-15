Return-Path: <linux-kernel-owner+w=401wt.eu-S1422820AbXCOFxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422820AbXCOFxd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 01:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422821AbXCOFxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 01:53:33 -0400
Received: from imx9.toshiba.co.jp ([202.33.96.51]:53288 "EHLO
	imx9.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422820AbXCOFxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 01:53:32 -0400
X-Greylist: delayed 1544 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Mar 2007 01:53:32 EDT
Message-Id: <200703150523.l2F5Ne5i017704@toshiba.co.jp>
MIME-Version: 1.0
Date: Thu, 15 Mar 2007 14:25:40 +0900
X-Mailer: Denshin 8 Go V32.1.4.5
X-My-Real-Login-Name: a_iguchi; 133.114.92.20
From: Akira Iguchi <akira2.iguchi@toshiba.co.jp>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: torvalds@linux-foundation.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: (Your message of "Wed, 14 Mar 2007 09:16:34 +0000")
  <E1HRPb0-0003Eh-OG@ZenIV.linux.org.uk>
References: <E1HRPb0-0003Eh-OG@ZenIV.linux.org.uk>
Subject: Re: [PATCH 10/13] BLK_DEV_IDE_CELLEB dependency fix
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al wrote:
>
>It's bool and it depends on IDE => should depend on IDE=y
>
>Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Move to "if BLK_DEV_IDEDMA_PCI" block because it depends on 
BLK_DEV_IDEDMA_PCI.

Signed-off-by: Kou Ishizaki <kou.ishizaki@toshiba.co.jp>
Signed-off-by: Akira Iguchi <akira2.iguchi@toshiba.co.jp>
---

diff -Nrpu -X linux-2.6.21-rc3/Documentation/dontdiff linux-2.6.21-rc3/drivers/ide/Kconfig linux-2.6.21-rc3.mod/drivers/ide/Kconfig
--- linux-2.6.21-rc3/drivers/ide/Kconfig	2007-03-07 13:41:20.000000000 +0900
+++ linux-2.6.21-rc3.mod/drivers/ide/Kconfig	2007-03-15 22:47:14.000000000 +0900
@@ -769,6 +769,14 @@ config BLK_DEV_TC86C001
 	help
 	This driver adds support for Toshiba TC86C001 GOKU-S chip.
 
+config BLK_DEV_IDE_CELLEB
+	bool "Toshiba's Cell Reference Set IDE support"
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

