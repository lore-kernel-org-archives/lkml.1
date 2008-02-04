Return-Path: <linux-kernel-owner+w=401wt.eu-S1757288AbYBDNul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288AbYBDNul (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 08:50:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755815AbYBDNuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 08:50:05 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:16723 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758295AbYBDNuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 08:50:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=i5rHvTVcXjDkx9IVzsHO/0sb/F83DTFkW2Soglx7H2coiyaARr/Ri7iv+TXMVtZdU7dvcSkooXlWexCpN/n81WxSCNRH3OR8Zp0tAPqaj+Q411GXSvQAy/34wxmytZfGH6gLQvnYxneYTpJRsh/HbdivWHpgbygmiy5Hpdgxqo4=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 22/22] ide-tape: schedule driver for removal after 6 months in case it turns out
Date: Mon,  4 Feb 2008 14:40:40 +0100
Message-Id: <1202132440-26648-23-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1202132440-26648-1-git-send-email-petkovbb@gmail.com>
References: <1202132440-26648-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 Documentation/feature-removal-schedule.txt |   14 ++++++++++++--
 drivers/ide/ide-tape.c                     |    5 +++++
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index a7d9d17..147bb63 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -264,8 +264,6 @@ Who:	Thomas Gleixner <tglx@linutronix.de>
 
 ---------------------------
 
----------------------------
-
 What:	i2c-i810, i2c-prosavage and i2c-savage4
 When:	May 2008
 Why:	These drivers are superseded by i810fb, intelfb and savagefb.
@@ -338,3 +336,15 @@ Why:	The support code for the old firmware hurts code readability/maintainabilit
 	and slightly hurts runtime performance. Bugfixes for the old firmware
 	are not provided by Broadcom anymore.
 Who:	Michael Buesch <mb@bu3sch.de>
+
+---------------------------
+
+What:	ide-tape driver
+When:	July 2008
+Files:	drivers/ide/ide-tape.c
+Why:	This driver might not have any users anymore and maintaining it for no
+	reason is an effort no one wants to make.
+Who:	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Borislav Petkov
+	<petkovbb@googlemail.com>
+
+---------------------------
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 2e6198f..86f206b 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -3803,6 +3803,11 @@ static int ide_tape_probe(ide_drive_t *drive)
 	g->fops = &idetape_block_ops;
 	ide_register_region(g);
 
+	printk(KERN_WARNING "It is possible that this driver does not have any"
+		" users anymore and, as a result, it will be REMOVED soon."
+		" Please notify Bart <bzolnier@gmail.com> or Boris"
+		" <petkovbb@gmail.com> in case you still need it.\n");
+
 	return 0;
 
 out_free_tape:
-- 
1.5.3.7

