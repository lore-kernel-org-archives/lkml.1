Return-Path: <linux-kernel-owner+w=401wt.eu-S1759569AbYAJWIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759569AbYAJWIF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 17:08:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758724AbYAJWHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 17:07:50 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:33091 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758963AbYAJWHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 17:07:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=BRHDZF3tznLO8SCMYkkF6UatGkARsUH3B7muI7eJt8pQmYUc1ydH0BFw9DuLQJB+5FyqUx4krvSSUDdwPpdR9Z2vEinw0xlqHgQsV4d4mAUtrd5v6wDDC0tp0/ZkrfsoLU/olFaVc6xBJs4deKybbyoTaLB2Fex9I0eToIcsFKM=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>
Subject: [PATCH 07/16] udf: fix sparse warnings (shadowing & mismatch between declaration and definition)
Date: Thu, 10 Jan 2008 23:06:23 +0100
Message-Id: <1200002792-8449-8-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1200002792-8449-1-git-send-email-marcin.slusarz@gmail.com>
References: <1200002792-8449-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix sparse warnings:
fs/udf/super.c:1431:24: warning: symbol 'bh' shadows an earlier one
fs/udf/super.c:1347:21: originally declared here
fs/udf/super.c:472:6: warning: symbol 'udf_write_super' was not declared. Should it be static?

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
CC: Jan Kara <jack@suse.cz>
Acked-by: Christoph Hellwig <hch@infradead.org>
---
 fs/udf/super.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 187aff9..5bf8526 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -474,7 +474,7 @@ static int udf_parse_options(char *options, struct udf_options *uopt)
 	return 1;
 }
 
-void udf_write_super(struct super_block *sb)
+static void udf_write_super(struct super_block *sb)
 {
 	lock_kernel();
 
@@ -1447,7 +1447,6 @@ static int udf_load_partition(struct super_block *sb, kernel_lb_addr *fileset)
 				map->s_type_specific.s_virtual.s_num_entries =
 					(sbi->s_vat_inode->i_size - 36) >> 2;
 			} else if (map->s_partition_type == UDF_VIRTUAL_MAP20) {
-				struct buffer_head *bh = NULL;
 				uint32_t pos;
 
 				pos = udf_block_map(sbi->s_vat_inode, 0);
-- 
1.5.3.7

