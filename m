Return-Path: <linux-kernel-owner+w=401wt.eu-S1759205AbXIBT7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759205AbXIBT7m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 15:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbXIBT7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 15:59:36 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44557 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbXIBT7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 15:59:35 -0400
Date: Mon, 3 Sep 2007 01:42:43 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Greg Kroah-Hartman <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net
Subject: [PATCH -mm] drivers/usb/serial/bus.c: Fix incompatible pointer type
 warning
In-Reply-To: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.in>
Message-ID: <alpine.LFD.0.999.0709030141460.29617@enigma.security.iitk.ac.in>
References: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.i
 n>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="464262402-406655073-1188763967=:29617"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--464262402-406655073-1188763967=:29617
Content-Type: TEXT/PLAIN; charset=iso-2022-jp


drivers/usb/serial/bus.c: In function ‘usb_serial_bus_deregister’:
drivers/usb/serial/bus.c:185:
warning: passing argument 1 of ‘free_dynids’ from incompatible pointer type

Above build warning comes when CONFIG_HOTPLUG=n because argument of
free_dynids() in serial/bus.c is a struct usb_serial_driver, not a
struct usb_driver. This is not a runtime bug, because the function
is an empty stub and never dereferences the passed pointer anyway.

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

 drivers/usb/serial/bus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.23-rc4-mm1/drivers/usb/serial/bus.c~fix	2007-09-02 20:33:18.000000000 +0530
+++ linux-2.6.23-rc4-mm1/drivers/usb/serial/bus.c	2007-09-02 20:39:06.000000000 +0530
@@ -154,7 +154,7 @@ static void free_dynids(struct usb_seria
 static struct driver_attribute drv_attrs[] = {
 	__ATTR_NULL,
 };
-static inline void free_dynids(struct usb_driver *drv)
+static inline void free_dynids(struct usb_serial_driver *drv)
 {
 }
 #endif
--464262402-406655073-1188763967=:29617--
