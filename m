Return-Path: <linux-kernel-owner+w=401wt.eu-S933192AbYBTQ2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933192AbYBTQ2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 11:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764393AbYBTQLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 11:11:55 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45592 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765524AbYBTQLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 11:11:38 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 30/37] NFS: Add some new I/O event counters for FS-Cache events
To: Trond.Myklebust@netapp.com, chuck.lever@oracle.com, casey@schaufler-ca.com
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Wed, 20 Feb 2008 16:08:39 +0000
Message-ID: <20080220160839.4715.90209.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080220160557.4715.66608.stgit@warthog.procyon.org.uk>
References: <20080220160557.4715.66608.stgit@warthog.procyon.org.uk>
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
 

