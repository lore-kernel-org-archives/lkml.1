Return-Path: <linux-kernel-owner+w=401wt.eu-S965627AbXCGRZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965627AbXCGRZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:25:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422885AbXCGRR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:17:58 -0500
Received: from ns.suse.de ([195.135.220.2]:44250 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422877AbXCGRRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:17:23 -0500
Message-Id: <20070307171545.709022892@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, David Brownell <david-b@pacbell.net>
Subject: [patch 076/101] USB: usbnet driver bugfix
Content-Disposition: inline; filename=usb-usbnet-driver-bugfix.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <david-b@pacbell.net>

The attached fixes an oops in the usbnet driver. The same patch is
in 2.6.21-rc1, but that one has many whitespace changes. This is much
smaller.


Signed-off-by: David Brownell <david-b@pacbell.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/net/usbnet.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- linux-2.6.20.1.orig/drivers/usb/net/usbnet.c
+++ linux-2.6.20.1/drivers/usb/net/usbnet.c
@@ -1182,6 +1182,9 @@ usbnet_probe (struct usb_interface *udev
 	// NOTE net->name still not usable ...
 	if (info->bind) {
 		status = info->bind (dev, udev);
+		if (status < 0)
+			goto out1;
+
 		// heuristic:  "usb%d" for links we know are two-host,
 		// else "eth%d" when there's reasonable doubt.  userspace
 		// can rename the link if it knows better.
@@ -1208,12 +1211,12 @@ usbnet_probe (struct usb_interface *udev
 	if (status == 0 && dev->status)
 		status = init_status (dev, udev);
 	if (status < 0)
-		goto out1;
+		goto out3;
 
 	if (!dev->rx_urb_size)
 		dev->rx_urb_size = dev->hard_mtu;
 	dev->maxpacket = usb_maxpacket (dev->udev, dev->out, 1);
-	
+
 	SET_NETDEV_DEV(net, &udev->dev);
 	status = register_netdev (net);
 	if (status)

--
