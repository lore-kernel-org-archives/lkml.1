Return-Path: <linux-kernel-owner+w=401wt.eu-S1755745AbZCJUAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745AbZCJUAJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 16:00:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754628AbZCJT7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 15:59:55 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48110 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbZCJT7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 15:59:54 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 10 Mar 2009 20:59:16 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/5] firewire: cdev: amendment to "add ioctl to query maximum
 transmission speed"
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.700492025c5bb3e8@s5r6.in-berlin.de>
Message-ID: <tkrat.0418569ebea41acc@s5r6.in-berlin.de>
References: <tkrat.700492025c5bb3e8@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The as yet unreleased FW_CDEV_IOC_GET_SPEED ioctl puts only a single
integer into the parameter buffer.  We can use ioctl()'s return value
instead.

(Also: Some whitespace change in firewire-cdev.h.)

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-cdev.c    |   11 +++++-----
 include/linux/firewire-cdev.h |   37 ++++++++++++----------------------
 2 files changed, 20 insertions(+), 28 deletions(-)

Index: linux/drivers/firewire/fw-cdev.c
===================================================================
--- linux.orig/drivers/firewire/fw-cdev.c
+++ linux/drivers/firewire/fw-cdev.c
@@ -1214,13 +1214,14 @@ static int ioctl_deallocate_iso_resource
 	return init_iso_resource(client, request, ISO_RES_DEALLOC_ONCE);
 }
 
+/*
+ * Returns a speed code:  Maximum speed to or from this device,
+ * limited by the device's link speed, the local node's link speed,
+ * and all PHY port speeds between the two links.
+ */
 static int ioctl_get_speed(struct client *client, void *buffer)
 {
-	struct fw_cdev_get_speed *request = buffer;
-
-	request->max_speed = client->device->max_speed;
-
-	return 0;
+	return client->device->max_speed;
 }
 
 static int ioctl_send_broadcast_request(struct client *client, void *buffer)
Index: linux/include/linux/firewire-cdev.h
===================================================================
--- linux.orig/include/linux/firewire-cdev.h
+++ linux/include/linux/firewire-cdev.h
@@ -223,28 +223,28 @@ union fw_cdev_event {
 };
 
 /* available since kernel version 2.6.22 */
-#define FW_CDEV_IOC_GET_INFO		_IOWR('#', 0x00, struct fw_cdev_get_info)
-#define FW_CDEV_IOC_SEND_REQUEST	_IOW('#', 0x01, struct fw_cdev_send_request)
-#define FW_CDEV_IOC_ALLOCATE		_IOWR('#', 0x02, struct fw_cdev_allocate)
-#define FW_CDEV_IOC_DEALLOCATE		_IOW('#', 0x03, struct fw_cdev_deallocate)
-#define FW_CDEV_IOC_SEND_RESPONSE	_IOW('#', 0x04, struct fw_cdev_send_response)
-#define FW_CDEV_IOC_INITIATE_BUS_RESET	_IOW('#', 0x05, struct fw_cdev_initiate_bus_reset)
-#define FW_CDEV_IOC_ADD_DESCRIPTOR	_IOWR('#', 0x06, struct fw_cdev_add_descriptor)
-#define FW_CDEV_IOC_REMOVE_DESCRIPTOR	_IOW('#', 0x07, struct fw_cdev_remove_descriptor)
-#define FW_CDEV_IOC_CREATE_ISO_CONTEXT	_IOWR('#', 0x08, struct fw_cdev_create_iso_context)
-#define FW_CDEV_IOC_QUEUE_ISO		_IOWR('#', 0x09, struct fw_cdev_queue_iso)
-#define FW_CDEV_IOC_START_ISO		_IOW('#', 0x0a, struct fw_cdev_start_iso)
-#define FW_CDEV_IOC_STOP_ISO		_IOW('#', 0x0b, struct fw_cdev_stop_iso)
+#define FW_CDEV_IOC_GET_INFO           _IOWR('#', 0x00, struct fw_cdev_get_info)
+#define FW_CDEV_IOC_SEND_REQUEST        _IOW('#', 0x01, struct fw_cdev_send_request)
+#define FW_CDEV_IOC_ALLOCATE           _IOWR('#', 0x02, struct fw_cdev_allocate)
+#define FW_CDEV_IOC_DEALLOCATE          _IOW('#', 0x03, struct fw_cdev_deallocate)
+#define FW_CDEV_IOC_SEND_RESPONSE       _IOW('#', 0x04, struct fw_cdev_send_response)
+#define FW_CDEV_IOC_INITIATE_BUS_RESET  _IOW('#', 0x05, struct fw_cdev_initiate_bus_reset)
+#define FW_CDEV_IOC_ADD_DESCRIPTOR     _IOWR('#', 0x06, struct fw_cdev_add_descriptor)
+#define FW_CDEV_IOC_REMOVE_DESCRIPTOR   _IOW('#', 0x07, struct fw_cdev_remove_descriptor)
+#define FW_CDEV_IOC_CREATE_ISO_CONTEXT _IOWR('#', 0x08, struct fw_cdev_create_iso_context)
+#define FW_CDEV_IOC_QUEUE_ISO          _IOWR('#', 0x09, struct fw_cdev_queue_iso)
+#define FW_CDEV_IOC_START_ISO           _IOW('#', 0x0a, struct fw_cdev_start_iso)
+#define FW_CDEV_IOC_STOP_ISO            _IOW('#', 0x0b, struct fw_cdev_stop_iso)
 
 /* available since kernel version 2.6.24 */
