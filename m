Return-Path: <linux-kernel-owner+w=401wt.eu-S1756194AbYBQSiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbYBQSiO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 13:38:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754607AbYBQShH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 13:37:07 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:63739 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469AbYBQShF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 13:37:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=VRnxhFNpKiemqG0ZeLmC/9oPHCpLuoPnbDzXXkWLqkUHsk19VOqOtCAwsvXTBu1bpbeaApmKsr8mQWMREhPVUGcQQTlsjvO4vVOCDvjhy9VOFUmyzv/llIMAPofVRjr5+mvmnz0Yd54Ghz748UmtVSOC4QIK8dQLTnLJjM4Nkd0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 17 Feb 2008 19:51:41 +0100
Message-Id: <20080217185141.16210.1716.sendpatchset@localhost.localdomain>
In-Reply-To: <20080217185105.16210.26582.sendpatchset@localhost.localdomain>
References: <20080217185105.16210.26582.sendpatchset@localhost.localdomain>
Subject: [PATCH 5/5] ide: unexport ide_hwifs[]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All modular users have been fixed to not reference ide_hwifs[] directly.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide.c |    5 -----
 1 file changed, 5 deletions(-)

Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -102,13 +102,8 @@ int ide_noacpitfs = 1;
 int ide_noacpionboot = 1;
 #endif
 
-/*
- * This is declared extern in ide.h, for access by other IDE modules:
- */
 ide_hwif_t ide_hwifs[MAX_HWIFS];	/* master data repository */
 
-EXPORT_SYMBOL(ide_hwifs);
-
 static void ide_port_init_devices_data(ide_hwif_t *);
 
 /*
