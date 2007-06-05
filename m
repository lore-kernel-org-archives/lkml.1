Return-Path: <linux-kernel-owner+w=401wt.eu-S1760365AbXFESFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760365AbXFESFK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 14:05:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754085AbXFESE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 14:04:58 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:17984 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819AbXFESE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 14:04:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=fB5Gh59BsWAXQkW1O1Ow10fRFgb1kTlEJls4AOlWmw6gyVuXR4vDC3CQG8u7ZEiwn1lISFDN1yEyRHsHv8nncTBBf8CjgUhfxyIW8wnTwqOh1d35qCJS00vHRxmA3Ph12L5KRfISiq3jK7VM20g7p/vBYALMmCeo5Vm3m4R5fDY=
Date: Tue, 5 Jun 2007 22:03:35 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH] UDF: coding style conversion - lindent fixups 2
Message-ID: <20070605180335.GC8398@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes sources were converted to kernel coding
style by Lindent for first and then by hands. But some
messed things were accidentally skipped.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
Andrew, the patch is incremental over
- udf-coding-style-conversion-lindent.patch
- udf-coding-style-conversion-lindent-fixups.patch

And there is still a bug in UDF system concerned to
deadlock on inode being dropped. I'm working on it.

 fs/udf/inode.c    |   14 ++++---
 fs/udf/truncate.c |  109 ++++++++++++++++++-----------------------------------
 2 files changed, 45 insertions(+), 78 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 5c8f812..9fcd76c 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1098,7 +1098,8 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 			make_bad_inode(inode);
 			return;
 		}
-		memcpy(UDF_I_DATA(inode), bh->b_data + sizeof(struct extendedFileEntry), inode->i_sb->s_blocksize - sizeof(struct extendedFileEntry));
+		memcpy(UDF_I_DATA(inode), bh->b_data + sizeof(struct extendedFileEntry),
+		       inode->i_sb->s_blocksize - sizeof(struct extendedFileEntry));
 	} else if (le16_to_cpu(fe->descTag.tagIdent) == TAG_IDENT_FE) {
 		UDF_I_EFE(inode) = 0;
 		UDF_I_USE(inode) = 0;
@@ -1800,7 +1801,8 @@ int8_t udf_current_aext(struct inode * inode, struct extent_position * epos,
 		if (!epos->offset)
 			epos->offset = sizeof(struct allocExtDesc);
 		ptr = epos->bh->b_data + epos->offset;
-		alen = sizeof(struct allocExtDesc) + le32_to_cpu(((struct allocExtDesc *)epos->bh->b_data)->lengthAllocDescs);
+		alen = sizeof(struct allocExtDesc) +
+			le32_to_cpu(((struct allocExtDesc *)epos->bh->b_data)->lengthAllocDescs);
 	}
 
 	switch (UDF_I_ALLOCTYPE(inode)) {
@@ -1827,9 +1829,8 @@ int8_t udf_current_aext(struct inode * inode, struct extent_position * epos,
 	return etype;
 }
 
-static int8_t
-udf_insert_aext(struct inode *inode, struct extent_position epos,
-		kernel_lb_addr neloc, uint32_t nelen)
+static int8_t udf_insert_aext(struct inode *inode, struct extent_position epos,
+			      kernel_lb_addr neloc, uint32_t nelen)
 {
 	kernel_lb_addr oeloc;
 	uint32_t oelen;
@@ -1913,7 +1914,8 @@ int8_t udf_delete_aext(struct inode * inode, struct extent_position epos,
 			aed = (struct allocExtDesc *)oepos.bh->b_data;
 			aed->lengthAllocDescs =
 				cpu_to_le32(le32_to_cpu(aed->lengthAllocDescs) - adsize);
-			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) || UDF_SB_UDFREV(inode->i_sb) >= 0x0201)
+			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) ||
+			    UDF_SB_UDFREV(inode->i_sb) >= 0x0201)
 				udf_update_tag(oepos.bh->b_data, epos.offset - adsize);
 			else
 				udf_update_tag(oepos.bh->b_data, sizeof(struct allocExtDesc));
