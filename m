Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbXJ2Tm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbXJ2Tm7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 15:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753857AbXJ2Tjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 15:39:43 -0400
Received: from havoc.gtf.org ([69.61.125.42]:60943 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752520AbXJ2Tjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 15:39:42 -0400
To: linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de
Message-Id: <0c9a8ba73c57e9f287c3d9062b6af0f124e1ae9b.1193686445.git.jeff@garzik.org>
In-Reply-To: <eb2aa159d7f722c61d637feb287bc0f2f9519b1d.1193686445.git.jeff@garzik.org>
References: <eb2aa159d7f722c61d637feb287bc0f2f9519b1d.1193686445.git.jeff@garzik.org>
From: Jeff Garzik <jeff@garzik.org>
Cc: kkeil@suse.de, akpm@linux-foundation.org
Subject: [PATCH 12/16] [ISDN] HiSax gazel: ifdef bug fixes for x86-64
Date: Mon, 29 Oct 2007 15:39:12 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Garzik <jeff@garzik.org>
---
 drivers/isdn/hisax/gazel.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/hisax/gazel.c b/drivers/isdn/hisax/gazel.c
index 1a09b8b..4855e2a 100644
--- a/drivers/isdn/hisax/gazel.c
+++ b/drivers/isdn/hisax/gazel.c
@@ -22,8 +22,11 @@
 #include <linux/pci.h>
 
 static int gazel_protocol;		/* 0 == use DEFAULT_PROTO */
+
+#ifdef CONFIG_ISA
 static int gazel_irq;			/* 0 == no ISA probing */
 static int gazel_io_base;		/* 0 == no ISA probing */
+#endif /* CONFIG_ISA */
 
 static const char *gazel_revision = "$Revision: 2.19.2.4 $";
 
@@ -489,6 +492,7 @@ reserve_regions(struct IsdnCard *card, struct IsdnCardState *cs)
 	return 1;
 }
 
+#ifdef CONFIG_ISA
 static void __devinit
 setup_gazelisa(struct IsdnCard *card, struct IsdnCardState *cs)
 {
@@ -534,7 +538,9 @@ setup_gazelisa(struct IsdnCard *card, struct IsdnCardState *cs)
 			break;
 	}
 }
+#endif /* CONFIG_ISA */
 
+#ifdef CONFIG_PCI
 static int __devinit
 setup_gazelpci(struct IsdnCard *card)
 {
@@ -601,6 +607,7 @@ setup_gazelpci(struct IsdnCard *card)
 
 	return (0);
 }
+#endif /* CONFIG_PCI */
 
 static int __devinit
 setup_gazel_rest(struct IsdnCard *card)
@@ -660,7 +667,7 @@ static int __devinit gazel_isa_setup(struct IsdnCard *card)
 
 	setup_gazelisa(card, cs);
 
-	return setup_gazel_rest(cs);
+	return setup_gazel_rest(card);
 }
 
 static int __devinit gazel_isa_init_one(struct device *dev, unsigned int id)
@@ -709,7 +716,7 @@ static int __devinit gazel_pci_setup(struct IsdnCard *card)
 	if (setup_gazelpci(card))
 		return 1;	/* error */
 
-	return setup_gazel_rest(card->cs);
+	return setup_gazel_rest(card);
 }
 
 static int __devinit gazel_pci_init_one(struct pci_dev *pdev,
-- 
1.5.2.4

