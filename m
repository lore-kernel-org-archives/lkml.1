Return-Path: <linux-kernel-owner+w=401wt.eu-S934387AbYBGVAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934387AbYBGVAK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:00:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762692AbYBGUvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:51:46 -0500
Received: from ns2.suse.de ([195.135.220.15]:38433 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762676AbYBGUvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:51:44 -0500
Date: Thu, 7 Feb 2008 12:47:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, linux-usb@vger.kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Grant Grundler <grundler@parisc-linux.org>,
       Phil Dibowitz <phil@ipom.com>
Subject: [patch 19/45] USB: storage: Add unusual_dev for HP r707
Message-ID: <20080207204722.GT16389@suse.de>
References: <20080207204118.202098927@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-storage-add-unusual_dev-for-hp-r707.patch"
In-Reply-To: <20080207204549.GA16389@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.24-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Grant Grundler <grundler@parisc-linux.org>

Add "FIX_CAPACITY" entry for HP Photosmart r707 Camera in "Disk" mode.
Camera will wedge when /lib/udev/vol_id attempts to access the last sector,
EIO gets reported to dmesg, and block device is marked "offline" (it is).
Reproduced vol_id behavior with:
	"dd if=/dev/sda of=/dev/null skip=60800 count=1"

Signed-off-by: Grant Grundler <grundler@parisc-linux.org>
Signed-off-by: Phil Dibowitz <phil@ipom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/unusual_devs.h |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -86,6 +86,14 @@ UNUSUAL_DEV(  0x03f0, 0x0307, 0x0001, 0x
 		US_SC_8070, US_PR_USBAT, init_usbat_cd, 0),
 #endif
 
+/* Reported by Grant Grundler <grundler@parisc-linux.org>
+ * HP r707 camera in "Disk" mode with 2.00.23 or 2.00.24 firmware.
+ */
+UNUSUAL_DEV(  0x03f0, 0x4002, 0x0001, 0x0001,
+		"HP",
+		"PhotoSmart R707",
+		US_SC_DEVICE, US_PR_DEVICE, NULL, US_FL_FIX_CAPACITY),
+
 /* Reported by Sebastian Kapfer <sebastian_kapfer@gmx.net>
  * and Olaf Hering <olh@suse.de> (different bcd's, same vendor/product)
  * for USB floppies that need the SINGLE_LUN enforcement.

-- 
