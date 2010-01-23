Return-Path: <linux-kernel-owner+w=401wt.eu-S1756019Ab0AWAVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab0AWAVX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 19:21:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755662Ab0AWAVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 19:21:08 -0500
Received: from kroah.org ([198.145.64.141]:35103 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755483Ab0AWATC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 19:19:02 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Jan 22 16:11:13 2010
Message-Id: <20100123001113.401655891@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 22 Jan 2010 16:10:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ryan May <rmay31@gmail.com>, Rohan Hart <rohan.hart17@gmail.com>
Subject: [25/29] USB: fix usbstorage for 2770:915d delivers no FAT
In-Reply-To: <20100123001145.GA7391@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ryan May <rmay31@gmail.com>

commit 10d2cdb6102669279bee2d9a00a22431b74583d5 upstream.

Resolves kernel.org bug 14914.

Remove entry for 2770:915d (usb digital camera with mass storage
support) from unusual_devs.h. The fix triggered by the entry causes
the file system on the camera to be completely inaccessible (no
partition table, the device is not mountable).

The patch works, but let me clarify a few things about it.  All the
patch does is remove the entry for this device from the
drivers/usb/storage/unusual_devs.h, which is supposed to help with a
problem with the device's reported size (I think).  I'm pretty sure it
was originally added for a reason, so I'm not sure removing it won't
cause other problems to reappear.  Also, I should note that this
unusual_devs.h entry was present (and activating workarounds) in
2.6.29, but in that version everything works fine.  Starting with
2.6.30, things no longer work.

Signed-off-by: Ryan May <rmay31@gmail.com>
Cc: Rohan Hart <rohan.hart17@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/unusual_devs.h |    7 -------
 1 file changed, 7 deletions(-)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1807,13 +1807,6 @@ UNUSUAL_DEV(  0x2735, 0x100b, 0x0000, 0x
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_GO_SLOW ),
 
-/* Reported by Rohan Hart <rohan.hart17@gmail.com> */
-UNUSUAL_DEV(  0x2770, 0x915d, 0x0010, 0x0010,
-		"INTOVA",
-		"Pixtreme",
-		US_SC_DEVICE, US_PR_DEVICE, NULL,
-		US_FL_FIX_CAPACITY ),
-
 /* Reported by Frederic Marchal <frederic.marchal@wowcompany.com>
  * Mio Moov 330
  */