-#define FW_CDEV_IOC_GET_CYCLE_TIMER	_IOR('#', 0x0c, struct fw_cdev_get_cycle_timer)
+#define FW_CDEV_IOC_GET_CYCLE_TIMER     _IOR('#', 0x0c, struct fw_cdev_get_cycle_timer)
 
 /* available since kernel version 2.6.30 */
 #define FW_CDEV_IOC_ALLOCATE_ISO_RESOURCE       _IOWR('#', 0x0d, struct fw_cdev_allocate_iso_resource)
 #define FW_CDEV_IOC_DEALLOCATE_ISO_RESOURCE      _IOW('#', 0x0e, struct fw_cdev_deallocate)
 #define FW_CDEV_IOC_ALLOCATE_ISO_RESOURCE_ONCE   _IOW('#', 0x0f, struct fw_cdev_allocate_iso_resource)
 #define FW_CDEV_IOC_DEALLOCATE_ISO_RESOURCE_ONCE _IOW('#', 0x10, struct fw_cdev_allocate_iso_resource)
-#define FW_CDEV_IOC_GET_SPEED                    _IOR('#', 0x11, struct fw_cdev_get_speed)
+#define FW_CDEV_IOC_GET_SPEED                     _IO('#', 0x11) /* returns speed code */
 #define FW_CDEV_IOC_SEND_BROADCAST_REQUEST       _IOW('#', 0x12, struct fw_cdev_send_request)
 #define FW_CDEV_IOC_SEND_STREAM_PACKET           _IOW('#', 0x13, struct fw_cdev_send_stream_packet)
 
@@ -602,15 +602,6 @@ struct fw_cdev_allocate_iso_resource {
 };
 
 /**
- * struct fw_cdev_get_speed - Query maximum speed to or from this device
- * @max_speed:	Speed code; minimum of the device's link speed, the local node's
- *		link speed, and all PHY port speeds between the two links
- */
-struct fw_cdev_get_speed {
-	__u32 max_speed;
-};
-
-/**
  * struct fw_cdev_send_stream_packet - send an asynchronous stream packet
  * @generation:   Bus generation where the packet is valid
  * @speed:	  Speed code to send the packet at

-- 
Stefan Richter
-=====-==--= --== -=-=-
http://arcgraph.de/sr/

