Return-Path: <linux-kernel-owner+w=401wt.eu-S932775AbYDPWaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932775AbYDPWaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 18:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760066AbYDPW2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 18:28:12 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:8492 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757247AbYDPW2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 18:28:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=PWTSVi6xedhr/XEVHWY2WXCeYKaZhNRNNlEfK0nKpXn0U5yIXPLVWCx9EbjGv/vFu9eEUcxY2+fqkuo+sVG3BeHbcMDmvj/xVj768k+JVMM3sZCrvFNG85/O2hGRn5yr2FFfX/wlXxccnASx0NO3Dn3AfFefL6OrUhXMPGXTHLo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] scc_pata: use ide_find_port()
Date: Thu, 17 Apr 2008 00:03:10 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Kou Ishizaki <kou.ishizaki@toshiba.co.jp>,
       Akira Iguchi <akira2.iguchi@toshiba.co.jp>,
       Stephen Rothwell <sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804170003.10503.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There should be no functional changes caused by this patch.

Cc: Kou Ishizaki <kou.ishizaki@toshiba.co.jp>
Cc: Akira Iguchi <akira2.iguchi@toshiba.co.jp>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
goes after "sgiioc4: use ide_find_port()" patch into IDE tree

 drivers/ide/pci/scc_pata.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

Index: b/drivers/ide/pci/scc_pata.c
===================================================================
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -534,12 +534,8 @@ static int scc_ide_setup_pci_device(stru
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 	int i;
 
-	for (i = 0; i < MAX_HWIFS; i++) {
-		hwif = &ide_hwifs[i];
-		if (hwif->chipset == ide_unknown)
-			break; /* pick an unused entry */
-	}
-	if (i == MAX_HWIFS) {
+	hwif = ide_find_port();
+	if (hwif == NULL) {
 		printk(KERN_ERR "%s: too many IDE interfaces, "
 				"no room in table\n", SCC_PATA_NAME);
 		return -ENOMEM;
