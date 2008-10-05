Return-Path: <linux-kernel-owner+w=401wt.eu-S1756562AbYJEQHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562AbYJEQHy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755263AbYJEQFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:05:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54850 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755034AbYJEQFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:05:47 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 09/76] Blackfin Serial Driver: move common variables out of
	serial headers and into the serial driver
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:05:47 +0100
Message-ID: <20081005160543.1997.6908.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

move common variables out of serial headers and into the serial driver and
rename "nr_ports" to "nr_active_ports" so as to easily differentiat
between BFIN_UART_NR_PORTS (the # of available) and nr_ports (the # of enabled)

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Alan Cox <alan@redhat.com>
---

 .../mach-bf527/include/mach/bfin_serial_5xx.h      |    3 ---
 .../mach-bf533/include/mach/bfin_serial_5xx.h      |    2 --
 .../mach-bf537/include/mach/bfin_serial_5xx.h      |    3 ---
 .../mach-bf548/include/mach/bfin_serial_5xx.h      |    3 ---
 .../mach-bf561/include/mach/bfin_serial_5xx.h      |    2 --
 drivers/serial/bfin_5xx.c                          |   17 ++++++++++-------
 6 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/arch/blackfin/mach-bf527/include/mach/bfin_serial_5xx.h b/arch/blackfin/mach-bf527/include/mach/bfin_serial_5xx.h
index 2526b6e..a23d047 100644
--- a/arch/blackfin/mach-bf527/include/mach/bfin_serial_5xx.h
+++ b/arch/blackfin/mach-bf527/include/mach/bfin_serial_5xx.h
@@ -119,7 +119,6 @@ static inline void UART_CLEAR_LSR(struct bfin_serial_port *uart)
 	bfin_write16(uart->port.membase + OFFSET_LSR, -1);
 }
 
-struct bfin_serial_port bfin_serial_ports[BFIN_UART_NR_PORTS];
 struct bfin_serial_res {
 	unsigned long uart_base_addr;
 	int uart_irq;
@@ -164,8 +163,6 @@ struct bfin_serial_res bfin_serial_resource[] = {
 #endif
 };
 
-int nr_ports = ARRAY_SIZE(bfin_serial_resource);
-
 #define DRIVER_NAME "bfin-uart"
 
 static void bfin_serial_hw_init(struct bfin_serial_port *uart)
diff --git a/arch/blackfin/mach-bf533/include/mach/bfin_serial_5xx.h b/arch/blackfin/mach-bf533/include/mach/bfin_serial_5xx.h
index ebf592b..20471cd 100644
--- a/arch/blackfin/mach-bf533/include/mach/bfin_serial_5xx.h
+++ b/arch/blackfin/mach-bf533/include/mach/bfin_serial_5xx.h
@@ -111,7 +111,6 @@ static inline void UART_CLEAR_LSR(struct bfin_serial_port *uart)
 	bfin_write16(uart->port.membase + OFFSET_LSR, -1);
 }
 
