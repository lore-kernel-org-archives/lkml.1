Return-Path: <linux-kernel-owner+w=401wt.eu-S1757335AbZBPAQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335AbZBPAQs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 19:16:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755784AbZBPANK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 19:13:10 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:51372 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877AbZBPANI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 19:13:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Z9ExhDoB7e97Vn7q0qFCHi4qGjebVfoR4xWuc1WTULna7Rudm1tYQTfNhEwFCcjq7l
         Dh3MosTAq+ehHJxqQeVj0kQiv10Cqj16z/XbRnZ1yRl2w5Gezi6tkT5MDut9UHzh9Qd2
         /a1giVF+skJADv4z53LHm/b7c5koRLinr0SDg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 16 Feb 2009 01:14:35 +0100
Message-Id: <20090216001435.27491.64345.sendpatchset@localhost.localdomain>
In-Reply-To: <20090216001309.27491.59759.sendpatchset@localhost.localdomain>
References: <20090216001309.27491.59759.sendpatchset@localhost.localdomain>
Subject: [PATCH 13/20] ide-cd: kill whole failed request in ide_cd_do_request()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide-cd: kill whole failed request in ide_cd_do_request()

Untangling cdrom_end_request() uncovered an error in completing
failed requests in ide_cd_do_request().  Fix it.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1078,7 +1078,7 @@ out_end:
 			rq->errors = -EIO;
 	}
 
-	nsectors = rq->hard_cur_sectors;
+	nsectors = rq->hard_nr_sectors;
 
 	if (nsectors == 0)
 		nsectors = 1;
