Return-Path: <linux-kernel-owner+w=401wt.eu-S1032346AbXFIAEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032346AbXFIAEw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 20:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969289AbXFIAE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 20:04:28 -0400
Received: from mail.suse.de ([195.135.220.2]:33568 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031358AbXFIAE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 20:04:26 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-usb-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Ben Collins <bcollins@ubuntu.com>,
       Alan Stern <stern@rowland.harvard.edu>, Phil Dibowitz <phil@ipom.com>
Subject: [PATCH 4/9] USB: UNUSUAL_DEV: Sync up some reported devices from Ubuntu
Date: Fri,  8 Jun 2007 17:03:49 -0700
Message-Id: <118134746039-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.1
In-Reply-To: <11813474492376-git-send-email-gregkh@suse.de>
References: <20070609000312.GA17574@kroah.com>
 <11813474343815-git-send-email-gregkh@suse.de>
 <1181347441440-git-send-email-gregkh@suse.de>
 <11813474492376-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Collins <bcollins@ubuntu.com>

UNUSUAL_DEV: Sync up some reported devices from Ubuntu

Various unusual dev entries accumulated from Ubuntu bug reports.

Signed-off-by: Ben Collins <bcollins@ubuntu.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Phil Dibowitz <phil@ipom.com>
---
 drivers/usb/storage/unusual_devs.h |   21 +++++++++++++++++++--
 1 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index d230ee7..54979c2 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1179,8 +1179,8 @@ UNUSUAL_DEV( 0x0a17, 0x006, 0x0000, 0xffff,
                 US_SC_DEVICE, US_PR_DEVICE, NULL,
                 US_FL_FIX_INQUIRY ),
 
-/* These are virtual windows driver CDs, which the zd1211rw driver automatically
- * converts into a WLAN devices. */
+/* These are virtual windows driver CDs, which the zd1211rw driver
+ * automatically converts into WLAN devices. */
 UNUSUAL_DEV( 0x0ace, 0x2011, 0x0101, 0x0101,
                 "ZyXEL",
                 "G-220F USB-WLAN Install",
@@ -1193,6 +1193,14 @@ UNUSUAL_DEV( 0x0ace, 0x20ff, 0x0101, 0x0101,
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_IGNORE_DEVICE ),
 
+/* SanDisk that has a second LUN for a driver ISO, reported by
+ * Ben Collins <bcollins@ubuntu.com> */
+UNUSUAL_DEV( 0x0781, 0x5406, 0x0000, 0xffff,
+		"SanDisk",
+		"U3 Cruzer Micro driver ISO",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_SINGLE_LUN ),
+
 #ifdef CONFIG_USB_STORAGE_ISD200
 UNUSUAL_DEV(  0x0bf6, 0xa001, 0x0100, 0x0110,
 		"ATI",
@@ -1271,6 +1279,15 @@ UNUSUAL_DEV( 0x0dd8, 0x1060, 0x0000, 0xffff,
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_FIX_INQUIRY ),
 
+/* Reported by Edward Chapman (taken from linux-usb mailing list)
+   Netac OnlyDisk Mini U2CV2 512MB USB 2.0 Flash Drive */
+UNUSUAL_DEV( 0x0dd8, 0xd202, 0x0000, 0x9999,
+		"Netac",
+		"USB Flash Disk",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_IGNORE_RESIDUE ),
+
+
 /* Patch by Stephan Walter <stephan.walter@epfl.ch>
  * I don't know why, but it works... */
 UNUSUAL_DEV( 0x0dda, 0x0001, 0x0012, 0x0012,
-- 
1.5.2.1

