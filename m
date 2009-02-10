Return-Path: <linux-kernel-owner+w=401wt.eu-S1758520AbZBJTVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758520AbZBJTVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 14:21:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755994AbZBJTE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 14:04:27 -0500
Received: from kroah.org ([198.145.64.141]:34003 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755991AbZBJTEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 14:04:22 -0500
Date: Tue, 10 Feb 2009 11:01:35 -0800
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
Subject: [patch 50/53] USB: usb-storage: add Pentax to the bad-vendor list
Message-ID: <20090210190135.GY14308@kroah.com>
References: <20090210185337.000769713@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline; filename="usb-usb-storage-add-pentax-to-the-bad-vendor-list.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090210185924.GA14308@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 506e9469833c66ed6bb9acd902e208f7301b6adb upstream.

This patch (as1202) adds Pentax to usb-storage's list of bad vendors
whose devices always need the CAPACITY_HEURISTICS flag.  This is in
addition to the existing entries: Nokia, Nikon, and Motorola.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Virgo Pärna <virgo.parna@mail.ee>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/scsiglue.c     |    2 ++
 drivers/usb/storage/unusual_devs.h |   15 ---------------
 2 files changed, 2 insertions(+), 15 deletions(-)

--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -64,6 +64,7 @@
  */
 #define VENDOR_ID_NOKIA		0x0421
 #define VENDOR_ID_NIKON		0x04b0
+#define VENDOR_ID_PENTAX	0x0a17
 #define VENDOR_ID_MOTOROLA	0x22b8
 
 /***********************************************************************
@@ -150,6 +151,7 @@ static int slave_configure(struct scsi_d
 		switch (le16_to_cpu(us->pusb_dev->descriptor.idVendor)) {
 		case VENDOR_ID_NOKIA:
 		case VENDOR_ID_NIKON:
+		case VENDOR_ID_PENTAX:
 		case VENDOR_ID_MOTOROLA:
 			if (!(us->fflags & (US_FL_FIX_CAPACITY |
 					US_FL_CAPACITY_OK)))
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1304,21 +1304,6 @@ UNUSUAL_DEV( 0x0a17, 0x0004, 0x1000, 0x1
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_FIX_INQUIRY ),
 
-
-/* Submitted by Per Winkvist <per.winkvist@uk.com> */
-UNUSUAL_DEV( 0x0a17, 0x006, 0x0000, 0xffff,
-		"Pentax",
-		"Optio S/S4",
-		US_SC_DEVICE, US_PR_DEVICE, NULL,
-		US_FL_FIX_INQUIRY ),
-
-/* Reported by Jaak Ristioja <Ristioja@gmail.com> */
-UNUSUAL_DEV( 0x0a17, 0x006e, 0x0100, 0x0100,
-		"Pentax",
-		"K10D",
-		US_SC_DEVICE, US_PR_DEVICE, NULL,
-		US_FL_FIX_CAPACITY ),
-
 /* These are virtual windows driver CDs, which the zd1211rw driver
  * automatically converts into WLAN devices. */
 UNUSUAL_DEV( 0x0ace, 0x2011, 0x0101, 0x0101,

