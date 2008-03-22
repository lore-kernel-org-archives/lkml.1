Return-Path: <linux-kernel-owner+w=401wt.eu-S1758255AbYCVVxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255AbYCVVxs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 17:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758292AbYCVVwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 17:52:20 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:3989 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473AbYCVVwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 17:52:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=jKh3P9JF7JIG7g2J+l1Sq7b1WlyERjhzsVnoMzDgo3Gt/M21pAZXEwLTcWnC+TN+YgaxNKV8a9e9LZNoWGhliVAEnWaqtBjCiJx05RGQaTUvoImYJc1B3qKaWOcRLz0jH1yvRLsxSqQ8l4wQf4TaDg/3DRQ4Z586Zqsq8o2z130=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 22 Mar 2008 23:07:15 +0100
Message-Id: <20080322220715.17636.8976.sendpatchset@localhost.localdomain>
In-Reply-To: <20080322220623.17636.44337.sendpatchset@localhost.localdomain>
References: <20080322220623.17636.44337.sendpatchset@localhost.localdomain>
Subject: [PATCH 8/8] ide: cleanup init_ide_data()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Remove no longer need init_ide_data() call from ide_setup().

* Cleanup init_ide_data().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide.c |   24 ------------------------
 1 file changed, 24 deletions(-)

Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -157,32 +157,9 @@ static void ide_port_init_devices_data(i
 	}
 }
 
-/*
- * init_ide_data() sets reasonable default values into all fields
- * of all instances of the hwifs and drives, but only on the first call.
- * Subsequent calls have no effect (they don't wipe out anything).
- *
- * This routine is normally called at driver initialization time,
- * but may also be called MUCH earlier during kernel "command-line"
- * parameter processing.  As such, we cannot depend on any other parts
- * of the kernel (such as memory allocation) to be functioning yet.
- *
- * This is too bad, as otherwise we could dynamically allocate the
- * ide_drive_t structs as needed, rather than always consuming memory
- * for the max possible number (MAX_HWIFS * MAX_DRIVES) of them.
- *
- * FIXME: We should stuff the setup data into __init and copy the
- * relevant hwifs/allocate them properly during boot.
- */
-#define MAGIC_COOKIE 0x12345678
 static void __init init_ide_data (void)
 {
 	unsigned int index;
-	static unsigned long magic_cookie = MAGIC_COOKIE;
-
-	if (magic_cookie != MAGIC_COOKIE)
-		return;		/* already initialized */
-	magic_cookie = 0;
 
 	/* Initialise all interface structures */
 	for (index = 0; index < MAX_HWIFS; ++index) {
@@ -733,7 +710,6 @@ EXPORT_SYMBOL(generic_ide_ioctl);
 static int __init ide_setup(char *s)
 {
 	printk(KERN_INFO "ide_setup: %s", s);
-	init_ide_data ();
 
 #ifdef CONFIG_BLK_DEV_IDEDOUBLER
 	if (!strcmp(s, "ide=doubler")) {
