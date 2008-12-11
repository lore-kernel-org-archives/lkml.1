Return-Path: <linux-kernel-owner+w=401wt.eu-S1759571AbYLKTcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759571AbYLKTcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:32:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757719AbYLKTSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:18:46 -0500
Received: from kroah.org ([198.145.64.141]:56265 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757707AbYLKTSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:18:44 -0500
Date: Thu, 11 Dec 2008 11:15:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>
Subject: [patch 41/83] USB: storage: unusual_devs entry for Mio C520-GPS
Message-ID: <20081211191504.GO5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-storage-unusual_devs-entry-for-mio-c520-gps.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit a6b7b034d7f20761c55743be2acb762ce09a0c6b upstream

This patch (as1176) adds an unusual_devs entry for the Mio C520 GPS
unit.  Other devices also based on the Mitac hardware use the same USB
interface firmware, so the Vendor and Product names are generalized.

This fixes Bugzilla #11583.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Tamas Kerecsen <kerecsen@bigfoot.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/storage/unusual_devs.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -318,6 +318,18 @@ UNUSUAL_DEV(  0x045a, 0x5210, 0x0101, 0x
 		US_SC_SCSI, US_PR_KARMA, rio_karma_init, 0),
 #endif
 
+/* Reported by Tamas Kerecsen <kerecsen@bigfoot.com>
+ * Obviously the PROM has not been customized by the VAR;
+ * the Vendor and Product string descriptors are:
+ *	Generic Mass Storage (PROTOTYPE--Remember to change idVendor)
+ *	Generic Manufacturer (PROTOTYPE--Remember to change idVendor)
+ */
+UNUSUAL_DEV(  0x045e, 0xffff, 0x0000, 0x0000,
+		"Mitac",
+		"GPS",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_MAX_SECTORS_64 ),
+
 /*
  * This virtual floppy is found in Sun equipment (x4600, x4200m2, etc.)
  * Reported by Pete Zaitcev <zaitcev@redhat.com>

