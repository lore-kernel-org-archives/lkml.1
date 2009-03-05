Return-Path: <linux-kernel-owner+w=401wt.eu-S1756279AbZCEQjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279AbZCEQjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 11:39:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754658AbZCEQjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 11:39:08 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:58273 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230AbZCEQjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 11:39:06 -0500
Subject: [RFC][PATCH 01/11] kill '_data' in cr_hdr_fd_data name
To: Ingo Molnar <mingo@elte.hu>
Cc: containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Thu, 05 Mar 2009 08:38:58 -0800
References: <20090305163857.0C18F3FD@kernel>
In-Reply-To: <20090305163857.0C18F3FD@kernel>
Message-Id: <20090305163858.8414173E@kernel>
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

diff -puN checkpoint/ckpt_file.c~f49811bdfd2cde1dfa766f38cc017a5cdd8be75e checkpoint/ckpt_file.c
--- linux-2.6.git/checkpoint/ckpt_file.c~f49811bdfd2cde1dfa766f38cc017a5cdd8be75e	2009-03-05 08:36:59.000000000 -0800
+++ linux-2.6.git-dave/checkpoint/ckpt_file.c	2009-03-05 08:36:59.000000000 -0800
@@ -76,7 +76,7 @@ int cr_scan_fds(struct files_struct *fil
 static int cr_write_fd_data(struct cr_ctx *ctx, struct file *file, int parent)
 {
 	struct cr_hdr h;
-	struct cr_hdr_fd_data *hh = cr_hbuf_get(ctx, sizeof(*hh));
+	struct cr_hdr_fd *hh = cr_hbuf_get(ctx, sizeof(*hh));
 	struct dentry *dent = file->f_dentry;
 	struct inode *inode = dent->d_inode;
 	enum fd_type fd_type;
diff -puN checkpoint/rstr_file.c~f49811bdfd2cde1dfa766f38cc017a5cdd8be75e checkpoint/rstr_file.c
--- linux-2.6.git/checkpoint/rstr_file.c~f49811bdfd2cde1dfa766f38cc017a5cdd8be75e	2009-03-05 08:36:59.000000000 -0800
+++ linux-2.6.git-dave/checkpoint/rstr_file.c	2009-03-05 08:36:59.000000000 -0800
@@ -71,7 +71,7 @@ static int cr_attach_get_file(struct fil
 static int
 cr_read_fd_data(struct cr_ctx *ctx, struct files_struct *files, int rparent)
 {
-	struct cr_hdr_fd_data *hh = cr_hbuf_get(ctx, sizeof(*hh));
+	struct cr_hdr_fd *hh = cr_hbuf_get(ctx, sizeof(*hh));
 	struct file *file;
 	int parent, ret;
 	int fd = 0;	/* pacify gcc warning */
diff -puN include/linux/checkpoint_hdr.h~f49811bdfd2cde1dfa766f38cc017a5cdd8be75e include/linux/checkpoint_hdr.h
--- linux-2.6.git/include/linux/checkpoint_hdr.h~f49811bdfd2cde1dfa766f38cc017a5cdd8be75e	2009-03-05 08:36:59.000000000 -0800
+++ linux-2.6.git-dave/include/linux/checkpoint_hdr.h	2009-03-05 08:36:59.000000000 -0800
@@ -137,7 +137,7 @@ enum  fd_type {
 	CR_FD_DIR,
 };
 
-struct cr_hdr_fd_data {
+struct cr_hdr_fd {
 	__u16 fd_type;
 	__u16 f_mode;
 	__u32 f_flags;
_
