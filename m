Return-Path: <linux-kernel-owner+w=401wt.eu-S1753084Ab0ANSMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084Ab0ANSMP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 13:12:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791Ab0ANSMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 13:12:14 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:24895 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab0ANSMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 13:12:13 -0500
From: Nitin Gupta <ngupta@vflare.org>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] [mmotm v2] comment on swap notify locking constraints
Date: Thu, 14 Jan 2010 23:40:02 +0530
Message-Id: <1263492602-3052-1-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A block device makes swap_slot_free_notify() callback
when the last reference to a swap slot is dropped.

This callback is made under swap_lock and page table
lock. This is a note of warning for registered callback
function which must meet these constraints.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
---
 include/linux/blkdev.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f86df8b..fb7b3c2 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1294,6 +1294,7 @@ struct block_device_operations {
 						unsigned long long);
 	int (*revalidate_disk) (struct gendisk *);
 	int (*getgeo)(struct block_device *, struct hd_geometry *);
+	/* this callback is with swap_lock and page table lock held */
 	void (*swap_slot_free_notify) (struct block_device *, unsigned long);
 	struct module *owner;
 };
-- 
1.6.2.5

