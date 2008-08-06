Return-Path: <linux-kernel-owner+w=401wt.eu-S1754210AbYHFNXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbYHFNXm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 09:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756072AbYHFNUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 09:20:08 -0400
Received: from lopsy-lu.misterjones.org ([62.4.18.26]:53649 "EHLO
	young-lust.wild-wind.fr.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753819AbYHFNUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 09:20:00 -0400
From: Marc Zyngier <maz@misterjones.org>
To: linux-kernel@vger.kernel.org
Cc: Amit Walambe <amit.walambe@eurotech-ltd.co.uk>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Marc Zyngier <maz@misterjones.org>,
       Marc Zyngier <marc.zyngier@altran.com>
Subject: [PATCH 2/5] Add support for the Arcom/Eurotech Viper SBC onboard ethernet.
Date: Wed,  6 Aug 2008 15:19:51 +0200
Message-Id: <15b4632ba095731c7c6c384de0698e2ef84fa775.1218018637.git.marc.zyngier@altran.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <37f79c8da83c915c5ecc1d81cad9f4f5ae3c2b4a.1218018636.git.marc.zyngier@altran.com>
References: <>
 <1218028794-850-1-git-send-email-maz@misterjones.org>
 <37f79c8da83c915c5ecc1d81cad9f4f5ae3c2b4a.1218018636.git.marc.zyngier@altran.com>
In-Reply-To: <37f79c8da83c915c5ecc1d81cad9f4f5ae3c2b4a.1218018636.git.marc.zyngier@altran.com>
References: <37f79c8da83c915c5ecc1d81cad9f4f5ae3c2b4a.1218018636.git.marc.zyngier@altran.com>
X-SA-Exim-Connect-IP: 81.255.32.141
X-SA-Exim-Rcpt-To: linux-kernel@vger.kernel.org, amit.walambe@eurotech-ltd.co.uk, linux@dominikbrodowski.net, maz@misterjones.org, marc.zyngier@altran.com
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on young-lust.wild-wind.fr.eu.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marc Zyngier <marc.zyngier@altran.com>
---
 drivers/net/smc91x.h |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/net/smc91x.h b/drivers/net/smc91x.h
index 22209b6..9481412 100644
--- a/drivers/net/smc91x.h
+++ b/drivers/net/smc91x.h
@@ -185,6 +185,27 @@ static inline void SMC_outw(u16 val, void __iomem *ioaddr, int reg)
 
 #define SMC_IRQ_FLAGS		(-1)
 
+#elif defined(CONFIG_ARCH_VIPER)
+
+/* We can only do 16-bit reads and writes in the static memory space. */
+#define SMC_CAN_USE_8BIT	0
+#define SMC_CAN_USE_16BIT	1
+#define SMC_CAN_USE_32BIT	0
+#define SMC_CAN_USE_DATACS	1
+#define SMC_NOWAIT		1
+
+#define SMC_IO_SHIFT		0
+
+#define SMC_inw(a, r)		readw((a) + (r))
+#define SMC_outw(v, a, r)	writew(v, (a) + (r))
+#define SMC_insw(a, r, p, l)	insw((a) + (r), p, l)
+#define SMC_outsw(a, r, p, l)	outsw((a) + (r), p, l)
+
+#define RPC_LSA_DEFAULT		RPC_LED_100_10
+#define RPC_LSB_DEFAULT		RPC_LED_TX_RX
+
+#define SMC_IRQ_FLAGS		(-1)	/* from resource */
+
 #elif defined(CONFIG_SA1100_ASSABET)
 
 #include <asm/arch/neponset.h>
-- 
1.5.4.3

