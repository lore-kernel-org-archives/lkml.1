Return-Path: <linux-kernel-owner+w=401wt.eu-S936564AbZLQEa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936564AbZLQEa3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935690AbZLQE3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:29:54 -0500
Received: from kroah.org ([198.145.64.141]:55709 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935684AbZLQEEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:46 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:53 2009
Message-Id: <20091217035653.760116687@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:21 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [084/151] xen/xenbus: make DEVICE_ATTR()s static
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

commit db05fed0ad72f264e39bcb366795f7367384ec92 upstream.

They don't need to be global, and may cause linker clashes.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/xen/xenbus/xenbus_probe.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -454,21 +454,21 @@ static ssize_t xendev_show_nodename(stru
 {
 	return sprintf(buf, "%s\n", to_xenbus_device(dev)->nodename);
 }
-DEVICE_ATTR(nodename, S_IRUSR | S_IRGRP | S_IROTH, xendev_show_nodename, NULL);
+static DEVICE_ATTR(nodename, S_IRUSR | S_IRGRP | S_IROTH, xendev_show_nodename, NULL);
 
 static ssize_t xendev_show_devtype(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
 	return sprintf(buf, "%s\n", to_xenbus_device(dev)->devicetype);
 }
-DEVICE_ATTR(devtype, S_IRUSR | S_IRGRP | S_IROTH, xendev_show_devtype, NULL);
+static DEVICE_ATTR(devtype, S_IRUSR | S_IRGRP | S_IROTH, xendev_show_devtype, NULL);
 
 static ssize_t xendev_show_modalias(struct device *dev,
 				    struct device_attribute *attr, char *buf)
 {
 	return sprintf(buf, "xen:%s\n", to_xenbus_device(dev)->devicetype);
 }
-DEVICE_ATTR(modalias, S_IRUSR | S_IRGRP | S_IROTH, xendev_show_modalias, NULL);
+static DEVICE_ATTR(modalias, S_IRUSR | S_IRGRP | S_IROTH, xendev_show_modalias, NULL);
 
 int xenbus_probe_node(struct xen_bus_type *bus,
 		      const char *type,


