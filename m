Return-Path: <linux-kernel-owner+w=401wt.eu-S1763030AbXKIXdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763030AbXKIXdf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 18:33:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756291AbXKIXd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 18:33:26 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:57085 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756283AbXKIXdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 18:33:25 -0500
Message-id: <468229952380128680@pripojeni.net>
In-reply-to: <4827138842526222333@pripojeni.net>
Subject: [PATCH 4/5] FS: sysfs, remove SPIN_LOCK_UNLOCKED
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Date: Fri, 9 Nov 2007 18:33:25 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs, remove SPIN_LOCK_UNLOCKED

SPIN_LOCK_UNLOCKED is deprecated, use DEFINE_SPINLOCK instead

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>

---
commit 828042d12cc0aa515e049889aa76d4066df100c0
tree 85652493f11a06d0a1cda316d0f88a2ee7117d50
parent 4e91ba06c53856bfaab065aaf9fd8f5b0dd59f6f
author Jiri Slaby <jirislaby@gmail.com> Thu, 25 Oct 2007 11:58:48 +0200
committer Jiri Slaby <jirislaby@gmail.com> Thu, 25 Oct 2007 11:58:48 +0200

 fs/sysfs/file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 6d31ac6..cb7eadf 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -37,7 +37,7 @@ void sysfs_printk_last_file(void)
  * sysfs_dirent->s_attr.open points to sysfs_open_dirent.  s_attr.open
  * is protected by sysfs_open_dirent_lock.
  */
-static spinlock_t sysfs_open_dirent_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(sysfs_open_dirent_lock);
 
 struct sysfs_open_dirent {
 	atomic_t		refcnt;
