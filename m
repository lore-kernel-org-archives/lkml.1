Return-Path: <linux-kernel-owner+w=401wt.eu-S1754856AbYKLAal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbYKLAal (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:30:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbYKLA0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:26:15 -0500
Received: from kroah.org ([198.145.64.141]:42181 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753336AbYKLA0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:26:14 -0500
Date: Tue, 11 Nov 2008 16:23:16 -0800
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
       alan@lxorguk.ukuu.org.uk, Mike Miller <mike.miller@hp.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [patch 12/49] cciss: new hardware support
Message-ID: <20081112002316.GM10989@kroah.com>
References: <20081112001401.926965113@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cciss-new-hardware-support.patch"
In-Reply-To: <20081112002215.GA10989@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mike Miller <mike.miller@hp.com>

commit 77ca7286d10b798e4907af941f29672bf484db77 upstream

cciss: new hardware support

Add support for 2 new SAS/SATA controllers.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Documentation/cciss.txt |    2 ++
 drivers/block/cciss.c   |    4 ++++
 2 files changed, 6 insertions(+)

--- a/Documentation/cciss.txt
+++ b/Documentation/cciss.txt
@@ -26,6 +26,8 @@ This driver is known to work with the fo
 	* SA P410i
 	* SA P411
 	* SA P812
+	* SA P712m
+	* SA P711m
 
 Detecting drive failures:
 -------------------------
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -96,6 +96,8 @@ static const struct pci_device_id cciss_
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3245},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3247},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3249},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324A},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324B},
 	{PCI_VENDOR_ID_HP,     PCI_ANY_ID,	PCI_ANY_ID, PCI_ANY_ID,
 		PCI_CLASS_STORAGE_RAID << 8, 0xffff << 8, 0},
 	{0,}
@@ -133,6 +135,8 @@ static struct board_type products[] = {
 	{0x3245103C, "Smart Array P410i", &SA5_access},
 	{0x3247103C, "Smart Array P411", &SA5_access},
 	{0x3249103C, "Smart Array P812", &SA5_access},
+	{0x324A103C, "Smart Array P712m", &SA5_access},
+	{0x324B103C, "Smart Array P711m", &SA5_access},
 	{0xFFFF103C, "Unknown Smart Array", &SA5_access},
 };
 

-- 
