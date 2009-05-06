Return-Path: <linux-kernel-owner+w=401wt.eu-S1760750AbZEFOw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760750AbZEFOw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 10:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760305AbZEFOtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 10:49:11 -0400
Received: from mail.crca.org.au ([67.207.131.56]:57880 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759955AbZEFOs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 10:48:59 -0400
X-Bogosity: Ham, spamicity=0.000000
From: Nigel Cunningham <nigel@tuxonice.net>
To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       tuxonice-devel@lists.tuxonice.net
Cc: Nigel Cunningham <nigel@tuxonice.net>
Subject: [PATCH 3/19] TuxOnIce: Make drop_pagecache non-static and declared in mm.h
Date: Thu,  7 May 2009 00:38:59 +1000
Message-Id: <1241620755-22133-4-git-send-email-nigel@tuxonice.net>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the drop_pagecache function non-static, so that TuxOnIce can
provide users with the option to drop caches and save whatever is left
over.

Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
---
 fs/drop_caches.c   |    2 +-
 include/linux/mm.h |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/drop_caches.c b/fs/drop_caches.c
index b6a719a..e2f2799 100644
--- a/fs/drop_caches.c
+++ b/fs/drop_caches.c
@@ -33,7 +33,7 @@ static void drop_pagecache_sb(struct super_block *sb)
 	iput(toput_inode);
 }
 
-static void drop_pagecache(void)
+void drop_pagecache(void)
 {
 	struct super_block *sb;
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 3daeccb..c4199cd 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1298,6 +1298,7 @@ int drop_caches_sysctl_handler(struct ctl_table *, int, struct file *,
 					void __user *, size_t *, loff_t *);
 unsigned long shrink_slab(unsigned long scanned, gfp_t gfp_mask,
 			unsigned long lru_pages);
+void drop_pagecache(void);
 
 #ifndef CONFIG_MMU
 #define randomize_va_space 0
-- 
1.5.6.3

