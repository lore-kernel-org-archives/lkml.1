Return-Path: <linux-kernel-owner+w=401wt.eu-S932790AbXKOGuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932790AbXKOGuq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:50:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758874AbXKOGnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:43:17 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57706 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758458AbXKOGnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:43:14 -0500
Date: Wed, 14 Nov 2007 22:41:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-wireless@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>,
       Marc Pignat <marc.pignat@hevs.ch>, Daniel Drake <dsd@gentoo.org>
Subject: [patch 16/16] zd1211rw, fix oops when ejecting install media
Message-ID: <20071115064123.GQ18951@kroah.com>
References: <20071115060353.071060513@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="zd1211rw-fix-oops-when-ejecting-install-media.patch"
In-Reply-To: <20071115063921.GA18827@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Marc Pignat <marc.pignat@hevs.ch>

patch e0579d576cb894a4cf3c5af04fbf38e8c1281738 in mainline.

The disconnect function can dereference the net_device structure when it
is never allocated. This is the case when ejecting the device installer.

Signed-off-by: Marc Pignat <marc.pignat@hevs.ch>
Acked-by: Daniel Drake <dsd@gentoo.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/zd1211rw/zd_usb.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -1041,14 +1041,17 @@ error:
 static void disconnect(struct usb_interface *intf)
 {
 	struct net_device *netdev = zd_intf_to_netdev(intf);
-	struct zd_mac *mac = zd_netdev_mac(netdev);
-	struct zd_usb *usb = &mac->chip.usb;
+	struct zd_mac *mac;
+	struct zd_usb *usb;
 
 	/* Either something really bad happened, or we're just dealing with
 	 * a DEVICE_INSTALLER. */
 	if (netdev == NULL)
 		return;
 
+	mac = zd_netdev_mac(netdev);
+	usb = &mac->chip.usb;
+
 	dev_dbg_f(zd_usb_dev(usb), "\n");
 
 	zd_netdev_disconnect(netdev);

-- 
