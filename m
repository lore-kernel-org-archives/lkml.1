Return-Path: <linux-kernel-owner+w=401wt.eu-S1756041Ab0A0V2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab0A0V2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 16:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610Ab0A0V2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 16:28:20 -0500
Received: from mail.perches.com ([173.55.12.10]:1561 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974Ab0A0V2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 16:28:20 -0500
Subject: [PATCH V2 11/13] drivers/block/floppy.c: Remove obfuscating
 CODE2SIZE macro
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
In-Reply-To: <cover.1264624291.git.joe@perches.com>
References: <cover.1264624291.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Jan 2010 13:28:17 -0800
Message-ID: <1264627697.14552.100.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And use DIV_ROUND_UP instead

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
+	ssize = DIV_ROUND_UP(1 << SIZECODE, 4);
 
 	if (ST1 & ST1_EOC)
 		eoc = 1;
@@ -2647,7 +2646,7 @@ static int make_raw_rw_request(void)
 	raw_cmd->track = TRACK << STRETCH(_floppy);
 	DR_SELECT = UNIT(current_drive) + PH_HEAD(_floppy, HEAD);
 	GAP = _floppy->gap;
-	CODE2SIZE;
+	ssize = DIV_ROUND_UP(1 << SIZECODE, 4);
 	SECT_PER_TRACK = _floppy->sect << 2 >> SIZECODE;
 	SECTOR = ((fsector_t % _floppy->sect) << 2 >> SIZECODE) +
 	    FD_SECTBASE(_floppy);


