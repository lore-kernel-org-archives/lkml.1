Return-Path: <linux-kernel-owner+w=401wt.eu-S1758580AbXLXALr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758580AbXLXALr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 19:11:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756086AbXLXALM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 19:11:12 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:36145 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758320AbXLXALK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 19:11:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=kkWM2EFIwH0WMEwSg9zaGtw03Kop8RkGYKVtdE09Zp6k63E8VlVC2ic7FlQpkD+G4D6SDy0nyIaWuCRiWxW2VaYik3PnqJBAiDafhBO2rRtpfCbmkJPLfp6Fj7i6dcLdLdmMZnioESx5OaFl8B3le55U+ABnl/sMN4ii29uNsU0=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>,
       Christoph Hellwig <hch@infradead.org>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 6/6] udf: fix sparse warnings (shadowing & mismatch between declaration and definition)
Date: Mon, 24 Dec 2007 01:10:22 +0100
Message-Id: <1198455022-27674-7-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1198455022-27674-1-git-send-email-marcin.slusarz@gmail.com>
References: <1198455022-27674-1-git-send-email-marcin.slusarz@gmail.com>
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
index dc09c2d..c190317 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -469,7 +469,7 @@ static int udf_parse_options(char *options, struct udf_options *uopt)
 	return 1;
 }
 
-void udf_write_super(struct super_block *sb)
+static void udf_write_super(struct super_block *sb)
 {
 	lock_kernel();
 
@@ -1428,7 +1428,6 @@ static int udf_load_partition(struct super_block *sb, kernel_lb_addr *fileset)
 				map->s_type_specific.s_virtual.s_num_entries =
 					(sbi->s_vat_inode->i_size - 36) >> 2;
 			} else if (map->s_partition_type == UDF_VIRTUAL_MAP20) {
-				struct buffer_head *bh = NULL;
 				uint32_t pos;
 
 				pos = udf_block_map(sbi->s_vat_inode, 0);
-- 
1.5.3.4

