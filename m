Return-Path: <linux-kernel-owner+w=401wt.eu-S1756198AbZBARxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbZBARxc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 12:53:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756230AbZBARtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 12:49:50 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:43113 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214AbZBARtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 12:49:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=ZY9mDMr70uVnRnspkdCi2lBY5l/lKhGY6/8+w1hAe/nli1dPwePUmS2kvC7w20+9PB
         S52xS4Yqw+aDukMVOskcdOorEYW0BQaO46DiNW07GnhKF8DAAAGQgLkXEdLrT7ahF28g
         uol4bFZlhaV6KcRKetMiRVr6wXC596HlqU/j0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 01 Feb 2009 18:50:40 +0100
Message-Id: <20090201175040.19144.95929.sendpatchset@localhost.localdomain>
In-Reply-To: <20090201174909.19144.67767.sendpatchset@localhost.localdomain>
References: <20090201174909.19144.67767.sendpatchset@localhost.localdomain>
Subject: [PATCH 13/15] ide: no need to read Status and Error registers for "empty" taskfile requests
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: no need to read Status and Error registers for "empty" taskfile requests

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-io.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -333,9 +333,7 @@ static ide_startstop_t execute_drive_cmd
 #ifdef DEBUG
  	printk("%s: DRIVE_CMD (null)\n", drive->name);
 #endif
-	(void)hwif->tp_ops->read_status(hwif);
-
-	ide_complete_rq(drive, ide_read_error(drive));
+	ide_complete_rq(drive, 0);
 
  	return ide_stopped;
 }
