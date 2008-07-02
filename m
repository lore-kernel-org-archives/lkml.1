Return-Path: <linux-kernel-owner+w=401wt.eu-S1758273AbYGBU12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273AbYGBU12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 16:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755181AbYGBU0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 16:26:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33178 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722AbYGBU0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 16:26:40 -0400
Date: Wed, 2 Jul 2008 13:24:56 -0700
From: Greg Kroah-Hartman <gregkh@suse.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
       davem@davemloft.net
Subject: [patch 04/04] USB: handle pci_name() being const
Message-ID: <20080702202456.GD14024@kroah.com>
References: <20080702200902.909349505@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-handle-pci_name-being-const.patch"
In-Reply-To: <20080702202200.GA14021@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes usb_create_hcd() to be able to handle the fact that
pci_name() has changed to a constant string.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/hcd.c |    2 +-
 drivers/usb/core/hcd.h |    2 +-
 include/linux/usb.h    |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1755,7 +1755,7 @@ EXPORT_SYMBOL_GPL (usb_hc_died);
  * If memory is unavailable, returns NULL.
  */
 struct usb_hcd *usb_create_hcd (const struct hc_driver *driver,
-		struct device *dev, char *bus_name)
+		struct device *dev, const char *bus_name)
 {
 	struct usb_hcd *hcd;
 
--- a/drivers/usb/core/hcd.h
+++ b/drivers/usb/core/hcd.h
@@ -233,7 +233,7 @@ extern void usb_hcd_disable_endpoint(str
 extern int usb_hcd_get_frame_number(struct usb_device *udev);
 
 extern struct usb_hcd *usb_create_hcd(const struct hc_driver *driver,
-		struct device *dev, char *bus_name);
+		struct device *dev, const char *bus_name);
 extern struct usb_hcd *usb_get_hcd(struct usb_hcd *hcd);
 extern void usb_put_hcd(struct usb_hcd *hcd);
 extern int usb_add_hcd(struct usb_hcd *hcd,
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -293,7 +293,7 @@ struct usb_devmap {
 struct usb_bus {
 	struct device *controller;	/* host/master side hardware */
 	int busnum;			/* Bus number (in order of reg) */
-	char *bus_name;			/* stable id (PCI slot_name etc) */
+	const char *bus_name;		/* stable id (PCI slot_name etc) */
 	u8 uses_dma;			/* Does the host controller use DMA? */
 	u8 otg_port;			/* 0, or number of OTG/HNP port */
 	unsigned is_b_host:1;		/* true during some HNP roleswitches */

-- 
