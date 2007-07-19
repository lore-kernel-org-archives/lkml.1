Return-Path: <linux-kernel-owner+w=401wt.eu-S1764265AbXGSH2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764265AbXGSH2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 03:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758210AbXGSH1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 03:27:52 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:37683 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158AbXGSH1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 03:27:51 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 19 Jul 2007 09:27:37 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2.6.22.y] fw-ohci: fix "scheduling while atomic"
To: stable@kernel.org
cc: linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>
Message-ID: <tkrat.bf75c55e27c90af7@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Date: Thu, 12 Jul 2007 22:25:14 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: firewire: fw-ohci: fix "scheduling while atomic"

context_stop is called by bus_reset_tasklet, among else.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
Fixes http://bugzilla.kernel.org/show_bug.cgi?id=8735.
Same as commit b980f5a224f3df6c884dbf5ae48797ce352ba139.

 drivers/firewire/fw-ohci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.22/drivers/firewire/fw-ohci.c
===================================================================
--- linux-2.6.22.orig/drivers/firewire/fw-ohci.c
+++ linux-2.6.22/drivers/firewire/fw-ohci.c
@@ -586,7 +586,7 @@ static void context_stop(struct context 
 			break;
 
 		fw_notify("context_stop: still active (0x%08x)\n", reg);
-		msleep(1);
+		mdelay(1);
 	}
 }
 

-- 
Stefan Richter
-=====-=-=== -=== =--==
http://arcgraph.de/sr/

