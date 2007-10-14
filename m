Return-Path: <linux-kernel-owner+w=401wt.eu-S1763634AbXJNShl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763634AbXJNShl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 14:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763360AbXJNSfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 14:35:42 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47945 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763345AbXJNSfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 14:35:41 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] more trivial signedness fixes in drivers
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1Ih8JQ-00043S-7E@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 14 Oct 2007 19:35:40 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/acpi/toshiba_acpi.c    |    2 +-
 drivers/ata/ata_piix.c         |    2 +-
 drivers/ata/sata_via.c         |    2 +-
 drivers/atm/firestream.c       |    2 +-
 drivers/block/cciss.c          |    2 +-
 drivers/hid/hid-input.c        |    2 +-
 drivers/isdn/hisax/hfc_2bds0.c |    3 ++-
 drivers/isdn/hisax/nj_s.c      |    2 +-
 drivers/net/tulip/tulip_core.c |    5 +++--
 drivers/pci/pci.c              |    2 +-
 sound/usb/usbaudio.c           |    2 +-
 11 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/acpi/toshiba_acpi.c b/drivers/acpi/toshiba_acpi.c
index 13369b4..a736ef7 100644
--- a/drivers/acpi/toshiba_acpi.c
+++ b/drivers/acpi/toshiba_acpi.c
@@ -362,7 +362,7 @@ static unsigned long write_video(const char *buffer, unsigned long count)
 	int crt_out = -1;
 	int tv_out = -1;
 	u32 hci_result;
-	int video_out;
+	u32 video_out;
 
 	/* scan expression.  Multiple expressions may be delimited with ;
 	 *
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index e783e67..9ce4aa9 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -1122,7 +1122,7 @@ static void __devinit piix_init_sata_map(struct pci_dev *pdev,
 					 const struct piix_map_db *map_db)
 {
 	struct piix_host_priv *hpriv = pinfo[0].private_data;
-	const unsigned int *map;
+	const int *map;
 	int i, invalid_map = 0;
 	u8 map_value;
 
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index 1dc9b4f..cc6ee08 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -505,7 +505,7 @@ static int svia_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 	int rc;
 	struct ata_host *host;
 	int board_id = (int) ent->driver_data;
-	const int *bar_sizes;
+	const unsigned *bar_sizes;
 
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
diff --git a/drivers/atm/firestream.c b/drivers/atm/firestream.c
index 737cea4..94ebc9d 100644
--- a/drivers/atm/firestream.c
+++ b/drivers/atm/firestream.c
@@ -1295,7 +1295,7 @@ static const struct atmdev_ops ops = {
 
 static void __devinit undocumented_pci_fix (struct pci_dev *pdev)
 {
-	int tint;
+	u32 tint;
 
 	/* The Windows driver says: */
 	/* Switch off FireStream Retry Limit Threshold 
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 28d1457..55c3237 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3101,7 +3101,7 @@ static void cciss_getgeometry(int cntl_num)
 	int i;
 	int listlength = 0;
 	__u32 lunid = 0;
-	int block_size;
+	unsigned block_size;
 	sector_t total_size;
 
 	ld_buff = kzalloc(sizeof(ReportLunData_struct), GFP_KERNEL);
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 0c3e12c..dd332f2 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -950,7 +950,7 @@ ignore:
 void hidinput_hid_event(struct hid_device *hid, struct hid_field *field, struct hid_usage *usage, __s32 value)
 {
 	struct input_dev *input;
-	int *quirks = &hid->quirks;
+	unsigned *quirks = &hid->quirks;
 
 	if (!field->hidinput)
 		return;
diff --git a/drivers/isdn/hisax/hfc_2bds0.c b/drivers/isdn/hisax/hfc_2bds0.c
index 8d98644..5c46a71 100644
--- a/drivers/isdn/hisax/hfc_2bds0.c
+++ b/drivers/isdn/hisax/hfc_2bds0.c
@@ -1019,7 +1019,8 @@ hfc_dbusy_timer(struct IsdnCardState *cs)
 static unsigned int
 *init_send_hfcd(int cnt)
 {
-	int i, *send;
+	int i;
+	unsigned *send;
 
 	if (!(send = kmalloc(cnt * sizeof(unsigned int), GFP_ATOMIC))) {
 		printk(KERN_WARNING
diff --git a/drivers/isdn/hisax/nj_s.c b/drivers/isdn/hisax/nj_s.c
index fa2db87..a895dfe 100644
--- a/drivers/isdn/hisax/nj_s.c
+++ b/drivers/isdn/hisax/nj_s.c
@@ -151,7 +151,7 @@ NETjet_S_card_msg(struct IsdnCardState *cs, int mt, void *arg)
 static int __devinit njs_pci_probe(struct pci_dev *dev_netjet,
 				   struct IsdnCardState *cs)
 {
-	int cfg;
+	u32 cfg;
 
 	if (pci_enable_device(dev_netjet))
 		return(0);
diff --git a/drivers/net/tulip/tulip_core.c b/drivers/net/tulip/tulip_core.c
index ee08292..e5e2c9c 100644
--- a/drivers/net/tulip/tulip_core.c
+++ b/drivers/net/tulip/tulip_core.c
@@ -292,6 +292,7 @@ static void tulip_up(struct net_device *dev)
 	struct tulip_private *tp = netdev_priv(dev);
 	void __iomem *ioaddr = tp->base_addr;
 	int next_tick = 3*HZ;
+	u32 reg;
 	int i;
 
 #ifdef CONFIG_TULIP_NAPI
@@ -307,14 +308,14 @@ static void tulip_up(struct net_device *dev)
 
 	/* Reset the chip, holding bit 0 set at least 50 PCI cycles. */
 	iowrite32(0x00000001, ioaddr + CSR0);
-	pci_read_config_dword(tp->pdev, PCI_COMMAND, &i);  /* flush write */
+	pci_read_config_dword(tp->pdev, PCI_COMMAND, &reg);  /* flush write */
 	udelay(100);
 
 	/* Deassert reset.
 	   Wait the specified 50 PCI cycles after a reset by initializing
 	   Tx and Rx queues and the address filter list. */
 	iowrite32(tp->csr0, ioaddr + CSR0);
-	pci_read_config_dword(tp->pdev, PCI_COMMAND, &i);  /* flush write */
+	pci_read_config_dword(tp->pdev, PCI_COMMAND, &reg);  /* flush write */
 	udelay(100);
 
 	if (tulip_debug > 1)
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 728b3c8..71d561f 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -658,7 +658,7 @@ int
 pci_restore_state(struct pci_dev *dev)
 {
 	int i;
-	int val;
+	u32 val;
 
 	/* PCI Express register must be restored first */
 	pci_restore_pcie_state(dev);
diff --git a/sound/usb/usbaudio.c b/sound/usb/usbaudio.c
index 7bd5852..ac5666f 100644
--- a/sound/usb/usbaudio.c
+++ b/sound/usb/usbaudio.c
@@ -2876,7 +2876,7 @@ static int create_fixed_stream_quirk(struct snd_usb_audio *chip,
 	struct audioformat *fp;
 	struct usb_host_interface *alts;
 	int stream, err;
-	int *rate_table = NULL;
+	unsigned *rate_table = NULL;
 
 	fp = kmemdup(quirk->data, sizeof(*fp), GFP_KERNEL);
 	if (! fp) {
-- 
1.5.3.GIT


