Return-Path: <linux-kernel-owner+w=401wt.eu-S1759248AbYA3JbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759248AbYA3JbQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 04:31:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755722AbYA3JaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 04:30:19 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:40738 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185AbYA3JaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 04:30:16 -0500
X-IronPort-AV: E=Sophos;i="4.25,276,1199682000"; 
   d="scan'208";a="47624082"
From: Bryan Wu <bryan.wu@analog.com>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Javier Herrero <jherrero@hvsistemas.es>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 01/12] [8250 Serial Driver]: Added support for 8250-class UARTs in HV Sistemas H8606 board
Date: Wed, 30 Jan 2008 17:30:01 +0800
Message-Id: <1201685412-29095-2-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1201685412-29095-1-git-send-email-bryan.wu@analog.com>
References: <1201685412-29095-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Javier Herrero <jherrero@hvsistemas.es>

Added support for 8250-class UARTs in HV Sistemas H8606 board,
modification in 8250.c driver for correct compilation with Blackfin

Signed-off-by: Javier Herrero <jherrero@hvsistemas.es>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/serial/8250.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index f94109c..96c221c 100644
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
1.5.3.4
