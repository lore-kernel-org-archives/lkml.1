Return-Path: <linux-kernel-owner+w=401wt.eu-S1756736AbYJEQIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736AbYJEQIz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754872AbYJEQGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:06:11 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54856 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754700AbYJEQGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:06:09 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 12/76] Blackfin Serial Driver: Fix bug - ircp fails on sir
	over Blackfin UART
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:06:09 +0100
Message-ID: <20081005160607.1997.15993.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graf Yang <graf.yang@analog.com>

We now use the sir_dev/irtty_sir/uart/bfin_serial drivers framework
to monitor the TX status.

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Alan Cox <alan@redhat.com>
---

 .../mach-bf527/include/mach/bfin_serial_5xx.h      |    3 +++
 .../mach-bf533/include/mach/bfin_serial_5xx.h      |    2 ++
 .../mach-bf537/include/mach/bfin_serial_5xx.h      |    3 +++
 .../mach-bf548/include/mach/bfin_serial_5xx.h      |    3 +++
 .../mach-bf561/include/mach/bfin_serial_5xx.h      |    2 ++
 drivers/serial/bfin_5xx.c                          |    4 ++++
 6 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/mach-bf527/include/mach/bfin_serial_5xx.h b/arch/blackfin/mach-bf527/include/mach/bfin_serial_5xx.h
index a23d047..75722d6 100644
--- a/arch/blackfin/mach-bf527/include/mach/bfin_serial_5xx.h
+++ b/arch/blackfin/mach-bf527/include/mach/bfin_serial_5xx.h
@@ -78,6 +78,9 @@
 #  define CONFIG_UART1_RTS_PIN -1
 # endif
 #endif
+
+#define BFIN_UART_TX_FIFO_SIZE	2
+
 /*
  * The pin configuration is different from schematic
  */
diff --git a/arch/blackfin/mach-bf533/include/mach/bfin_serial_5xx.h b/arch/blackfin/mach-bf533/include/mach/bfin_serial_5xx.h
index 20471cd..815bfe5 100644
--- a/arch/blackfin/mach-bf533/include/mach/bfin_serial_5xx.h
+++ b/arch/blackfin/mach-bf533/include/mach/bfin_serial_5xx.h
@@ -69,6 +69,8 @@
 # endif
 #endif
 
+#define BFIN_UART_TX_FIFO_SIZE	2
+
 struct bfin_serial_port {
         struct uart_port        port;
         unsigned int            old_status;
diff --git a/arch/blackfin/mach-bf537/include/mach/bfin_serial_5xx.h b/arch/blackfin/mach-bf537/include/mach/bfin_serial_5xx.h
index 08dfe30..b3f87e1 100644
--- a/arch/blackfin/mach-bf537/include/mach/bfin_serial_5xx.h
+++ b/arch/blackfin/mach-bf537/include/mach/bfin_serial_5xx.h
@@ -78,6 +78,9 @@
 #  define CONFIG_UART1_RTS_PIN -1
 # endif
 #endif
+
+#define BFIN_UART_TX_FIFO_SIZE	2
+
 /*
  * The pin configuration is different from schematic
  */
diff --git a/arch/blackfin/mach-bf548/include/mach/bfin_serial_5xx.h b/arch/blackfin/mach-bf548/include/mach/bfin_serial_5xx.h
index 76976b1..e4cf35e 100644
--- a/arch/blackfin/mach-bf548/include/mach/bfin_serial_5xx.h
+++ b/arch/blackfin/mach-bf548/include/mach/bfin_serial_5xx.h
@@ -82,6 +82,9 @@
 #  define CONFIG_UART1_RTS_PIN -1
 # endif
 #endif
+
+#define BFIN_UART_TX_FIFO_SIZE	2
+
 /*
  * The pin configuration is different from schematic
  */
diff --git a/arch/blackfin/mach-bf561/include/mach/bfin_serial_5xx.h b/arch/blackfin/mach-bf561/include/mach/bfin_serial_5xx.h
index 6cddca4..e0ce0c1 100644
--- a/arch/blackfin/mach-bf561/include/mach/bfin_serial_5xx.h
+++ b/arch/blackfin/mach-bf561/include/mach/bfin_serial_5xx.h
@@ -69,6 +69,8 @@
 # endif
 #endif
 
+#define BFIN_UART_TX_FIFO_SIZE	2
+
 struct bfin_serial_port {
         struct uart_port        port;
         unsigned int            old_status;
diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 5e20f50..a5cf0e7 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -761,6 +761,9 @@ bfin_serial_set_termios(struct uart_port *port, struct ktermios *termios,
 	val |= UCEN;
 	UART_PUT_GCTL(uart, val);
 
+	/* Port speed changed, update the per-port timeout. */
+	uart_update_timeout(port, termios->c_cflag, baud);
+
 	spin_unlock_irqrestore(&uart->port.lock, flags);
 }
 
@@ -865,6 +868,7 @@ static void __init bfin_serial_init_ports(void)
 
 	for (i = 0; i < nr_active_ports; i++) {
 		bfin_serial_ports[i].port.uartclk   = get_sclk();
+		bfin_serial_ports[i].port.fifosize  = BFIN_UART_TX_FIFO_SIZE;
 		bfin_serial_ports[i].port.ops       = &bfin_serial_pops;
 		bfin_serial_ports[i].port.line      = i;
 		bfin_serial_ports[i].port.iotype    = UPIO_MEM;

