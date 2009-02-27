Return-Path: <linux-kernel-owner+w=401wt.eu-S1760007AbZB0UfC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760007AbZB0UfC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 15:35:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759674AbZB0Uee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 15:34:34 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:34099 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759635AbZB0Ued (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 15:34:33 -0500
Subject: [RFC][PATCH 1/8] kill '_data' in cr_hdr_fd_data name
To: Ingo Molnar <mingo@elte.hu>
Cc: containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Alexey Dobriyan <adobriyan@gmail.com>, hch@infradead.org,
       Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Fri, 27 Feb 2009 12:34:25 -0800
Message-Id: <20090227203425.F3B51176@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The 'cr_hdr_fd_data' name is too long for me.  Adding data
at the end doesn't clarify anything in its use which makes
it a waste of space.  Kill it.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/checkpoint/ckpt_file.c         |    2 +-
 linux-2.6.git-dave/checkpoint/rstr_file.c         |    2 +-
 linux-2.6.git-dave/include/linux/checkpoint_hdr.h |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN checkpoint/ckpt_file.c~no_data0 checkpoint/ckpt_file.c
--- linux-2.6.git/checkpoint/ckpt_file.c~no_data0	2009-02-27 12:07:37.000000000 -0800
+++ linux-2.6.git-dave/checkpoint/ckpt_file.c	2009-02-27 12:07:37.000000000 -0800
@@ -76,7 +76,7 @@ int cr_scan_fds(struct files_struct *fil
 static int cr_write_fd_data(struct cr_ctx *ctx, struct file *file, int parent)
 {
 	struct cr_hdr h;
-	struct cr_hdr_fd_data *hh = cr_hbuf_get(ctx, sizeof(*hh));
+	struct cr_hdr_fd *hh = cr_hbuf_get(ctx, sizeof(*hh));
 	struct dentry *dent = file->f_dentry;
 	struct inode *inode = dent->d_inode;
 	enum fd_type fd_type;
diff -puN checkpoint/rstr_file.c~no_data0 checkpoint/rstr_file.c
--- linux-2.6.git/checkpoint/rstr_file.c~no_data0	2009-02-27 12:07:37.000000000 -0800
+++ linux-2.6.git-dave/checkpoint/rstr_file.c	2009-02-27 12:07:37.000000000 -0800
@@ -71,7 +71,7 @@ static int cr_attach_get_file(struct fil
 static int
 cr_read_fd_data(struct cr_ctx *ctx, struct files_struct *files, int rparent)
 {
-	struct cr_hdr_fd_data *hh = cr_hbuf_get(ctx, sizeof(*hh));
+	struct cr_hdr_fd *hh = cr_hbuf_get(ctx, sizeof(*hh));
 	struct file *file;
 	int parent, ret;
 	int fd = 0;	/* pacify gcc warning */
diff -puN include/linux/checkpoint_hdr.h~no_data0 include/linux/checkpoint_hdr.h
--- linux-2.6.git/include/linux/checkpoint_hdr.h~no_data0	2009-02-27 12:07:37.000000000 -0800
+++ linux-2.6.git-dave/include/linux/checkpoint_hdr.h	2009-02-27 12:07:37.000000000 -0800
@@ -137,7 +137,7 @@ enum  fd_type {
 	CR_FD_DIR,
 };
 
-struct cr_hdr_fd_data {
+struct cr_hdr_fd {
 	__u16 fd_type;
 	__u16 f_mode;
 	__u32 f_flags;
_
