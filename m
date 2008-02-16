Return-Path: <linux-kernel-owner+w=401wt.eu-S1759590AbYBPUMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759590AbYBPUMp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 15:12:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756694AbYBPUMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 15:12:12 -0500
Received: from fk-out-0910.google.com ([209.85.128.185]:14552 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525AbYBPUMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 15:12:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=gcEyw7KGKl7qrb082lfSN+pATeZKP9JSqBFIsTzdPf3OjoCdRVC6tTEAO30DIWyfZTx/gS7biRBW7BjCri+D++cnchq2OrWfmWE6pY3cfF6uSsbVDfNoGo/0Ml+TxQe14XmdAvHDAUdC4i9IPfTxlSuzWRrZHu4LFsRSokBwr9I=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 16 Feb 2008 21:26:40 +0100
Message-Id: <20080216202640.25536.99766.sendpatchset@localhost.localdomain>
In-Reply-To: <20080216202634.25536.78915.sendpatchset@localhost.localdomain>
References: <20080216202634.25536.78915.sendpatchset@localhost.localdomain>
Subject: [PATCH 2/9] au1xxx-ide: use ide_find_port()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/mips/au1xxx-ide.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: b/drivers/ide/mips/au1xxx-ide.c
===================================================================
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -603,9 +603,11 @@ static int au_ide_probe(struct device *d
 		goto out;
 	}
 
-	/* FIXME:  This might possibly break PCMCIA IDE devices */
-
-	hwif                            = &ide_hwifs[pdev->id];
+	hwif = ide_find_port();
+	if (hwif == NULL) {
+		ret = -ENOENT;
+		goto out;
+	}
 
 	memset(&hw, 0, sizeof(hw));
 	auide_setup_ports(&hw, ahwif);
