Return-Path: <linux-kernel-owner+w=401wt.eu-S1764880AbXIUXOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764880AbXIUXOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 19:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762220AbXIUXOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 19:14:00 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:60987 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754341AbXIUXN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 19:13:58 -0400
Subject: [PATCH] JBD/ext34 cleanups: convert to kzalloc
From: Mingming Cao <cmm@us.ibm.com>
Reply-To: cmm@us.ibm.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ext4 development <linux-ext4@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1190239431.4318.34.camel@localhost.localdomain>
References: <1189796027.3841.6.camel@localhost.localdomain>
	 <1190057391.3845.22.camel@localhost.localdomain>
	 <1190066466.31220.5.camel@dyn9047017100.beaverton.ibm.com>
	 <1190069851.6725.6.camel@localhost.localdomain>
	 <20070918090407.GA671@infradead.org>
	 <1190133347.3819.6.camel@localhost.localdomain>
	 <1190138690.6528.23.camel@norville.austin.ibm.com>
	 <1190163601.3819.15.camel@localhost.localdomain>
	 <20070918191920.a2130a3c.akpm@linux-foundation.org>
	 <1190229352.4318.12.camel@localhost.localdomain>
	 <20070919194813.GT32520@schatzie.adilger.int>
	 <1190239431.4318.34.camel@localhost.localdomain>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Fri, 21 Sep 2007 16:13:56 -0700
Message-Id: <1190416436.11349.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Convert kmalloc to kzalloc() and get rid of the memset().

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext3/xattr.c       |    3 +--
 fs/ext4/xattr.c       |    3 +--
 fs/jbd/journal.c      |    3 +--
 fs/jbd/transaction.c  |    2 +-
 fs/jbd2/journal.c     |    3 +--
 fs/jbd2/transaction.c |    2 +-
 6 files changed, 6 insertions(+), 10 deletions(-)

Index: linux-2.6.23-rc6/fs/jbd/journal.c
===================================================================
--- linux-2.6.23-rc6.orig/fs/jbd/journal.c	2007-09-21 09:08:02.000000000
-0700
+++ linux-2.6.23-rc6/fs/jbd/journal.c	2007-09-21 09:10:37.000000000
-0700
@@ -653,10 +653,9 @@ static journal_t * journal_init_common (
 	journal_t *journal;
 	int err;
 
-	journal = kmalloc(sizeof(*journal), GFP_KERNEL|__GFP_NOFAIL);
+	journal = kzalloc(sizeof(*journal), GFP_KERNEL|__GFP_NOFAIL);
 	if (!journal)
 		goto fail;
-	memset(journal, 0, sizeof(*journal));
 
 	init_waitqueue_head(&journal->j_wait_transaction_locked);
 	init_waitqueue_head(&journal->j_wait_logspace);
Index: linux-2.6.23-rc6/fs/jbd/transaction.c
===================================================================
--- linux-2.6.23-rc6.orig/fs/jbd/transaction.c	2007-09-21
09:13:11.000000000 -0700
+++ linux-2.6.23-rc6/fs/jbd/transaction.c	2007-09-21 09:13:24.000000000
-0700
@@ -96,7 +96,7 @@ static int start_this_handle(journal_t *
 
 alloc_transaction:
 	if (!journal->j_running_transaction) {
-		new_transaction = kmalloc(sizeof(*new_transaction),
+		new_transaction = kzalloc(sizeof(*new_transaction),
 						GFP_NOFS|__GFP_NOFAIL);
 		if (!new_transaction) {
 			ret = -ENOMEM;
Index: linux-2.6.23-rc6/fs/jbd2/journal.c
===================================================================
--- linux-2.6.23-rc6.orig/fs/jbd2/journal.c	2007-09-21
09:10:53.000000000 -0700
+++ linux-2.6.23-rc6/fs/jbd2/journal.c	2007-09-21 09:11:13.000000000
-0700
@@ -654,10 +654,9 @@ static journal_t * journal_init_common (
 	journal_t *journal;
 	int err;
 
-	journal = kmalloc(sizeof(*journal), GFP_KERNEL|__GFP_NOFAIL);
+	journal = kzalloc(sizeof(*journal), GFP_KERNEL|__GFP_NOFAIL);
 	if (!journal)
 		goto fail;
-	memset(journal, 0, sizeof(*journal));
 
 	init_waitqueue_head(&journal->j_wait_transaction_locked);
 	init_waitqueue_head(&journal->j_wait_logspace);
Index: linux-2.6.23-rc6/fs/jbd2/transaction.c
===================================================================
--- linux-2.6.23-rc6.orig/fs/jbd2/transaction.c	2007-09-21
09:12:46.000000000 -0700
+++ linux-2.6.23-rc6/fs/jbd2/transaction.c	2007-09-21 09:12:59.000000000
-0700
@@ -96,7 +96,7 @@ static int start_this_handle(journal_t *
 
 alloc_transaction:
 	if (!journal->j_running_transaction) {
-		new_transaction = kmalloc(sizeof(*new_transaction),
+		new_transaction = kzalloc(sizeof(*new_transaction),
 						GFP_NOFS|__GFP_NOFAIL);
 		if (!new_transaction) {
 			ret = -ENOMEM;
Index: linux-2.6.23-rc6/fs/ext3/xattr.c
===================================================================
--- linux-2.6.23-rc6.orig/fs/ext3/xattr.c	2007-09-21 10:22:24.000000000
-0700
+++ linux-2.6.23-rc6/fs/ext3/xattr.c	2007-09-21 10:24:19.000000000 -0700
@@ -741,12 +741,11 @@ ext3_xattr_block_set(handle_t *handle, s
 		}
 	} else {
 		/* Allocate a buffer where we construct the new block. */
-		s->base = kmalloc(sb->s_blocksize, GFP_KERNEL);
+		s->base = kzalloc(sb->s_blocksize, GFP_KERNEL);
 		/* assert(header == s->base) */
 		error = -ENOMEM;
 		if (s->base == NULL)
 			goto cleanup;
-		memset(s->base, 0, sb->s_blocksize);
 		header(s->base)->h_magic = cpu_to_le32(EXT3_XATTR_MAGIC);
 		header(s->base)->h_blocks = cpu_to_le32(1);
 		header(s->base)->h_refcount = cpu_to_le32(1);
Index: linux-2.6.23-rc6/fs/ext4/xattr.c
===================================================================
--- linux-2.6.23-rc6.orig/fs/ext4/xattr.c	2007-09-21 10:20:21.000000000
-0700
+++ linux-2.6.23-rc6/fs/ext4/xattr.c	2007-09-21 10:21:00.000000000 -0700
@@ -750,12 +750,11 @@ ext4_xattr_block_set(handle_t *handle, s
 		}
 	} else {
 		/* Allocate a buffer where we construct the new block. */
-		s->base = kmalloc(sb->s_blocksize, GFP_KERNEL);
+		s->base = kzalloc(sb->s_blocksize, GFP_KERNEL);
 		/* assert(header == s->base) */
 		error = -ENOMEM;
 		if (s->base == NULL)
 			goto cleanup;
-		memset(s->base, 0, sb->s_blocksize);
 		header(s->base)->h_magic = cpu_to_le32(EXT4_XATTR_MAGIC);
 		header(s->base)->h_blocks = cpu_to_le32(1);
 		header(s->base)->h_refcount = cpu_to_le32(1);


