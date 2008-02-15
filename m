Return-Path: <linux-kernel-owner+w=401wt.eu-S1760217AbYBOS3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760217AbYBOS3u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 13:29:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756202AbYBOS3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 13:29:42 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:1517 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221AbYBOS3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 13:29:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kEU1PrLpem4nK2kAwZxGdX8oYyNNneQIRR57HnN8pNZNOd9QmanLYde0DVU49zUwqmXJS8gPkha9ELV8/tibQXjQk28200LDuNnMhVJRCeWa9ewFiJU9D/rr7QE0MesNLZL1pzX9Uc2pnRqX6/9ZfMbRaBHIa6HF02w+WSa6BUg=
Subject: [PATCH] coda: add static to functions in dir.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jan Harkes <jaharkes@cs.cmu.edu>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 15 Feb 2008 10:29:39 -0800
Message-Id: <1203100179.15275.10.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

coda_unlink, coda_rmdir, coda_readdir can all be static, the forward
declarations already were.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/coda/dir.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/coda/dir.c b/fs/coda/dir.c
index f89ff08..3d2580e 100644
--- a/fs/coda/dir.c
+++ b/fs/coda/dir.c
@@ -345,7 +345,7 @@ static int coda_symlink(struct inode *dir_inode, struct dentry *de,
 }
 
 /* destruction routines: unlink, rmdir */
-int coda_unlink(struct inode *dir, struct dentry *de)
+static int coda_unlink(struct inode *dir, struct dentry *de)
 {
         int error;
 	const char *name = de->d_name.name;
@@ -365,7 +365,7 @@ int coda_unlink(struct inode *dir, struct dentry *de)
 	return 0;
 }
 
-int coda_rmdir(struct inode *dir, struct dentry *de)
+static int coda_rmdir(struct inode *dir, struct dentry *de)
 {
 	const char *name = de->d_name.name;
 	int len = de->d_name.len;
@@ -424,7 +424,7 @@ static int coda_rename(struct inode *old_dir, struct dentry *old_dentry,
 
 
 /* file operations for directories */
-int coda_readdir(struct file *coda_file, void *buf, filldir_t filldir)
+static int coda_readdir(struct file *coda_file, void *buf, filldir_t filldir)
 {
 	struct coda_file_info *cfi;
 	struct file *host_file;
-- 
1.5.4.1.1278.gc75be



