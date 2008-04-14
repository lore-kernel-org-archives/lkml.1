Return-Path: <linux-kernel-owner+w=401wt.eu-S1762285AbYDNT5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762285AbYDNT5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 15:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760598AbYDNT46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 15:56:58 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:55857 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760439AbYDNT45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 15:56:57 -0400
Date: Mon, 14 Apr 2008 22:55:51 +0300
From: Adrian Bunk <bunk@kernel.org>
To: chris@zankel.net
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] xtensa: don't offer PARPORT_PC
Message-ID: <20080414195551.GE26885@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following compile error:

<--  snip  -->

...
  CC [M]  drivers/parport/parport_pc.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/parport/parport_pc.c:67:25: error: asm/parport.h: No such file or directory
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/parport/parport_pc.c: In function 'parport_pc_find_ports':
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/parport/parport_pc.c:3215: error: implicit declaration of function 'parport_pc_find_nonpci_ports'
make[3]: *** [drivers/parport/parport_pc.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
2a5e7c5402f0f38ab160eca47b905b23d1e71a3d diff --git a/drivers/parport/Kconfig b/drivers/parport/Kconfig
index 209b4a4..0670918 100644
--- a/drivers/parport/Kconfig
+++ b/drivers/parport/Kconfig
@@ -36,7 +36,7 @@ if PARPORT
 config PARPORT_PC
 	tristate "PC-style hardware"
 	depends on (!SPARC64 || PCI) && !SPARC32 && !M32R && !FRV && \
-		(!M68K || ISA) && !MN10300
+		(!M68K || ISA) && !MN10300 && !XTENSA
 	---help---
 	  You should say Y here if you have a PC-style parallel port. All
 	  IBM PC compatible computers and some Alphas have PC-style

