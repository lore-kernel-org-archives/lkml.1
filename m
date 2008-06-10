Return-Path: <linux-kernel-owner+w=401wt.eu-S1758012AbYFJUw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012AbYFJUw0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 16:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757958AbYFJUuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 16:50:35 -0400
Received: from gv-out-0910.google.com ([216.239.58.191]:27835 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757566AbYFJUud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 16:50:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=gNWOq4rGfqPyVuw8TXfV/nlaU5ZpHOyYWRRe51D35CL8Yo+DeH2/RhpvysA8bObZp5
         7RXK/ODR9Esc+cJ/zlyKj9MonK3moFZuph3aW0uxMWi2mLDWJSLOSs7ETd7Mne20hFSG
         Fbhl4DD7aLqi6SWhS5jUwkgaGzfmlHs/qg4GI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 10 Jun 2008 22:52:09 +0200
Message-Id: <20080610205209.18469.99360.sendpatchset@localhost.localdomain>
In-Reply-To: <20080610205059.18469.44856.sendpatchset@localhost.localdomain>
References: <20080610205059.18469.44856.sendpatchset@localhost.localdomain>
Subject: [PATCH 08/14] ide-h8300: print driver banner message early
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print driver banner message early and without interface number.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/h8300/ide-h8300.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: b/drivers/ide/h8300/ide-h8300.c
===================================================================
--- a/drivers/ide/h8300/ide-h8300.c
+++ b/drivers/ide/h8300/ide-h8300.c
@@ -189,6 +189,8 @@ static int __init h8300_ide_init(void)
 	int index;
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
+	printk(KERN_INFO DRV_NAME ": H8/300 generic IDE interface\n");
+
 	if (!request_region(CONFIG_H8300_IDE_BASE, H8300_IDE_GAP*8, "ide-h8300"))
 		goto out_busy;
 	if (!request_region(CONFIG_H8300_IDE_ALT, H8300_IDE_GAP, "ide-h8300")) {
@@ -205,7 +207,6 @@ static int __init h8300_ide_init(void)
 	index = hwif->index;
 	ide_init_port_hw(hwif, &hw);
 	hwif_setup(hwif);
-	printk(KERN_INFO "ide%d: H8/300 generic IDE interface\n", index);
 
 	idx[0] = index;
 
