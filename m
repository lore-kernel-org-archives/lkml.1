Return-Path: <linux-kernel-owner+w=401wt.eu-S1754155AbXLFPbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbXLFPbz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 10:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524AbXLFPbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 10:31:47 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:50010 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbXLFPbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 10:31:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=I5OSSH9Dq623Ncui93RoV9X7L8RiuD9weAoufH0gp1pfby6Q/UuQLOOr2B4NffiImnnBYkAWu62PIJ5sIOlMMXcjjc/0axoP3TousXIkIRqDSaggngipEyJWdvNwW6an2/iCcIkcYGpFE4ib1GR7ALXofSq2lpbQ1ybyPyuy7cg=
From: Denis Cheng <crquan@gmail.com>
To: reiserfs-dev@namesys.com, reiserfs-devel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 12/20] fs/reiserfs/xattr.c: use LIST_HEAD instead of LIST_HEAD_INIT
Date: Thu,  6 Dec 2007 23:31:16 +0800
Message-Id: <1196955076-5582-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

single list_head variable initialized with LIST_HEAD_INIT could almost
always can be replaced with LIST_HEAD declaration, this shrinks the code
and looks better.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 fs/reiserfs/xattr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/reiserfs/xattr.c b/fs/reiserfs/xattr.c
index 1597f6b..a5bd23c 100644
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -1084,7 +1084,7 @@ ssize_t reiserfs_listxattr(struct dentry * dentry, char *buffer, size_t size)
 }
 
 /* This is the implementation for the xattr plugin infrastructure */
-static struct list_head xattr_handlers = LIST_HEAD_INIT(xattr_handlers);
+static LIST_HEAD(xattr_handlers);
 static DEFINE_RWLOCK(handler_lock);
 
 static struct reiserfs_xattr_handler *find_xattr_handler_prefix(const char
-- 
1.5.3.4

