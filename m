Return-Path: <linux-kernel-owner+w=401wt.eu-S1756250AbYGVVP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250AbYGVVP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 17:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756354AbYGVVOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 17:14:32 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:1590 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756172AbYGVVOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 17:14:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=UenqZDB4rCuopiTGSgj/PahcGnzfbISI3FVHjpVST/7uqaS6RTdM3bdzftxohAboPj
         6tL0b4beXMHyKf2e51Js0OA1cZt2knjQSNzi+OICBmxh3uDOvePVnjU0Cwll4lKvCX1T
         p3a6zluSgmduOzH5Y8fOhHD9kf6xmevth2EAA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 22 Jul 2008 23:12:20 +0200
Message-Id: <20080722211220.20478.34892.sendpatchset@localhost.localdomain>
In-Reply-To: <20080722211159.20478.74184.sendpatchset@localhost.localdomain>
References: <20080722211159.20478.74184.sendpatchset@localhost.localdomain>
Subject: [PATCH 03/10] ide: remove superfluous check from ide_disk_special()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This condition is checked by both ide_disk_init_mult_count()
and set_multcount() so no need to do it again in ide_disk_special().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-io.c |    2 --
 1 file changed, 2 deletions(-)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -540,8 +540,6 @@ static ide_startstop_t ide_disk_special(
 		ide_tf_set_restore_cmd(drive, &args.tf);
 	} else if (s->b.set_multmode) {
 		s->b.set_multmode = 0;
-		if (drive->mult_req > drive->id->max_multsect)
-			drive->mult_req = drive->id->max_multsect;
 		ide_tf_set_setmult_cmd(drive, &args.tf);
 	} else if (s->all) {
 		int special = s->all;
