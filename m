Return-Path: <linux-kernel-owner+w=401wt.eu-S1755922Ab0A0Us4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab0A0Us4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 15:48:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755832Ab0A0Usu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 15:48:50 -0500
Received: from mail.perches.com ([173.55.12.10]:1546 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755429Ab0A0Uqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 15:46:35 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH 11/13] drivers/block/floppy.c: Remove obfuscating CODE2SIZE macro
Date: Wed, 27 Jan 2010 12:46:27 -0800
Message-Id: <4cafcde7cd66be92f7d0bde18745cf0201c1edee.1264624292.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1264624291.git.joe@perches.com>
References: <cover.1264624291.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/floppy.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 6124070..d559964 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -2143,7 +2143,6 @@ static void format_interrupt(void)
 	cont->redo();
 }
 
-#define CODE2SIZE (ssize = ((1 << SIZECODE) + 3) >> 2)
 #define FM_MODE(x, y) ((y) & ~(((x)->rate & 0x80) >> 1))
 #define CT(x) ((x) | 0xc0)
 
@@ -2347,7 +2346,7 @@ static void rw_interrupt(void)
 		DRS->first_read_date = jiffies;
 
 	nr_sectors = 0;
-	CODE2SIZE;
+	ssize = ((1 << SIZECODE) + 3) >> 2;
 
 	if (ST1 & ST1_EOC)
 		eoc = 1;
@@ -2647,7 +2646,7 @@ static int make_raw_rw_request(void)
 	raw_cmd->track = TRACK << STRETCH(_floppy);
 	DR_SELECT = UNIT(current_drive) + PH_HEAD(_floppy, HEAD);
 	GAP = _floppy->gap;
-	CODE2SIZE;
+	ssize = ((1 << SIZECODE) + 3) >> 2;
 	SECT_PER_TRACK = _floppy->sect << 2 >> SIZECODE;
 	SECTOR = ((fsector_t % _floppy->sect) << 2 >> SIZECODE) +
 	    FD_SECTBASE(_floppy);
-- 
1.6.6.rc0.57.gad7a

