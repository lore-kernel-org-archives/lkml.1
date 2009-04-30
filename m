Return-Path: <linux-kernel-owner+w=401wt.eu-S1756394AbZD3ML6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394AbZD3ML6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 08:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756508AbZD3MLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 08:11:24 -0400
Received: from bender.cm4all.net ([87.106.27.49]:55451 "EHLO bender.cm4all.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760497AbZD3MLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 08:11:21 -0400
From: Max Kellermann <mk@cm4all.com>
Subject: [splice PATCH 1/3] splice: use "long" for tee() return values
To: linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com, w@1wt.eu
Date: Thu, 30 Apr 2009 14:03:42 +0200
Message-ID: <20090430120342.5689.74090.stgit@rabbit.intern.cm-ag>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_tee() and other internal functions related to that have a "long"
return value.  Internally, some of them work with an "int ret".
Convert them to "long".

Signed-off-by: Max Kellermann <mk@cm4all.com>
---

 fs/splice.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 666953d..f07e304 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1589,12 +1589,13 @@ static int link_opipe_prep(struct pipe_inode_info *pipe, unsigned int flags)
 /*
  * Link contents of ipipe to opipe.
  */
-static int link_pipe(struct pipe_inode_info *ipipe,
-		     struct pipe_inode_info *opipe,
-		     size_t len, unsigned int flags)
+static long link_pipe(struct pipe_inode_info *ipipe,
+		      struct pipe_inode_info *opipe,
+		      size_t len, unsigned int flags)
 {
 	struct pipe_buffer *ibuf, *obuf;
-	int ret = 0, i = 0, nbuf;
+	long ret = 0;
+	int i = 0, nbuf;
 
 	/*
 	 * Potential ABBA deadlock, work around it by ordering lock
@@ -1679,7 +1680,7 @@ static long do_tee(struct file *in, struct file *out, size_t len,
 {
 	struct pipe_inode_info *ipipe = pipe_info(in->f_path.dentry->d_inode);
 	struct pipe_inode_info *opipe = pipe_info(out->f_path.dentry->d_inode);
-	int ret = -EINVAL;
+	long ret = -EINVAL;
 
 	/*
 	 * Duplicate the contents of ipipe to opipe without actually

