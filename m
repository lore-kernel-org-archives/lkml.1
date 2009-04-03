Return-Path: <linux-kernel-owner+w=401wt.eu-S936018AbZDCQIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936018AbZDCQIX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 12:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934935AbZDCP5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:57:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56627 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934944AbZDCP4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:56:55 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 26/41] NFS: Add FS-Cache option bit and debug bit [ver #48]
To: linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-fsdevel@vger.kernel.org
Date: Fri, 03 Apr 2009 16:56:50 +0100
Message-ID: <20090403155650.28714.58686.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
References: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
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
Acked-by: Steve Dickson <steved@redhat.com>
Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Tested-by: Daire Byrne <Daire.Byrne@framestore.com>
---

 include/linux/nfs_fs.h    |    1 +
 include/linux/nfs_fs_sb.h |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)


diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index bde2557..fd3e7f9 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -583,6 +583,7 @@ extern void * nfs_root_data(void);
 #define NFSDBG_CALLBACK		0x0100
 #define NFSDBG_CLIENT		0x0200
 #define NFSDBG_MOUNT		0x0400
+#define NFSDBG_FSCACHE		0x0800
 #define NFSDBG_ALL		0xFFFF
 
 #ifdef __KERNEL__
diff --git a/include/linux/nfs_fs_sb.h b/include/linux/nfs_fs_sb.h
index 29b1e40..a749f85 100644
--- a/include/linux/nfs_fs_sb.h
+++ b/include/linux/nfs_fs_sb.h
@@ -96,6 +96,8 @@ struct nfs_server {
 	unsigned int		acdirmin;
 	unsigned int		acdirmax;
 	unsigned int		namelen;
+	unsigned int		options;	/* extra options enabled by mount */
+#define NFS_OPTION_FSCACHE	0x00000001	/* - local caching enabled */
 
 	struct nfs_fsid		fsid;
 	__u64			maxfilesize;	/* maximum file size */

