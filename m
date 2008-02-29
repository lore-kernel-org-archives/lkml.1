Return-Path: <linux-kernel-owner+w=401wt.eu-S1752611AbYB2BBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbYB2BBW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 20:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763422AbYB2Arc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 19:47:32 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932327AbYB2ArO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 19:47:14 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 22/37] NFS: Add FS-Cache option bit and debug bit [ver #34]
To: Trond.Myklebust@netapp.com, chuck.lever@oracle.com, casey@schaufler-ca.com
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Fri, 29 Feb 2008 00:45:31 +0000
Message-ID: <20080229004531.4142.88161.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080229004332.4142.51771.stgit@warthog.procyon.org.uk>
References: <20080229004332.4142.51771.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add FS-Cache option bit to nfs_server struct.  This is set to indicate local
on-disk caching is enabled for a particular superblock.

Also add debug bit for local caching operations.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/nfs_fs.h    |    1 +
 include/linux/nfs_fs_sb.h |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)


diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index a69ba80..14894c9 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -578,6 +578,7 @@ extern void * nfs_root_data(void);
 #define NFSDBG_CALLBACK		0x0100
 #define NFSDBG_CLIENT		0x0200
 #define NFSDBG_MOUNT		0x0400
+#define NFSDBG_FSCACHE		0x0800
 #define NFSDBG_ALL		0xFFFF
 
 #ifdef __KERNEL__
diff --git a/include/linux/nfs_fs_sb.h b/include/linux/nfs_fs_sb.h
index 3423c67..e7c4cdd 100644
--- a/include/linux/nfs_fs_sb.h
+++ b/include/linux/nfs_fs_sb.h
@@ -99,6 +99,8 @@ struct nfs_server {
 	unsigned int		acdirmin;
 	unsigned int		acdirmax;
 	unsigned int		namelen;
+	unsigned int		options;	/* extra options enabled by mount */
+#define NFS_OPTION_FSCACHE	0x00000001	/* - local caching enabled */
 
 	struct nfs_fsid		fsid;
 	__u64			maxfilesize;	/* maximum file size */

