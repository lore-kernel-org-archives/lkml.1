Return-Path: <linux-kernel-owner+w=401wt.eu-S1757388AbZCJUBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388AbZCJUBr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 16:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756382AbZCJUBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 16:01:38 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48124 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755603AbZCJUBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 16:01:37 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 10 Mar 2009 21:01:08 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 3/5] firewire: cdev: fix race of ioctl_send_request with bus
 reset
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.700492025c5bb3e8@s5r6.in-berlin.de>
Message-ID: <tkrat.3179a4eba4a0f5ee@s5r6.in-berlin.de>
References: <tkrat.700492025c5bb3e8@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bus reset handler concurrently frees client->device->node.  Use
device->node_id instead.  This is equivalent to device->node->node_id
while device->generation is current.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-cdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/firewire/fw-cdev.c
===================================================================
--- linux.orig/drivers/firewire/fw-cdev.c
+++ linux/drivers/firewire/fw-cdev.c
@@ -585,7 +585,7 @@ static int ioctl_send_request(struct cli
 		return -EINVAL;
 	}
 
-	return init_request(client, request, client->device->node->node_id,
+	return init_request(client, request, client->device->node_id,
 			    client->device->max_speed);
 }
 

-- 
Stefan Richter
-=====-==--= --== -=-=-
http://arcgraph.de/sr/

