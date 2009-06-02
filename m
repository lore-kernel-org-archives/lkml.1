Return-Path: <linux-kernel-owner+w=401wt.eu-S1760233AbZFBHNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760233AbZFBHNQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 03:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758614AbZFBHLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 03:11:51 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:46629 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757336AbZFBHLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 03:11:48 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Robin Getz <rgetz@blackfin.uclinux.org>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 06/11] Blackfin Serial Driver: fix baudrate for early_printk
Date: Tue,  2 Jun 2009 03:11:35 -0400
Message-Id: <1243926700-30485-6-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1243926700-30485-1-git-send-email-vapier@gentoo.org>
References: <1243926700-30485-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Getz <rgetz@blackfin.uclinux.org>

Since we already setup the early console UART in
arch/blackfin/kernel/early_printk.c, and common functions which are
enabled from the .setup will override the proper settings later, don't
fill in these structures.  Otherwise we get mangled baudrate settings when
using early_printk.

Signed-off-by: Robin Getz <rgetz@blackfin.uclinux.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/serial/bfin_5xx.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 65a4c07..dfae22d 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -1272,12 +1272,17 @@ static __init void early_serial_write(struct console *con, const char *s,
 	}
 }
 
+/*
+ * This should have a .setup or .early_setup in it, but then things get called
+ * without the command line options, and the baud rate gets messed up - so
+ * don't let the common infrastructure play with things. (see calls to setup
+ * & earlysetup in ./kernel/printk.c:register_console()
+ */
 static struct __initdata console bfin_early_serial_console = {
 	.name = "early_BFuart",
 	.write = early_serial_write,
 	.device = uart_console_device,
 	.flags = CON_PRINTBUFFER,
-	.setup = bfin_serial_console_setup,
 	.index = -1,
 	.data  = &bfin_serial_reg,
 };
-- 
1.6.3.1

