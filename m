Return-Path: <linux-kernel-owner+w=401wt.eu-S939760AbXFHHyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939760AbXFHHyw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938406AbXFHHZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:25:21 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:55356 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938325AbXFHHZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:25:11 -0400
Message-Id: <20070608072159.888965000@sous-sol.org>
References: <20070608072127.352723000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:21:44 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 17/54] ieee1394: eth1394: bring back a parent device
Content-Disposition: inline; filename=ieee1394-eth1394-bring-back-a-parent-device.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Stefan Richter <stefanr@s5r6.in-berlin.de>

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
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
Same as commit ef50a6c59dc66f22eba67704e291d709f21e0456.

 drivers/ieee1394/eth1394.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- linux-2.6.21.4.orig/drivers/ieee1394/eth1394.c
+++ linux-2.6.21.4/drivers/ieee1394/eth1394.c
@@ -584,10 +584,9 @@ static void ether1394_add_host (struct h
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
 

-- 
