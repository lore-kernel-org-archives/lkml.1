Return-Path: <linux-kernel-owner+w=401wt.eu-S1752723AbZBCQZD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbZBCQZD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 11:25:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbZBCQYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 11:24:53 -0500
Received: from relay1.sgi.com ([192.48.179.29]:41085 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751986AbZBCQYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 11:24:52 -0500
Date: Tue, 3 Feb 2009 10:24:51 -0600
From: Dean Nelson <dcn@sgi.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] sgi-xp: link XPNET's net_device_ops to its net_device structure
Message-ID: <20090203162451.GA32228@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A recent patch by Stephen Hemminger to convert XPNET to use net_device_ops and
internal net_device_stats failed to link the net_device_ops structure to the
net_device structure. See commit e8ac9c55f28482f5b2f497a8e7eb90985db237c2.

Signed-off-by: Dean Nelson <dcn@sgi.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>

---

 drivers/misc/sgi-xp/xpnet.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/drivers/misc/sgi-xp/xpnet.c
===================================================================
--- linux.orig/drivers/misc/sgi-xp/xpnet.c	2009-02-03 06:52:18.000000000 -0600
+++ linux/drivers/misc/sgi-xp/xpnet.c	2009-02-03 09:45:12.021089437 -0600
@@ -3,7 +3,7 @@
  * License.  See the file "COPYING" in the main directory of this archive
  * for more details.
  *
- * Copyright (C) 1999-2008 Silicon Graphics, Inc. All rights reserved.
+ * Copyright (C) 1999-2009 Silicon Graphics, Inc. All rights reserved.
  */
 
 /*
@@ -551,6 +551,7 @@ xpnet_init(void)
 
 	netif_carrier_off(xpnet_device);
 
+	xpnet_device->netdev_ops = &xpnet_netdev_ops;
 	xpnet_device->mtu = XPNET_DEF_MTU;
 
 	/*
