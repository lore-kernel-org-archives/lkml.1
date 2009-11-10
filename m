Return-Path: <linux-kernel-owner+w=401wt.eu-S1755098AbZKJJQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098AbZKJJQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 04:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754579AbZKJJQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 04:16:25 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:39959 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754430AbZKJJQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 04:16:23 -0500
From: Tao Ma <tao.ma@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: sunil.mushran@oracle.com, Tao Ma <tao.ma@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH] JBD/JBD2: free j_wbuf if journal init fails.
Date: Tue, 10 Nov 2009 17:13:22 +0800
Message-Id: <1257844402-7828-1-git-send-email-tao.ma@oracle.com>
X-Mailer: git-send-email 1.5.4.GIT
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4AF92F43.0103:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If journal init fails, we need to free j_wbuf.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/jbd/journal.c  |    2 ++
 fs/jbd2/journal.c |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index bd3c073..49d5cd6 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -756,6 +756,7 @@ journal_t * journal_init_dev(struct block_device *bdev,
 
 	return journal;
 out_err:
+	kfree(journal->j_wbuf);
 	kfree(journal);
 	return NULL;
 }
@@ -820,6 +821,7 @@ journal_t * journal_init_inode (struct inode *inode)
 
 	return journal;
 out_err:
+	kfree(journal->j_wbuf);
 	kfree(journal);
 	return NULL;
 }
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index b0ab521..fed8538 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -913,6 +913,7 @@ journal_t * jbd2_journal_init_dev(struct block_device *bdev,
 
 	return journal;
 out_err:
+	kfree(journal->j_wbuf);
 	jbd2_stats_proc_exit(journal);
 	kfree(journal);
 	return NULL;
@@ -986,6 +987,7 @@ journal_t * jbd2_journal_init_inode (struct inode *inode)
 
 	return journal;
 out_err:
+	kfree(journal->j_wbuf);
 	jbd2_stats_proc_exit(journal);
 	kfree(journal);
 	return NULL;
-- 
1.5.4.4

