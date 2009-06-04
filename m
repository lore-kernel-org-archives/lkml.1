Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015AbZFDOW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbZFDOW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 10:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbZFDOWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 10:22:51 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:56714 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbZFDOWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 10:22:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:date:subject:mime-version:x-uid:x-length:to
         :content-type:content-transfer-encoding:content-disposition
         :message-id;
        b=Ky/4OFA264c1bnvi3rRbcRWutEWGWaGBLXRK7R+TNpCxtrwiJV83Jn5+ecMc2+0wqY
         fTjzQ/q1pmKJafX1kGB8yJCAgQbk3fcxd2lV4hwLfVGqu1bDgqKpv2EqSL+snIZH6LiJ
         ZapCIHRkSqTpip+AfqValaARXCM9f8j5HioPw=
From: Florian Fainelli <florian@openwrt.org>
Date: Thu, 4 Jun 2009 16:22:46 +0200
Subject: [PATCH 8/8] 8250: add Texas Instruments AR7 internal UART
MIME-Version: 1.0
X-Length: 2074
To: "Linux-MIPS" <linux-mips@linux-mips.org>,
       Ralf Baechle <ralf@linux-mips.org>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-serial@vger.kernel.org
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906041622.47591.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

We discussed that in private, there are a couple of things
to fix in order to get 8250 working properly with TI AR7 HW.
If you can still merge that bit, this would ease future work, thanks !
--
From: Florian Fainelli <florian@openwrt.org>

This patch adds support for Texas Instruments AR7 internal
UART.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index a0127e9..fb867a9 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -287,6 +287,13 @@ static const struct serial8250_config uart_config[] = {
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
