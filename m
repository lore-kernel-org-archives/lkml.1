Return-Path: <linux-kernel-owner+w=401wt.eu-S1755241AbYKCUFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbYKCUFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 15:05:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753054AbYKCUFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 15:05:05 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:51038 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbYKCUFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 15:05:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=FVRc+ZCprHY55OrekbcnqZ+JBuyDs+3g77vNQtHMg2EWQ9bKkWtwuSvpgZHOs8HxjN
         PNNngO9pDWRNho/k+iG3jUZCWPFYzZ2y7zOuaYfgyDYSM5I4U6B6Mxj7t39N/OaBELyt
         DaZ9wnyFZZMdAx61DWe0YYdGfU5w78oZ4ShP0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, Sergei Shtylyov <sshtylyov@ru.mvista.com>
Date: Mon, 03 Nov 2008 21:02:44 +0100
Message-Id: <20081103200244.5098.29817.sendpatchset@localhost.localdomain>
Subject: [PATCH 1/6] ide: fix ->quirk_list checking in ide_do_request()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: fix ->quirk_list checking in ide_do_request()

Fix nIEN quirk check to also omit quirky devices using pdc202xx_{new,old}
host drivers for which ->quirk_list == 2.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
against pata-2.6 tree

 drivers/ide/ide-io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -1028,7 +1028,7 @@ static void ide_do_request (ide_hwgroup_
 			 * set nIEN for previous hwif, drives in the
 			 * quirk_list may not like intr setups/cleanups
 			 */
-			if (drive->quirk_list != 1)
+			if (drive->quirk_list == 0)
 				hwif->tp_ops->set_irq(hwif, 0);
 		}
 		hwgroup->hwif = hwif;
