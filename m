Return-Path: <linux-kernel-owner+w=401wt.eu-S1758187AbYAVXAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187AbYAVXAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 18:00:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755458AbYAVW75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 17:59:57 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:5155 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbYAVW7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 17:59:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=nDNqD1Bz/QL4pu9sH8RLuzwl9J52/WuEURaaMu3ITm1hfRZ8YwGgDMH5xQ+QWdWpYnJ5jVDW1ZYnMpocWEcHh5RHI+Ee8eudz0guOPNprh023IAOyFhhz2C9CCPEY94wL9MnEU3H/Z0PSzpE6YGWuZfrgV4CZn0+d5+paeGNKHY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide-cs: use ide_std_init_ports()
Date: Wed, 23 Jan 2008 00:03:06 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801230003.07211.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


No reason to use ide_init_hwif_ports() in ide-cs (as a nice side-effect
this makes ide-cs work on archs that don't define IDE_ARCH_OBSOLETE_INIT).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/legacy/ide-cs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/legacy/ide-cs.c
===================================================================
--- a/drivers/ide/legacy/ide-cs.c
+++ b/drivers/ide/legacy/ide-cs.c
@@ -151,7 +151,7 @@ static int idecs_register(unsigned long 
     u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
     memset(&hw, 0, sizeof(hw));
-    ide_init_hwif_ports(&hw, io, ctl, NULL);
+    ide_std_init_ports(&hw, io, ctl);
     hw.irq = irq;
     hw.chipset = ide_pci;
     hw.dev = &handle->dev;
