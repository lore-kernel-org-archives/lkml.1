Return-Path: <linux-kernel-owner+w=401wt.eu-S1754163Ab0ANOfD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab0ANOfD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 09:35:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753931Ab0ANOfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 09:35:01 -0500
Received: from mail-qy0-f194.google.com ([209.85.221.194]:53412 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623Ab0ANOfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 09:35:00 -0500
From: Nitin Gupta <ngupta@vflare.org>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] [mmotm] comment on swap notify locking constraints
Date: Thu, 14 Jan 2010 20:02:51 +0530
Message-Id: <1263479571-7873-1-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A block device makes swap_slot_free_notify() callback
when the last reference to a swap slot is dropped.

This callback is made under swap_lock and often with
lock for corresponding swapcache page also held. This
is a note of warning for registered callback function
which must meet these constraints.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
---
 include/linux/blkdev.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 14b95a3..e3dcff6 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1295,6 +1295,7 @@ struct block_device_operations {
 						unsigned long long);
 	int (*revalidate_disk) (struct gendisk *);
 	int (*getgeo)(struct block_device *, struct hd_geometry *);
+	/* this callback is with swap_lock and often page lock also held */
 	void (*swap_slot_free_notify) (struct block_device *, unsigned long);
 	struct module *owner;
 };
-- 
1.6.2.5

