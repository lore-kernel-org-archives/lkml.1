Return-Path: <linux-kernel-owner+w=401wt.eu-S1759766AbYAFQvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759766AbYAFQvs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 11:51:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758883AbYAFQuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 11:50:50 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:18967 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758532AbYAFQus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 11:50:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=t2IPlTkzXv8v+PLLJmP0O1yOn14sCSFJzeAlAhbIykK3bvLdSSmsJ/RT3pDbDlzpPGhNrunbMzVuTaxJNvJpfxwCI7WOqQuuoWdo4emz2Jqv9cuyI12NlYd0Gdz0VBJBRfNeEntqGzkE/gpIDnwnbpbWltnXmfXkH6YY2V/fdOs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 06 Jan 2008 18:02:34 +0100
Message-Id: <20080106170234.6861.14452.sendpatchset@localhost.localdomain>
In-Reply-To: <20080106170220.6861.4814.sendpatchset@localhost.localdomain>
References: <20080106170220.6861.4814.sendpatchset@localhost.localdomain>
Subject: [PATCH 2/8] au1xxx-ide: fix ->io_32bit handling
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The host driver must set hwif's ->no_io_32bit setting not drive's one
(ide_port_tune_devices() overrides drive's setting).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/mips/au1xxx-ide.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: b/drivers/ide/mips/au1xxx-ide.c
===================================================================
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -658,8 +658,7 @@ static int au_ide_probe(struct device *d
 	hwif->drives[0].autotune        = 1;    /* 1=autotune, 2=noautotune, 0=default */
 	hwif->drives[1].autotune	= 1;
 
-	hwif->drives[0].no_io_32bit	= 1;
-	hwif->drives[1].no_io_32bit	= 1;
+	hwif->no_io_32bit		= 1;
 
 	auide_hwif.hwif                 = hwif;
 	hwif->hwif_data                 = &auide_hwif;
