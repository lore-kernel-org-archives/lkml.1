Return-Path: <linux-kernel-owner+w=401wt.eu-S1755927AbYKIQ4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbYKIQ4L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 11:56:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755813AbYKIQzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 11:55:53 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:43590 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755819AbYKIQzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 11:55:52 -0500
Date: Sun, 9 Nov 2008 17:55:49 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 5/8] drivers/mtd/maps/nettel.c: use ARRAY_SIZE
Message-ID: <Pine.LNX.4.64.0811091755280.32509@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

ARRAY_SIZE is more concise to use when the size of an array is divided by
the size of its type or the size of its first element.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@i@
@@

#include <linux/kernel.h>

@depends on i using "paren.iso"@
type T;
T[] E;
@@

- (sizeof(E)/sizeof(E[...]))
+ ARRAY_SIZE(E)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/mtd/maps/nettel.c     |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/maps/nettel.c b/drivers/mtd/maps/nettel.c
index 965e6c6..f38e92c 100644
--- a/drivers/mtd/maps/nettel.c
+++ b/drivers/mtd/maps/nettel.c
@@ -362,8 +362,7 @@ static int __init nettel_init(void)
 
 	intel_mtd->owner = THIS_MODULE;
 
-	num_intel_partitions = sizeof(nettel_intel_partitions) /
-		sizeof(nettel_intel_partitions[0]);
+	num_intel_partitions = ARRAY_SIZE(nettel_intel_partitions);
 
 	if (intelboot) {
 		/*
