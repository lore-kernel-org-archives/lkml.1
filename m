Return-Path: <linux-kernel-owner+w=401wt.eu-S1756489AbZJPRXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489AbZJPRXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 13:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754194AbZJPRSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 13:18:35 -0400
Received: from kroah.org ([198.145.64.141]:48559 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754207AbZJPRSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 13:18:31 -0400
X-Mailbox-Line: From linux@linux.site Fri Oct 16 10:12:00 2009
Message-Id: <20091016171159.669531487@linux.site>
User-Agent: quilt/0.47-14.9
Date: Fri, 16 Oct 2009 10:10:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Marcel Holtmann <marcel@holtmann.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [25/46] Bluetooth: Disconnect HIDRAW devices on disconnect
References: <20091016170953.128828149@linux.site>
Content-Disposition: inline; filename=bluetooth-disconnect-hidraw-devices-on-disconnect.patch
In-Reply-To: <20091016171422.GA13339@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Marcel Holtmann <marcel@holtmann.org>

commit 364f63519d94442ed373ac7da79033c8282df46a upstream.

Currently the HID subsystem will create HIDRAW devices for the transport
driver, but it will not disconnect them. Until the HID subsytem gets
fixed, ensure that HIDRAW and HIDDEV devices are disconnected when the
Bluetooth HID device gets removed.

Based on a patch from Brian Rogers <brian@xyzw.org>

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/bluetooth/hidp/core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -40,6 +40,7 @@
 
 #include <linux/input.h>
 #include <linux/hid.h>
+#include <linux/hidraw.h>
 
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci_core.h>
@@ -573,6 +574,8 @@ static int hidp_session(void *arg)
 	if (session->hid) {
 		if (session->hid->claimed & HID_CLAIMED_INPUT)
 			hidinput_disconnect(session->hid);
+		if (session->hid->claimed & HID_CLAIMED_HIDRAW)
+			hidraw_disconnect(session->hid);
 		hid_destroy_device(session->hid);
 	}
 


