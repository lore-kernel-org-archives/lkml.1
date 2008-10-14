Return-Path: <linux-kernel-owner+w=401wt.eu-S1753122AbYJNNav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122AbYJNNav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 09:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbYJNNaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 09:30:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44857 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540AbYJNNae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 09:30:34 -0400
Date: Tue, 14 Oct 2008 10:28:21 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Jiri Kosina <jikos@jikos.cz>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix numlock led on Dell keyboard (413c:2105)
Message-ID: <20081014102821.2693b15e@pedra.chehab.org>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This keyboard needs to re-sync numlock after probing.
    
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/hid/hid-dell.c b/drivers/hid/hid-dell.c
index 98ee40e..1a0d0df 100644
--- a/drivers/hid/hid-dell.c
+++ b/drivers/hid/hid-dell.c
@@ -47,6 +47,7 @@ err_free:
 
 static const struct hid_device_id dell_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DELL, USB_DEVICE_ID_DELL_W7658) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_DELL, USB_DEVICE_ID_DELL_SK8115) },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, dell_devices);
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index fa4e4fd..b74c505 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -132,6 +132,7 @@
 
 #define USB_VENDOR_ID_DELL		0x413c
 #define USB_DEVICE_ID_DELL_W7658	0x2005
+#define USB_DEVICE_ID_DELL_SK8115	0x2105
 
 #define USB_VENDOR_ID_DELORME		0x1163
 #define USB_DEVICE_ID_DELORME_EARTHMATE 0x0100
