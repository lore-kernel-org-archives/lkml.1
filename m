Return-Path: <linux-kernel-owner+w=401wt.eu-S1759127AbZAXOWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759127AbZAXOWm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 09:22:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755332AbZAXOV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 09:21:28 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:65257 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552AbZAXOVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 09:21:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=JgrAZNhvbzPllvGIxywkjzjr5SxE4PDstQQXyhVF2dL1GOM8Mg11dv1RDhYV6PEFuv
         cKSt6ayK3ScNOcpKDN000CJA7PhSLM3avlHOc6x9Lj2n4HOtXqwv1xnU26MZSAigU4eJ
         kWMTKLlr2WSuPKOkrrIKq0f3tWVJHwCBQK1N0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide_arm: use struct ide_port_info
Date: Sat, 24 Jan 2009 15:15:22 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-next-20090123; KDE/4.1.3; i686; ; )
Cc: linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901241515.22288.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide_arm: use struct ide_port_info

This fixes hwif->channel and drive->dn assignments.

Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide_arm.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: b/drivers/ide/ide_arm.c
===================================================================
--- a/drivers/ide/ide_arm.c
+++ b/drivers/ide/ide_arm.c
@@ -18,6 +18,10 @@
 #define IDE_ARM_IO	0x1f0
 #define IDE_ARM_IRQ	IRQ_HARDDISK
 
+static const struct ide_port_info ide_arm_port_info = {
+	.host_flags		= IDE_HFLAG_NO_DMA,
+};
+
 static int __init ide_arm_init(void)
 {
 	unsigned long base = IDE_ARM_IO, ctl = IDE_ARM_IO + 0x206;
@@ -41,7 +45,7 @@ static int __init ide_arm_init(void)
 	hw.irq = IDE_ARM_IRQ;
 	hw.chipset = ide_generic;
 
-	return ide_host_add(NULL, hws, NULL);
+	return ide_host_add(&ide_arm_port_info, hws, NULL);
 }
 
 module_init(ide_arm_init);
