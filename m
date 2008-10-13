Return-Path: <linux-kernel-owner+w=401wt.eu-S1764100AbYJMKGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764100AbYJMKGY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 06:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763297AbYJMJpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 05:45:55 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:45891 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761244AbYJMJpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 05:45:52 -0400
X-IronPort-AV: E=Sophos;i="4.33,402,1220241600"; 
   d="scan'208";a="61013703"
From: Bryan Wu <cooloney@kernel.org>
To: alan@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       Sonic Zhang <sonic.zhang@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 4/6] Blackfin Serial Driver: Clean serial console and early prink code`
Date: Mon, 13 Oct 2008 17:46:23 +0800
Message-Id: <1223891185-13924-5-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1223891185-13924-1-git-send-email-cooloney@kernel.org>
References: <1223891185-13924-1-git-send-email-cooloney@kernel.org>
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
