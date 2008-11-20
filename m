Return-Path: <linux-kernel-owner+w=401wt.eu-S1756910AbYKTOtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910AbYKTOtg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 09:49:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755707AbYKTOnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:43:17 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41059 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756076AbYKTOnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:43:12 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 17/45] FS-Cache: Bit waiting helpers [ver #41]
To: trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Date: Thu, 20 Nov 2008 14:43:07 +0000
Message-ID: <20081120144307.10667.19967.stgit@warthog.procyon.org.uk>
In-Reply-To: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
References: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add helpers for use with wait_on_bit().

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/fscache/fsc-internal.h |    3 +++
 fs/fscache/fsc-main.c     |   20 ++++++++++++++++++++
 2 files changed, 23 insertions(+), 0 deletions(-)


diff --git a/fs/fscache/fsc-internal.h b/fs/fscache/fsc-internal.h
index 8f1beb5..5418101 100644
--- a/fs/fscache/fsc-internal.h
+++ b/fs/fscache/fsc-internal.h
@@ -58,6 +58,9 @@ extern unsigned fscache_defer_create;
 extern unsigned fscache_debug;
 extern struct kobject *fscache_root;
 
+extern int fscache_wait_bit(void *);
+extern int fscache_wait_bit_interruptible(void *);
+
 /*
  * fsc-stats.c
  */
diff --git a/fs/fscache/fsc-main.c b/fs/fscache/fsc-main.c
index 5ecbaa7..714c0ef 100644
--- a/fs/fscache/fsc-main.c
+++ b/fs/fscache/fsc-main.c
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

