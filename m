Return-Path: <linux-kernel-owner+w=401wt.eu-S1752036AbZASONu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbZASONu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 09:13:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbZASONP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 09:13:15 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:36546 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbZASONO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 09:13:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=xJi1lgqna6zz+xv8eJvzWN7M2RCCm3Rb6tRQYlSZsEUyIRugoBTnunWKXDYZZfoWRS
         aQmtjJue4WmvGRgpp0eKO5RTQQ6u0WISoFUmLeP8UHPWz8N55CaGpDMdTnOQGyJE6rMh
         2TH+So//NyYxkvBgtIsNrui4XFjesne25Yihg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 19 Jan 2009 15:13:37 +0100
Message-Id: <20090119141337.27613.43908.sendpatchset@localhost.localdomain>
In-Reply-To: <20090119141330.27613.34546.sendpatchset@localhost.localdomain>
References: <20090119141330.27613.34546.sendpatchset@localhost.localdomain>
Subject: [PATCH 01/12] amd74xx: use ide_pci_is_in_compatibility_mode()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] amd74xx: use ide_pci_is_in_compatibility_mode()

Fix ->init_hwif to check if IDE PCI controller is in compatibility
mode instead of checking for hwif->irq == 0.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/amd74xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/amd74xx.c
===================================================================
--- a/drivers/ide/amd74xx.c
+++ b/drivers/ide/amd74xx.c
@@ -187,7 +187,7 @@ static void __devinit init_hwif_amd74xx(
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 
-	if (hwif->irq == 0) /* 0 is bogus but will do for now */
+	if (ide_pci_is_in_compatibility_mode(dev))
 		hwif->irq = pci_get_legacy_ide_irq(dev, hwif->channel);
 }
 
