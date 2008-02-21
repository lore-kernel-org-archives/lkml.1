Return-Path: <linux-kernel-owner+w=401wt.eu-S933693AbYBUQ6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933693AbYBUQ6G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 11:58:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755122AbYBUQ5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 11:57:53 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:57105 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752829AbYBUQ5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 11:57:52 -0500
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Victor <linux@maxim.org.za>,
       michael <trimarchi@gandalf.sssup.it>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH] atmel_serial: Fix interrupt handler return value
Date: Thu, 21 Feb 2008 17:56:32 +0100
Message-Id: <1203612992-18588-1-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should only return IRQ_HANDLED when we actually found something to
handle. This is important since the USART interrupt handler may be
shared with the timer interrupt on some chips.

Pointed-out-by: michael <trimarchi@gandalf.sssup.it>
Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 drivers/serial/atmel_serial.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index fad245b..d57bf3e 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -549,7 +549,7 @@ static irqreturn_t atmel_interrupt(int irq, void *dev_id)
 		atmel_handle_transmit(port, pending);
 	} while (pass_counter++ < ATMEL_ISR_PASS_LIMIT);
 
-	return IRQ_HANDLED;
+	return pass_counter ? IRQ_HANDLED : IRQ_NONE;
 }
 
 /*
-- 
1.5.4.1

