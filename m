Return-Path: <linux-kernel-owner+w=401wt.eu-S1756309AbZCJUHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309AbZCJUHa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 16:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629AbZCJUHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 16:07:21 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48184 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbZCJUHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 16:07:20 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 10 Mar 2009 21:07:06 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/5] firewire: core: drop unused call parameters of
 close_transaction
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.be62682e320707a0@s5r6.in-berlin.de>
Message-ID: <tkrat.1b175a76fec079fc@s5r6.in-berlin.de>
References: <tkrat.be62682e320707a0@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All callers inserted NULL and 0 here.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-transaction.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

Index: linux/drivers/firewire/fw-transaction.c
===================================================================
--- linux.orig/drivers/firewire/fw-transaction.c
+++ linux/drivers/firewire/fw-transaction.c
@@ -65,8 +65,7 @@
 #define PHY_IDENTIFIER(id)		((id) << 30)
 
 static int close_transaction(struct fw_transaction *transaction,
-			     struct fw_card *card, int rcode,
-			     u32 *payload, size_t length)
+			     struct fw_card *card, int rcode)
 {
 	struct fw_transaction *t;
 	unsigned long flags;
@@ -82,7 +81,7 @@ static int close_transaction(struct fw_t
 	spin_unlock_irqrestore(&card->lock, flags);
 
 	if (&t->link != &card->transaction_list) {
-		t->callback(card, rcode, payload, length, t->callback_data);
+		t->callback(card, rcode, NULL, 0, t->callback_data);
 		return 0;
 	}
 
@@ -110,7 +109,7 @@ int fw_cancel_transaction(struct fw_card
 	 * if the transaction is still pending and remove it in that case.
 	 */
 
-	return close_transaction(transaction, card, RCODE_CANCELLED, NULL, 0);
+	return close_transaction(transaction, card, RCODE_CANCELLED);
 }
 EXPORT_SYMBOL(fw_cancel_transaction);
 
@@ -122,7 +121,7 @@ static void transmit_complete_callback(s
 
 	switch (status) {
 	case ACK_COMPLETE:
-		close_transaction(t, card, RCODE_COMPLETE, NULL, 0);
+		close_transaction(t, card, RCODE_COMPLETE);
 		break;
 	case ACK_PENDING:
 		t->timestamp = packet->timestamp;
@@ -130,20 +129,20 @@ static void transmit_complete_callback(s
 	case ACK_BUSY_X:
 	case ACK_BUSY_A:
 	case ACK_BUSY_B:
-		close_transaction(t, card, RCODE_BUSY, NULL, 0);
+		close_transaction(t, card, RCODE_BUSY);
 		break;
 	case ACK_DATA_ERROR:
-		close_transaction(t, card, RCODE_DATA_ERROR, NULL, 0);
+		close_transaction(t, card, RCODE_DATA_ERROR);
 		break;
 	case ACK_TYPE_ERROR:
-		close_transaction(t, card, RCODE_TYPE_ERROR, NULL, 0);
+		close_transaction(t, card, RCODE_TYPE_ERROR);
 		break;
 	default:
 		/*
 		 * In this case the ack is really a juju specific
 		 * rcode, so just forward that to the callback.
 		 */
-		close_transaction(t, card, status, NULL, 0);
+		close_transaction(t, card, status);
 		break;
 	}
 }

-- 
Stefan Richter
-=====-==--= --== -=-=-
http://arcgraph.de/sr/

