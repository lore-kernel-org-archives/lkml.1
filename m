Return-Path: <linux-kernel-owner+w=401wt.eu-S1758762AbYG1UR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762AbYG1UR5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 16:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbYG1URt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 16:17:49 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:44791 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbYG1URs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 16:17:48 -0400
Date: Mon, 28 Jul 2008 23:17:05 +0300
From: Adrian Bunk <bunk@kernel.org>
To: lethal@linux-sh.org, Yusuke Goda <goda.yusuke@renesas.com>,
       Magnus Damm <damm@igel.co.jp>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] SH_AP325RXA must select I2C
Message-ID: <20080728201705.GC7713@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following build error:

<--  snip  -->

...
  LD      vmlinux
arch/sh/boards/renesas/ap325rxa/built-in.o: In function `camera_set_capture':
setup.c:(.text+0x80): undefined reference to `i2c_get_adapter'
setup.c:(.text+0x88): undefined reference to `i2c_transfer'
make[1]: *** [vmlinux] Error 1

<--  snip  -->

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
cdcb22706c51f0ae44946f4c3826cc3658960eba 
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 7bfb0d2..6f77d0a 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -520,6 +520,7 @@ config SH_MIGOR
 config SH_AP325RXA
 	bool "AP-325RXA"
 	depends on CPU_SUBTYPE_SH7723
+	select I2C
 	help
 	  Renesas "AP-325RXA" support.
 	  Compatible with ALGO SYSTEM CO.,LTD. "AP-320A"

