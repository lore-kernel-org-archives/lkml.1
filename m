Return-Path: <linux-kernel-owner+w=401wt.eu-S1753007AbYJ0LQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007AbYJ0LQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 07:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbYJ0LQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 07:16:24 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:43386 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbYJ0LQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 07:16:23 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: jkosina@suse.cz
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 2/2] HID: usbhid, sync on deleted io_retry timer
Date: Mon, 27 Oct 2008 12:16:16 +0100
Message-Id: <1225106176-5496-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1225106176-5496-1-git-send-email-jirislaby@gmail.com>
References: <1225106176-5496-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When suspending, make sure that the timer is not running.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/hid/usbhid/hid-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index a761e08..9ad4bae 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -1045,7 +1045,7 @@ static int hid_suspend(struct usb_interface *intf, pm_message_t message)
 	spin_lock_irq(&usbhid->inlock);	/* Sync with error handler */
 	set_bit(HID_SUSPENDED, &usbhid->iofl);
 	spin_unlock_irq(&usbhid->inlock);
-	del_timer(&usbhid->io_retry);
+	del_timer_sync(&usbhid->io_retry);
 	usb_kill_urb(usbhid->urbin);
 	mutex_unlock(&usbhid->setup);
 	dev_dbg(&intf->dev, "suspend\n");
-- 
1.6.0.2

