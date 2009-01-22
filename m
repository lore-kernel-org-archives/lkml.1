Return-Path: <linux-kernel-owner+w=401wt.eu-S1758739AbZAVOS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758739AbZAVOS6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 09:18:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758195AbZAVORw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 09:17:52 -0500
Received: from mail-ew0-f20.google.com ([209.85.219.20]:58120 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758062AbZAVORv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 09:17:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=KSXUx6XwixymcxZ1OmM2X9W80r7dyXUcck7MwVWRIdNFiq0HnU7FJZzIMGkrn3/3kN
         fsvDoZwxqqlVvbCaJ4NxuMLr3CX8HdwjwxqqLvDHohJaxNkq8LlctWNV4b5UA3hXA2WQ
         OWXPNSr/Qq4Ko5N/p9y666XmYaIUWFUK2fOIA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 22 Jan 2009 15:18:21 +0100
Message-Id: <20090122141821.25516.192.sendpatchset@localhost.localdomain>
In-Reply-To: <20090122141801.25516.5620.sendpatchset@localhost.localdomain>
References: <20090122141801.25516.5620.sendpatchset@localhost.localdomain>
Subject: [PATCH 3/8] ide: shorten timeout value in ide_driveid_update()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: shorten timeout value in ide_driveid_update()

Shorten timeout value in ide_driveid_update() (30s -> 15s)
to match try_to_identify().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-iops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -325,7 +325,7 @@ int ide_driveid_update(ide_drive_t *driv
 
 	tp_ops->exec_command(hwif, ATA_CMD_ID_ATA);
 
-	if (ide_busy_sleep(hwif, WAIT_WORSTCASE, use_altstatus)) {
+	if (ide_busy_sleep(hwif, WAIT_WORSTCASE / 2, use_altstatus)) {
 		rc = 1;
 		goto out_err;
 	}
