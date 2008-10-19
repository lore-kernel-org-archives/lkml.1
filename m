Return-Path: <linux-kernel-owner+w=401wt.eu-S1751602AbYJSOA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602AbYJSOA5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 10:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbYJSOAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 10:00:46 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:36960 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbYJSOAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 10:00:45 -0400
From: Dmitri Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Dmitri Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] kill suid bit only for regular files
Date: Sun, 19 Oct 2008 18:00:39 +0400
Message-Id: <1224424839-3892-1-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't have to do it because it is useless for non regular files.
In fact block device may trigger this path without dentry->d_inode->i_mutex.

Signed-off-by: Dmitri Monakhov <dmonakhov@openvz.org>
---
 mm/filemap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index a2907d5..3d5a2e7 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1767,7 +1767,7 @@ int should_remove_suid(struct dentry *dentry)
 	if (unlikely((mode & S_ISGID) && (mode & S_IXGRP)))
 		kill |= ATTR_KILL_SGID;
 
-	if (unlikely(kill && !capable(CAP_FSETID)))
+	if (unlikely(kill && !capable(CAP_FSETID) && S_ISREG(mode)))
 		return kill;
 
 	return 0;
-- 
1.5.4.3

