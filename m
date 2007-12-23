Return-Path: <linux-kernel-owner+w=401wt.eu-S1758568AbXLWB6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758568AbXLWB6f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 20:58:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758234AbXLWB54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 20:57:56 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:51028 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757229AbXLWB5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 20:57:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=sXIAnYGSe1Q+pu3ETO7NxCq82blzgURm0IGVXlBEc5Z/5D9JefKzHTdtV4cliMf8LqSRdCAlUmQmUfI63zeolrBu9PlCT3nj29sr/UcU94WIuE7UoLuCVA8pgNgJqYy44SmMw9Bqml2toueQRT03sqqCYkB0aRWJgqKqQzwzp2g=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 24/24] udf: fix sparse warnings (shadowing & mismatch between declaration and definition)
Date: Sun, 23 Dec 2007 02:51:14 +0100
Message-Id: <1198374674-12128-25-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1198374674-12128-1-git-send-email-marcin.slusarz@gmail.com>
References: <1198374674-12128-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix warnings:
fs/udf/super.c:1370:24: warning: symbol 'bh' shadows an earlier one
fs/udf/super.c:1288:21: originally declared here
fs/udf/super.c:450:6: warning: symbol 'udf_write_super' was not declared. Should it be static?

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
CC: Jan Kara <jack@suse.cz>
---
 fs/udf/super.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index f6c911b..da68130 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -447,7 +447,7 @@ static int udf_parse_options(char *options, struct udf_options *uopt)
 	return 1;
 }
 
-void udf_write_super(struct super_block *sb)
+static void udf_write_super(struct super_block *sb)
 {
 	lock_kernel();
 
@@ -1367,7 +1367,6 @@ static int udf_load_partition(struct super_block *sb, kernel_lb_addr *fileset)
 				map->s_type_specific.s_virtual.s_num_entries =
 					(udf_sb_vat_inode(sb)->i_size - 36) >> 2;
 			} else if (map->s_partition_type == UDF_VIRTUAL_MAP20) {
-				struct buffer_head *bh = NULL;
 				uint32_t pos;
 
 				pos = udf_block_map(udf_sb_vat_inode(sb), 0);
-- 
1.5.3.4

