Return-Path: <linux-kernel-owner+w=401wt.eu-S1757924AbZABLws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924AbZABLws (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 06:52:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757114AbZABLwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 06:52:40 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:48206 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756974AbZABLwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 06:52:39 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 2 Jan 2009 12:47:13 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: cdev: fix documentation of FW_CDEV_IOC_GET_INFO
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.c7deb6ca39b7041e@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FW_CDEV_IOC_GET_INFO ioctl looks at client->device->config_rom, not
at the local node's config ROM.

We could fix the implementation or the documentation.  I believe the way
how it is currently implemented is more useful than the way how it is
currently documented, hence let's change only the documentation.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 include/linux/firewire-cdev.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/include/linux/firewire-cdev.h
===================================================================
--- linux.orig/include/linux/firewire-cdev.h
+++ linux/include/linux/firewire-cdev.h
@@ -194,21 +194,21 @@ union fw_cdev_event {
 /**
  * struct fw_cdev_get_info - General purpose information ioctl
  * @version:	The version field is just a running serial number.
  *		We never break backwards compatibility, but may add more
  *		structs and ioctls in later revisions.
  * @rom_length:	If @rom is non-zero, at most rom_length bytes of configuration
  *		ROM will be copied into that user space address.  In either
  *		case, @rom_length is updated with the actual length of the
  *		configuration ROM.
  * @rom:	If non-zero, address of a buffer to be filled by a copy of the
- *		local node's configuration ROM
+ *		device's configuration ROM
  * @bus_reset:	If non-zero, address of a buffer to be filled by a
  *		&struct fw_cdev_event_bus_reset with the current state
  *		of the bus.  This does not cause a bus reset to happen.
  * @bus_reset_closure: Value of &closure in this and subsequent bus reset events
  * @card:	The index of the card this device belongs to
  */
 struct fw_cdev_get_info {
 	__u32 version;
 	__u32 rom_length;
 	__u64 rom;

-- 
Stefan Richter
-=====-==--= ---= ---=-
http://arcgraph.de/sr/

