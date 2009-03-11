Return-Path: <linux-kernel-owner+w=401wt.eu-S1754665AbZCKV7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbZCKV7X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 17:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753509AbZCKV6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 17:58:08 -0400
Received: from smtp103.biz.mail.mud.yahoo.com ([68.142.200.238]:21746 "HELO
	smtp103.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753853AbZCKV6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 17:58:06 -0400
X-Yahoo-SMTP: Y9aU0H6swBAqsiryRZEA7xtDWlgllPfq7He2xMk-
X-YMail-OSG: exq8vIQVM1m03krIotUEAeoEG1B92QD9Qd8Bks7Ft6uVvoLqxa19voucygwuMwQxF0bsHEh6op3DaUPaz6i5xiQRO5bF9h3aW3UJs9PNfVor0TNR3Q4juMTU43p37N2QdWcGvH3m44kMwXTHzUeww9qopsJUnyvOSIrs0Enm7T4o7FTpZQrHrklQmf08uJFhh59Jt97vCe9xAwdcAUsBvp3MyeuRQXZ4..ZEoybOcStnhak-
X-Yahoo-Newman-Property: ymail-3
From: Steven King <sfking@fdwdc.com>
To: uClinux development list <uclinux-dev@uclinux.org>
Subject: [RFC 04/14] Coldfire generic GPIO (m68knommu)
Date: Wed, 11 Mar 2009 13:55:54 -0800
User-Agent: KMail/1.9.10
Organization: fdwdc.com
Cc: linux-kernel@vger.kernel.org, Greg Ungerer <gerg@snapgear.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200903111455.54876.sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Steven King <sfking@fdwdc.com>

diff --git a/arch/m68k/include/asm/m520xsim.h b/arch/m68k/include/asm/m520xsim.h
index 49d016e..efdff3b 100644
--- a/arch/m68k/include/asm/m520xsim.h
+++ b/arch/m68k/include/asm/m520xsim.h
@@ -41,6 +41,62 @@
 #define MCFSIM_SDCS0        0x000a8110	/* SDRAM Chip Select 0 Configuration */
 #define MCFSIM_SDCS1        0x000a8114	/* SDRAM Chip Select 1 Configuration */
 
+#define MCFEPORT_EPDDR			0xFC088002
+#define MCFEPORT_EPDR			0xFC088004
+#define MCFEPORT_EPPDR			0xFC088005
+
+#define MCFGPIO_PODR_BUSCTL		0xFC0A4000
+#define MCFGPIO_PODR_BE			0xFC0A4001
+#define MCFGPIO_PODR_CS			0xFC0A4002
+#define MCFGPIO_PODR_FECI2C		0xFC0A4003
+#define MCFGPIO_PODR_QSPI		0xFC0A4004
+#define MCFGPIO_PODR_TIMER		0xFC0A4005
+#define MCFGPIO_PODR_UART		0xFC0A4006
+#define MCFGPIO_PODR_FECH		0xFC0A4007
+#define MCFGPIO_PODR_FECL		0xFC0A4008
+
+#define MCFGPIO_PDDR_BUSCTL		0xFC0A400C
+#define MCFGPIO_PDDR_BE			0xFC0A400D
+#define MCFGPIO_PDDR_CS			0xFC0A400E
+#define MCFGPIO_PDDR_FECI2C		0xFC0A400F
+#define MCFGPIO_PDDR_QSPI		0xFC0A4010
+#define MCFGPIO_PDDR_TIMER		0xFC0A4011
+#define MCFGPIO_PDDR_UART		0xFC0A4012
+#define MCFGPIO_PDDR_FECH		0xFC0A4013
+#define MCFGPIO_PDDR_FECL		0xFC0A4014
+
+#define MCFGPIO_PPDSDR_BUSCTL		0xFC0A401A
+#define MCFGPIO_PPDSDR_BE		0xFC0A401B
+#define MCFGPIO_PPDSDR_CS		0xFC0A401C
+#define MCFGPIO_PPDSDR_FECI2C		0xFC0A401D
+#define MCFGPIO_PPDSDR_QSPI		0xFC0A401E
+#define MCFGPIO_PPDSDR_TIMER		0xFC0A401F
+#define MCFGPIO_PPDSDR_UART		0xFC0A4021
+#define MCFGPIO_PPDSDR_FECH		0xFC0A4021
+#define MCFGPIO_PPDSDR_FECL		0xFC0A4022
+
+#define MCFGPIO_PCLRR_BUSCTL		0xFC0A4024
+#define MCFGPIO_PCLRR_BE		0xFC0A4025
+#define MCFGPIO_PCLRR_CS		0xFC0A4026
+#define MCFGPIO_PCLRR_FECI2C		0xFC0A4027
+#define MCFGPIO_PCLRR_QSPI		0xFC0A4028
+#define MCFGPIO_PCLRR_TIMER		0xFC0A4029
+#define MCFGPIO_PCLRR_UART		0xFC0A402A
+#define MCFGPIO_PCLRR_FECH		0xFC0A402B
+#define MCFGPIO_PCLRR_FECL		0xFC0A402C
+/*
+ * Generic GPIO support
+ */
+#define MCFGPIO_PODR			MCFGPIO_PODR_BUSCTL
+#define MCFGPIO_PDDR			MCFGPIO_PDDR_BUSCTL
+#define MCFGPIO_PPDR			MCFGPIO_PPDSDR_BUSCTL
+#define MCFGPIO_SETR			MCFGPIO_PPDSDR_BUSCTL
+#define MCFGPIO_CLRR			MCFGPIO_PCLRR_BUSCTL
+
+#define MCFGPIO_PIN_MAX			80
+#define MCFGPIO_IRQ_MAX			8
+#define MCFGPIO_IRQ_VECBASE		MCFINT_VECBASE
+/****************************************************************************/
 
 #define MCF_GPIO_PAR_UART                   (0xA4036)
 #define MCF_GPIO_PAR_FECI2C                 (0xA4033)
