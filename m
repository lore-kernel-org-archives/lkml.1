Return-Path: <linux-kernel-owner+w=401wt.eu-S933731AbZGQAF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933731AbZGQAF7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 20:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933720AbZGQAF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 20:05:57 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39124 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933710AbZGQAF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 20:05:56 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 11/21] Blackfin: fix wrong CTS inversion
Date: Thu, 16 Jul 2009 20:05:36 -0400
Message-Id: <1247789146-18786-12-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1247789146-18786-1-git-send-email-vapier@gentoo.org>
References: <1247789146-18786-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

The Blackfin serial headers were inverting the CTS value leading to wrong
handling of the CTS line which broke CTS/RTS handling completely.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 .../mach-bf518/include/mach/bfin_serial_5xx.h      |    2 +-
 .../mach-bf527/include/mach/bfin_serial_5xx.h      |    2 +-
 .../mach-bf533/include/mach/bfin_serial_5xx.h      |    2 +-
 .../mach-bf537/include/mach/bfin_serial_5xx.h      |    2 +-
 .../mach-bf538/include/mach/bfin_serial_5xx.h      |    2 +-
 .../mach-bf561/include/mach/bfin_serial_5xx.h      |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/blackfin/mach-bf518/include/mach/bfin_serial_5xx.h b/arch/blackfin/mach-bf518/include/mach/bfin_serial_5xx.h
index 0fb2ce5..dbade93 100644
--- a/arch/blackfin/mach-bf518/include/mach/bfin_serial_5xx.h
+++ b/arch/blackfin/mach-bf518/include/mach/bfin_serial_5xx.h
@@ -53,7 +53,7 @@
 #define UART_SET_DLAB(uart)     do { UART_PUT_LCR(uart, UART_GET_LCR(uart) | DLAB); SSYNC(); } while (0)
 #define UART_CLEAR_DLAB(uart)   do { UART_PUT_LCR(uart, UART_GET_LCR(uart) & ~DLAB); SSYNC(); } while (0)
 
-#define UART_GET_CTS(x) (!gpio_get_value(x->cts_pin))
+#define UART_GET_CTS(x) gpio_get_value(x->cts_pin)
 #define UART_DISABLE_RTS(x) gpio_set_value(x->rts_pin, 1)
 #define UART_ENABLE_RTS(x) gpio_set_value(x->rts_pin, 0)
 #define UART_ENABLE_INTS(x, v) UART_PUT_IER(x, v)
diff --git a/arch/blackfin/mach-bf527/include/mach/bfin_serial_5xx.h b/arch/blackfin/mach-bf527/include/mach/bfin_serial_5xx.h
index a625659..ebd6ceb 100644
--- a/arch/blackfin/mach-bf527/include/mach/bfin_serial_5xx.h
+++ b/arch/blackfin/mach-bf527/include/mach/bfin_serial_5xx.h
@@ -53,7 +53,7 @@
 #define UART_SET_DLAB(uart)     do { UART_PUT_LCR(uart, UART_GET_LCR(uart) | DLAB); SSYNC(); } while (0)
 #define UART_CLEAR_DLAB(uart)   do { UART_PUT_LCR(uart, UART_GET_LCR(uart) & ~DLAB); SSYNC(); } while (0)
 
-#define UART_GET_CTS(x) (!gpio_get_value(x->cts_pin))
+#define UART_GET_CTS(x) gpio_get_value(x->cts_pin)
 #define UART_DISABLE_RTS(x) gpio_set_value(x->rts_pin, 1)
 #define UART_ENABLE_RTS(x) gpio_set_value(x->rts_pin, 0)
 #define UART_ENABLE_INTS(x, v) UART_PUT_IER(x, v)
diff --git a/arch/blackfin/mach-bf533/include/mach/bfin_serial_5xx.h b/arch/blackfin/mach-bf533/include/mach/bfin_serial_5xx.h
index a3789d7..4062e24 100644
--- a/arch/blackfin/mach-bf533/include/mach/bfin_serial_5xx.h
+++ b/arch/blackfin/mach-bf533/include/mach/bfin_serial_5xx.h
@@ -53,7 +53,7 @@
 #define UART_SET_DLAB(uart)     do { UART_PUT_LCR(uart, UART_GET_LCR(uart) | DLAB); SSYNC(); } while (0)
 #define UART_CLEAR_DLAB(uart)   do { UART_PUT_LCR(uart, UART_GET_LCR(uart) & ~DLAB); SSYNC(); } while (0)
 
