Return-Path: <linux-kernel-owner+w=401wt.eu-S1761771AbZAaDGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761771AbZAaDGi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 22:06:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757184AbZAaCrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:47:37 -0500
Received: from kroah.org ([198.145.64.141]:55398 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756866AbZAaCr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:47:28 -0500
Date: Fri, 30 Jan 2009 18:42:57 -0800
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
       alan@lxorguk.ukuu.org.uk, Joseph Chan <josephchan@via.com.tw>,
       Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 21/43] libata: pata_via: support VX855, future chips whose
	IDE controller use 0x0571
Message-ID: <20090131024257.GV12368@kroah.com>
References: <20090131022548.656772939@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="libata-pata_via-support-vx855-future-chips-whose-ide-controller-use-0x0571.patch"
In-Reply-To: <20090131024158.GA12368@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: JosephChan@via.com.tw <JosephChan@via.com.tw>

commit e4d866cdea24543ee16ce6d07d80c513e86ba983 upstream.

It supports VX855 and future chips whose IDE controller uses PCI ID 0x0571.

Signed-off-by: Joseph Chan <josephchan@via.com.tw>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/pata_via.c  |   22 +++++++++++++++++-----
 include/linux/pci_ids.h |    4 ++++
 2 files changed, 21 insertions(+), 5 deletions(-)

--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -86,6 +86,10 @@ enum {
 	VIA_SATA_PATA	= 0x800, /* SATA/PATA combined configuration */
 };
 
+enum {
+	VIA_IDFLAG_SINGLE = (1 << 0), /* single channel controller) */
+};
+
 /*
  * VIA SouthBridge chips.
  */
@@ -97,8 +101,12 @@ static const struct via_isa_bridge {
 	u8 rev_max;
 	u16 flags;
 } via_isa_bridges[] = {
+	{ "vx855",	PCI_DEVICE_ID_VIA_VX855,    0x00, 0x2f,
+	  VIA_UDMA_133 | VIA_BAD_AST | VIA_SATA_PATA },
 	{ "vx800",	PCI_DEVICE_ID_VIA_VX800,    0x00, 0x2f, VIA_UDMA_133 |
 	VIA_BAD_AST | VIA_SATA_PATA },
+	{ "vt8261",	PCI_DEVICE_ID_VIA_8261,     0x00, 0x2f,
+	  VIA_UDMA_133 | VIA_BAD_AST },
 	{ "vt8237s",	PCI_DEVICE_ID_VIA_8237S,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
 	{ "vt8251",	PCI_DEVICE_ID_VIA_8251,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
 	{ "cx700",	PCI_DEVICE_ID_VIA_CX700,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST | VIA_SATA_PATA },
@@ -122,6 +130,8 @@ static const struct via_isa_bridge {
 	{ "vt82c586",	PCI_DEVICE_ID_VIA_82C586_0, 0x00, 0x0f, VIA_UDMA_NONE | VIA_SET_FIFO },
 	{ "vt82c576",	PCI_DEVICE_ID_VIA_82C576,   0x00, 0x2f, VIA_UDMA_NONE | VIA_SET_FIFO | VIA_NO_UNMASK },
 	{ "vt82c576",	PCI_DEVICE_ID_VIA_82C576,   0x00, 0x2f, VIA_UDMA_NONE | VIA_SET_FIFO | VIA_NO_UNMASK | VIA_BAD_ID },
+	{ "vtxxxx",	PCI_DEVICE_ID_VIA_ANON,    0x00, 0x2f,
+	  VIA_UDMA_133 | VIA_BAD_AST },
 	{ NULL }
 };
 
@@ -460,6 +470,7 @@ static int via_init_one(struct pci_dev *
 	static int printed_version;
 	u8 enable;
 	u32 timing;
+	unsigned long flags = id->driver_data;
 	int rc;
 
 	if (!printed_version++)
@@ -469,9 +480,13 @@ static int via_init_one(struct pci_dev *
 	if (rc)
 		return rc;
 
+	if (flags & VIA_IDFLAG_SINGLE)
+		ppi[1] = &ata_dummy_port_info;
+
 	/* To find out how the IDE will behave and what features we
 	   actually have to look at the bridge not the IDE controller */
-	for (config = via_isa_bridges; config->id; config++)
+	for (config = via_isa_bridges; config->id != PCI_DEVICE_ID_VIA_ANON;
+	     config++)
 		if ((isa = pci_get_device(PCI_VENDOR_ID_VIA +
 			!!(config->flags & VIA_BAD_ID),
 			config->id, NULL))) {
@@ -482,10 +497,6 @@ static int via_init_one(struct pci_dev *
 			pci_dev_put(isa);
 		}
 
-	if (!config->id) {
-		printk(KERN_WARNING "via: Unknown VIA SouthBridge, disabling.\n");
-		return -ENODEV;
-	}
 	pci_dev_put(isa);
 
 	if (!(config->flags & VIA_NO_ENABLES)) {
@@ -587,6 +598,7 @@ static const struct pci_device_id via[] 
 	{ PCI_VDEVICE(VIA, 0x1571), },
 	{ PCI_VDEVICE(VIA, 0x3164), },
 	{ PCI_VDEVICE(VIA, 0x5324), },
+	{ PCI_VDEVICE(VIA, 0xC409), VIA_IDFLAG_SINGLE },
 
 	{ },
 };
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1357,6 +1357,7 @@
 #define PCI_DEVICE_ID_VIA_8783_0	0x3208
 #define PCI_DEVICE_ID_VIA_8237		0x3227
 #define PCI_DEVICE_ID_VIA_8251		0x3287
+#define PCI_DEVICE_ID_VIA_8261		0x3402
 #define PCI_DEVICE_ID_VIA_8237A		0x3337
 #define PCI_DEVICE_ID_VIA_8237S		0x3372
 #define PCI_DEVICE_ID_VIA_SATA_EIDE	0x5324
@@ -1366,10 +1367,13 @@
 #define PCI_DEVICE_ID_VIA_CX700		0x8324
 #define PCI_DEVICE_ID_VIA_CX700_IDE	0x0581
 #define PCI_DEVICE_ID_VIA_VX800		0x8353
+#define PCI_DEVICE_ID_VIA_VX855		0x8409
 #define PCI_DEVICE_ID_VIA_8371_1	0x8391
 #define PCI_DEVICE_ID_VIA_82C598_1	0x8598
 #define PCI_DEVICE_ID_VIA_838X_1	0xB188
 #define PCI_DEVICE_ID_VIA_83_87XX_1	0xB198
+#define PCI_DEVICE_ID_VIA_C409_IDE	0XC409
+#define PCI_DEVICE_ID_VIA_ANON		0xFFFF
 
 #define PCI_VENDOR_ID_SIEMENS           0x110A
 #define PCI_DEVICE_ID_SIEMENS_DSCC4     0x2102

