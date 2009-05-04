Return-Path: <linux-kernel-owner+w=401wt.eu-S1752188AbZEDFFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbZEDFFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 01:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751375AbZEDFFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 01:05:30 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:17067 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbZEDFF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 01:05:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=GW1rbnw6VtsJfAh0K8FkGrGDlixJp5yECEaF0CkZtDH3hdZLNzQsHY1YyNJMxig1Cn
         KF+VEsYNDUTN3BWJCqjTYnBoYsf2/1CZ6tlzTS/r/IdOm5pibvOrK4zGQh4Dnt793yWU
         4rESwXtmT7/iLFXoIAOawBgg3Hp5k7qKU3DFM=
MIME-Version: 1.0
Date: Mon, 4 May 2009 01:05:28 -0400
Message-ID: <3a3680030905032205u2c3490e8r62e66c48aff97fee@mail.gmail.com>
Subject: [PATCH] btrfs: remove the improper comment for btrfs_ioctl_resize()
From: Li Hong <lihong.hi@gmail.com>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Cc: lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In Li Zefan's commit dae7b665cf6d6e6e733f1c9c16cf55547dd37e33,
a combination call of kmalloc() and copy_from_user() is replaced by
memdup_user(). So btrfs_ioctl_resize() doesn't use GFP_NOFS any more.

Signed-off-by: Li Hong <lihong.hi@gmail.com>
---
 fs/btrfs/ioctl.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 5e94ea6..2624b53 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -437,10 +437,6 @@ out_unlock:
 	return 0;
 }

-/*
- * Called inside transaction, so use GFP_NOFS
- */
-
 static int btrfs_ioctl_resize(struct btrfs_root *root, void __user *arg)
 {
 	u64 new_size;
-- 
1.6.2.1
