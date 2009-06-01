Return-Path: <linux-kernel-owner+w=401wt.eu-S1757983AbZFAMAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983AbZFAMAq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 08:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756190AbZFAMAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 08:00:38 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:18622 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339AbZFAMAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 08:00:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:date:subject:mime-version:x-uid:x-length:to
         :content-type:content-transfer-encoding:content-disposition
         :message-id;
        b=lXWunBX5l0KU3Fw4z8RFbGqNVrf4TMUJpy74egT53Vz+NoAFPpwPh1eFNZU516qZSG
         P2DI4AE1r+1AEkvG78q6k0K3Evqbj4kdt+Nk/y9UvPSpUSk6XNTBuPVqYYC8EhC0X1Cc
         cJ//CWgxrXymQ/tRUtuQYx0o7pOGEzIWR7xL4=
From: Florian Fainelli <florian@openwrt.org>
Date: Mon, 1 Jun 2009 14:00:35 +0200
Subject: [PATCH 5/9] serial: add support for the TI AR7 internal UART
MIME-Version: 1.0
X-Length: 2075
To: linux-kernel@vger.kernel.org, akpm <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-serial@vger.kernel.org
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906011400.35997.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the TI AR7 internal UART.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index b4b3981..03376b0 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -286,6 +286,13 @@ static const struct serial8250_config uart_config[] = {
 		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
 		.flags		= UART_CAP_FIFO,
 	},
+	[PORT_AR7] = {
+		.name		= "AR7",
+		.fifo_size	= 16,
+		.tx_loadsz	= 16,
+		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_00,
+		.flags		= UART_CAP_FIFO | UART_CAP_AFE,
+	},
 };
 
 #if defined (CONFIG_SERIAL_8250_AU1X00)
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 57a97e5..48766ea 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -41,7 +41,8 @@
 #define PORT_XSCALE	15
 #define PORT_RM9000	16	/* PMC-Sierra RM9xxx internal UART */
 #define PORT_OCTEON	17	/* Cavium OCTEON internal UART */
-#define PORT_MAX_8250	17	/* max port ID */
+#define PORT_AR7	18	/* Texas Instruments AR7 internal UART */
+#define PORT_MAX_8250	18	/* max port ID */
 
 /*
  * ARM specific type numbers.  These are not currently guaranteed
