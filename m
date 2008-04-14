Return-Path: <linux-kernel-owner+w=401wt.eu-S1761195AbYDNOT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761195AbYDNOT1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 10:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760782AbYDNOR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 10:17:58 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:41764 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758548AbYDNOR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 10:17:58 -0400
Date: Mon, 14 Apr 2008 17:16:53 +0300
From: Adrian Bunk <bunk@kernel.org>
To: hskinnemoen@atmel.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] avr32: don't offer PARPORT_PC
Message-ID: <20080414141653.GE6695@cs181133002.pp.htv.fi>
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
3b0a3cafbbc80f3feb3644c02198002157f52f68 diff --git a/drivers/parport/Kconfig b/drivers/parport/Kconfig
index b7bcdcc..209b4a4 100644
--- a/drivers/parport/Kconfig
+++ b/drivers/parport/Kconfig
@@ -36,7 +36,7 @@ if PARPORT
 config PARPORT_PC
 	tristate "PC-style hardware"
 	depends on (!SPARC64 || PCI) && !SPARC32 && !M32R && !FRV && \
-		(!M68K || ISA) && !MN10300
+		(!M68K || ISA) && !MN10300 && !AVR32
 	---help---
 	  You should say Y here if you have a PC-style parallel port. All
 	  IBM PC compatible computers and some Alphas have PC-style

