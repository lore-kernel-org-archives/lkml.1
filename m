Return-Path: <linux-kernel-owner+w=401wt.eu-S1758196AbYKTOyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758196AbYKTOyx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 09:54:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756225AbYKTOok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:44:40 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41133 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756253AbYKTOoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:44:20 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 30/45] NFS: Add FS-Cache option bit and debug bit [ver #41]
To: trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Date: Thu, 20 Nov 2008 14:44:14 +0000
Message-ID: <20081120144414.10667.77048.stgit@warthog.procyon.org.uk>
In-Reply-To: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
References: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
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
---

 include/linux/nfs_fs.h    |    1 +
 include/linux/nfs_fs_sb.h |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)


diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index 4eaa834..9400333 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -586,6 +586,7 @@ extern void * nfs_root_data(void);
 #define NFSDBG_CALLBACK		0x0100
 #define NFSDBG_CLIENT		0x0200
 #define NFSDBG_MOUNT		0x0400
+#define NFSDBG_FSCACHE		0x0800
 #define NFSDBG_ALL		0xFFFF
 
 #ifdef __KERNEL__
diff --git a/include/linux/nfs_fs_sb.h b/include/linux/nfs_fs_sb.h
index 4e477ae..6fd68d5 100644
--- a/include/linux/nfs_fs_sb.h
+++ b/include/linux/nfs_fs_sb.h
@@ -102,6 +102,8 @@ struct nfs_server {
 	unsigned int		acdirmin;
 	unsigned int		acdirmax;
 	unsigned int		namelen;
+	unsigned int		options;	/* extra options enabled by mount */
+#define NFS_OPTION_FSCACHE	0x00000001	/* - local caching enabled */
 
 	struct nfs_fsid		fsid;
 	__u64			maxfilesize;	/* maximum file size */

