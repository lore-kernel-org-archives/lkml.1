Return-Path: <linux-kernel-owner+w=401wt.eu-S1754850AbZJUTUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbZJUTUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 15:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754819AbZJUTUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 15:20:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754312AbZJUTUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 15:20:10 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>,
       Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>
Subject: [PATCH 01/41] VFS: BUG() if somebody tries to rehash an already hashed dentry
Date: Wed, 21 Oct 2009 12:18:59 -0700
Message-Id: <1256152779-10054-2-git-send-email-vaurora@redhat.com>
In-Reply-To: <1256152779-10054-1-git-send-email-vaurora@redhat.com>
References: <1256152779-10054-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

Break early when somebody tries to rehash an already hashed dentry.
Otherwise this leads to interesting corruptions in the dcache hash table
later on.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/dcache.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 9e5cd3c..38bf982 100644
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
1.6.3.3

