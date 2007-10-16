Return-Path: <linux-kernel-owner+w=401wt.eu-S934526AbXJPRkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934526AbXJPRkt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 13:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762624AbXJPRkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 13:40:40 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:35489 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222AbXJPRkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 13:40:39 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 16 Oct 2007 19:40:04 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH corrected] firewire: fw-ohci: fix DMA mapping for ar context
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>
In-Reply-To: <4714F652.1060007@s5r6.in-berlin.de>
Message-ID: <tkrat.c21e564719351bc6@s5r6.in-berlin.de>
References: <tkrat.2493a847503e3d62@s5r6.in-berlin.de>
 <4714F652.1060007@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The CPU must not touch the buffer after it was DMA-mapped.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-ohci.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/drivers/firewire/fw-ohci.c
===================================================================
--- linux.orig/drivers/firewire/fw-ohci.c
+++ linux/drivers/firewire/fw-ohci.c
@@ -258,6 +258,7 @@ static int ar_context_add_page(struct ar
 		free_page((unsigned long) ab);
 		return -ENOMEM;
 	}
+	dma_sync_single_for_cpu(dev, ab_bus, PAGE_SIZE, DMA_BIDIRECTIONAL);
 
 	memset(&ab->descriptor, 0, sizeof(ab->descriptor));
 	ab->descriptor.control        = cpu_to_le16(DESCRIPTOR_INPUT_MORE |

-- 
Stefan Richter
-=====-=-=== =-=- =----
http://arcgraph.de/sr/

