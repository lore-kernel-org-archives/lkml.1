Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbYJ0W2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbYJ0W2a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 18:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbYJ0W1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 18:27:55 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51175 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbYJ0W1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 18:27:54 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 27 Oct 2008 23:27:37 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [patch 2.6.27.y 3/6] firewire: Survive more than 256 bus resets
To: stable@kernel.org
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.df6e0a4afb92ef6e@s5r6.in-berlin.de>
Message-ID: <tkrat.6faab57f3da8f9b9@s5r6.in-berlin.de>
References: <tkrat.df6e0a4afb92ef6e@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Date: Thu, 16 Oct 2008 15:51:59 -0400
From: Jay Fenlason <fenlason@redhat.com>

The "color" is used during the topology building after a bus reset,
hovever in "struct fw_node"s it is stored in a u8, but in struct fw_card
it is stored in an int.  When the value wraps in one struct, but not
the other, disaster strikes.

Signed-off-by: Jay Fenlason <fenlason@redhat.com>

Fixes http://bugzilla.kernel.org/show_bug.cgi?id=10922 -
machine locks up solid if a series of bus resets occurs.

Same as commit 4f9740d4f5a17fa6a1b097fa3ccdfb7246660307.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-transaction.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/firewire/fw-transaction.h
===================================================================
--- linux.orig/drivers/firewire/fw-transaction.h
+++ linux/drivers/firewire/fw-transaction.h
@@ -248,7 +248,7 @@ struct fw_card {
 	struct fw_node *local_node;
 	struct fw_node *root_node;
 	struct fw_node *irm_node;
-	int color;
+	u8 color; /* must be u8 to match the definition in struct fw_node */
 	int gap_count;
 	bool beta_repeaters_present;
 

-- 
Stefan Richter
-=====-==--- =-=- ==-==
http://arcgraph.de/sr/

