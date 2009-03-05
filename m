Return-Path: <linux-kernel-owner+w=401wt.eu-S1756741AbZCESHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741AbZCESHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 13:07:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755491AbZCESH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 13:07:29 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:42208 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754995AbZCESH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 13:07:28 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 5 Mar 2009 19:07:00 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: core: normalize a function argument name
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.916a9336931722b9@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's called "payload" rather than "data" almost everywhere in
fw-transaction.c.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-transaction.c |    6 +++---
 drivers/firewire/fw-transaction.h |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

Index: linux/drivers/firewire/fw-transaction.c
===================================================================
--- linux.orig/drivers/firewire/fw-transaction.c
+++ linux/drivers/firewire/fw-transaction.c
@@ -317,15 +317,15 @@ static void transaction_callback(struct 
  */
 int fw_run_transaction(struct fw_card *card, int tcode, int destination_id,
 		       int generation, int speed, unsigned long long offset,
-		       void *data, size_t length)
+		       void *payload, size_t length)
 {
 	struct transaction_callback_data d;
 	struct fw_transaction t;
 
 	init_completion(&d.done);
-	d.payload = data;
+	d.payload = payload;
 	fw_send_request(card, &t, tcode, destination_id, generation, speed,
-			offset, data, length, transaction_callback, &d);
+			offset, payload, length, transaction_callback, &d);
 	wait_for_completion(&d.done);
 
 	return d.rcode;
Index: linux/drivers/firewire/fw-transaction.h
===================================================================
--- linux.orig/drivers/firewire/fw-transaction.h
+++ linux/drivers/firewire/fw-transaction.h
@@ -405,14 +405,14 @@ int fw_core_initiate_bus_reset(struct fw
 
 void fw_send_request(struct fw_card *card, struct fw_transaction *t,
 		int tcode, int destination_id, int generation, int speed,
-		unsigned long long offset, void *data, size_t length,
+		unsigned long long offset, void *payload, size_t length,
 		fw_transaction_callback_t callback, void *callback_data);
 int fw_cancel_transaction(struct fw_card *card,
 			  struct fw_transaction *transaction);
 void fw_flush_transactions(struct fw_card *card);
 int fw_run_transaction(struct fw_card *card, int tcode, int destination_id,
 		       int generation, int speed, unsigned long long offset,
-		       void *data, size_t length);
+		       void *payload, size_t length);
 void fw_send_phy_config(struct fw_card *card,
 			int node_id, int generation, int gap_count);
 

-- 
Stefan Richter
-=====-==--= --== --=-=
http://arcgraph.de/sr/

