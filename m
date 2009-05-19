Return-Path: <linux-kernel-owner+w=401wt.eu-S1756070AbZESOyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070AbZESOyw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 10:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755025AbZESOyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 10:54:09 -0400
Received: from d112a2.x-mailer.de ([212.162.53.4]:50771 "EHLO
	d112a2.x-mailer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391AbZESOyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 10:54:08 -0400
Message-Id: <0af9f6af1cd9be72d77981699db2c52235353e4c.1242739648.git.kkeil@pingi.linux-pingi.de>
In-Reply-To: <cover.1242739648.git.kkeil@pingi.linux-pingi.de>
References: <cover.1242739648.git.kkeil@pingi.linux-pingi.de>
Subject: [PATCH 02/19] Fix bug in XHFC registering
From: Karsten Keil <keil@b1-systems.de>
To: linux-kernel@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       i4ldeveloper@listserv.isdn4linux.de
Date: Tue, 19 May 2009 15:58:24 +0200
X-Info: valid message
X-Info: original Date
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Eversberg <andreas@eversberg.eu>

Calling mISDN_register_device() without pci device for the XHFC case.

Signed-off-by: Andreas Eversberg <andreas@eversberg.eu>
Signed-off-by: Karsten Keil <keil@b1-systems.de>
---
 drivers/isdn/hardware/mISDN/hfcmulti.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index 896fceb..71b0de5 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -5096,13 +5096,15 @@ init_multi_port(struct hfc_multi *hc, int pt)
 		test_and_set_bit(HFC_CFG_DIS_ECHANNEL,
 		    &hc->chan[i + 2].cfg);
 	}
-	if (hc->ctype == HFC_TYPE_XHFC)
+	if (hc->ctype == HFC_TYPE_XHFC) {
 		snprintf(name, MISDN_MAX_IDLEN - 1, "xhfc.%d-%d",
 			HFC_cnt + 1, pt + 1);
-	else
+		ret = mISDN_register_device(&dch->dev, NULL, name);
+	} else {
 		snprintf(name, MISDN_MAX_IDLEN - 1, "hfc-%ds.%d-%d",
 			hc->ctype, HFC_cnt + 1, pt + 1);
-	ret = mISDN_register_device(&dch->dev, &hc->pci_dev->dev, name);
+		ret = mISDN_register_device(&dch->dev, &hc->pci_dev->dev, name);
+	}
 	if (ret)
 		goto free_chan;
 	hc->created[pt] = 1;
-- 
1.6.0.2

