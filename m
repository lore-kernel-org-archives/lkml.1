Return-Path: <linux-kernel-owner+w=401wt.eu-S934693AbZDAXUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934693AbZDAXUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 19:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934174AbZDAXGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 19:06:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34679 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933883AbZDAXFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 19:05:50 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 28/43] NFS: Add FS-Cache option bit and debug bit [ver #46]
To: viro@ZenIV.linux.org.uk
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Date: Thu, 02 Apr 2009 00:05:46 +0100
Message-ID: <20090401230545.28177.60569.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090401230321.28177.12010.stgit@warthog.procyon.org.uk>
References: <20090401230321.28177.12010.stgit@warthog.procyon.org.uk>
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

