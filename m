Return-Path: <linux-kernel-owner+w=401wt.eu-S1755271AbZAZUlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbZAZUlX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 15:41:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753422AbZAZUkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 15:40:49 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:48568 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbZAZUkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 15:40:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=LLXsEyu4C9AkVl5jBTZ9DhVeAB1haWTsHXRm30qkTQtrYXlqiTJoXR7k01eafakSFw
         lpiSxS9lhzC7Z5qLZe+y6Fel+IjFByUysQ9Q+cD45RZ4PEP+8bWeXK2cBnmHxbxUD4Bo
         LQEWuSXMshl+97EfIyuJ6gMiOI3ZsXELPBRaw=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 1/3] ide-cd: use ide_drive_t's rq in cdrom_queue_request_sense
Date: Mon, 26 Jan 2009 21:40:38 +0100
Message-Id: <1233002440-4325-1-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functionality change resulting from this patch.

Suggested-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-cd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index d3d5fb6..3907466 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -207,7 +207,7 @@ static void cdrom_queue_request_sense(ide_drive_t *drive, void *sense,
 				      struct request *failed_command)
 {
 	struct cdrom_info *info		= drive->driver_data;
-	struct request *rq		= &info->request_sense_request;
+	struct request *rq		= &drive->request_sense_rq;
 
 	ide_debug_log(IDE_DBG_SENSE, "Call %s\n", __func__);
 
-- 
1.6.0.4

