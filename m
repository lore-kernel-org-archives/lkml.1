Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab0BSUGU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 15:06:20 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:48938 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244Ab0BSUGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 15:06:19 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 19 Feb 2010 21:06:07 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: cdev: increment ABI version number
To: linux1394-devel@lists.sourceforge.net, Pieter Palmers <pieterp@joow.be>
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.9650095fffa41adc@s5r6.in-berlin.de>
Message-ID: <tkrat.f3725b33bc1bfdaa@s5r6.in-berlin.de>
References: <tkrat.9650095fffa41adc@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so that clients can detect whether the FW_CDEV_IOC_GET_CYCLE_TIMER ioctl
is reliable (on all tested controllers, especially the widely used VIA
controllers, also NEC controllers, see commits b677532b and 1c1517ef).
Also add a comment on the 2.6.32 iso xmit enhancement.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 include/linux/firewire-cdev.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: b/include/linux/firewire-cdev.h
===================================================================
--- a/include/linux/firewire-cdev.h
+++ b/include/linux/firewire-cdev.h
@@ -256,8 +256,10 @@ union fw_cdev_event {
  *  1  (2.6.22)  - initial version
  *  2  (2.6.30)  - changed &fw_cdev_event_iso_interrupt.header if
  *                 &fw_cdev_create_iso_context.header_size is 8 or more
+ *     (2.6.32)  - added time stamp to xmit &fw_cdev_event_iso_interrupt
+ *  3  (2.6.34)  - made &fw_cdev_get_cycle_timer reliable
  */
-#define FW_CDEV_VERSION 2
+#define FW_CDEV_VERSION 3
 
 /**
  * struct fw_cdev_get_info - General purpose information ioctl
@@ -556,6 +558,9 @@ struct fw_cdev_stop_iso {
  * @cycle_timer consists of 7 bits cycleSeconds, 13 bits cycleCount, and
  * 12 bits cycleOffset, in host byte order.  Cf. the Cycle Time register
  * per IEEE 1394 or Isochronous Cycle Timer register per OHCI-1394.
+ *
+ * In version 1 and 2 of the ABI, this ioctl returned unreliable (non-
+ * monotonic) @cycle_timer values on certain controllers.
  */
 struct fw_cdev_get_cycle_timer {
 	__u64 local_time;

-- 
Stefan Richter
-=====-==-=- --=- =--==
http://arcgraph.de/sr/