-struct bfin_serial_port bfin_serial_ports[BFIN_UART_NR_PORTS];
 struct bfin_serial_res {
 	unsigned long	uart_base_addr;
 	int		uart_irq;
@@ -142,7 +141,6 @@ struct bfin_serial_res bfin_serial_resource[] = {
 
 #define DRIVER_NAME "bfin-uart"
 
-int nr_ports = BFIN_UART_NR_PORTS;
 static void bfin_serial_hw_init(struct bfin_serial_port *uart)
 {
 
diff --git a/arch/blackfin/mach-bf537/include/mach/bfin_serial_5xx.h b/arch/blackfin/mach-bf537/include/mach/bfin_serial_5xx.h
index 1bf56ff..08dfe30 100644
--- a/arch/blackfin/mach-bf537/include/mach/bfin_serial_5xx.h
+++ b/arch/blackfin/mach-bf537/include/mach/bfin_serial_5xx.h
@@ -119,7 +119,6 @@ static inline void UART_CLEAR_LSR(struct bfin_serial_port *uart)
 	bfin_write16(uart->port.membase + OFFSET_LSR, -1);
 }
 
-struct bfin_serial_port bfin_serial_ports[BFIN_UART_NR_PORTS];
 struct bfin_serial_res {
 	unsigned long	uart_base_addr;
 	int		uart_irq;
@@ -164,8 +163,6 @@ struct bfin_serial_res bfin_serial_resource[] = {
 #endif
 };
 
-int nr_ports = ARRAY_SIZE(bfin_serial_resource);
-
 #define DRIVER_NAME "bfin-uart"
 
 static void bfin_serial_hw_init(struct bfin_serial_port *uart)
diff --git a/arch/blackfin/mach-bf548/include/mach/bfin_serial_5xx.h b/arch/blackfin/mach-bf548/include/mach/bfin_serial_5xx.h
index 5e29446..76976b1 100644
--- a/arch/blackfin/mach-bf548/include/mach/bfin_serial_5xx.h
+++ b/arch/blackfin/mach-bf548/include/mach/bfin_serial_5xx.h
@@ -105,7 +105,6 @@ struct bfin_serial_port {
 #endif
 };
 
-struct bfin_serial_port bfin_serial_ports[BFIN_UART_NR_PORTS];
 struct bfin_serial_res {
 	unsigned long	uart_base_addr;
 	int		uart_irq;
@@ -170,8 +169,6 @@ struct bfin_serial_res bfin_serial_resource[] = {
 #endif
 };
 
-int nr_ports = ARRAY_SIZE(bfin_serial_resource);
-
 #define DRIVER_NAME "bfin-uart"
 
 static void bfin_serial_hw_init(struct bfin_serial_port *uart)
diff --git a/arch/blackfin/mach-bf561/include/mach/bfin_serial_5xx.h b/arch/blackfin/mach-bf561/include/mach/bfin_serial_5xx.h
index 8aa0278..6cddca4 100644
--- a/arch/blackfin/mach-bf561/include/mach/bfin_serial_5xx.h
+++ b/arch/blackfin/mach-bf561/include/mach/bfin_serial_5xx.h
@@ -111,7 +111,6 @@ static inline void UART_CLEAR_LSR(struct bfin_serial_port *uart)
 	bfin_write16(uart->port.membase + OFFSET_LSR, -1);
 }
 
-struct bfin_serial_port bfin_serial_ports[BFIN_UART_NR_PORTS];
 struct bfin_serial_res {
 	unsigned long	uart_base_addr;
 	int		uart_irq;
@@ -142,7 +141,6 @@ struct bfin_serial_res bfin_serial_resource[] = {
 
 #define DRIVER_NAME "bfin-uart"
 
-int nr_ports = BFIN_UART_NR_PORTS;
 static void bfin_serial_hw_init(struct bfin_serial_port *uart)
 {
 
diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 976de91..382fb8d 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -42,6 +42,9 @@
 #define BFIN_SERIAL_MAJOR	204
 #define BFIN_SERIAL_MINOR	64
 
+static struct bfin_serial_port bfin_serial_ports[BFIN_UART_NR_PORTS];
+static int nr_active_ports = ARRAY_SIZE(bfin_serial_resource);
+
 /*
  * Setup for console. Argument comes from the menuconfig
  */
@@ -859,7 +862,7 @@ static void __init bfin_serial_init_ports(void)
 		return;
 	first = 0;
 
-	for (i = 0; i < nr_ports; i++) {
+	for (i = 0; i < nr_active_ports; i++) {
 		bfin_serial_ports[i].port.uartclk   = get_sclk();
 		bfin_serial_ports[i].port.ops       = &bfin_serial_pops;
 		bfin_serial_ports[i].port.line      = i;
@@ -961,7 +964,7 @@ bfin_serial_console_setup(struct console *co, char *options)
 	 * if so, search for the first available port that does have
 	 * console support.
 	 */
-	if (co->index == -1 || co->index >= nr_ports)
+	if (co->index == -1 || co->index >= nr_active_ports)
 		co->index = 0;
 	uart = &bfin_serial_ports[co->index];
 
@@ -1072,7 +1075,7 @@ struct console __init *bfin_earlyserial_init(unsigned int port,
 	struct bfin_serial_port *uart;
 	struct ktermios t;
 
-	if (port == -1 || port >= nr_ports)
+	if (port == -1 || port >= nr_active_ports)
 		port = 0;
 	bfin_serial_init_ports();
 	bfin_early_serial_console.index = port;
@@ -1102,7 +1105,7 @@ static int bfin_serial_suspend(struct platform_device *dev, pm_message_t state)
 {
 	int i;
 
-	for (i = 0; i < nr_ports; i++) {
+	for (i = 0; i < nr_active_ports; i++) {
 		if (bfin_serial_ports[i].port.dev != &dev->dev)
 			continue;
 		uart_suspend_port(&bfin_serial_reg, &bfin_serial_ports[i].port);
@@ -1115,7 +1118,7 @@ static int bfin_serial_resume(struct platform_device *dev)
 {
 	int i;
 
-	for (i = 0; i < nr_ports; i++) {
+	for (i = 0; i < nr_active_ports; i++) {
 		if (bfin_serial_ports[i].port.dev != &dev->dev)
 			continue;
 		uart_resume_port(&bfin_serial_reg, &bfin_serial_ports[i].port);
@@ -1134,7 +1137,7 @@ static int bfin_serial_probe(struct platform_device *dev)
 			break;
 
 	if (i < dev->num_resources) {
-		for (i = 0; i < nr_ports; i++, res++) {
+		for (i = 0; i < nr_active_ports; i++, res++) {
 			if (bfin_serial_ports[i].port.mapbase != res->start)
 				continue;
 			bfin_serial_ports[i].port.dev = &dev->dev;
@@ -1149,7 +1152,7 @@ static int bfin_serial_remove(struct platform_device *dev)
 {
 	int i;
 
-	for (i = 0; i < nr_ports; i++) {
+	for (i = 0; i < nr_active_ports; i++) {
 		if (bfin_serial_ports[i].port.dev != &dev->dev)
 			continue;
 		uart_remove_one_port(&bfin_serial_reg, &bfin_serial_ports[i].port);

