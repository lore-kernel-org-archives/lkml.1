Return-Path: <linux-kernel-owner+w=401wt.eu-S1758949AbYJPRqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758949AbYJPRqA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758197AbYJPRoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:44:46 -0400
Received: from ti-out-0910.google.com ([209.85.142.190]:20082 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758172AbYJPRoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:44:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=V1mfEmNK0FNEGB7+LkxKfPYVkljkwpRvao4Kd16R3utz83YW5xJj2+20W7NAytHQyE
         oOypxqtCXwsLGl7R/HfpTyInxp1OcR5pBrujASekFP6NdpghU46MHv0cOwsg2KvXxcKz
         83VFyqeekHNZl5nWPJvSiKctIcIyYZQ2HqqV0=
From: Bryan Wu <cooloney@kernel.org>
To: alan@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       Sonic Zhang <sonic.zhang@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 5/9] Blackfin Serial Driver: Clean serial console and early prink code`
Date: Fri, 17 Oct 2008 01:44:03 +0800
Message-Id: <1224179047-13073-6-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1224179047-13073-1-git-send-email-cooloney@kernel.org>
References: <1224179047-13073-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Singed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/serial/bfin_5xx.c |   16 ++++------------
 1 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 3cc7b98..44a0855 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -987,7 +987,7 @@ static void __init bfin_serial_init_ports(void)
 
 }
 
-#ifdef CONFIG_SERIAL_BFIN_CONSOLE
+#if defined(CONFIG_SERIAL_BFIN_CONSOLE) || defined(CONFIG_EARLY_PRINTK)
 /*
  * If the port was already initialised (eg, by a boot loader),
  * try to determine the current setup.
@@ -1031,24 +1031,20 @@ bfin_serial_console_get_options(struct bfin_serial_port *uart, int *baud,
 	}
 	pr_debug("%s:baud = %d, parity = %c, bits= %d\n", __func__, *baud, *parity, *bits);
 }
-#endif
 
-#if defined(CONFIG_SERIAL_BFIN_CONSOLE) || defined(CONFIG_EARLY_PRINTK)
 static struct uart_driver bfin_serial_reg;
 
 static int __init
 bfin_serial_console_setup(struct console *co, char *options)
 {
 	struct bfin_serial_port *uart;
-# ifdef CONFIG_SERIAL_BFIN_CONSOLE
 	int baud = 57600;
 	int bits = 8;
 	int parity = 'n';
-#  ifdef CONFIG_SERIAL_BFIN_CTSRTS
+# ifdef CONFIG_SERIAL_BFIN_CTSRTS
 	int flow = 'r';
-#  else
+# else
 	int flow = 'n';
-#  endif
 # endif
 
 	/*
@@ -1060,16 +1056,12 @@ bfin_serial_console_setup(struct console *co, char *options)
 		co->index = 0;
 	uart = &bfin_serial_ports[co->index];
 
-# ifdef CONFIG_SERIAL_BFIN_CONSOLE
 	if (options)
 		uart_parse_options(options, &baud, &parity, &bits, &flow);
 	else
 		bfin_serial_console_get_options(uart, &baud, &parity, &bits);
 
 	return uart_set_options(&uart->port, co, baud, parity, bits, flow);
-# else
-	return 0;
-# endif
 }
 #endif /* defined (CONFIG_SERIAL_BFIN_CONSOLE) ||
 				 defined (CONFIG_EARLY_PRINTK) */
@@ -1179,7 +1171,7 @@ struct console __init *bfin_earlyserial_init(unsigned int port,
 	return &bfin_early_serial_console;
 }
 
-#endif /* CONFIG_SERIAL_BFIN_CONSOLE */
+#endif /* CONFIG_EARLY_PRINTK */
 
 #ifdef CONFIG_DEBUG_KERNEL
 void bfin_serial_debug(const char *fmt, ...)
-- 
1.5.6

