Return-Path: <linux-kernel-owner+w=401wt.eu-S1756321AbYBSTae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321AbYBSTae (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 14:30:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753577AbYBST3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 14:29:45 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:36940 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760148AbYBST3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 14:29:44 -0500
Date: Tue, 19 Feb 2008 21:29:08 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Jaime Velasco Juan <jsagarribay@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org
Subject: [2.6 patch] make stk_camera_{suspend,resume}() static
Message-ID: <20080219192908.GF31955@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global stk_camera_{suspend,resume}() 
static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/media/video/stk-webcam.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

0142ed9da391bdcb89b8f029aaf7909a73bf4e20 diff --git a/drivers/media/video/stk-webcam.c b/drivers/media/video/stk-webcam.c
index ceba45a..d2bf541 100644
--- a/drivers/media/video/stk-webcam.c
+++ b/drivers/media/video/stk-webcam.c
@@ -1465,7 +1465,7 @@ static void stk_camera_disconnect(struct usb_interface *interface)
 }
 
 #ifdef CONFIG_PM
-int stk_camera_suspend(struct usb_interface *intf, pm_message_t message)
+static int stk_camera_suspend(struct usb_interface *intf, pm_message_t message)
 {
 	struct stk_camera *dev = usb_get_intfdata(intf);
 	if (is_streaming(dev)) {
@@ -1476,7 +1476,7 @@ int stk_camera_suspend(struct usb_interface *intf, pm_message_t message)
 	return 0;
 }
 
-int stk_camera_resume(struct usb_interface *intf)
+static int stk_camera_resume(struct usb_interface *intf)
 {
 	struct stk_camera *dev = usb_get_intfdata(intf);
 	if (!is_initialised(dev))

