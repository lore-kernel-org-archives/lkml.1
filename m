Return-Path: <linux-kernel-owner+w=401wt.eu-S1761243AbZFINsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761243AbZFINsW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 09:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbZFINq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 09:46:57 -0400
Received: from mx1.emlix.com ([193.175.82.87]:51563 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbZFINqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 09:46:53 -0400
From: "Oskar Schirmer" <os@emlix.com>
To: Sascha Hauer <kernel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Oskar Schirmer <os@emlix.com>
Subject: [PATCH 1/8] imx: serial: fix whitespaces (no changes in functionality)
Date: Tue,  9 Jun 2009 15:46:44 +0200
Message-Id: <1244555211-15618-2-git-send-email-os@emlix.com>
In-Reply-To: <1244555211-15618-1-git-send-email-os@emlix.com>
References: <1244555211-15618-1-git-send-email-os@emlix.com>
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Oskar Schirmer <os@emlix.com>
---
 drivers/serial/imx.c |   48 +++++++++++++++++++++++-------------------------
 1 files changed, 23 insertions(+), 25 deletions(-)

diff --git a/drivers/serial/imx.c b/drivers/serial/imx.c
index 9f460b1..424f679 100644
--- a/drivers/serial/imx.c
+++ b/drivers/serial/imx.c
@@ -302,8 +302,7 @@ static inline void imx_transmit_buffer(struct imx_port *sport)
 		/* send xmit->buf[xmit->tail]
 		 * out the port here */
 		writel(xmit->buf[xmit->tail], sport->port.membase + URTX0);
-		xmit->tail = (xmit->tail + 1) &
-		         (UART_XMIT_SIZE - 1);
+		xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
 		sport->port.icount.tx++;
 		if (uart_circ_empty(xmit))
 			break;
@@ -395,8 +394,7 @@ static irqreturn_t imx_rxint(int irq, void *dev_id)
 				continue;
 		}
 
-		if (uart_handle_sysrq_char
-		            (&sport->port, (unsigned char)rx))
+		if (uart_handle_sysrq_char(&sport->port, (unsigned char)rx))
 			continue;
 
 		if (rx & (URXD_PRERR | URXD_OVRRUN | URXD_FRMERR) ) {
@@ -471,26 +469,26 @@ static unsigned int imx_tx_empty(struct uart_port *port)
  */
 static unsigned int imx_get_mctrl(struct uart_port *port)
 {
-        struct imx_port *sport = (struct imx_port *)port;
-        unsigned int tmp = TIOCM_DSR | TIOCM_CAR;
+	struct imx_port *sport = (struct imx_port *)port;
+	unsigned int tmp = TIOCM_DSR | TIOCM_CAR;
 
-        if (readl(sport->port.membase + USR1) & USR1_RTSS)
-                tmp |= TIOCM_CTS;
+	if (readl(sport->port.membase + USR1) & USR1_RTSS)
+		tmp |= TIOCM_CTS;
 
-        if (readl(sport->port.membase + UCR2) & UCR2_CTS)
-                tmp |= TIOCM_RTS;
+	if (readl(sport->port.membase + UCR2) & UCR2_CTS)
+		tmp |= TIOCM_RTS;
 
-        return tmp;
+	return tmp;
 }
 
 static void imx_set_mctrl(struct uart_port *port, unsigned int mctrl)
 {
-        struct imx_port *sport = (struct imx_port *)port;
+	struct imx_port *sport = (struct imx_port *)port;
 	unsigned long temp;
 
 	temp = readl(sport->port.membase + UCR2) & ~UCR2_CTS;
 
-        if (mctrl & TIOCM_RTS)
+	if (mctrl & TIOCM_RTS)
 		temp |= UCR2_CTS;
 
 	writel(temp, sport->port.membase + UCR2);
@@ -1070,22 +1068,22 @@ static struct uart_driver imx_reg = {
 
 static int serial_imx_suspend(struct platform_device *dev, pm_message_t state)
 {
-        struct imx_port *sport = platform_get_drvdata(dev);
+	struct imx_port *sport = platform_get_drvdata(dev);
 
-        if (sport)
-                uart_suspend_port(&imx_reg, &sport->port);
+	if (sport)
+		uart_suspend_port(&imx_reg, &sport->port);
 
-        return 0;
+	return 0;
 }
 
 static int serial_imx_resume(struct platform_device *dev)
 {
-        struct imx_port *sport = platform_get_drvdata(dev);
+	struct imx_port *sport = platform_get_drvdata(dev);
 
-        if (sport)
-                uart_resume_port(&imx_reg, &sport->port);
+	if (sport)
+		uart_resume_port(&imx_reg, &sport->port);
 
-        return 0;
+	return 0;
 }
 
 static int serial_imx_probe(struct platform_device *pdev)
@@ -1141,7 +1139,7 @@ static int serial_imx_probe(struct platform_device *pdev)
 	imx_ports[pdev->id] = sport;
 
 	pdata = pdev->dev.platform_data;
-	if(pdata && (pdata->flags & IMXUART_HAVE_RTSCTS))
+	if (pdata && (pdata->flags & IMXUART_HAVE_RTSCTS))
 		sport->have_rtscts = 1;
 
 	if (pdata->init) {
@@ -1191,13 +1189,13 @@ static int serial_imx_remove(struct platform_device *pdev)
 }
 
 static struct platform_driver serial_imx_driver = {
-        .probe          = serial_imx_probe,
-        .remove         = serial_imx_remove,
+	.probe		= serial_imx_probe,
+	.remove		= serial_imx_remove,
 
 	.suspend	= serial_imx_suspend,
 	.resume		= serial_imx_resume,
 	.driver		= {
-	        .name	= "imx-uart",
+		.name	= "imx-uart",
 		.owner	= THIS_MODULE,
 	},
 };
-- 
1.5.3.7

