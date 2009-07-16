Return-Path: <linux-kernel-owner+w=401wt.eu-S932696AbZGPQ5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932696AbZGPQ5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 12:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932582AbZGPQ5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 12:57:31 -0400
Received: from cantor.suse.de ([195.135.220.2]:46508 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932577AbZGPQ5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 12:57:31 -0400
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH] vm: Document that setting vfs_cache_pressure to 0 isn't a good idea
Date: Thu, 16 Jul 2009 18:57:29 +0200
Message-Id: <1247763449-22360-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: Christian Thaeter <ct@pipapo.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 Documentation/sysctl/vm.txt |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

 Andrew, would you merge this please? Thanks.

diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
index c4de635..76e8671 100644
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -585,7 +585,9 @@ caching of directory and inode objects.
 At the default value of vfs_cache_pressure=100 the kernel will attempt to
 reclaim dentries and inodes at a "fair" rate with respect to pagecache and
 swapcache reclaim.  Decreasing vfs_cache_pressure causes the kernel to prefer
-to retain dentry and inode caches.  Increasing vfs_cache_pressure beyond 100
+to retain dentry and inode caches. When vfs_cache_pressure=0, the kernel will
+never reclaim dentries and inodes due to memory pressure and this can easily
+lead to out-of-memory conditions. Increasing vfs_cache_pressure beyond 100
 causes the kernel to prefer to reclaim dentries and inodes.
 
 ==============================================================
-- 
1.6.0.2

