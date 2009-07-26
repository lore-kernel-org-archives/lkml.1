Return-Path: <linux-kernel-owner+w=401wt.eu-S1751883AbZGYOee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbZGYOee (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 10:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750877AbZGYOed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 10:34:33 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:63818 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbZGYOec convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 10:34:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=gj5LLajp/ENrOxthoG/AL88FZRMvTmnJLTqerIVNMJRddIxP8HzRnFhjw/GfiaRziW
         8W3b3W3+zkIc+V3Hunisu50tX7/oX/tcZdAf3oFwj9lA5T1fYSo/8b4tFHwctqGjYZqH
         kRpG1z421pK/omfe+oCq4xynwDik1uN2rrHPk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: James.Bottomley@hansenpartnership.com
Subject: [PATCH] scsi: remove superfluous NULL pointer check from scsi_kill_request()
Date: Sun, 26 Jul 2009 16:29:25 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc4-next-20090723-04314-g011b7b2-dirty; KDE/4.2.4; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Dan Carpenter <error27@gmail.com>, corbet@lwn.net, eteo@redhat.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200907261629.26529.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] scsi: remove superfluous NULL pointer check from scsi_kill_request()

>From Dan's list:

drivers/scsi/scsi_lib.c +1365 scsi_kill_request(9) warning: variable derefenced in initializer 'cmd'
drivers/scsi/scsi_lib.c +1365 scsi_kill_request(9) warning: variable derefenced before check 'cmd'

We dereference cmd (and possible OOPS if cmd == NULL) before starting
the request so just remove the superfluous debugging code altogether.

Reported-by: Dan Carpenter <error27@gmail.com>
Cc: corbet@lwn.net
Cc: eteo@redhat.com
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/scsi/scsi_lib.c |    6 ------
 1 file changed, 6 deletions(-)

Index: b/drivers/scsi/scsi_lib.c
===================================================================
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1365,12 +1365,6 @@ static void scsi_kill_request(struct req
 
 	blk_start_request(req);
 
-	if (unlikely(cmd == NULL)) {
-		printk(KERN_CRIT "impossible request in %s.\n",
-				 __func__);
-		BUG();
-	}
-
 	scsi_init_cmd_errh(cmd);
 	cmd->result = DID_NO_CONNECT << 16;
 	atomic_inc(&cmd->device->iorequest_cnt);
