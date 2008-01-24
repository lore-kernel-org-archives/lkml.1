Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566AbYAXAyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbYAXAyk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 19:54:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbYAXAy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 19:54:29 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:45360 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722AbYAXAy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 19:54:28 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 24 Jan 2008 01:53:51 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/4] firewire: fw-cdev: use device generation, not card
 generation
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>,
       Jarod Wilson <jwilson@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
In-Reply-To: <tkrat.288da3bd61ecfb20@s5r6.in-berlin.de>
Message-ID: <tkrat.8ff4f57f5db5f094@s5r6.in-berlin.de>
References: <tkrat.66a8b3070e07d80f@s5r6.in-berlin.de>
 <200711011453.35268.nickpiggin@yahoo.com.au>
 <4729A1BF.8010800@s5r6.in-berlin.de>
 <tkrat.288da3bd61ecfb20@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have to use the fw_device.generation here, not the fw_card.generation,
because the generation must never be newer than the node ID when we emit
a transaction.  This cannot be guaranteed with fw_card.generation.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

This code also needs barriers to work precisely as intended.  They will
be added by a subsequent patch which consistently updates readers and
writers of .generation and .node_id.

 drivers/firewire/fw-cdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/firewire/fw-cdev.c
===================================================================
--- linux.orig/drivers/firewire/fw-cdev.c
+++ linux/drivers/firewire/fw-cdev.c
@@ -206,12 +206,12 @@ fill_bus_reset_event(struct fw_cdev_even
 
 	event->closure	     = client->bus_reset_closure;
 	event->type          = FW_CDEV_EVENT_BUS_RESET;
+	event->generation    = client->device->generation;
 	event->node_id       = client->device->node_id;
 	event->local_node_id = card->local_node->node_id;
 	event->bm_node_id    = 0; /* FIXME: We don't track the BM. */
 	event->irm_node_id   = card->irm_node->node_id;
 	event->root_node_id  = card->root_node->node_id;
-	event->generation    = card->generation;
 }
 
 static void

-- 
Stefan Richter
-=====-==--- ---= ==---
http://arcgraph.de/sr/

