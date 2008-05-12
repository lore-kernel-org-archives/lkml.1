Return-Path: <linux-kernel-owner+w=401wt.eu-S1760223AbYELEan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760223AbYELEan (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 00:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757477AbYELEaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 00:30:04 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:6827 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbYELE3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 00:29:23 -0400
X-IronPort-AV: E=Sophos;i="4.27,471,1204520400"; 
   d="scan'208";a="53384626"
From: Bryan Wu <cooloney@kernel.org>
To: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, Javier Herrero <jherrero@hvsistemas.es>,
       Bryan Wu <bryan.wu@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/2] [8250 Serial Driver]: Added support for 8250-class UARTs in HV Sistemas H8606 board
Date: Mon, 12 May 2008 12:29:24 +0800
Message-Id: <1210566565-6205-2-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1210566565-6205-1-git-send-email-cooloney@kernel.org>
References: <1210566565-6205-1-git-send-email-cooloney@kernel.org>
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
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/serial/8250.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index a1ca9b7..d171561 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -1548,6 +1548,10 @@ static int serial_link_irq_chain(struct uart_8250_port *up)
 		i->head = &up->list;
 		spin_unlock_irq(&i->lock);
 
+#ifdef SERIAL_EXTRA_IRQ_FLAGS
+		irq_flags |= SERIAL_EXTRA_IRQ_FLAGS;
+#endif
+
 		ret = request_irq(up->port.irq, serial8250_interrupt,
 				  irq_flags, "serial", i);
 		if (ret < 0)
-- 
1.5.5
