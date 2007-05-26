Return-Path: <linux-kernel-owner+w=401wt.eu-S1759027AbXEZKJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759027AbXEZKJK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 06:09:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755112AbXEZKI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 06:08:58 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49135 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939AbXEZKI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 06:08:57 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 26 May 2007 12:08:35 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: eth1394: bring back a parent device
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Message-ID: <tkrat.9bca5c4cc2183f71@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I will submit this for 2.6.22-rc and 2.6.21.y if nobody objects.

Date: Mon, 21 May 2007 01:05:41 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: ieee1394: eth1394: bring back a parent device

This adds a real parent device to eth1394's ethX device like in Linux
2.6.20 and older.  However, due to unfinished conversion of the ieee1394
away from class_device, we now refer to the FireWire controller's PCI
device as the parent, not to the ieee1394 driver's fw-host device.

Having a real parent device instead of a virtual one allows udev scripts
to distinguish eth1394 interfaces from networking bridges, bondings and
the likes.

Fixes a regression since 2.6.21:
https://bugs.gentoo.org/show_bug.cgi?id=177199

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/eth1394.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Index: linux-2.6.22-rc2/drivers/ieee1394/eth1394.c
===================================================================
--- linux-2.6.22-rc2.orig/drivers/ieee1394/eth1394.c
+++ linux-2.6.22-rc2/drivers/ieee1394/eth1394.c
@@ -599,10 +599,9 @@ static void ether1394_add_host(struct hp
 	}
 
 	SET_MODULE_OWNER(dev);
-#if 0
-	/* FIXME - Is this the correct parent device anyway? */
-	SET_NETDEV_DEV(dev, &host->device);
-#endif
+
+	/* This used to be &host->device in Linux 2.6.20 and before. */
+	SET_NETDEV_DEV(dev, host->device.parent);
 
 	priv = netdev_priv(dev);
 	INIT_LIST_HEAD(&priv->ip_node_list);

-- 
Stefan Richter
-=====-=-=== -=-= ==-=-
http://arcgraph.de/sr/