-#define UART_GET_CTS(x) (!gpio_get_value(x->cts_pin))
+#define UART_GET_CTS(x) gpio_get_value(x->cts_pin)
 #define UART_DISABLE_RTS(x) gpio_set_value(x->rts_pin, 1)
 #define UART_ENABLE_RTS(x) gpio_set_value(x->rts_pin, 0)
 #define UART_ENABLE_INTS(x, v) UART_PUT_IER(x, v)
diff --git a/arch/blackfin/mach-bf537/include/mach/bfin_serial_5xx.h b/arch/blackfin/mach-bf537/include/mach/bfin_serial_5xx.h
index b86662f..e95d54f 100644
--- a/arch/blackfin/mach-bf537/include/mach/bfin_serial_5xx.h
+++ b/arch/blackfin/mach-bf537/include/mach/bfin_serial_5xx.h
@@ -53,7 +53,7 @@
 #define UART_SET_DLAB(uart)     do { UART_PUT_LCR(uart, UART_GET_LCR(uart) | DLAB); SSYNC(); } while (0)
 #define UART_CLEAR_DLAB(uart)   do { UART_PUT_LCR(uart, UART_GET_LCR(uart) & ~DLAB); SSYNC(); } while (0)
 
-#define UART_GET_CTS(x) (!gpio_get_value(x->cts_pin))
+#define UART_GET_CTS(x) gpio_get_value(x->cts_pin)
 #define UART_DISABLE_RTS(x) gpio_set_value(x->rts_pin, 1)
 #define UART_ENABLE_RTS(x) gpio_set_value(x->rts_pin, 0)
 #define UART_ENABLE_INTS(x, v) UART_PUT_IER(x, v)
diff --git a/arch/blackfin/mach-bf538/include/mach/bfin_serial_5xx.h b/arch/blackfin/mach-bf538/include/mach/bfin_serial_5xx.h
index c536551..999f239 100644
--- a/arch/blackfin/mach-bf538/include/mach/bfin_serial_5xx.h
+++ b/arch/blackfin/mach-bf538/include/mach/bfin_serial_5xx.h
@@ -53,7 +53,7 @@
 #define UART_SET_DLAB(uart)     do { UART_PUT_LCR(uart, UART_GET_LCR(uart) | DLAB); SSYNC(); } while (0)
 #define UART_CLEAR_DLAB(uart)   do { UART_PUT_LCR(uart, UART_GET_LCR(uart) & ~DLAB); SSYNC(); } while (0)
 
-#define UART_GET_CTS(x) (!gpio_get_value(x->cts_pin))
+#define UART_GET_CTS(x) gpio_get_value(x->cts_pin)
 #define UART_DISABLE_RTS(x) gpio_set_value(x->rts_pin, 1)
 #define UART_ENABLE_RTS(x) gpio_set_value(x->rts_pin, 0)
 #define UART_ENABLE_INTS(x, v) UART_PUT_IER(x, v)
diff --git a/arch/blackfin/mach-bf561/include/mach/bfin_serial_5xx.h b/arch/blackfin/mach-bf561/include/mach/bfin_serial_5xx.h
index a1b5087..fd5e887 100644
--- a/arch/blackfin/mach-bf561/include/mach/bfin_serial_5xx.h
+++ b/arch/blackfin/mach-bf561/include/mach/bfin_serial_5xx.h
@@ -53,7 +53,7 @@
 #define UART_SET_DLAB(uart)     do { UART_PUT_LCR(uart, UART_GET_LCR(uart) | DLAB); SSYNC(); } while (0)
 #define UART_CLEAR_DLAB(uart)   do { UART_PUT_LCR(uart, UART_GET_LCR(uart) & ~DLAB); SSYNC(); } while (0)
 
-#define UART_GET_CTS(x) (!gpio_get_value(x->cts_pin))
+#define UART_GET_CTS(x) gpio_get_value(x->cts_pin)
 #define UART_DISABLE_RTS(x) gpio_set_value(x->rts_pin, 1)
 #define UART_ENABLE_RTS(x) gpio_set_value(x->rts_pin, 0)
 #define UART_ENABLE_INTS(x, v) UART_PUT_IER(x, v)
-- 
1.6.3.3

