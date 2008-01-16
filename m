Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbYAPXOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbYAPXOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 18:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754240AbYAPXNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 18:13:32 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:10411 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbYAPXNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 18:13:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=PYInQGG2CafHqQFuJYFXb2O/Aei2OSxM/Q+6/zTdM+CrdWAzsNHBjQCJOK/Y7RD8rd7ef1k8xi6ECXJHn7bRq+Evg938U7BxE+qTZtemGW89SEsJnLX9Qnrwx7RH8EXl6e0AyTYBHxHD4BqE1UQeALqIsGc9zTk0FGuOlk1DRYI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 17 Jan 2008 00:26:10 +0100
Message-Id: <20080116232610.9166.8941.sendpatchset@localhost.localdomain>
In-Reply-To: <20080116232556.9166.13457.sendpatchset@localhost.localdomain>
References: <20080116232556.9166.13457.sendpatchset@localhost.localdomain>
Subject: [PATCH 02/22] ide: remove redundant init_hwif_default() call from ide_register_hw()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ide_init_port_hw() call overrides setup done by init_hwif_default().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -716,10 +716,8 @@ int ide_register_hw(hw_regs_t *hw, void 
 found:
 	if (hwif->present)
 		ide_unregister(index);
-	else if (!hwif->hold) {
+	else if (!hwif->hold)
 		ide_init_port_data(hwif, index);
-		init_hwif_default(hwif, index);
-	}
 
 	ide_init_port_hw(hwif, hw);
 	hwif->quirkproc = quirkproc;
