Return-Path: <linux-kernel-owner+w=401wt.eu-S1755938AbYIGWRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938AbYIGWRc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 18:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755268AbYIGWQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 18:16:51 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:25685 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791AbYIGWQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 18:16:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=oGSyeLvb6u0YXj4RCS+ycoxdmUO4dMej+y5rlGHbQOVbq6y82Jib9gHy0DLKrii3Wn
         bpbTk5/q1h3nNUfUuWnWUC4lxXEIas5s4jbCaExz/4V2iralJEVrFkJdMtSdXAmpYDqK
         uXApQBTkT8AevBRqZyPsQJB4zfB2yEsrEi/SE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 08 Sep 2008 00:14:37 +0200
Message-Id: <20080907221437.24285.70475.sendpatchset@localhost.localdomain>
In-Reply-To: <20080907221424.24285.81137.sendpatchset@localhost.localdomain>
References: <20080907221424.24285.81137.sendpatchset@localhost.localdomain>
Subject: [PATCH 02/18] ide-disk: lock media before checking for media change
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-disk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -836,7 +836,6 @@ static int idedisk_open(struct inode *in
 	idkp->openers++;
 
 	if ((drive->dev_flags & IDE_DFLAG_REMOVABLE) && idkp->openers == 1) {
-		check_disk_change(inode->i_bdev);
 		/*
 		 * Ignore the return code from door_lock,
 		 * since the open() has already succeeded,
@@ -845,6 +844,7 @@ static int idedisk_open(struct inode *in
 		if ((drive->dev_flags & IDE_DFLAG_DOORLOCKING) &&
 		    idedisk_set_doorlock(drive, 1))
 			drive->dev_flags &= ~IDE_DFLAG_DOORLOCKING;
+		check_disk_change(inode->i_bdev);
 	}
 	return 0;
 }
