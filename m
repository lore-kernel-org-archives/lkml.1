Return-Path: <linux-kernel-owner+w=401wt.eu-S933559AbYETSKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933559AbYETSKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 14:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765339AbYETSGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 14:06:41 -0400
Received: from el-out-1112.google.com ([209.85.162.176]:3485 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760028AbYETSGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 14:06:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=eF/05/cv45xUdGKeG2x/uLm+v2Q+1kHNsypgqtHsYAX2s8c4MNN2+euRYbEJPNih0x6MxPjZutVnuU3mtc8k1GBDSrsHfzgnfk4hTqjG/Vpn4QHXcfOeo96xDUalX8TwXY/iVBwYwWu6cemZmhGEpTpuTkx7H2uIN5ZlVCR8VCc=
Subject: [PATCH 13/21] ext2: use aligned-endian get/put helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 20 May 2008 11:06:15 -0700
Message-Id: <1211306775.5915.177.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/ext2/super.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index ef50cbc..ca619bf 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1277,8 +1277,8 @@ static int ext2_statfs (struct dentry * dentry, struct kstatfs * buf)
 	buf->f_ffree = ext2_count_free_inodes(sb);
 	es->s_free_inodes_count = cpu_to_le32(buf->f_ffree);
 	buf->f_namelen = EXT2_NAME_LEN;
-	fsid = le64_to_cpup((void *)es->s_uuid) ^
-	       le64_to_cpup((void *)es->s_uuid + sizeof(u64));
+	fsid = get_le64((void *)es->s_uuid) ^
+	       get_le64((void *)es->s_uuid + sizeof(u64));
 	buf->f_fsid.val[0] = fsid & 0xFFFFFFFFUL;
 	buf->f_fsid.val[1] = (fsid >> 32) & 0xFFFFFFFFUL;
 	return 0;
-- 
1.5.5.1.570.g26b5e


