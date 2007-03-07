Return-Path: <linux-kernel-owner+w=401wt.eu-S965536AbXCGOYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965536AbXCGOYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 09:24:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965537AbXCGOYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 09:24:55 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965563AbXCGOYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 09:24:54 -0500
Subject: [GFS2] NFS filehandle check [3/12]
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com
Cc: "S. Wendy Cheng" <wcheng@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1173277501.11001.752.camel@quoit.chygwyn.com>
References: <1173277501.11001.752.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Wed, 07 Mar 2007 14:27:59 +0000
Message-Id: <1173277679.11001.758.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From a7d2b2bdc9a0b55d5b08e15756c7e65c48c4bca5 Mon Sep 17 00:00:00 2001
From: Wendy Cheng <wcheng@redhat.com>
Date: Fri, 23 Feb 2007 00:21:17 -0500
Subject: [PATCH] [GFS2] NFS filehandle check

File handle checking error found in '07 NFS connectathon. The fh_type
and fh_len are not necessarily identical. Some of the client machines
could fail mount with stale filehandle without this patch.

Signed-off-by: S. Wendy Cheng <wcheng@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_export.c b/fs/gfs2/ops_export.c
index 1de05b6..aad9183 100644
--- a/fs/gfs2/ops_export.c
+++ b/fs/gfs2/ops_export.c
@@ -38,14 +38,11 @@ static struct dentry *gfs2_decode_fh(struct super_block *sb,
 	struct gfs2_fh_obj fh_obj;
 	struct gfs2_inum_host *this, parent;
 
-	if (fh_type != fh_len)
-		return NULL;
-
 	this 		= &fh_obj.this;
 	fh_obj.imode 	= DT_UNKNOWN;
 	memset(&parent, 0, sizeof(struct gfs2_inum));
 
-	switch (fh_type) {
+	switch (fh_len) {
 	case GFS2_LARGE_FH_SIZE:
 		parent.no_formal_ino = ((u64)be32_to_cpu(fh[4])) << 32;
 		parent.no_formal_ino |= be32_to_cpu(fh[5]);
-- 
1.4.4.2



