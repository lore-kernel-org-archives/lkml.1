Return-Path: <linux-kernel-owner+w=401wt.eu-S1755693AbZFQUpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbZFQUpt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 16:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761517AbZFQUpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 16:45:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:41474 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757009AbZFQUpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 16:45:09 -0400
From: Jan Blunck <jblunck@suse.de>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       vaurora@redhat.com, hch@lst.de, miklos@szeredi.hu
Subject: [PATCH] VFS: BUG() if somebody tries to rehash an already hashed dentry
Date: Wed, 17 Jun 2009 22:45:05 +0200
Message-Id: <1245271510-31542-2-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1245271510-31542-1-git-send-email-jblunck@suse.de>
References: <1245271510-31542-1-git-send-email-jblunck@suse.de>
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
index 75659a6..191c488 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1550,6 +1550,7 @@ void d_rehash(struct dentry * entry)
 {
 	spin_lock(&dcache_lock);
 	spin_lock(&entry->d_lock);
+	BUG_ON(!d_unhashed(entry));
 	_d_rehash(entry);
 	spin_unlock(&entry->d_lock);
 	spin_unlock(&dcache_lock);
-- 
1.6.0.2

