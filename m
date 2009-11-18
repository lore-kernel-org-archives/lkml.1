Return-Path: <linux-kernel-owner+w=401wt.eu-S1756892AbZKRJZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892AbZKRJZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 04:25:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756812AbZKRJZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 04:25:22 -0500
Received: from cantor.suse.de ([195.135.220.2]:42319 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756852AbZKRJZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 04:25:19 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, jkacur@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       matthew@wil.cx, Jan Blunck <jblunck@suse.de>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 18/20] BKL: Remove BKL from do_new_mount()
Date: Wed, 18 Nov 2009 10:24:51 +0100
Message-Id: <1258536293-7762-19-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1258536293-7762-1-git-send-email-jblunck@suse.de>
References: <1258536293-7762-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After pushing down the BKL to the get_sb/fill_super operations of the
filesystems that still make usage of the BKL it is safe to remove it from
do_new_mount().

I've read through all the code formerly covered by the BKL inside
do_kern_mount() and have satisfied myself that it doesn't need the BKL
any more.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Cc: Matthew Wilcox <matthew@wil.cx>
---
 fs/namespace.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index bdc3cb4..3f95497 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1647,9 +1647,7 @@ static int do_new_mount(struct path *path, char *type, int flags,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	lock_kernel();
 	mnt = do_kern_mount(type, flags, name, data);
-	unlock_kernel();
 	if (IS_ERR(mnt))
 		return PTR_ERR(mnt);
 
-- 
1.6.4.2

