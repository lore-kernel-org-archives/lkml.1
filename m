Return-Path: <linux-kernel-owner+w=401wt.eu-S936140AbYCSVG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936140AbYCSVG0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756999AbYCST5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:57:20 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:36814 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761273AbYCST5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:57:18 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 19 Mar 2008 20:55:28 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/2] firewire: catch self_id_count == 0
To: Jarod Wilson <jwilson@redhat.com>
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Message-ID: <tkrat.b99824b37365e037@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fw_core_handle_bus_reset() incorrectly relied on the assumption that
self_id_count > 0.  The added check should fix one aspect of
http://bugzilla.kernel.org/show_bug.cgi?id=10128

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-topology.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux/drivers/firewire/fw-topology.c
===================================================================
--- linux.orig/drivers/firewire/fw-topology.c
+++ linux/drivers/firewire/fw-topology.c
@@ -513,6 +513,11 @@ fw_core_handle_bus_reset(struct fw_card 
 
 	fw_flush_transactions(card);
 
+	if (self_id_count == 0) {
+		fw_destroy_nodes(card);
+		return;
+	}
+
 	spin_lock_irqsave(&card->lock, flags);
 
 	/*

-- 
Stefan Richter
-=====-==--- --== =--==
http://arcgraph.de/sr/

