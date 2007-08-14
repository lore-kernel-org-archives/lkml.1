Return-Path: <linux-kernel-owner+w=401wt.eu-S933810AbXHNSj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933810AbXHNSj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 14:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765446AbXHNSjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 14:39:21 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:51728
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588AbXHNSjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 14:39:20 -0400
Subject: [PATCH] synclink_gt fix module reference
From: Paul Fulghum <paulkf@microgate.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 14 Aug 2007 12:39:15 -0500
Message-Id: <1187113155.16053.2.camel@x2.microgate.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Get module reference on open() by generic HDLC
to prevent module from unloading while interface
is active.

Signed-off-by: Paul Fulghum <paulkf@microgate.com>

--- a/drivers/char/synclink_gt.c	2007-07-08 18:32:17.000000000 -0500
+++ b/drivers/char/synclink_gt.c	2007-08-14 12:27:50.000000000 -0500
@@ -1570,6 +1570,9 @@ static int hdlcdev_open(struct net_devic
 	int rc;
 	unsigned long flags;
 
+	if (!try_module_get(THIS_MODULE))
+		return -EBUSY;
+
 	DBGINFO(("%s hdlcdev_open\n", dev->name));
 
 	/* generic HDLC layer open processing */
@@ -1639,6 +1642,7 @@ static int hdlcdev_close(struct net_devi
 	info->netcount=0;
 	spin_unlock_irqrestore(&info->netlock, flags);
 
+	module_put(THIS_MODULE);
 	return 0;
 }
 


