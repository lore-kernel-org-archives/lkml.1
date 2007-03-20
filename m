Return-Path: <linux-kernel-owner+w=401wt.eu-S1751789AbXCTVpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789AbXCTVpJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 17:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbXCTVpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 17:45:08 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44622 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbXCTVpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 17:45:07 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 20 Mar 2007 22:43:22 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2.6.21-rc4] ieee1394: fix oops on "modprobe -r ohci1394" after
 network class_device conversion
To: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
cc: =?iso-8859-1?Q?Ismail_D=F6nmez?= <ismail@pardus.org.tr>,
       Adrian Bunk <bunk@stusta.de>, Greg KH <greg@kroah.com>,
       Thomas Meyer <thomas@m3y3r.de>, Tobias Diedrich <ranma@tdiedrich.de>
In-Reply-To: <200703150249.04169.ismail@pardus.org.tr>
Message-ID: <tkrat.5965dca5154c0fa2@s5r6.in-berlin.de>
References: <200703140642.28390.ismail@pardus.org.tr>
 <200703150051.29945.ismail@pardus.org.tr> <45F88E8B.90403@s5r6.in-berlin.de>
 <200703150249.04169.ismail@pardus.org.tr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The networking subsystem has been converted from class_device to device
but ieee1394 hasn't.  This results in a 100% reproducible NULL pointer
dereference if the ohci1394 driver module is unloaded while the eth1394
module is still loaded.
http://lkml.org/lkml/2006/11/16/147
http://lkml.org/lkml/2007/3/14/4

This is a regression in 2.6.21-rc1.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Works for me.  I still can connect to an OS X box via eth1394 after that
and modprobe -r ohci1394 before modprobe -r eth1394 works again.

Index: linux-2.6.21-rc4/drivers/ieee1394/eth1394.c
===================================================================
--- linux-2.6.21-rc4.orig/drivers/ieee1394/eth1394.c	2007-03-16 19:24:44.000000000 +0100
+++ linux-2.6.21-rc4/drivers/ieee1394/eth1394.c	2007-03-20 22:28:49.000000000 +0100
@@ -586,7 +586,10 @@ static void ether1394_add_host (struct h
         }
 
 	SET_MODULE_OWNER(dev);
+#if 0
+	/* FIXME - Is this the correct parent device anyway? */
 	SET_NETDEV_DEV(dev, &host->device);
+#endif
 
 	priv = netdev_priv(dev);
 


-- 
Stefan Richter
-=====-=-=== --== =-=--
http://arcgraph.de/sr/