diff --git a/fs/udf/truncate.c b/fs/udf/truncate.c
index cf562f5..b1655f2 100644
--- a/fs/udf/truncate.c
+++ b/fs/udf/truncate.c
@@ -33,12 +33,10 @@ static void extent_trunc(struct inode *inode, struct extent_position *epos,
 			 uint32_t nelen)
 {
 	kernel_lb_addr neloc = {};
-	int last_block =
-	    (elen + inode->i_sb->s_blocksize -
-	     1) >> inode->i_sb->s_blocksize_bits;
-	int first_block =
-	    (nelen + inode->i_sb->s_blocksize -
-	     1) >> inode->i_sb->s_blocksize_bits;
+	int last_block = (elen + inode->i_sb->s_blocksize - 1) >>
+		inode->i_sb->s_blocksize_bits;
+	int first_block = (nelen + inode->i_sb->s_blocksize - 1) >>
+		inode->i_sb->s_blocksize_bits;
 
 	if (nelen) {
 		if (etype == (EXT_NOT_RECORDED_ALLOCATED >> 30)) {
@@ -154,16 +152,16 @@ void udf_discard_prealloc(struct inode *inode)
 		extent_trunc(inode, &epos, eloc, etype, elen, 0);
 		if (!epos.bh) {
 			UDF_I_LENALLOC(inode) =
-			    epos.offset - udf_file_entry_alloc_offset(inode);
+				epos.offset - udf_file_entry_alloc_offset(inode);
 			mark_inode_dirty(inode);
 		} else {
 			struct allocExtDesc *aed =
-			    (struct allocExtDesc *)(epos.bh->b_data);
+				(struct allocExtDesc *)(epos.bh->b_data);
 			aed->lengthAllocDescs =
-			    cpu_to_le32(epos.offset -
-					sizeof(struct allocExtDesc));
-			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT)
-			    || UDF_SB_UDFREV(inode->i_sb) >= 0x0201)
+				cpu_to_le32(epos.offset -
+					    sizeof(struct allocExtDesc));
+			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) ||
+			    UDF_SB_UDFREV(inode->i_sb) >= 0x0201)
 				udf_update_tag(epos.bh->b_data, epos.offset);
 			else
 				udf_update_tag(epos.bh->b_data,
@@ -181,7 +179,7 @@ void udf_discard_prealloc(struct inode *inode)
 void udf_truncate_extents(struct inode *inode)
 {
 	struct extent_position epos;
-	kernel_lb_addr eloc, neloc = { 0, 0 };
+	kernel_lb_addr eloc, neloc = {};
 	uint32_t elen, nelen = 0, indirect_ext_len = 0, lenalloc;
 	int8_t etype;
 	struct super_block *sb = inode->i_sb;
@@ -197,9 +195,8 @@ void udf_truncate_extents(struct inode *inode)
 		BUG();
 
 	etype = inode_bmap(inode, first_block, &epos, &eloc, &elen, &offset);
-	byte_offset =
-	    (offset << sb->s_blocksize_bits) +
-	    (inode->i_size & (sb->s_blocksize - 1));
+	byte_offset = (offset << sb->s_blocksize_bits) +
+		(inode->i_size & (sb->s_blocksize - 1));
 	if (etype != -1) {
 		epos.offset -= adsize;
 		extent_trunc(inode, &epos, eloc, etype, elen, byte_offset);
@@ -214,9 +211,7 @@ void udf_truncate_extents(struct inode *inode)
 		else
 			lenalloc -= sizeof(struct allocExtDesc);
 
-		while ((etype =
-			udf_current_aext(inode, &epos, &eloc, &elen,
-					 0)) != -1) {
+		while ((etype = udf_current_aext(inode, &epos, &eloc, &elen, 0)) != -1) {
 			if (etype == (EXT_NEXT_EXTENT_ALLOCDECS >> 30)) {
 				udf_write_aext(inode, &epos, neloc, nelen, 0);
 				if (indirect_ext_len) {
@@ -228,52 +223,35 @@ void udf_truncate_extents(struct inode *inode)
 							0, indirect_ext_len);
 				} else {
 					if (!epos.bh) {
-						UDF_I_LENALLOC(inode) =
-						    lenalloc;
+						UDF_I_LENALLOC(inode) = lenalloc;
 						mark_inode_dirty(inode);
 					} else {
 						struct allocExtDesc *aed =
-						    (struct allocExtDesc
-						     *)(epos.bh->b_data);
+							(struct allocExtDesc *)(epos.bh->b_data);
 						aed->lengthAllocDescs =
 						    cpu_to_le32(lenalloc);
-						if (!UDF_QUERY_FLAG
-						    (sb, UDF_FLAG_STRICT)
-						    || UDF_SB_UDFREV(sb) >=
-						    0x0201)
-							udf_update_tag(epos.bh->
-								       b_data,
-								       lenalloc
-								       +
-								       sizeof
-								       (struct
-									allocExtDesc));
+						if (!UDF_QUERY_FLAG(sb, UDF_FLAG_STRICT) ||
+						    UDF_SB_UDFREV(sb) >= 0x0201)
+							udf_update_tag(epos.bh->b_data,
+								       lenalloc +
+								       sizeof(struct allocExtDesc));
 						else
-							udf_update_tag(epos.bh->
-								       b_data,
-								       sizeof
-								       (struct
-									allocExtDesc));
-						mark_buffer_dirty_inode(epos.bh,
-									inode);
+							udf_update_tag(epos.bh->b_data,
+								       sizeof(struct allocExtDesc));
+						mark_buffer_dirty_inode(epos.bh, inode);
 					}
 				}
 				brelse(epos.bh);
 				epos.offset = sizeof(struct allocExtDesc);
 				epos.block = eloc;
-				epos.bh =
-				    udf_tread(sb,
-					      udf_get_lb_pblock(sb, eloc, 0));
+				epos.bh = udf_tread(sb, udf_get_lb_pblock(sb, eloc, 0));
 				if (elen)
-					indirect_ext_len = (elen +
-							    sb->s_blocksize -
-							    1) >> sb->
-					    s_blocksize_bits;
+					indirect_ext_len = (elen + sb->s_blocksize -1) >>
+						sb->s_blocksize_bits;
 				else
 					indirect_ext_len = 1;
 			} else {
-				extent_trunc(inode, &epos, eloc, etype, elen,
-					     0);
+				extent_trunc(inode, &epos, eloc, etype, elen, 0);
 				epos.offset += adsize;
 			}
 		}
@@ -291,16 +269,13 @@ void udf_truncate_extents(struct inode *inode)
 				struct allocExtDesc *aed =
 				    (struct allocExtDesc *)(epos.bh->b_data);
 				aed->lengthAllocDescs = cpu_to_le32(lenalloc);
-				if (!UDF_QUERY_FLAG(sb, UDF_FLAG_STRICT)
-				    || UDF_SB_UDFREV(sb) >= 0x0201)
+				if (!UDF_QUERY_FLAG(sb, UDF_FLAG_STRICT) ||
+				    UDF_SB_UDFREV(sb) >= 0x0201)
 					udf_update_tag(epos.bh->b_data,
-						       lenalloc +
-						       sizeof(struct
-							      allocExtDesc));
+						       lenalloc + sizeof(struct allocExtDesc));
 				else
 					udf_update_tag(epos.bh->b_data,
-						       sizeof(struct
-							      allocExtDesc));
+						       sizeof(struct allocExtDesc));
 				mark_buffer_dirty_inode(epos.bh, inode);
 			}
 		}
