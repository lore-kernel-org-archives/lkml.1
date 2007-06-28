Return-Path: <linux-kernel-owner+w=401wt.eu-S1763780AbXF1PHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763780AbXF1PHl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 11:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757192AbXF1PHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 11:07:32 -0400
Received: from mail.gmx.net ([213.165.64.20]:52178 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757170AbXF1PHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 11:07:31 -0400
X-Authenticated: #402683
X-Provags-ID: V01U2FsdGVkX1/qmltsuQPqOt24VYyCrCzMKI68aSrD5qmObEtEAQ
	ShRLyPr/bt/S3A
Subject: [PATCH] myri10ge: SET_NETDEV_DEV()
From: Maik Hampel <m.hampel@gmx.de>
To: Jeff Garzik <jeff@garzik.org>
Cc: Brice Goglin <brice@myri.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 28 Jun 2007 17:07:26 +0200
Message-Id: <1183043246.2659.19.camel@c64>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

SET_NETDEV_DEV() in myri10ge to create the "/sys/class/net/<if>/device"
symlink.

Signed-off-by: Maik Hampel <m.hampel@gmx.de>

diff -Naur a/drivers/net/myri10ge/myri10ge.c
b/drivers/net/myri10ge/myri10ge.c
--- a/drivers/net/myri10ge/myri10ge.c	2007-06-28 16:04:41.000000000
+0200
+++ b/drivers/net/myri10ge/myri10ge.c	2007-06-28 16:31:24.000000000
+0200
@@ -2854,6 +2854,8 @@
 		return -ENOMEM;
 	}
 
+	SET_NETDEV_DEV(netdev, &pdev->dev);
+
 	mgp = netdev_priv(netdev);
 	memset(mgp, 0, sizeof(*mgp));
 	mgp->dev = netdev;


