Return-Path: <linux-kernel-owner+w=401wt.eu-S1762394AbXJYXeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762394AbXJYXeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 19:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760504AbXJYXds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 19:33:48 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:2101 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758843AbXJYXdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 19:33:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=r3rNO/SiV1a5ATMRmEkzYUYQFuXMKKRL1FlxlBvVauzIrgiZddKGCsOzwgMJWs77lpm8ARKni8UAtl+6Xy9xv8rh2mLJdm7SbSkzhPCIDdgVormXDRVsxFpdjMVAXCpHulhkbxesvGwiY5qEnIF8U2hP1dzsKi96BqQHwVAYuBs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/3] ide: fix drive_is_ready() for non-PCI hosts and CONFIG_IDEPCI_SHARE_IRQ=y
Date: Fri, 26 Oct 2007 01:36:37 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710260136.37333.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Need to check if the host is a PCI one before reading IDE_ALTSTATUS_REG.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-iops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -455,7 +455,7 @@ int drive_is_ready (ide_drive_t *drive)
 	 * an interrupt with another pci card/device.  We make no assumptions
 	 * about possible isa-pnp and pci-pnp issues yet.
 	 */
-	if (IDE_CONTROL_REG)
+	if (hwif->pci_dev && IDE_CONTROL_REG)
 		stat = hwif->INB(IDE_ALTSTATUS_REG);
 	else
 #endif /* CONFIG_IDEPCI_SHARE_IRQ */
