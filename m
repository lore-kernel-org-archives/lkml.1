Return-Path: <linux-kernel-owner+w=401wt.eu-S1763433AbZE1QeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763433AbZE1QeY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 12:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758773AbZE1QeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 12:34:17 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:4937 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758283AbZE1QeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 12:34:16 -0400
From: Kir Kolyshkin <kir@openvz.org>
To: linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Kir Kolyshkin <kir@openvz.org>
Subject: [PATCH] USB: cdc-acm: quirk for Alcatel OT-I650
Date: Thu, 28 May 2009 20:33:58 +0400
Message-Id: <1243528438-23040-1-git-send-email-kir@openvz.org>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This mobile phone fails to work as a modem, failing with:
 cdc_acm: Zero length descriptor references
 cdc_acm: probe of 1-6.1.3:1.1 failed with error -22

Tested to work fine with this patch.

Signed-off-by: Kir Kolyshkin <kir@openvz.org>
---
 drivers/usb/class/cdc-acm.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 0a69c09..68701c9 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1384,6 +1384,9 @@ static struct usb_device_id acm_ids[] = {
 					   Maybe we should define a new
 					   quirk for this. */
 	},
+	{ USB_DEVICE(0x1bbb, 0x0003), /* Alcatel OT-I650 */
+	.driver_info = NO_UNION_NORMAL, /* reports zero length descriptor */
+	},
 
 	/* control interfaces with various AT-command sets */
 	{ USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_ACM,
-- 
1.6.0.6

