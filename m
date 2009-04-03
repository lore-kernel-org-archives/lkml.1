Return-Path: <linux-kernel-owner+w=401wt.eu-S1765556AbZDCQDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765556AbZDCQDi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 12:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934621AbZDCP4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:56:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56562 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934611AbZDCP4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:56:05 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 16/41] FS-Cache: Bit waiting helpers [ver #48]
To: linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-fsdevel@vger.kernel.org
Date: Fri, 03 Apr 2009 16:55:58 +0100
Message-ID: <20090403155558.28714.62750.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
References: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add helpers for use with wait_on_bit().

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Steve Dickson <steved@redhat.com>
Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Tested-by: Daire Byrne <Daire.Byrne@framestore.com>
---

 fs/fscache/internal.h |    3 +++
 fs/fscache/main.c     |   20 ++++++++++++++++++++
 2 files changed, 23 insertions(+), 0 deletions(-)


diff --git a/fs/fscache/internal.h b/fs/fscache/internal.h
index 4c6ba56..1638994 100644
--- a/fs/fscache/internal.h
+++ b/fs/fscache/internal.h
@@ -82,6 +82,9 @@ extern unsigned fscache_defer_create;
 extern unsigned fscache_debug;
 extern struct kobject *fscache_root;
 
+extern int fscache_wait_bit(void *);
+extern int fscache_wait_bit_interruptible(void *);
+
 /*
  * fsc-proc.c
  */
diff --git a/fs/fscache/main.c b/fs/fscache/main.c
index 48b79d2..4de41b5 100644
--- a/fs/fscache/main.c
+++ b/fs/fscache/main.c
@@ -102,3 +102,23 @@ static void __exit fscache_exit(void)
 }
 
 module_exit(fscache_exit);
+
+/*
+ * wait_on_bit() sleep function for uninterruptible waiting
+ */
+int fscache_wait_bit(void *flags)
+{
+	schedule();
+	return 0;
+}
+EXPORT_SYMBOL(fscache_wait_bit);
+
+/*
+ * wait_on_bit() sleep function for interruptible waiting
+ */
+int fscache_wait_bit_interruptible(void *flags)
+{
+	schedule();
+	return signal_pending(current);
+}
+EXPORT_SYMBOL(fscache_wait_bit_interruptible);

