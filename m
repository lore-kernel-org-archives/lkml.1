Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388AbXL3RcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbXL3RcW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 12:32:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbXL3Rbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 12:31:44 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:7832 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbXL3Rbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 12:31:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=bVbglexkNNkNnyhpk83sWATHzqQaUdHtB66qwnv07+ZFNCt3/nKisPxL7IaicRiYlmvjmS10nbmZnCslR7yxdD7HfXKW1WTTLlhvSHFfZovXTB0wS3oX0HF3Ue1kp0+38sXwzsRId1YYFloN7GHp6OQ3NqsPFRkhcnPIGta4xpk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/3] au1xxx-ide: device tree bugfix
Date: Sun, 30 Dec 2007 18:23:49 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712301823.49573.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add missing hw.dev setup (so hwif->gendev.parent will be set by
ide_init_port_hw() to point to the parent device).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/mips/au1xxx-ide.c |    1 +
 1 file changed, 1 insertion(+)

Index: b/drivers/ide/mips/au1xxx-ide.c
===================================================================
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -602,6 +602,7 @@ static int au_ide_probe(struct device *d
 	memset(&hw, 0, sizeof(hw));
 	auide_setup_ports(&hw, ahwif);
 	hw.irq = ahwif->irq;
+	hw.dev = dev;
 	hw.chipset = ide_au1xxx;
 
 	ide_init_port_hw(hwif, &hw);
