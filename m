Return-Path: <linux-kernel-owner+w=401wt.eu-S1764240AbZCNBku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764240AbZCNBku (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754126AbZCNBU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:20:58 -0400
Received: from kroah.org ([198.145.64.141]:35322 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753903AbZCNBUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:20:38 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:39 2009
Message-Id: <20090314011039.709998889@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:10:33 -0700
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
       alan@lxorguk.ukuu.org.uk, Adam Lackorzynski <adam@os.inf.tu-dresden.de>,
       Scott H Kilau <Scott_Kilau@digi.com>, Wendy Xiong <wendyx@us.ibm.com>
Subject: [patch 056/114] jsm: additional device support
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=jsm-additional-device-support.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Adam Lackorzynski <adam@os.inf.tu-dresden.de>

commit ffa7525c13eb3db0fd19a3e1cffe2ce6f561f5f3 upstream.

I have a Digi Neo 8 PCI card (114f:00b1) Serial controller: Digi
International Digi Neo 8 (rev 05)

that works with the jsm driver after using the following patch.

Signed-off-by: Adam Lackorzynski <adam@os.inf.tu-dresden.de>
Cc: Scott H Kilau <Scott_Kilau@digi.com>
Cc: Wendy Xiong <wendyx@us.ibm.com>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/serial/jsm/jsm_driver.c |    3 +++
 include/linux/pci_ids.h         |    1 +
 2 files changed, 4 insertions(+)

--- a/drivers/serial/jsm/jsm_driver.c
+++ b/drivers/serial/jsm/jsm_driver.c
@@ -84,6 +84,8 @@ static int jsm_probe_one(struct pci_dev 
 	brd->pci_dev = pdev;
 	if (pdev->device == PCIE_DEVICE_ID_NEO_4_IBM)
 		brd->maxports = 4;
+	else if (pdev->device == PCI_DEVICE_ID_DIGI_NEO_8)
+		brd->maxports = 8;
 	else
 		brd->maxports = 2;
 
@@ -212,6 +214,7 @@ static struct pci_device_id jsm_pci_tbl[
 	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCI_DEVICE_ID_NEO_2RJ45), 0, 0, 2 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCI_DEVICE_ID_NEO_2RJ45PRI), 0, 0, 3 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCIE_DEVICE_ID_NEO_4_IBM), 0, 0, 4 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCI_DEVICE_ID_DIGI_NEO_8), 0, 0, 5 },
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, jsm_pci_tbl);
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1445,6 +1445,7 @@
 #define PCI_DEVICE_ID_DIGI_DF_M_E	0x0071
 #define PCI_DEVICE_ID_DIGI_DF_M_IOM2_A	0x0072
 #define PCI_DEVICE_ID_DIGI_DF_M_A	0x0073
+#define PCI_DEVICE_ID_DIGI_NEO_8	0x00B1
 #define PCI_DEVICE_ID_NEO_2DB9          0x00C8
 #define PCI_DEVICE_ID_NEO_2DB9PRI       0x00C9
 #define PCI_DEVICE_ID_NEO_2RJ45         0x00CA


