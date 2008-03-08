Return-Path: <linux-kernel-owner+w=401wt.eu-S1753714AbYCHVio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714AbYCHVio (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 16:38:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbYCHVig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 16:38:36 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:55812 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbYCHVif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 16:38:35 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 8 Mar 2008 22:38:16 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: warn on fatal condition in topology code
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.958f8693fedf5cf6@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If this ever happens to anybody, we want to have it in his log.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-topology.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/drivers/firewire/fw-topology.c
===================================================================
--- linux.orig/drivers/firewire/fw-topology.c
+++ linux/drivers/firewire/fw-topology.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/wait.h>
 #include <linux/errno.h>
+#include <asm/bug.h>
 #include <asm/system.h>
 #include "fw-transaction.h"
 #include "fw-topology.h"
@@ -425,8 +426,8 @@ update_tree(struct fw_card *card, struct
 	node1 = fw_node(list1.next);
 
 	while (&node0->link != &list0) {
+		WARN_ON(node0->port_count != node1->port_count);
 
-		/* assert(node0->port_count == node1->port_count); */
 		if (node0->link_on && !node1->link_on)
 			event = FW_NODE_LINK_OFF;
 		else if (!node0->link_on && node1->link_on)

-- 
Stefan Richter
-=====-==--- --== -=---
http://arcgraph.de/sr/