@@ -313,21 +288,14 @@ void udf_truncate_extents(struct inode *inode)
 			 *  no extent above inode->i_size => truncate is
 			 *  extending the file by 'offset' blocks.
 			 */
-			if ((!epos.bh
-			     && epos.offset ==
-			     udf_file_entry_alloc_offset(inode)) || (epos.bh
-								     && epos.
-								     offset ==
-								     sizeof
-								     (struct
-								      allocExtDesc)))
-			{
+			if ((!epos.bh &&
+			     epos.offset == udf_file_entry_alloc_offset(inode)) ||
+			    (epos.bh && epos.offset == sizeof(struct allocExtDesc))) {
 				/* File has no extents at all or has empty last
 				 * indirect extent! Create a fake extent... */
 				extent.extLocation.logicalBlockNum = 0;
 				extent.extLocation.partitionReferenceNum = 0;
-				extent.extLength =
-				    EXT_NOT_RECORDED_NOT_ALLOCATED;
+				extent.extLength = EXT_NOT_RECORDED_NOT_ALLOCATED;
 			} else {
 				epos.offset -= adsize;
 				etype = udf_next_aext(inode, &epos,
@@ -336,10 +304,7 @@ void udf_truncate_extents(struct inode *inode)
 				extent.extLength |= etype << 30;
 			}
 			udf_extend_file(inode, &epos, &extent,
-					offset +
-					((inode->
-					  i_size & (sb->s_blocksize - 1)) !=
-					 0));
+					offset + ((inode->i_size & (sb->s_blocksize - 1)) != 0));
 		}
 	}
 	UDF_I_LENEXTENTS(inode) = inode->i_size;
