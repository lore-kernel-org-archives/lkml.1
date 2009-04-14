Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbZDNLKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbZDNLKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 07:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbZDNLKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 07:10:04 -0400
Received: from cantor.suse.de ([195.135.220.2]:39728 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350AbZDNLKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 07:10:01 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
Subject: [PATCH 2/6] Handle possible bio_alloc failure in btrfs
Date: Tue, 14 Apr 2009 16:36:36 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.27.21-0.1-default; KDE/4.2.1; x86_64; ; )
MIME-Version: 1.0
Content-Disposition: inline
To: Chris Mason <chris.mason@oracle.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-btrfs@vger.kernel.org
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200904141636.36894.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle possible bio_alloc failure in btrfs.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

Index: linux-2.6/fs/btrfs/inode.c
===================================================================
--- linux-2.6.orig/fs/btrfs/inode.c
+++ linux-2.6/fs/btrfs/inode.c
@@ -1714,6 +1714,11 @@ static int btrfs_io_failed_hook(struct b
 		return -EIO;
 	}
 	bio = bio_alloc(GFP_NOFS, 1);
+	if (unlikely(!bio)) {
+		kfree(failrec);
+		return -ENOMEM;
+	}
+	
 	bio->bi_private = state;
 	bio->bi_end_io = failed_bio->bi_end_io;
 	bio->bi_sector = failrec->logical >> 9;


