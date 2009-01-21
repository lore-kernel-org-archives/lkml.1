Return-Path: <linux-kernel-owner+w=401wt.eu-S1764245AbZAULVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764245AbZAULVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 06:21:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756947AbZAULVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 06:21:01 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34063 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756151AbZAULU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 06:20:59 -0500
Date: Wed, 21 Jan 2009 12:20:56 +0100
From: Jiri Pirko <jpirko@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Subject: [PATCH] fs/pipe.c: do free read pipe work in free_read_pipe()
Message-ID: <20090121112055.GC3780@psychotron.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch just introduces function free_read_pipe() which do the free read pipe
work. This approach is similar to free_write_pipe().


Signed-off-by: Jiri Pirko <jpirko@redhat.com>
---
 fs/pipe.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index 3a48ba5..44cdc45 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -989,6 +989,12 @@ struct file *create_read_pipe(struct file *wrf, int flags)
 	return f;
 }
 
+void free_read_pipe(struct file *f)
+{
+	path_put(&f->f_path);
+	put_filp(f);
+}
+
 int do_pipe_flags(int *fd, int flags)
 {
 	struct file *fw, *fr;
@@ -1027,8 +1033,7 @@ int do_pipe_flags(int *fd, int flags)
  err_fdr:
 	put_unused_fd(fdr);
  err_read_pipe:
-	path_put(&fr->f_path);
-	put_filp(fr);
+	free_read_pipe(fr);
  err_write_pipe:
 	free_write_pipe(fw);
 	return error;
-- 
1.6.0.6

