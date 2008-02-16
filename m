Return-Path: <linux-kernel-owner+w=401wt.eu-S1764236AbYBPDXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764236AbYBPDXz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 22:23:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759491AbYBPDWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 22:22:50 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:24358 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbYBPDWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 22:22:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Ns8gNw2iXaEWxuvMCzvjUUJtKJ2NZd2FMtZg1Hh1caxt3xYErWzR1yulRNrxaukdC4VtkAgd4XyjtQOc9mHp7ygXhXWWCshWz0k98Pb8sQTglhJPacf4C1wJYIE+exLJbNtpcKJSqyEG4MVkNpw7K4UnXpjE9ai6xAXHzeWvXLg=
Subject: [PATCH 3/4] jffs2: fix sparse warning in write.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 15 Feb 2008 19:22:16 -0800
Message-Id: <1203132136.7442.33.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/jffs2/write.c:585:28: warning: symbol 'fd' shadows an earlier one
fs/jffs2/write.c:536:27: originally declared here

No need to redeclare fd, use the original one, after this point,
fd is always reassigned before it used again.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/jffs2/write.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/jffs2/write.c b/fs/jffs2/write.c
index 776f13c..beade55 100644
--- a/fs/jffs2/write.c
+++ b/fs/jffs2/write.c
@@ -582,9 +582,9 @@ int jffs2_do_unlink(struct jffs2_sb_info *c, struct jffs2_inode_info *dir_f,
 		jffs2_add_fd_to_list(c, fd, &dir_f->dents);
 		up(&dir_f->sem);
 	} else {
-		struct jffs2_full_dirent *fd = dir_f->dents;
 		uint32_t nhash = full_name_hash(name, namelen);
 
+		fd = dir_f->dents;
 		/* We don't actually want to reserve any space, but we do
 		   want to be holding the alloc_sem when we write to flash */
 		down(&c->alloc_sem);
-- 
1.5.4.1.1278.gc75be


