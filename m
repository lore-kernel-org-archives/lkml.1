Return-Path: <linux-kernel-owner+w=401wt.eu-S1757109AbXGJMqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757109AbXGJMqL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 08:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbXGJMoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 08:44:34 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:56646 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755140AbXGJMoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 08:44:09 -0400
Date: Tue, 10 Jul 2007 14:44:42 +0200
From: Adrian Bunk <bunk@stusta.de>
To: dbrownell@users.sourceforge.net
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [2.6 patch] spi.c:scan_boardinfo() mustn't be __init_or_module
Message-ID: <20070710124442.GV3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following section mismatch:

<--  snip  -->

...
  MODPOST vmlinux
WARNING: drivers/built-in.o(.text+0x889735): Section mismatch: reference to .init.text:scan_boardinfo (between 'spi_register_master' and '__unregister')
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc6-mm1/drivers/spi/spi.c.old	2007-07-10 04:17:26.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/spi/spi.c	2007-07-10 04:18:01.000000000 +0200
@@ -302,8 +302,7 @@
  * creates board info from kernel command lines
  */
 
-static void __init_or_module
-scan_boardinfo(struct spi_master *master)
+static void scan_boardinfo(struct spi_master *master)
 {
 	struct boardinfo	*bi;
 	struct device		*dev = master->cdev.dev;

