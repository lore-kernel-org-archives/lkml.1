Return-Path: <linux-kernel-owner+w=401wt.eu-S1753796AbZASOPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbZASOPY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 09:15:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753682AbZASONf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 09:13:35 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:36546 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465AbZASONe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 09:13:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=fVT/zltqcse8M0G6ziLvBQg7TuSt9rPbAHoKg3q9cVnxIIzW/JJFno9uQjZFSkjGol
         C8t4M7HZ6c61Y5axtAHfIs1LvdWxRfSBosNOxtg3AgoT7JJ7Bfm31jj1gEd0N6nysWM1
         Rx6iaunF3J77XIoov+aFtLQ+Cm/9OTaZfbNfE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 19 Jan 2009 15:13:56 +0100
Message-Id: <20090119141356.27613.95935.sendpatchset@localhost.localdomain>
In-Reply-To: <20090119141330.27613.34546.sendpatchset@localhost.localdomain>
References: <20090119141330.27613.34546.sendpatchset@localhost.localdomain>
Subject: [PATCH 04/12] trm290: small ->init_hwif cleanup
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] trm290: small ->init_hwif cleanup

Core IDE PCI code takes care of assigning hwif->irq for both ports.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/trm290.c |    3 ---
 1 file changed, 3 deletions(-)

Index: b/drivers/ide/trm290.c
===================================================================
--- a/drivers/ide/trm290.c
+++ b/drivers/ide/trm290.c
@@ -277,9 +277,6 @@ static void __devinit init_hwif_trm290(i
 	if (reg & 0x10)
 		/* legacy mode */
 		hwif->irq = hwif->channel ? 15 : 14;
-	else if (!hwif->irq && hwif->mate && hwif->mate->irq)
-		/* sharing IRQ with mate */
-		hwif->irq = hwif->mate->irq;
 
 #if 1
 	{
