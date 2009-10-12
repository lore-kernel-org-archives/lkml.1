Return-Path: <linux-kernel-owner+w=401wt.eu-S1758577AbZJLW0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758577AbZJLW0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 18:26:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758568AbZJLW0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 18:26:09 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:37033 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758533AbZJLW0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 18:26:07 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH] input: bcm5974: retract efi-broken suspend_resume
Date: Tue, 13 Oct 2009 00:23:42 +0200
Message-Id: <1255386223-4109-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.6.3.3
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1MxTKP-0005ma-89.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1MxTKP-0005ma-89 bba2898b4d4ab55702b0156cb2e7df12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the recent system-wide improvements on suspend/resume and EFI
booting the suspend_resume method of the bcm5974 has broken. When
waking up from the S3 state on the MacBookAir, the trackpad is found
in a yet unknown state, unable to switch to the proper multitouch
mode.  The result is a frozen touchpad, and a flood of errors of the
kind

bcm5974: bad trackpad package, length: 8.

This patch retracts the reset_resume method altogether, falling back
on the generic unbind/rebind functionality of the usb layer until
further investigations can be made as how to reset the device when
booting from efi.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/mouse/bcm5974.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index 2d8fc0b..79e182a 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -760,7 +760,6 @@ static struct usb_driver bcm5974_driver = {
 	.disconnect		= bcm5974_disconnect,
 	.suspend		= bcm5974_suspend,
 	.resume			= bcm5974_resume,
-	.reset_resume		= bcm5974_resume,
 	.id_table		= bcm5974_table,
 	.supports_autosuspend	= 1,
 };
-- 
1.6.3.3

