Return-Path: <linux-kernel-owner+w=401wt.eu-S932562AbXGaU3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562AbXGaU3O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 16:29:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764391AbXGaU0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 16:26:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763825AbXGaUZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 16:25:51 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 08/14] CacheFiles: Export things for CacheFiles
To: torvalds@osdl.org, akpm@osdl.org, steved@redhat.com,
       trond.myklebust@fys.uio.no
Cc: linux-fsdevel@vger.kernel.org, linux-cachefs@redhat.com,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org
Date: Tue, 31 Jul 2007 21:25:36 +0100
Message-ID: <20070731202536.6412.55024.stgit@warthog.cambridge.redhat.com>
In-Reply-To: <20070731202454.6412.88646.stgit@warthog.cambridge.redhat.com>
References: <20070731202454.6412.88646.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Export a number of functions for CacheFiles's use.

Signed-Off-By: David Howells <dhowells@redhat.com>
---

 fs/file_table.c  |    1 +
 fs/super.c       |    2 ++
 kernel/auditsc.c |    2 ++
 3 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index d17fd69..a438ecc 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -234,6 +234,7 @@ struct file fastcall *fget_light(unsigned int fd, int *fput_needed)
 	return file;
 }
 
+EXPORT_SYMBOL_GPL(fget_light);
 
 void put_filp(struct file *file)
 {
diff --git a/fs/super.c b/fs/super.c
index fc8ebed..c0d99dd 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -270,6 +270,8 @@ int fsync_super(struct super_block *sb)
 	return sync_blockdev(sb->s_bdev);
 }
 
+EXPORT_SYMBOL_GPL(fsync_super);
+
 /**
  *	generic_shutdown_super	-	common helper for ->kill_sb()
  *	@sb: superblock to kill
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index a777d37..1c068ec 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1526,6 +1526,8 @@ add_names:
 	}
 }
 
+EXPORT_SYMBOL_GPL(__audit_inode_child);
+
 /**
  * auditsc_get_stamp - get local copies of audit_context values
  * @ctx: audit_context for the task

