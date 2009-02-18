Return-Path: <linux-kernel-owner+w=401wt.eu-S1759369AbZBRWgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759369AbZBRWgw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 17:36:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757835AbZBRWb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 17:31:59 -0500
Received: from kroah.org ([198.145.64.141]:34768 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757825AbZBRWb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 17:31:57 -0500
Date: Wed, 18 Feb 2009 14:29:09 -0800
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
       alan@lxorguk.ukuu.org.uk, Zlatko Calusic <zlatko.calusic@iskon.hr>
Subject: [patch 07/36] Add support for VT6415 PCIE PATA IDE Host Controller
Message-ID: <20090218222909.GH10668@kroah.com>
References: <20090218222447.432108614@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="add-support-for-vt6415-pcie-pata-ide-host-controller.patch"
In-Reply-To: <20090218222841.GA10668@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zlatko Calusic <zlatko.calusic@iskon.hr>

commit 5955c7a2cfb6a35429adea5dc480002b15ca8cfc upstream.

Signed-off-by: Zlatko Calusic <zlatko.calusic@iskon.hr>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/pata_via.c  |    4 +++-
 include/linux/pci_ids.h |    1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -111,7 +111,8 @@ static const struct via_isa_bridge {
 	{ "vt8237s",	PCI_DEVICE_ID_VIA_8237S,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
 	{ "vt8251",	PCI_DEVICE_ID_VIA_8251,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
 	{ "cx700",	PCI_DEVICE_ID_VIA_CX700,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST | VIA_SATA_PATA },
-	{ "vt6410",	PCI_DEVICE_ID_VIA_6410,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST | VIA_NO_ENABLES},
+	{ "vt6410",	PCI_DEVICE_ID_VIA_6410,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST | VIA_NO_ENABLES },
+	{ "vt6415",	PCI_DEVICE_ID_VIA_6415,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST | VIA_NO_ENABLES },
 	{ "vt8237a",	PCI_DEVICE_ID_VIA_8237A,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
 	{ "vt8237",	PCI_DEVICE_ID_VIA_8237,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
 	{ "vt8235",	PCI_DEVICE_ID_VIA_8235,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
@@ -594,6 +595,7 @@ static int via_reinit_one(struct pci_dev
 #endif
 
 static const struct pci_device_id via[] = {
+	{ PCI_VDEVICE(VIA, 0x0415), },
 	{ PCI_VDEVICE(VIA, 0x0571), },
 	{ PCI_VDEVICE(VIA, 0x0581), },
 	{ PCI_VDEVICE(VIA, 0x1571), },
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1301,6 +1301,7 @@
 #define PCI_DEVICE_ID_VIA_VT3351	0x0351
 #define PCI_DEVICE_ID_VIA_VT3364	0x0364
 #define PCI_DEVICE_ID_VIA_8371_0	0x0391
+#define PCI_DEVICE_ID_VIA_6415		0x0415
 #define PCI_DEVICE_ID_VIA_8501_0	0x0501
 #define PCI_DEVICE_ID_VIA_82C561	0x0561
 #define PCI_DEVICE_ID_VIA_82C586_1	0x0571

