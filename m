Return-Path: <linux-kernel-owner+w=401wt.eu-S1759607AbYGERto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759607AbYGERto (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 13:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756650AbYGERiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 13:38:15 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:33094 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755967AbYGERgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 13:36:32 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: Shen Feng <shen@cn.fujitsu.com>, Mingming Cao <cmm@us.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 18/52] ext4: return error when calling ext4_ext_split failed
Date: Sat,  5 Jul 2008 13:35:44 -0400
Message-Id: <1215279378-30504-19-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.6.rc3.1.g36b7.dirty
In-Reply-To: <1215279378-30504-18-git-send-email-tytso@mit.edu>
References: <1215279378-30504-1-git-send-email-tytso@mit.edu>
 <1215279378-30504-2-git-send-email-tytso@mit.edu>
 <1215279378-30504-3-git-send-email-tytso@mit.edu>
 <1215279378-30504-4-git-send-email-tytso@mit.edu>
 <1215279378-30504-5-git-send-email-tytso@mit.edu>
 <1215279378-30504-6-git-send-email-tytso@mit.edu>
 <1215279378-30504-7-git-send-email-tytso@mit.edu>
 <1215279378-30504-8-git-send-email-tytso@mit.edu>
 <1215279378-30504-9-git-send-email-tytso@mit.edu>
 <1215279378-30504-10-git-send-email-tytso@mit.edu>
 <1215279378-30504-11-git-send-email-tytso@mit.edu>
 <1215279378-30504-12-git-send-email-tytso@mit.edu>
 <1215279378-30504-13-git-send-email-tytso@mit.edu>
 <1215279378-30504-14-git-send-email-tytso@mit.edu>
 <1215279378-30504-15-git-send-email-tytso@mit.edu>
 <1215279378-30504-16-git-send-email-tytso@mit.edu>
 <1215279378-30504-17-git-send-email-tytso@mit.edu>
 <1215279378-30504-18-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shen Feng <shen@cn.fujitsu.com>

ext4_ext_create_new_leaf must return error when its
calling to ext4_ext_split failed.

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/extents.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index f7a746b..bc17ed7 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -981,6 +981,8 @@ repeat:
 		/* if we found index with free entry, then use that
 		 * entry: create all needed subtree and add new leaf */
 		err = ext4_ext_split(handle, inode, path, newext, i);
+		if (err)
+			goto out;
 
 		/* refill path */
 		ext4_ext_drop_refs(path);
-- 
1.5.6.rc3.1.g36b7.dirty

