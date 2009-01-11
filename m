Return-Path: <linux-kernel-owner+w=401wt.eu-S1753912AbZAKTOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912AbZAKTOZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 14:14:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbZAKTOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 14:14:04 -0500
Received: from ti-out-0910.google.com ([209.85.142.191]:62795 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbZAKTOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 14:14:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:cc:bcc:subject:date:user-agent;
        b=xC7M6NvvIaiHmEbY4pFhSddiAnfqla8REKVHhGU2lxUh108PO4n1Y1cbr0RMo3JBQB
         HVch6lA9zL6yK0G3VZ/IFkEVqwOK5IWWjaCzWKEi6z+Af+FWGN++5s3whsrVUTAMSCvN
         37/BsOpZ4CcQXEET734z1iIYA2Lj7UqKDO/bg=
Message-ID: <496a44f7.05636e0a.69b8.6278@mx.google.com>
From: Qinghuang Feng <qhfeng.kernel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: bfields@fieldses.org, neilb@suse.de, linux-nfs@vger.kernel.org
Subject: [PATCH] NFSD: cleanup for nfs3proc.c 
Date: Mon, 12 Jan 2009 03:13:53 +0800
User-Agent: sniper-patch-carrier/1.06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MSDOS_SUPER_MAGIC is defined in <linux/magic.h>,
so use MSDOS_SUPER_MAGIC directly.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index 9dbd2eb..579ce8c 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -18,6 +18,7 @@
 #include <linux/unistd.h>
 #include <linux/slab.h>
 #include <linux/major.h>
+#include <linux/magic.h>
 
 #include <linux/sunrpc/svc.h>
 #include <linux/nfsd/nfsd.h>
@@ -569,7 +570,7 @@ nfsd3_proc_fsinfo(struct svc_rqst * rqstp, struct nfsd_fhandle    *argp,
 		struct super_block *sb = argp->fh.fh_dentry->d_inode->i_sb;
 
 		/* Note that we don't care for remote fs's here */
-		if (sb->s_magic == 0x4d44 /* MSDOS_SUPER_MAGIC */) {
+		if (sb->s_magic == MSDOS_SUPER_MAGIC) {
 			resp->f_properties = NFS3_FSF_BILLYBOY;
 		}
 		resp->f_maxfilesize = sb->s_maxbytes;
@@ -610,7 +611,7 @@ nfsd3_proc_pathconf(struct svc_rqst * rqstp, struct nfsd_fhandle      *argp,
 			resp->p_link_max = EXT2_LINK_MAX;
 			resp->p_name_max = EXT2_NAME_LEN;
 			break;
-		case 0x4d44:	/* MSDOS_SUPER_MAGIC */
+		case MSDOS_SUPER_MAGIC:
 			resp->p_case_insensitive = 1;
 			resp->p_case_preserving  = 0;
 			break;

