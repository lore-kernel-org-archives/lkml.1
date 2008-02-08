Return-Path: <linux-kernel-owner+w=401wt.eu-S1756925AbYBHRNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925AbYBHRNl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 12:13:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761579AbYBHQ4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 11:56:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52904 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932685AbYBHQzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 11:55:24 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 30/37] NFS: Add some new I/O event counters for FS-Cache events
To: Trond.Myklebust@netapp.com, chuck.lever@oracle.com
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Fri, 08 Feb 2008 16:54:38 +0000
Message-ID: <20080208165437.15902.21602.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080208165156.15902.62457.stgit@warthog.procyon.org.uk>
References: <20080208165156.15902.62457.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add some new NFS I/O event counters for FS-Cache events.  They have to be
added as byte counters because I may need to be able to increase the numbers
by more than 1 at a time.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/nfs/iostat.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)


diff --git a/fs/nfs/iostat.h b/fs/nfs/iostat.h
index 6350ecb..0e3b170 100644
--- a/fs/nfs/iostat.h
+++ b/fs/nfs/iostat.h
@@ -60,6 +60,13 @@ enum nfs_stat_bytecounters {
 	NFSIOS_SERVERWRITTENBYTES,
 	NFSIOS_READPAGES,
 	NFSIOS_WRITEPAGES,
+#ifdef CONFIG_NFS_FSCACHE
+	NFSIOS_FSCACHE_READ_OK,
+	NFSIOS_FSCACHE_READ_FAIL,
+	NFSIOS_FSCACHE_WRITE_OK,
+	NFSIOS_FSCACHE_WRITE_FAIL,
+	NFSIOS_FSCACHE_UNCACHE,
+#endif
 	__NFSIOS_BYTESMAX,
 };
 

