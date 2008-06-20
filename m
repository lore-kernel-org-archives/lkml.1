Return-Path: <linux-kernel-owner+w=401wt.eu-S1762955AbYFTUZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762955AbYFTUZN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760862AbYFTUTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:19:15 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35183 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760853AbYFTUTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:19:07 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 27/70] usb-serial-bus: tidy coding style
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:01:43 +0100
Message-ID: <20080620200141.1479.88300.stgit@localhost.localdomain>
In-Reply-To: <20080620195406.1479.12620.stgit@localhost.localdomain>
References: <20080620195406.1479.12620.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>

Tidy up

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/usb/serial/bus.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)


diff --git a/drivers/usb/serial/bus.c b/drivers/usb/serial/bus.c
index 0b14aea..83bbb5b 100644
--- a/drivers/usb/serial/bus.c
+++ b/drivers/usb/serial/bus.c
@@ -15,7 +15,8 @@
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 
-static int usb_serial_device_match (struct device *dev, struct device_driver *drv)
+static int usb_serial_device_match(struct device *dev,
+						struct device_driver *drv)
 {
 	struct usb_serial_driver *driver;
 	const struct usb_serial_port *port;
@@ -46,7 +47,7 @@ static ssize_t show_port_number(struct device *dev,
 
 static DEVICE_ATTR(port_number, S_IRUGO, show_port_number, NULL);
 
-static int usb_serial_device_probe (struct device *dev)
+static int usb_serial_device_probe(struct device *dev)
 {
 	struct usb_serial_driver *driver;
 	struct usb_serial_port *port;
@@ -66,7 +67,7 @@ static int usb_serial_device_probe (struct device *dev)
 			retval = -EIO;
 			goto exit;
 		}
-		retval = driver->port_probe (port);
+		retval = driver->port_probe(port);
 		module_put(driver->driver.owner);
 		if (retval)
 			goto exit;
@@ -77,8 +78,8 @@ static int usb_serial_device_probe (struct device *dev)
 		goto exit;
 
 	minor = port->number;
-	tty_register_device (usb_serial_tty_driver, minor, dev);
-	dev_info(&port->serial->dev->dev, 
+	tty_register_device(usb_serial_tty_driver, minor, dev);
+	dev_info(&port->serial->dev->dev,
 		 "%s converter now attached to ttyUSB%d\n",
 		 driver->description, minor);
 
@@ -86,7 +87,7 @@ exit:
 	return retval;
 }
 
-static int usb_serial_device_remove (struct device *dev)
+static int usb_serial_device_remove(struct device *dev)
 {
 	struct usb_serial_driver *driver;
 	struct usb_serial_port *port;
@@ -94,9 +95,8 @@ static int usb_serial_device_remove (struct device *dev)
 	int minor;
 
 	port = to_usb_serial_port(dev);
-	if (!port) {
+	if (!port)
 		return -ENODEV;
-	}
 
 	device_remove_file(&port->dev, &dev_attr_port_number);
 
@@ -107,12 +107,12 @@ static int usb_serial_device_remove (struct device *dev)
 			retval = -EIO;
 			goto exit;
 		}
-		retval = driver->port_remove (port);
+		retval = driver->port_remove(port);
 		module_put(driver->driver.owner);
 	}
 exit:
 	minor = port->number;
-	tty_unregister_device (usb_serial_tty_driver, minor);
+	tty_unregister_device(usb_serial_tty_driver, minor);
 	dev_info(dev, "%s converter now disconnected from ttyUSB%d\n",
 		 driver->description, minor);
 

