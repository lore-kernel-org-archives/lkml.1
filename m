Return-Path: <linux-kernel-owner+w=401wt.eu-S1761941AbYBLKAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761941AbYBLKAU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 05:00:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760132AbYBLKAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 05:00:06 -0500
Received: from smtp.nokia.com ([192.100.105.134]:17692 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756486AbYBLKAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 05:00:04 -0500
From: Felipe Balbi <felipe.balbi@nokia.com>
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Cc: me@felipebalbi.com, david-b@pacbell.net,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: [PATCH] USB: OTG: Fix weirdnesses on enumerating partial otg devices
Date: Tue, 12 Feb 2008 12:00:03 -0500
Message-Id: <1202835603-10663-1-git-send-email-felipe.balbi@nokia.com>
X-Mailer: git-send-email 1.5.4.34.g053d9
X-OriginalArrivalTime: 12 Feb 2008 09:59:28.0768 (UTC) FILETIME=[F4DEB000:01C86D5D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the check for is_b_host upon enumerating otg devices as it
can trigger some weird behaviors on otg sessions. Some devices claim
to be b_host even though they have an a_connector attached to it.

Checking b_hnp_enable flag should be secure enough or terms of
otg compliancy.

Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
---
 drivers/usb/core/hub.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 68fc521..963cf9b 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1315,7 +1315,7 @@ static int usb_configure_device_otg(struct usb_device *udev)
 		/* Maybe it can talk to us, though we can't talk to it.
 		 * (Includes HNP test device.)
 		 */
-		if (udev->bus->b_hnp_enable || udev->bus->is_b_host) {
+		if (udev->bus->b_hnp_enable) {
 			err = usb_port_suspend(udev);
 			if (err < 0)
 				dev_dbg(&udev->dev, "HNP fail, %d\n", err);
-- 
1.5.4.34.g053d9

