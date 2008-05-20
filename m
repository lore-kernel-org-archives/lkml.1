Return-Path: <linux-kernel-owner+w=401wt.eu-S932791AbYETSIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932791AbYETSIH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 14:08:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932387AbYETSGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 14:06:23 -0400
Received: from rn-out-0910.google.com ([64.233.170.188]:36158 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765378AbYETSGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 14:06:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=rUd/jJy5fkPZftzLx16KqfTSOrC5rx3vSKz33qXXuodkl77AZhI3P2CRT5zKWfN2V50Dc1P4mYNF5K6wUoy+Jwcd8syeLY45z6QfZFP6Ui7GF9/PmzSu/OnHGiDqOKtAhrsWx4rLgOqlAzjfheaRMnoi3Klv2Mhrfx4SLj9bkSw=
Subject: [PATCH 15/21] ext4: use aligned-endian get/put helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 20 May 2008 11:06:12 -0700
Message-Id: <1211306772.5915.172.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/ext4/super.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 09d9359..d0e537b 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3006,8 +3006,8 @@ static int ext4_statfs (struct dentry * dentry, struct kstatfs * buf)
 	buf->f_ffree = percpu_counter_sum_positive(&sbi->s_freeinodes_counter);
 	es->s_free_inodes_count = cpu_to_le32(buf->f_ffree);
 	buf->f_namelen = EXT4_NAME_LEN;
-	fsid = le64_to_cpup((void *)es->s_uuid) ^
-	       le64_to_cpup((void *)es->s_uuid + sizeof(u64));
+	fsid = get_le64((void *)es->s_uuid) ^
+	       get_le64((void *)es->s_uuid + sizeof(u64));
 	buf->f_fsid.val[0] = fsid & 0xFFFFFFFFUL;
 	buf->f_fsid.val[1] = (fsid >> 32) & 0xFFFFFFFFUL;
 	return 0;
-- 
1.5.5.1.570.g26b5e


