Return-Path: <linux-kernel-owner+w=401wt.eu-S1756725AbZKRJY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725AbZKRJY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 04:24:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756696AbZKRJY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 04:24:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39384 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754421AbZKRJYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 04:24:55 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, jkacur@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       matthew@wil.cx, Jan Blunck <jblunck@suse.de>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: [PATCH 01/20] JFS: Free sbi memory in error path
Date: Wed, 18 Nov 2009 10:24:34 +0100
Message-Id: <1258536293-7762-2-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1258536293-7762-1-git-send-email-jblunck@suse.de>
References: <1258536293-7762-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I spotted the missing kfree() while removing the BKL.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/jfs/super.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index 2234c73..67f8c3e 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -452,6 +452,7 @@ static int jfs_fill_super(struct super_block *sb, void *data, int silent)
 
 	if (newLVSize) {
 		printk(KERN_ERR "resize option for remount only\n");
+		kfree(sbi);
 		return -EINVAL;
 	}
 
-- 
1.6.4.2

