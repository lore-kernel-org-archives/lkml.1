Return-Path: <linux-kernel-owner+w=401wt.eu-S1760574AbXH2K7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760574AbXH2K7E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 06:59:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757121AbXH2K6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 06:58:54 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:43857 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970AbXH2K6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 06:58:53 -0400
Date: Wed, 29 Aug 2007 11:16:22 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [SERIAL] BCM1480 serial build fix
Message-ID: <20070829101622.GA21542@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thiemo Seufer <ths@networkno.de>

The appended patch restores serial functionality for the BCM1480.

Signed-Off-By: Thiemo Seufer <ths@networkno.de>
Signed-Off-By: Ralf Baechle <ralf@linux-mips.org>

diff --git a/drivers/serial/sb1250-duart.c b/drivers/serial/sb1250-duart.c
index 1d9d728..e7f5c0e 100644
--- a/drivers/serial/sb1250-duart.c
+++ b/drivers/serial/sb1250-duart.c
@@ -57,6 +57,12 @@
 #define SBD_CTRLREGS(line)	A_BCM1480_DUART_CTRLREG((line), 0)
 #define SBD_INT(line)		(K_BCM1480_INT_UART_0 + (line))
 
+#define DUART_CHANREG_SPACING	BCM1480_DUART_CHANREG_SPACING
+
+#define R_DUART_IMRREG(line)	R_BCM1480_DUART_IMRREG(line)
+#define R_DUART_INCHREG(line)	R_BCM1480_DUART_INCHREG(line)
+#define R_DUART_ISRREG(line)	R_BCM1480_DUART_ISRREG(line)
+
 #elif defined(CONFIG_SIBYTE_SB1250) || defined(CONFIG_SIBYTE_BCM112X)
 #include <asm/sibyte/sb1250_regs.h>
 #include <asm/sibyte/sb1250_int.h>
diff --git a/include/asm-mips/sibyte/bcm1480_regs.h b/include/asm-mips/sibyte/bcm1480_regs.h
index 2738c13..c34d36b 100644
--- a/include/asm-mips/sibyte/bcm1480_regs.h
+++ b/include/asm-mips/sibyte/bcm1480_regs.h
@@ -227,10 +227,15 @@
 	(A_BCM1480_DUART(chan) +					\
 	 BCM1480_DUART_CHANREG_SPACING * 3 + (reg))
 
+#define DUART_IMRISR_SPACING	    0x20
+#define DUART_INCHNG_SPACING	    0x10
+
 #define R_BCM1480_DUART_IMRREG(chan)					\
 	(R_DUART_IMR_A + ((chan) & 1) * DUART_IMRISR_SPACING)
 #define R_BCM1480_DUART_ISRREG(chan)					\
 	(R_DUART_ISR_A + ((chan) & 1) * DUART_IMRISR_SPACING)
+#define R_BCM1480_DUART_INCHREG(chan)					\
+	(R_DUART_IN_CHNG_A + ((chan) & 1) * DUART_INCHNG_SPACING)
 
 #define A_BCM1480_DUART_IMRREG(chan)					\
 	(A_BCM1480_DUART_CTRLREG((chan), R_BCM1480_DUART_IMRREG(chan)))

----- End forwarded message -----
