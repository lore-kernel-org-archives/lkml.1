Return-Path: <linux-kernel-owner+w=401wt.eu-S1759961AbYAYHY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759961AbYAYHY5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:24:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758719AbYAYHP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:15:58 -0500
Received: from ns2.suse.de ([195.135.220.15]:47512 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758709AbYAYHP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:15:57 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <teheo@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 032/196] sysfs: remove SPIN_LOCK_UNLOCKED
Date: Thu, 24 Jan 2008 23:09:30 -0800
Message-Id: <1201245134-4876-32-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

SPIN_LOCK_UNLOCKED is deprecated, use DEFINE_SPINLOCK instead

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <teheo@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 4045bdc..09a0611 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -66,7 +66,7 @@ static struct sysfs_ops subsys_sysfs_ops = {
  * sysfs_dirent->s_attr.open points to sysfs_open_dirent.  s_attr.open
  * is protected by sysfs_open_dirent_lock.
  */
-static spinlock_t sysfs_open_dirent_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(sysfs_open_dirent_lock);
 
 struct sysfs_open_dirent {
 	atomic_t		refcnt;
-- 
1.5.3.8

