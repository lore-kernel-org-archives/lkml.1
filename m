Return-Path: <linux-kernel-owner+w=401wt.eu-S964823AbZKYOF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964823AbZKYOF3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 09:05:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934636AbZKYOF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 09:05:28 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:61871 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934617AbZKYOF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 09:05:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=jT2hgfPT1tpDyS/UHFbVwMOsT428hT0CDAd3qNfBpGRJHhbwbvjKTO+qzHyY07rxYN
         Vq0rH1a0A8AwcZGJTfWGqMqZwV5yDf/M7qTiKo158oCpcj+RimmQy0/WFo1M6fOO7wS6
         piR4dwChsfbsBfJ+DA4FyFnr2N50CJuBZnHA4=
Date: Wed, 25 Nov 2009 22:09:45 +0800
From: "Liuweni" <qingshenlwy@gmail.com>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Cc: "strongzgy" <strongzgy@gmail.com>, "xgr178" <xgr178@163.com>,
       "Liu Hui" <onlyflyer@gmail.com>, "viro" <viro@zeniv.linux.org.uk>,
       "akpm" <akpm@linux-foundation.org>, "jack" <jack@suse.cz>,
       "npiggin" <npiggin@suse.de>,
       "linux-fsdevel" <linux-fsdevel@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3]fs/inode: iunique() Optimize Performance
Message-ID: <200911252209432039291@gmail.com>
X-mailer: Foxmail 6, 15, 201, 22 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
move the if condition out the while{}.
While the function executing, the if 
condition won't check again and again.
And this code won't change the function
of iunique().

---
Signed-off-by: Liuwenyi<qingshenlwy@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Nick Piggin <npiggin@suse.de>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
diff --git a/fs/inode.c b/fs/inode.c
index 4d8e3be..8ff1e99 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -838,9 +838,10 @@ ino_t iunique(struct super_block *sb, ino_t max_reserved)
 	ino_t res;
 
 	spin_lock(&inode_lock);
+
+	if (counter <= max_reserved)
+		counter = max_reserved + 1;
 	do {
-		if (counter <= max_reserved)
-			counter = max_reserved + 1;
 		res = counter++;
 		head = inode_hashtable + hash(sb, res);
 		inode = find_inode_fast(sb, head, res);

 				
--------------
Best Regards,
Liuweni
2009-11-25

