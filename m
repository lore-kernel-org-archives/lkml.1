Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab0CIRYg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 12:24:36 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:54684 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941Ab0CIRW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 12:22:29 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-serial@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 05/13] serial: bfin_sport_uart: rename early platform driver class string
Date: Tue,  9 Mar 2010 12:25:32 -0500
Message-Id: <1268155540-8241-6-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1268155540-8241-1-git-send-email-vapier@gentoo.org>
References: <1268155540-8241-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Clarifies command line set up for devices between consoles and early
devices.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/serial/bfin_sport_uart.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/bfin_sport_uart.c b/drivers/serial/bfin_sport_uart.c
index 18bc4a3..5101e38 100644
--- a/drivers/serial/bfin_sport_uart.c
+++ b/drivers/serial/bfin_sport_uart.c
@@ -526,6 +526,8 @@ struct uart_ops sport_uart_ops = {
 static struct sport_uart_port *bfin_sport_uart_ports[BFIN_SPORT_UART_MAX_PORTS];
 
 #ifdef CONFIG_SERIAL_BFIN_SPORT_CONSOLE
+#define CLASS_BFIN_SPORT_CONSOLE	"bfin-sport-console"
+
 static int __init
 sport_uart_console_setup(struct console *co, char *options)
 {
@@ -787,7 +789,7 @@ static struct platform_driver sport_uart_driver = {
 
 #ifdef CONFIG_SERIAL_BFIN_SPORT_CONSOLE
 static __initdata struct early_platform_driver early_sport_uart_driver = {
-	.class_str = DRV_NAME,
+	.class_str = CLASS_BFIN_SPORT_CONSOLE,
 	.pdrv = &sport_uart_driver,
 	.requested_id = EARLY_PLATFORM_ID_UNSET,
 };
@@ -796,7 +798,8 @@ static int __init sport_uart_rs_console_init(void)
 {
 	early_platform_driver_register(&early_sport_uart_driver, DRV_NAME);
 
-	early_platform_driver_probe(DRV_NAME, BFIN_SPORT_UART_MAX_PORTS, 0);
+	early_platform_driver_probe(CLASS_BFIN_SPORT_CONSOLE,
+		BFIN_SPORT_UART_MAX_PORTS, 0);
 
 	register_console(&sport_uart_console);
 
-- 
1.7.0.2

