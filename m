Return-Path: <linux-kernel-owner+w=401wt.eu-S1756806AbZKRJZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806AbZKRJZL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 04:25:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756693AbZKRJZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 04:25:06 -0500
Received: from cantor.suse.de ([195.135.220.2]:42202 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754541AbZKRJZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 04:25:02 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, jkacur@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       matthew@wil.cx, Jan Blunck <jblunck@suse.de>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 04/20] BKL: Remove outdated comment and include
Date: Wed, 18 Nov 2009 10:24:37 +0100
Message-Id: <1258536293-7762-5-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1258536293-7762-1-git-send-email-jblunck@suse.de>
References: <1258536293-7762-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remount_fs does not need lock_kernel() anymore since that was pushed down some
time ago. Since nothing needs smp_lock.h anymore lets remove it.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/super.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 19eb70b..6fe4611 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -23,7 +23,6 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
 #include <linux/acct.h>
 #include <linux/blkdev.h>
 #include <linux/quotaops.h>
@@ -618,8 +617,6 @@ static void do_emergency_remount(struct work_struct *work)
 		down_write(&sb->s_umount);
 		if (sb->s_root && sb->s_bdev && !(sb->s_flags & MS_RDONLY)) {
 			/*
-			 * ->remount_fs needs lock_kernel().
-			 *
 			 * What lock protects sb->s_flags??
 			 */
 			do_remount_sb(sb, MS_RDONLY, NULL, 1);
-- 
1.6.4.2

