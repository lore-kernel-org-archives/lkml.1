Return-Path: <linux-kernel-owner+w=401wt.eu-S1753217AbYDQTeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbYDQTeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 15:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750976AbYDQTdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 15:33:50 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51183 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750952AbYDQTdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 15:33:49 -0400
Date: Thu, 17 Apr 2008 15:33:48 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andy Whitcroft <apw@shadowen.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>
cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: False positive in checkpatch (2.6.25)
Message-ID: <Pine.LNX.4.44L0.0804171530070.19418-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the patch:

------------------------------------------------------
--- usb-2.6.orig/drivers/usb/core/driver.c
+++ usb-2.6/drivers/usb/core/driver.c
@@ -1541,14 +1541,11 @@ static int usb_resume(struct device *dev
 	udev = to_usb_device(dev);
 
 	/* If udev->skip_sys_resume is set then udev was already suspended
-	 * when the system suspend started, so we don't want to resume
-	 * udev during this system wakeup.  However a reset-resume counts
-	 * as a wakeup event, so allow a reset-resume to occur if remote
-	 * wakeup is enabled. */
-	if (udev->skip_sys_resume) {
-		if (!(udev->reset_resume && udev->do_remote_wakeup))
-			return -EHOSTUNREACH;
-	}
+	 * when the system suspend started, so we don't want to resume it
+	 * during this system wakeup.
+	 */
+	if (udev->skip_sys_resume)
+		return 0;
 	return usb_external_resume_device(udev);
 }
 
------------------------------------------------------

And here's the output from checkpatch.pl:

------------------------------------------------------
ERROR: space prohibited after that '*' (ctx:ExW)
#15: FILE: drivers/usb/core/driver.c:1544:
+        * when the system suspend started, so we don't want to resume it
         ^

ERROR: Missing Signed-off-by: line(s)

total: 2 errors, 0 warnings, 19 lines checked

/tmp/t has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.
------------------------------------------------------

Alan Stern

