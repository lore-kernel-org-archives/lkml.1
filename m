Return-Path: <linux-kernel-owner+w=401wt.eu-S1752784AbZIGXOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbZIGXOJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 19:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbZIGXOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 19:14:09 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:33243 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbZIGXOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 19:14:08 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 8 Sep 2009 01:13:53 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: core: fix topology map response handler
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.625657a5b02c4d55@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This register is 1 kBytes large.  Adjust topology_map.length to prevent
registration of other response handlers in this region and to make sure
that we respond to requests to the upper half of the register.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-transaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.31-rc9/drivers/firewire/core-transaction.c
===================================================================
--- linux-2.6.31-rc9.orig/drivers/firewire/core-transaction.c
+++ linux-2.6.31-rc9/drivers/firewire/core-transaction.c
@@ -834,7 +834,7 @@ static void handle_topology_map(struct f
 }
 
 static struct fw_address_handler topology_map = {
-	.length			= 0x200,
+	.length			= 0x400,
 	.address_callback	= handle_topology_map,
 };
 

-- 
Stefan Richter
-=====-==--= =--= -=---
http://arcgraph.de/sr/

