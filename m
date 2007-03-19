Return-Path: <linux-kernel-owner+w=401wt.eu-S1753395AbXCSJ0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbXCSJ0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 05:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbXCSJ0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 05:26:48 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:34852 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753369AbXCSJ03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 05:26:29 -0400
Date: Mon, 19 Mar 2007 10:26:32 +0100
From: Adrian Bunk <bunk@stusta.de>
To: "Jeremy A. Roberson" <jroberson@gtcocalcomp.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: [2.6 patch] drivers/usb/input/gtco.c: fix a use-before-check
Message-ID: <20070319092632.GQ752@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

NULL checks should be before the first dereference.

Spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.21-rc3-mm2/drivers/usb/input/gtco.c.old	2007-03-19 09:29:44.000000000 +0100
+++ linux-2.6.21-rc3-mm2/drivers/usb/input/gtco.c	2007-03-19 09:30:31.000000000 +0100
@@ -1047,13 +1047,10 @@ static void gtco_disconnect(struct usb_i
 
 	/* Grab private device ptr */
 	struct gtco    *device = usb_get_intfdata (interface);
-	struct input_dev *inputdev;
-
-	inputdev = device->inputdevice;
 
 	/* Now reverse all the registration stuff */
 	if (device) {
-		input_unregister_device(inputdev);
+		input_unregister_device(device->inputdevice);
 		usb_kill_urb(device->urbinfo);
 		usb_free_urb(device->urbinfo);
 		usb_buffer_free(device->usbdev, REPORT_MAX_SIZE,

