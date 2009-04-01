Return-Path: <linux-kernel-owner+w=401wt.eu-S1757827AbZDALJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757827AbZDALJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 07:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755714AbZDALJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 07:09:05 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:59534 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752780AbZDALJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 07:09:03 -0400
Subject: [PATCH] Free the temporary vfsmount created in bdev_cache_init()
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Cheng Renquan <crquan@gmail.com>
Date: Wed, 01 Apr 2009 12:07:37 +0100
Message-ID: <20090401110703.12974.99902.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.358.g140c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Apr 2009 11:08:09.0948 (UTC) FILETIME=[244D59C0:01C9B2BA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vfsmount structure allocated in this function (the bd_mnt local
variable) is only used to obtain the blockdev_superblock and there are
no other references to it. This structure can be safely freed (and
prevent kmemleak from reporting it).

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Cheng Renquan <crquan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---

This patch was submitted and acked some time ago but I don't think it
made it into the kernel. Here it is again. Thanks.

 fs/block_dev.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 8c3c689..e7a332f 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -492,6 +492,7 @@ void __init bdev_cache_init(void)
 	if (IS_ERR(bd_mnt))
 		panic("Cannot create bdev pseudo-fs");
 	blockdev_superblock = bd_mnt->mnt_sb;	/* For writeback */
+	free_vfsmnt(bd_mnt);
 }
 
 /*

