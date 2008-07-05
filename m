Return-Path: <linux-kernel-owner+w=401wt.eu-S1760485AbYGERyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760485AbYGERyW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 13:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756564AbYGERim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 13:38:42 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:33109 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755963AbYGERge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 13:36:34 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: Shen Feng <shen@cn.fujitsu.com>, Mingming Cao <cmm@us.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 09/52] ext4: remove double definitions of xattr macros
Date: Sat,  5 Jul 2008 13:35:35 -0400
Message-Id: <1215279378-30504-10-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.6.rc3.1.g36b7.dirty
In-Reply-To: <1215279378-30504-9-git-send-email-tytso@mit.edu>
References: <1215279378-30504-1-git-send-email-tytso@mit.edu>
 <1215279378-30504-2-git-send-email-tytso@mit.edu>
 <1215279378-30504-3-git-send-email-tytso@mit.edu>
 <1215279378-30504-4-git-send-email-tytso@mit.edu>
 <1215279378-30504-5-git-send-email-tytso@mit.edu>
 <1215279378-30504-6-git-send-email-tytso@mit.edu>
 <1215279378-30504-7-git-send-email-tytso@mit.edu>
 <1215279378-30504-8-git-send-email-tytso@mit.edu>
 <1215279378-30504-9-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shen Feng <shen@cn.fujitsu.com>

remove the definitions of macros XATTR_TRUSTED_PREFIX and XATTR_USER_PREFIX
since they are defined in linux/xattr.h

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/xattr_trusted.c |    4 +---
 fs/ext4/xattr_user.c    |    4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/xattr_trusted.c b/fs/ext4/xattr_trusted.c
index fff3338..ac1a52c 100644
--- a/fs/ext4/xattr_trusted.c
+++ b/fs/ext4/xattr_trusted.c
@@ -13,13 +13,11 @@
 #include "ext4.h"
 #include "xattr.h"
 
-#define XATTR_TRUSTED_PREFIX "trusted."
-
 static size_t
 ext4_xattr_trusted_list(struct inode *inode, char *list, size_t list_size,
 			const char *name, size_t name_len)
 {
-	const size_t prefix_len = sizeof(XATTR_TRUSTED_PREFIX)-1;
+	const size_t prefix_len = XATTR_TRUSTED_PREFIX_LEN;
 	const size_t total_len = prefix_len + name_len + 1;
 
 	if (!capable(CAP_SYS_ADMIN))
diff --git a/fs/ext4/xattr_user.c b/fs/ext4/xattr_user.c
index 67be723..d91aa61 100644
--- a/fs/ext4/xattr_user.c
+++ b/fs/ext4/xattr_user.c
@@ -12,13 +12,11 @@
 #include "ext4.h"
 #include "xattr.h"
 
-#define XATTR_USER_PREFIX "user."
-
 static size_t
 ext4_xattr_user_list(struct inode *inode, char *list, size_t list_size,
 		     const char *name, size_t name_len)
 {
-	const size_t prefix_len = sizeof(XATTR_USER_PREFIX)-1;
+	const size_t prefix_len = XATTR_USER_PREFIX_LEN;
 	const size_t total_len = prefix_len + name_len + 1;
 
 	if (!test_opt(inode->i_sb, XATTR_USER))
-- 
1.5.6.rc3.1.g36b7.dirty

