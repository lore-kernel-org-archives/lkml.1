Return-Path: <linux-kernel-owner+w=401wt.eu-S1752947AbZK3S4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947AbZK3S4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 13:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbZK3S4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 13:56:20 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:34914 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbZK3S4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 13:56:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:message-id:cc
         :content-type:content-transfer-encoding;
        b=cFMeqpAgZPh+AdKqe7H85lFkn59LYugcqqYkOcaFemqITlHq8rd9v3aDWOy92wuQ+5
         s8tabjFMfRpcEmFp/M680AOF7AmCMC3VhMat8fX6j7A+er50ifUnrqz3Kb7wKxzSrpmU
         H8Y5fBO8xLD4nQjf83mdoZ1ztREZEwrqPO+Cc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] slc90e66: fix UDMA handling
Date: Mon, 30 Nov 2009 19:55:18 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
MIME-Version: 1.0
Message-Id: <200911301955.18158.bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checking of the currently programmed UDMA mode.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/slc90e66.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: b/drivers/ide/slc90e66.c
===================================================================
--- a/drivers/ide/slc90e66.c
+++ b/drivers/ide/slc90e66.c
@@ -92,8 +92,7 @@ static void slc90e66_set_dma_mode(ide_hw
 
 		if (!(reg48 & u_flag))
 			pci_write_config_word(dev, 0x48, reg48|u_flag);
-		/* FIXME: (reg4a & a_speed) ? */
-		if ((reg4a & u_speed) != u_speed) {
+		if ((reg4a & a_speed) != u_speed) {
 			pci_write_config_word(dev, 0x4a, reg4a & ~a_speed);
 			pci_read_config_word(dev, 0x4a, &reg4a);
 			pci_write_config_word(dev, 0x4a, reg4a|u_speed);
