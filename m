Return-Path: <linux-kernel-owner+w=401wt.eu-S1752492AbZHBIvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbZHBIvx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 04:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbZHBIvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 04:51:51 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:53281 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013AbZHBIvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 04:51:50 -0400
Date: Sun, 2 Aug 2009 10:49:54 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: petkovbb@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 15/15] drivers/ide/ide-cd.c: Use DIV_ROUND_CLOSEST
Message-ID: <Pine.LNX.4.64.0908021049350.15557@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The kernel.h macro DIV_ROUND_CLOSEST performs the computation (x + d/2)/d
but is perhaps more readable.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@haskernel@
@@

#include <linux/kernel.h>

@depends on haskernel@
expression x,__divisor;
@@

- (((x) + ((__divisor) / 2)) / (__divisor))
+ DIV_ROUND_CLOSEST(x,__divisor)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/ide/ide-cd.c                |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 6a9a769..1483a8d 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1146,8 +1146,8 @@ void ide_cdrom_update_speed(ide_drive_t *drive, u8 *buf)
 	ide_debug_log(IDE_DBG_PROBE, "curspeed: %u, maxspeed: %u",
 				     curspeed, maxspeed);
 
-	cd->current_speed = (curspeed + (176/2)) / 176;
-	cd->max_speed = (maxspeed + (176/2)) / 176;
+	cd->current_speed = DIV_ROUND_CLOSEST(curspeed, 176);
+	cd->max_speed = DIV_ROUND_CLOSEST(maxspeed, 176);
 }
 
 #define IDE_CD_CAPABILITIES \
