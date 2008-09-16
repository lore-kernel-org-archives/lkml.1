Return-Path: <linux-kernel-owner+w=401wt.eu-S1756676AbYIPT3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676AbYIPT3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 15:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754639AbYIPT30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 15:29:26 -0400
Received: from xenotime.net ([66.160.160.81]:46219 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750770AbYIPT3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 15:29:25 -0400
Date: Tue, 16 Sep 2008 12:29:21 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: linux-next@vger.kernel.org, akpm@linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, axboe@kernel.dk
Subject: [PATCH -next] blkdev.h: fix warnings when CONFIG_BLOCK=n
In-Reply-To: <20080916173415.14012569.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.0809161226230.32267@shark.he.net>
References: <20080916173415.14012569.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix lots of build warnings when CONFIG_BLOCK=n:

linux-next-20080916/include/linux/blkdev.h:1093: warning: 'struct block_device' declared inside parameter list
linux-next-20080916/include/linux/blkdev.h:1093: warning: its scope is only this definition or declaration, which is probably not what you want
linux-next-20080916/include/linux/blkdev.h:1097: warning: 'struct gendisk' declared inside parameter list
linux-next-20080916/include/linux/blkdev.h:1105: warning: 'struct hd_geometry' declared inside parameter list

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/linux/blkdev.h |    4 ++++
 1 file changed, 4 insertions(+)

--- linux-next-20080916.orig/include/linux/blkdev.h
+++ linux-next-20080916/include/linux/blkdev.h
@@ -1089,6 +1089,10 @@ static inline long nr_blockdev_pages(voi
 
 #endif /* CONFIG_BLOCK */
 
+struct block_device;
+struct gendisk;
+struct hd_geometry;
+
 extern int __blkdev_driver_ioctl(struct block_device *, fmode_t, unsigned int,
 				 unsigned long);
 
