Return-Path: <linux-kernel-owner+w=401wt.eu-S1751489AbXCDIaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489AbXCDIaQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 03:30:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490AbXCDIaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 03:30:16 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:40324 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbXCDIaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 03:30:14 -0500
To: bfennema@falcon.csc.calpoly.edu
CC: linux-kernel@vger.kernel.org
Subject: [patch] udf: possible null pointer dereference while load_partition
From: Dmitriy Monakhov <dmonakhov@openvz.org>
Date: Sun, 04 Mar 2007 11:30:34 +0300
Message-ID: <87abytl8b9.fsf@sw.ru>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=


sb_read may return NULL, let's explicitly check it.
Signed-off-by: Dmitriy Monakhov <dmonakhov@openvz.org>


--=-=-=
Content-Disposition: inline;
 filename=diff-mm-udf-load_partition-sb_read-errh-fix

diff --git a/fs/udf/super.c b/fs/udf/super.c
index f4b3265..951b85d 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1407,6 +1407,8 @@ udf_load_partition(struct super_block *sb, kernel_lb_addr *fileset)
 
 					pos = udf_block_map(UDF_SB_VAT(sb), 0);
 					bh = sb_bread(sb, pos);
+					if (!bh)
+						return 1;
 					UDF_SB_TYPEVIRT(sb,i).s_start_offset =
 						le16_to_cpu(((struct virtualAllocationTable20 *)bh->b_data + udf_ext0_offset(UDF_SB_VAT(sb)))->lengthHeader) +
 							udf_ext0_offset(UDF_SB_VAT(sb));

--=-=-=--

