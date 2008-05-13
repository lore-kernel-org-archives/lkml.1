Return-Path: <linux-kernel-owner+w=401wt.eu-S1758306AbYEMEPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758306AbYEMEPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 00:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbYEMEOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 00:14:33 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:54654 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757177AbYEMEOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 00:14:32 -0400
X-IronPort-AV: E=Sophos;i="4.27,477,1204520400"; 
   d="scan'208";a="68185750"
From: Bryan Wu <cooloney@kernel.org>
To: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Cc: Javier Herrero <jherrero@hvsistemas.es>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/2] [8250 Serial Driver]: Added support for 8250-class UARTs in HV Sistemas H8606 board
Date: Tue, 13 May 2008 12:14:28 +0800
Message-Id: <1210652069-16788-2-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1210652069-16788-1-git-send-email-cooloney@kernel.org>
References: <1210652069-16788-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Javier Herrero <jherrero@hvsistemas.es>

Added support for 8250-class UARTs in HV Sistemas H8606 board,
modification in 8250.c driver for correct compilation with Blackfin

Besides, I think that there is more people using 8250-class UARTs
with a different hardware than the H8606 board. This code can be shared
by them.

Signed-off-by: Javier Herrero <jherrero@hvsistemas.es>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/serial/8250.c |    5 +++--
 drivers/serial/8250.h |    5 +++++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index a1ca9b7..1400ea6 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -43,6 +43,7 @@
 
 #include <asm/io.h>
 #include <asm/irq.h>
+#include <asm/serial.h>
 
 #include "8250.h"
 
@@ -92,8 +93,6 @@ static unsigned int nr_uarts = CONFIG_SERIAL_8250_RUNTIME_UARTS;
  */
 #define CONFIG_HUB6 1
 
-#include <asm/serial.h>
-
 /*
  * SERIAL_PORT_DFNS tells us about built-in ports that have no
  * standard enumeration mechanism.   Platforms that can find all
@@ -1548,6 +1547,8 @@ static int serial_link_irq_chain(struct uart_8250_port *up)
 		i->head = &up->list;
 		spin_unlock_irq(&i->lock);
 
+		irq_flags |= SERIAL_EXTRA_IRQ_FLAGS;
+
 		ret = request_irq(up->port.irq, serial8250_interrupt,
 				  irq_flags, "serial", i);
 		if (ret < 0)
diff --git a/drivers/serial/8250.h b/drivers/serial/8250.h
index 91bd28f..a10a40c 100644
--- a/drivers/serial/8250.h
+++ b/drivers/serial/8250.h
@@ -78,3 +78,8 @@ struct serial8250_config {
 #else
 #define ALPHA_KLUDGE_MCR 0
 #endif
+
+#ifndef SERIAL_EXTRA_IRQ_FLAGS
+#define SERIAL_EXTRA_IRQ_FLAGS 0
+#endif
+
-- 
1.5.5
