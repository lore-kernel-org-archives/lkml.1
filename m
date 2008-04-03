Return-Path: <linux-kernel-owner+w=401wt.eu-S1762238AbYDUN3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762238AbYDUN3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 09:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757276AbYDUNTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 09:19:35 -0400
Received: from rn-out-0910.google.com ([64.233.170.189]:35324 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759597AbYDUNTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 09:19:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:in-reply-to:references:date:subject:cc:from;
        b=NmjvgSJLua+IAUxhIuHOF0eeOMjr1Wou7aw7cJxnHRkAEA2UU0ClQ29kjz+9EhSLQuGq3vuFR8joBVcMF47K5gq53vi6oOoxgcb4t0gcnULLwQC6SH4UlpOoh9tZF2TLeTMm+Kw556qiD5+NHJvR5B+oaZR0rl4VzDrp1JVxiN0=
Message-Id: <6eae9b0acdb6f03ed87ef882760e0ef8f440dc1a.1208783694.git.dmitry.torokhov@gmail.com>
In-Reply-To: <cover.1208783694.git.dmitry.torokhov@gmail.com>
References: <cover.1208783694.git.dmitry.torokhov@gmail.com>
Date: Thu, 3 Apr 2008 16:19:33 -0400
Subject: [PATCH 19/37] Input: xpad - don't use GFP_ATOMIC
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz, akpm@linux-foundation.org
From: Oliver Neukum <dmitry.torokhov@gmail.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GFP_ATOMIC should not be used when GFP_KERNEL can be used.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/joystick/xpad.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index ebf8303..d4d289e 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -497,7 +497,7 @@ static int xpad_init_output(struct usb_interface *intf, struct usb_xpad *xpad)
 		return 0;
 
 	xpad->odata = usb_buffer_alloc(xpad->udev, XPAD_PKT_LEN,
-				       GFP_ATOMIC, &xpad->odata_dma );
+				       GFP_KERNEL, &xpad->odata_dma);
 	if (!xpad->odata)
 		goto fail1;
 
@@ -729,7 +729,7 @@ static int xpad_probe(struct usb_interface *intf, const struct usb_device_id *id
 		goto fail1;
 
 	xpad->idata = usb_buffer_alloc(udev, XPAD_PKT_LEN,
-				       GFP_ATOMIC, &xpad->idata_dma);
+				       GFP_KERNEL, &xpad->idata_dma);
 	if (!xpad->idata)
 		goto fail1;
 
-- 
1.5.5.rc2.6.gf58d


