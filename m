Return-Path: <linux-kernel-owner+w=401wt.eu-S1754747AbYKJGbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbYKJGbH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 01:31:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbYKJGay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 01:30:54 -0500
Received: from mail.suse.de ([195.135.220.2]:43507 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226AbYKJGax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 01:30:53 -0500
Message-ID: <4917D517.9050702@suse.de>
Date: Mon, 10 Nov 2008 15:30:47 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Neil Brown <neilb@suse.de>
Subject: [PATCH 3/3] block/md: fix md autodetection
References: <4917D4AB.4080401@kernel.org> <4917D4E6.5060008@kernel.org>
In-Reply-To: <4917D4E6.5060008@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Block ext devt conversion missed md_autodetect_dev() call in
rescan_partitions() leaving md autodetect unable to see partitions.
Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Neil Brown <neilb@suse.de>
---
Oops, I forgot 2/3 in the subject of the second patch.  Sorry.

 fs/partitions/check.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: work/fs/partitions/check.c
===================================================================
--- work.orig/fs/partitions/check.c
+++ work/fs/partitions/check.c
@@ -577,7 +577,7 @@ int rescan_partitions(struct gendisk *di
 		}
 #ifdef CONFIG_BLK_DEV_MD
 		if (state->parts[p].flags & ADDPART_FLAG_RAID)
-			md_autodetect_dev(bdev->bd_dev+p);
+			md_autodetect_dev(part_to_dev(part)->devt);
 #endif
 	}
 	kfree(state);
