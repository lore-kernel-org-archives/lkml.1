Return-Path: <linux-kernel-owner+w=401wt.eu-S1761909AbZANLmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761909AbZANLmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 06:42:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757332AbZANLlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 06:41:31 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:50859 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759116AbZANLl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 06:41:29 -0500
Subject: [PATCH] Free the temporary vfsmount created in bdev_cache_init()
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Cheng Renquan <crquan@gmail.com>
Date: Wed, 14 Jan 2009 11:40:47 +0000
Message-ID: <20090114114047.5009.61420.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.330.gdc1a.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jan 2009 11:40:47.0381 (UTC) FILETIME=[F1372C50:01C9763C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vfsmount structure allocated in this function (the bd_mnt local
variable) is only used to obtain the blockdev_superblock and there are
no other references to it. This structure can be safely freed.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Cheng Renquan <crquan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 fs/block_dev.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index b3c1eff..5124756 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -346,6 +346,7 @@ void __init bdev_cache_init(void)
 	if (IS_ERR(bd_mnt))
 		panic("Cannot create bdev pseudo-fs");
 	blockdev_superblock = bd_mnt->mnt_sb;	/* For writeback */
+	free_vfsmnt(bd_mnt);
 }
 
 /*

