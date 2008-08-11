Return-Path: <linux-kernel-owner+w=401wt.eu-S1755364AbYHKAYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbYHKAYL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 20:24:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753788AbYHKAXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 20:23:47 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:57557 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495AbYHKAXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 20:23:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=ensQYGR7t6w9IUjKrFYShMk9RZpbUzxXTPmoWrcTXU0PQGYD59TQrWYVgkiVRg/MAz
         0fhdmbmdfbQHBezh49DzfoUiNIAtnBql34YgjlUJm17RuXzuhpMse+Kwu/aUhMJfd3qp
         I1rWgML41MKm0SXa3yVsE3nacK3pD7IfB8QaQ=
Subject: [PATCH 2/2] mISDN: annotate iomem pointer and add statics
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Karsten Keil <kkeil@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 10 Aug 2008 17:23:48 -0700
Message-Id: <1218414228.24441.30.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/isdn/hardware/mISDN/hfcpci.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
index 9f808ec..cd8302a 100644
--- a/drivers/isdn/hardware/mISDN/hfcpci.c
+++ b/drivers/isdn/hardware/mISDN/hfcpci.c
@@ -43,7 +43,7 @@ MODULE_LICENSE("GPL");
 module_param(debug, uint, 0);
 
 static LIST_HEAD(HFClist);
-DEFINE_RWLOCK(HFClock);
+static DEFINE_RWLOCK(HFClock);
 
 enum {
 	HFC_CCD_2BD0,
@@ -88,7 +88,7 @@ struct hfcPCI_hw {
 	unsigned char		bswapped;
 	unsigned char		protocol;
 	int			nt_timer;
-	unsigned char		*pci_io; /* start of PCI IO memory */
+	unsigned char __iomem 	*pci_io; /* start of PCI IO memory */
 	dma_addr_t		dmahandle;
 	void			*fifos; /* FIFO memory */
 	int			last_bfifo_cnt[2];
@@ -153,7 +153,7 @@ release_io_hfcpci(struct hfc_pci *hc)
 	pci_write_config_word(hc->pdev, PCI_COMMAND, 0);
 	del_timer(&hc->hw.timer);
 	pci_free_consistent(hc->pdev, 0x8000, hc->hw.fifos, hc->hw.dmahandle);
-	iounmap((void *)hc->hw.pci_io);
+	iounmap(hc->hw.pci_io);
 }
 
 /*
@@ -522,7 +522,7 @@ receive_dmsg(struct hfc_pci *hc)
 /*
  * check for transparent receive data and read max one threshold size if avail
  */
-int
+static int
 hfcpci_empty_fifo_trans(struct bchannel *bch, struct bzfifo *bz, u_char *bdata)
 {
 	 __le16 *z1r, *z2r;
@@ -575,7 +575,7 @@ hfcpci_empty_fifo_trans(struct bchannel *bch, struct bzfifo *bz, u_char *bdata)
 /*
  * B-channel main receive routine
  */
-void
+static void
 main_rec_hfcpci(struct bchannel *bch)
 {
 	struct hfc_pci	*hc = bch->hw;
@@ -1678,7 +1678,7 @@ hfcpci_l2l1B(struct mISDNchannel *ch, struct sk_buff *skb)
  * called for card init message
  */
 
-void
+static void
 inithfcpci(struct hfc_pci *hc)
 {
 	printk(KERN_DEBUG "inithfcpci: entered\n");
@@ -1965,7 +1965,7 @@ setup_hw(struct hfc_pci *hc)
 		printk(KERN_WARNING "HFC-PCI: No IRQ for PCI card found\n");
 		return 1;
 	}
-	hc->hw.pci_io = (char *)(ulong)hc->pdev->resource[1].start;
+	hc->hw.pci_io = (char __iomem *)(unsigned long)hc->pdev->resource[1].start;
 
 	if (!hc->hw.pci_io) {
 		printk(KERN_WARNING "HFC-PCI: No IO-Mem for PCI card found\n");
-- 
1.6.0.rc1.278.g9c632

