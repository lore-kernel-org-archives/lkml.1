Return-Path: <linux-kernel-owner+w=401wt.eu-S1755693Ab0A0UsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693Ab0A0UsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 15:48:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755512Ab0A0Uqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 15:46:39 -0500
Received: from mail.perches.com ([173.55.12.10]:1519 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755279Ab0A0Uqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 15:46:33 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH 01/13] drivers/block/floppy.c: Remove REPEAT macro
Date: Wed, 27 Jan 2010 12:46:17 -0800
Message-Id: <dfd4c514eefebf82ed33a23a9171fbae93007770.1264624291.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1264624291.git.joe@perches.com>
References: <cover.1264624291.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

macros with hidden flow changes aren't nice.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/floppy.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index c917320..e750554 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -2885,7 +2885,6 @@ static int make_raw_rw_request(void)
 
 static void redo_fd_request(void)
 {
-#define REPEAT {request_done(0); continue; }
 	int drive;
 	int tmp;
 
@@ -2920,7 +2919,8 @@ static void redo_fd_request(void)
 		if (test_bit(current_drive, &fake_change) ||
 		    test_bit(FD_DISK_CHANGED_BIT, &DRS->flags)) {
 			DPRINT("disk absent or changed during operation\n");
-			REPEAT;
+			request_done(0);
+			continue;
 		}
 		if (!_floppy) {	/* Autodetection */
 			if (!probing) {
@@ -2928,7 +2928,8 @@ static void redo_fd_request(void)
 				if (next_valid_format()) {
 					DPRINT("no autodetectable formats\n");
 					_floppy = NULL;
-					REPEAT;
+					request_done(0);
+					continue;
 				}
 			}
 			probing = 1;
@@ -2949,7 +2950,6 @@ static void redo_fd_request(void)
 		debugt("queue fd request");
 		return;
 	}
-#undef REPEAT
 }
 
 static struct cont_t rw_cont = {
-- 
1.6.6.rc0.57.gad7a

