Return-Path: <linux-kernel-owner+w=401wt.eu-S934862AbXHPD2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934862AbXHPD2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 23:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938221AbXHPD1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 23:27:49 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:24286 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938215AbXHPD1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 23:27:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:subject:date:message-id:x-mailer;
        b=iugTLxPi66P+SRZ4iZFofKzxJga/tdPEBYtmYM8mqdMU0OpS9HIl/uY4C8RLXZk909OKLN95lK/yEwbryg9vng2w9Vy5470V0pmiBqZdqO9e4MzMvsQPV6qv9YzvLNZ6feEDi9dzwniSx6Pc0AkuSQj0GbiwOyuUThWiv+xdAKg=
From: Denis Cheng <crquan@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, cr_quan@163.com
Subject: [PATCH] vfs: use list_for_each_entry instead
Date: Thu, 16 Aug 2007 11:28:16 +0800
Message-Id: <11872348963990-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.rc4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 fs/super.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index fc8ebed..f287c15 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -334,15 +334,12 @@ struct super_block *sget(struct file_system_type *type,
 			int (*set)(struct super_block *,void *),
 			void *data)
 {
-	struct super_block *s = NULL;
-	struct list_head *p;
+	struct super_block *s = NULL, *old;
 	int err;
 
 retry:
 	spin_lock(&sb_lock);
-	if (test) list_for_each(p, &type->fs_supers) {
-		struct super_block *old;
-		old = list_entry(p, struct super_block, s_instances);
+	if (test) list_for_each_entry(old, &type->fs_supers, s_instances) {
 		if (!test(old, data))
 			continue;
 		if (!grab_super(old))
-- 
1.5.3.rc4

