Return-Path: <linux-kernel-owner+w=401wt.eu-S1758018AbZEKTNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018AbZEKTNo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 15:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754273AbZEKTNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 15:13:34 -0400
Received: from mail-ew0-f224.google.com ([209.85.219.224]:41685 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbZEKTNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 15:13:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=HNrtX7rMjIvOzFxUq72uxQzUCbL08GOyx4lvk5Q/DNlgQu/k0nAWgPx16BHRXmM1Qc
         iyguXL+X5cSfHpKEMDG11LwP1iq+uSsMPzAdnyQlAMg68HnjrEXZLilZfQBX0iRhPupv
         TkqWib0LxUy5pX5mXkni9YwkeBZan6k3MseWE=
Message-ID: <4A0878DC.8040907@gmail.com>
Date: Mon, 11 May 2009 21:13:32 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: jeremy@xensource.com
CC: virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 2] xen pvfb: remove driver_data direct access of struct device
References: <4A08775C.20305@gmail.com>
In-Reply-To: <4A08775C.20305@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid direct access to the driver_data pointer in struct device, the
functions dev_get_drvdata() and dev_set_drvdata() should be used.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
And another few, also see http://lkml.org/lkml/2009/5/4/353

diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
index 2493f05..15502d5 100644
--- a/drivers/video/xen-fbfront.c
+++ b/drivers/video/xen-fbfront.c
@@ -384,7 +384,7 @@ static int __devinit xenfb_probe(struct xenbus_device *dev,
 		fb_size = XENFB_DEFAULT_FB_LEN;
 	}
 
-	dev->dev.driver_data = info;
+	dev_set_drvdata(&dev->dev, info);
 	info->xbdev = dev;
 	info->irq = -1;
 	info->x1 = info->y1 = INT_MAX;
@@ -503,7 +503,7 @@ xenfb_make_preferred_console(void)
 
 static int xenfb_resume(struct xenbus_device *dev)
 {
-	struct xenfb_info *info = dev->dev.driver_data;
+	struct xenfb_info *info = dev_get_drvdata(&dev->dev);
 
 	xenfb_disconnect_backend(info);
 	xenfb_init_shared_page(info, info->fb_info);
@@ -512,7 +512,7 @@ static int xenfb_resume(struct xenbus_device *dev)
 
 static int xenfb_remove(struct xenbus_device *dev)
 {
-	struct xenfb_info *info = dev->dev.driver_data;
+	struct xenfb_info *info = dev_get_drvdata(&dev->dev);
 
 	xenfb_disconnect_backend(info);
 	if (info->fb_info) {
@@ -621,7 +621,7 @@ static void xenfb_disconnect_backend(struct xenfb_info *info)
 static void xenfb_backend_changed(struct xenbus_device *dev,
 				  enum xenbus_state backend_state)
 {
-	struct xenfb_info *info = dev->dev.driver_data;
+	struct xenfb_info *info = dev_get_drvdata(&dev->dev);
 	int val;
 
 	switch (backend_state) {
