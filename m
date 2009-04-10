Return-Path: <linux-kernel-owner+w=401wt.eu-S934303AbZDJHSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934303AbZDJHSx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 03:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936404AbZDJHQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 03:16:47 -0400
Received: from mfbichi12.ns.itscom.net ([219.110.2.190]:35916 "EHLO
	mfbichi12.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759196AbZDJHQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 03:16:44 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, linux-fsdevel@vger.kernel.org,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: [RFC Aufs2 #5 27/29] export splice functions
Date: Fri, 10 Apr 2009 16:02:41 +0900
Message-Id: <1239346963-30953-28-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.6.1.284.g5dc13
In-Reply-To: <1239346963-30953-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1239346963-30953-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

export splice functions to aufs module and others

Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
---
 fs/splice.c            |   10 +++++-----
 include/linux/splice.h |    6 ++++++
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index c18aa7e..8d81965 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -904,8 +904,8 @@ EXPORT_SYMBOL(generic_splice_sendpage);
 /*
  * Attempt to initiate a splice from pipe to file.
  */
-static long do_splice_from(struct pipe_inode_info *pipe, struct file *out,
-			   loff_t *ppos, size_t len, unsigned int flags)
+long do_splice_from(struct pipe_inode_info *pipe, struct file *out,
+		    loff_t *ppos, size_t len, unsigned int flags)
 {
 	int ret;
 
@@ -928,9 +928,9 @@ static long do_splice_from(struct pipe_inode_info *pipe, struct file *out,
 /*
  * Attempt to initiate a splice from a file to a pipe.
  */
-static long do_splice_to(struct file *in, loff_t *ppos,
-			 struct pipe_inode_info *pipe, size_t len,
-			 unsigned int flags)
+long do_splice_to(struct file *in, loff_t *ppos,
+		  struct pipe_inode_info *pipe, size_t len,
+		  unsigned int flags)
 {
 	int ret;
 
diff --git a/include/linux/splice.h b/include/linux/splice.h
index 528dcb9..5123bc6 100644
--- a/include/linux/splice.h
+++ b/include/linux/splice.h
@@ -71,4 +71,10 @@ extern ssize_t splice_to_pipe(struct pipe_inode_info *,
 extern ssize_t splice_direct_to_actor(struct file *, struct splice_desc *,
 				      splice_direct_actor *);
 
+extern long do_splice_from(struct pipe_inode_info *pipe, struct file *out,
+			   loff_t *ppos, size_t len, unsigned int flags);
+extern long do_splice_to(struct file *in, loff_t *ppos,
+			 struct pipe_inode_info *pipe, size_t len,
+			 unsigned int flags);
+
 #endif
-- 
1.6.1.284.g5dc13

