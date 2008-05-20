Return-Path: <linux-kernel-owner+w=401wt.eu-S933605AbYETSKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933605AbYETSKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 14:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759329AbYETSGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 14:06:42 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:3977 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932602AbYETSGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 14:06:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=W27SYKl6ZGrg5eNqu0s6YNBbmsTezuNLUZ6QzUMD1IDlBa1TwAF2ebrOUNs6m1W/GyWviVhXlokBC093WIpi7cjFT0c4ABZfGmAPnlnrQQs5JPablic0FKUoK9UCDhCO4dE0HvodVW6ZZh77DN+pnbWPu5pdRuFeg6FntjtNZM4=
Subject: [PATCH 14/21] ext3: use aligned-endian get/put helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 20 May 2008 11:06:16 -0700
Message-Id: <1211306776.5915.178.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/ext3/super.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index fe3119a..1dbae0f 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -2595,8 +2595,8 @@ static int ext3_statfs (struct dentry * dentry, struct kstatfs * buf)
 	buf->f_ffree = percpu_counter_sum_positive(&sbi->s_freeinodes_counter);
 	es->s_free_inodes_count = cpu_to_le32(buf->f_ffree);
 	buf->f_namelen = EXT3_NAME_LEN;
-	fsid = le64_to_cpup((void *)es->s_uuid) ^
-	       le64_to_cpup((void *)es->s_uuid + sizeof(u64));
+	fsid = get_le64((void *)es->s_uuid) ^
+	       get_le64((void *)es->s_uuid + sizeof(u64));
 	buf->f_fsid.val[0] = fsid & 0xFFFFFFFFUL;
 	buf->f_fsid.val[1] = (fsid >> 32) & 0xFFFFFFFFUL;
 	return 0;
-- 
1.5.5.1.570.g26b5e


