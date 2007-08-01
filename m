Return-Path: <linux-kernel-owner+w=401wt.eu-S1758330AbXHAGts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758330AbXHAGts (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 02:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbXHAGtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 02:49:41 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:36857 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbXHAGtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 02:49:40 -0400
Date: Wed, 1 Aug 2007 15:48:55 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] net: smc91x: Build fixes for general sh boards.
Message-ID: <20070801064855.GA8118@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

SH boards in general only wire this up in 8 or 16-bit mode, and
as we never had the wrappers for 32-bit mode defined, SMC_CAN_USE_32BIT
caused build failure for the non-Solution Engine boards. This gets it
building again.

Also kill off the straggling set_irq_type() definition, this is left
over cruft that was missed when the rest of it switched to IRQ flags.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

--

 drivers/net/smc91x.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/smc91x.h b/drivers/net/smc91x.h
index f842944..6ff3a16 100644
--- a/drivers/net/smc91x.h
+++ b/drivers/net/smc91x.h
@@ -299,7 +299,7 @@ SMC_outw(u16 val, void __iomem *ioaddr, int reg)
 
 #define SMC_CAN_USE_8BIT       1
 #define SMC_CAN_USE_16BIT      1
-#define SMC_CAN_USE_32BIT      1
+#define SMC_CAN_USE_32BIT      0
 
 #define SMC_inb(a, r)          inb((a) + (r))
 #define SMC_inw(a, r)          inw((a) + (r))
@@ -310,8 +310,6 @@ SMC_outw(u16 val, void __iomem *ioaddr, int reg)
 
 #endif  /* BOARDS */
 
-#define set_irq_type(irq, type) do {} while (0)
-
 #elif   defined(CONFIG_M32R)
 
 #define SMC_CAN_USE_8BIT	0
