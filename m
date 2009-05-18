Return-Path: <linux-kernel-owner+w=401wt.eu-S1759288AbZERQSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759288AbZERQSn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 12:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758102AbZERQOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 12:14:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:41501 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324AbZERQJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 12:09:29 -0400
From: Jan Blunck <jblunck@suse.de>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, bharata@in.ibm.com, dwmw2@infradead.org,
       mszeredi@suse.cz, vaurora@redhat.com
Subject: [PATCH 02/32] VFS: BUG() if somebody tries to rehash an already hashed dentry
Date: Mon, 18 May 2009 18:08:58 +0200
Message-Id: <1242662968-11684-3-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1242662968-11684-1-git-send-email-jblunck@suse.de>
References: <1242662968-11684-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Break early when somebody tries to rehash an already hashed dentry.
Otherwise this leads to interesting corruptions in the dcache hash table
later on.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Valerie Aurora (Henson) <vaurora@redhat.com>
---
 fs/dcache.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 07e2d4a..085f527 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1562,6 +1562,7 @@ void d_rehash(struct dentry * entry)
 {
 	spin_lock(&dcache_lock);
 	spin_lock(&entry->d_lock);
+	BUG_ON(!d_unhashed(entry));
 	_d_rehash(entry);
 	spin_unlock(&entry->d_lock);
 	spin_unlock(&dcache_lock);
-- 
1.6.1.3

