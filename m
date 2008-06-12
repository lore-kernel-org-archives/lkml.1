Return-Path: <linux-kernel-owner+w=401wt.eu-S1758036AbYFLGnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036AbYFLGnd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 02:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755604AbYFLGlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 02:41:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:9579 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbYFLGlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 02:41:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=awUP40bYV5pFdjYoSGbOB0ZO2S60rrVJ5pKURxbKoRI06WA2HX7h80p6WZrDS5447G
         cjOz0oFBUH8CWZSF5q4WV2Bkj6aI1JF8eXaeCJsKUNJi0h1Plr3FMKecNb5FOhX5UCPK
         Jvznfit064hYX2K+AXKpEqbr0xeI6JBM2MR3o=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 05/18] ide-cd: ide_do_rw_cdrom: add the catch-all bad request case to the if-else block
Date: Thu, 12 Jun 2008 08:40:57 +0200
Message-Id: <1213252870-20474-6-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1213252870-20474-1-git-send-email-petkovbb@gmail.com>
References: <1213252870-20474-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-cd.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index e63eea2..21c4510 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1249,11 +1249,11 @@ static ide_startstop_t ide_do_rw_cdrom(ide_drive_t *drive, struct request *rq,
 		/* right now this can only be a reset... */
 		cdrom_end_request(drive, 1);
 		return ide_stopped;
+	} else {
+		blk_dump_rq_flags(rq, "ide-cd bad flags");
+		cdrom_end_request(drive, 0);
+		return ide_stopped;
 	}
-
-	blk_dump_rq_flags(rq, "ide-cd bad flags");
-	cdrom_end_request(drive, 0);
-	return ide_stopped;
 }
 
 
-- 
1.5.5.1

