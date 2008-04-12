Return-Path: <linux-kernel-owner+w=401wt.eu-S1758732AbYDLTlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758732AbYDLTlI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 15:41:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755559AbYDLTky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 15:40:54 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:2811 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214AbYDLTkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 15:40:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=MwqW05pc/4cOfxya+vRuVcmv3FsigbibBXoWLXiFIAPo2t91Wf5tEcgX7SpETEICv53TpOTvaFUZI6K/Ux4c50pVRMTlihYpOXywouF04g+ZejCSPP5jKY8k6IFGX8+QSh7zLrP37xdRmr3d5COTh6lYOGM+pWGKSP3oTw6I0qs=
Date: Sat, 12 Apr 2008 23:40:08 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] UDF - use UDF_MAX_WRITE_VERSION instead of numbers
Message-ID: <20080412194008.GB8388@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Jan, the patch is over current yours for_mm branch

Yep, i know it exceeds 80 column *but* it looks much better
in this way ;)

Index: linux-2.6.git/fs/udf/inode.c
===================================================================
--- linux-2.6.git.orig/fs/udf/inode.c	2008-04-12 22:53:15.000000000 +0400
+++ linux-2.6.git/fs/udf/inode.c	2008-04-12 23:34:28.000000000 +0400
@@ -1732,7 +1732,7 @@ int8_t udf_add_aext(struct inode *inode,
 		}
 		if (epos->bh) {
 			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) ||
-			    UDF_SB(inode->i_sb)->s_udfrev >= 0x0201)
+			    UDF_SB(inode->i_sb)->s_udfrev >= UDF_MAX_WRITE_VERSION)
 				udf_update_tag(epos->bh->b_data, loffset);
 			else
 				udf_update_tag(epos->bh->b_data,
@@ -1754,7 +1754,7 @@ int8_t udf_add_aext(struct inode *inode,
 		aed = (struct allocExtDesc *)epos->bh->b_data;
 		le32_add_cpu(&aed->lengthAllocDescs, adsize);
 		if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) ||
-				UDF_SB(inode->i_sb)->s_udfrev >= 0x0201)
+				UDF_SB(inode->i_sb)->s_udfrev >= UDF_MAX_WRITE_VERSION)
 			udf_update_tag(epos->bh->b_data,
 					epos->offset + (inc ? 0 : adsize));
 		else
@@ -1802,7 +1802,7 @@ int8_t udf_write_aext(struct inode *inod
 
 	if (epos->bh) {
 		if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) ||
-		    UDF_SB(inode->i_sb)->s_udfrev >= 0x0201) {
+		    UDF_SB(inode->i_sb)->s_udfrev >= UDF_MAX_WRITE_VERSION) {
 			struct allocExtDesc *aed =
 				(struct allocExtDesc *)epos->bh->b_data;
 			udf_update_tag(epos->bh->b_data,
@@ -1968,7 +1968,7 @@ int8_t udf_delete_aext(struct inode *ino
 			aed = (struct allocExtDesc *)oepos.bh->b_data;
 			le32_add_cpu(&aed->lengthAllocDescs, -(2 * adsize));
 			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) ||
-			    UDF_SB(inode->i_sb)->s_udfrev >= 0x0201)
+			    UDF_SB(inode->i_sb)->s_udfrev >= UDF_MAX_WRITE_VERSION)
 				udf_update_tag(oepos.bh->b_data,
 						oepos.offset - (2 * adsize));
 			else
@@ -1985,7 +1985,7 @@ int8_t udf_delete_aext(struct inode *ino
 			aed = (struct allocExtDesc *)oepos.bh->b_data;
 			le32_add_cpu(&aed->lengthAllocDescs, -adsize);
 			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) ||
-			    UDF_SB(inode->i_sb)->s_udfrev >= 0x0201)
+			    UDF_SB(inode->i_sb)->s_udfrev >= UDF_MAX_WRITE_VERSION)
 				udf_update_tag(oepos.bh->b_data,
 						epos.offset - adsize);
 			else
Index: linux-2.6.git/fs/udf/truncate.c
===================================================================
--- linux-2.6.git.orig/fs/udf/truncate.c	2008-04-12 22:53:15.000000000 +0400
+++ linux-2.6.git/fs/udf/truncate.c	2008-04-12 23:31:54.000000000 +0400
@@ -165,7 +165,7 @@ void udf_discard_prealloc(struct inode *
 				cpu_to_le32(epos.offset -
 					    sizeof(struct allocExtDesc));
 			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) ||
-			    UDF_SB(inode->i_sb)->s_udfrev >= 0x0201)
+			    UDF_SB(inode->i_sb)->s_udfrev >= UDF_MAX_WRITE_VERSION)
 				udf_update_tag(epos.bh->b_data, epos.offset);
 			else
 				udf_update_tag(epos.bh->b_data,
@@ -190,7 +190,7 @@ static void udf_update_alloc_ext_desc(st
 	int len = sizeof(struct allocExtDesc);
 
 	aed->lengthAllocDescs =	cpu_to_le32(lenalloc);
-	if (!UDF_QUERY_FLAG(sb, UDF_FLAG_STRICT) || sbi->s_udfrev >= 0x0201)
+	if (!UDF_QUERY_FLAG(sb, UDF_FLAG_STRICT) || sbi->s_udfrev >= UDF_MAX_WRITE_VERSION)
 		len += lenalloc;
 
 	udf_update_tag(epos->bh->b_data, len);
