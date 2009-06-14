Return-Path: <linux-kernel-owner+w=401wt.eu-S1755470AbZFNJog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbZFNJog (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 05:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750796AbZFNJo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 05:44:29 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:60350 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbZFNJo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 05:44:29 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 14 Jun 2009 11:44:24 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: core: use more outbound tlabels
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.e2bb42d0db655b15@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This appears to be a typo.  Tlabel is a 6 bits wide datum; we should
wrap it after 63 rather than 31.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-transaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/firewire/core-transaction.c
===================================================================
--- a/drivers/firewire/core-transaction.c
+++ b/drivers/firewire/core-transaction.c
@@ -294,7 +294,7 @@ void fw_send_request(struct fw_card *car
 		return;
 	}
 
-	card->current_tlabel = (card->current_tlabel + 1) & 0x1f;
+	card->current_tlabel = (card->current_tlabel + 1) & 0x3f;
 	card->tlabel_mask |= (1 << tlabel);
 
 	t->node_id = destination_id;

-- 
Stefan Richter
-=====-==--= -==- -===-
http://arcgraph.de/sr/

