Return-Path: <linux-kernel-owner+w=401wt.eu-S1751771AbXJUJU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771AbXJUJU1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 05:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751080AbXJUJUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 05:20:20 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:40233 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbXJUJUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 05:20:19 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 21 Oct 2007 11:20:07 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: fw-ohci: shut up a superfluous compiler warning
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.fdb5232bde32f451@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

New warning since commit ab88ca488b8af66c3defa165874e81e695319a19,
"firewire: fw-ohci: missing dma_unmap_single":
drivers/firewire/fw-ohci.c: In function 'at_context_transmit':
drivers/firewire/fw-ohci.c:609: warning: 'payload_bus' may be used
 uninitialized in this function

Access to payload_bus is conditional on packet->payload_length > 0,
and that won't change while in at_context_queue_packet.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-ohci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/firewire/fw-ohci.c
===================================================================
--- linux.orig/drivers/firewire/fw-ohci.c
+++ linux/drivers/firewire/fw-ohci.c
@@ -606,7 +606,7 @@ static int
 at_context_queue_packet(struct context *ctx, struct fw_packet *packet)
 {
 	struct fw_ohci *ohci = ctx->ohci;
-	dma_addr_t d_bus, payload_bus;
+	dma_addr_t d_bus, uninitialized_var(payload_bus);
 	struct driver_data *driver_data;
 	struct descriptor *d, *last;
 	__le32 *header;

-- 
Stefan Richter
-=====-=-=== =-=- =-=-=
http://arcgraph.de/sr/

