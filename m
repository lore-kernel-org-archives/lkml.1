Return-Path: <linux-kernel-owner+w=401wt.eu-S1752837Ab0AXNsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab0AXNsN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 08:48:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203Ab0AXNsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 08:48:12 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:39572 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab0AXNsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 08:48:09 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 24 Jan 2010 14:48:00 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: cdev: add_descriptor documentation fix
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.bec6fc906a5bb8cc@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct fw_cdev_add_descriptor.length is in quadlets, not in bytes.
Also remove any doubts about the endianess of descriptor data.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 include/linux/firewire-cdev.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux/include/linux/firewire-cdev.h
===================================================================
--- linux.orig/include/linux/firewire-cdev.h
+++ linux/include/linux/firewire-cdev.h
@@ -369,42 +369,44 @@ struct fw_cdev_deallocate {
  *
  * Initiate a bus reset for the bus this device is on.  The bus reset can be
  * either the original (long) bus reset or the arbitrated (short) bus reset
  * introduced in 1394a-2000.
  */
 struct fw_cdev_initiate_bus_reset {
 	__u32 type;	/* FW_CDEV_SHORT_RESET or FW_CDEV_LONG_RESET */
 };
 
 /**
  * struct fw_cdev_add_descriptor - Add contents to the local node's config ROM
  * @immediate:	If non-zero, immediate key to insert before pointer
  * @key:	Upper 8 bits of root directory pointer
  * @data:	Userspace pointer to contents of descriptor block
- * @length:	Length of descriptor block data, in bytes
+ * @length:	Length of descriptor block data, in quadlets
  * @handle:	Handle to the descriptor, written by the kernel
  *
  * Add a descriptor block and optionally a preceding immediate key to the local
  * node's configuration ROM.
  *
  * The @key field specifies the upper 8 bits of the descriptor root directory
  * pointer and the @data and @length fields specify the contents. The @key
  * should be of the form 0xXX000000. The offset part of the root directory entry
  * will be filled in by the kernel.
  *
  * If not 0, the @immediate field specifies an immediate key which will be
  * inserted before the root directory pointer.
  *
+ * @immediate, @key, and @data array elements are CPU-endian quadlets.
+ *
  * If successful, the kernel adds the descriptor and writes back a handle to the
  * kernel-side object to be used for later removal of the descriptor block and
  * immediate key.
  *
  * This ioctl affects the configuration ROMs of all local nodes.
  * The ioctl only succeeds on device files which represent a local node.
  */
 struct fw_cdev_add_descriptor {
 	__u32 immediate;
 	__u32 key;
 	__u64 data;
 	__u32 length;
 	__u32 handle;
 };

-- 
Stefan Richter
-=====-==-=- ---= ==---
http://arcgraph.de/sr/

