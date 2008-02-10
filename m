Return-Path: <linux-kernel-owner+w=401wt.eu-S1757240AbYBJVNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240AbYBJVNd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 16:13:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755384AbYBJVNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 16:13:08 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:49006 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbYBJVNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 16:13:05 -0500
Date: Sun, 10 Feb 2008 21:08:49 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: sfr@canb.auug.org.au, axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/8] drivers/block: Use FIELD_SIZEOF
Message-ID: <Pine.LNX.4.64.0802102108000.23906@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Robert P.J. Day proposed to use the macro FIELD_SIZEOF in replace of code
that matches its definition.

The modification was made using the following semantic patch
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@haskernel@
@@

#include <linux/kernel.h>

@depends on haskernel@
type t;
identifier f;
@@

- (sizeof(((t*)0)->f))
+ FIELD_SIZEOF(t, f)

@depends on haskernel@
type t;
identifier f;
@@

- sizeof(((t*)0)->f)
+ FIELD_SIZEOF(t, f)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---

diff -u -p a/drivers/block/viodasd.c b/drivers/block/viodasd.c
--- a/drivers/block/viodasd.c 2008-02-02 15:28:17.000000000 +0100
+++ b/drivers/block/viodasd.c 2008-02-10 17:42:42.000000000 +0100
@@ -69,7 +69,7 @@ MODULE_LICENSE("GPL");
 enum {
 	PARTITION_SHIFT = 3,
 	MAX_DISKNO = HVMAXARCHITECTEDVIRTUALDISKS,
-	MAX_DISK_NAME = sizeof(((struct gendisk *)0)->disk_name)
+	MAX_DISK_NAME = FIELD_SIZEOF(struct gendisk, disk_name)
 };
 
 static DEFINE_SPINLOCK(viodasd_spinlock);
