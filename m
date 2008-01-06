Return-Path: <linux-kernel-owner+w=401wt.eu-S1758415AbYAFApp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758415AbYAFApp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 19:45:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757471AbYAFAp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 19:45:26 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:60007 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757837AbYAFApX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 19:45:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=VPjbKYl/beR3RD+ZE/TKzDijUgP2OftLjIPMdyEQEK2ehz13wtiwvC2HlFAYkDgb7Y5G7edEOhWD5dSb9MdVA8qcfSJEvlMOsRliUHoZ6u5kHOy4m29WAPhxwjoFpj4j/kc61rQmGXqadHmdoNlfDLjvnCTDzf7WmCiVk1pf4qI=
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>,
       Christoph Hellwig <hch@infradead.org>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH] udf: fix sparse warnings (shadowing & mismatch between declaration and definition)
Date: Sun,  6 Jan 2008 01:44:35 +0100
Message-Id: <1199580275-2487-7-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199580275-2487-1-git-send-email-marcin.slusarz@gmail.com>
References: <1199580275-2487-1-git-send-email-marcin.slusarz@gmail.com>
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
CC: Christoph Hellwig <hch@infradead.org>
---
 fs/udf/super.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 5423d26..a5fb461 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -474,7 +474,7 @@ static int udf_parse_options(char *options, struct udf_options *uopt)
 	return 1;
 }
 
-void udf_write_super(struct super_block *sb)
+static void udf_write_super(struct super_block *sb)
 {
 	lock_kernel();
 
@@ -1433,7 +1433,6 @@ static int udf_load_partition(struct super_block *sb, kernel_lb_addr *fileset)
 				map->s_type_specific.s_virtual.s_num_entries =
 					(sbi->s_vat_inode->i_size - 36) >> 2;
 			} else if (map->s_partition_type == UDF_VIRTUAL_MAP20) {
-				struct buffer_head *bh = NULL;
 				uint32_t pos;
 
 				pos = udf_block_map(sbi->s_vat_inode, 0);
-- 
1.5.3.7

