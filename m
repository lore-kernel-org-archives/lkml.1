Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbXLUP77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbXLUP77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 10:59:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750763AbXLUP7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 10:59:52 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:46600 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbXLUP7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 10:59:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=LTNnAw8P3NXZx6gD5FobWymQ3LPAP/VY6l8wvjx6mte0IPHvTVDqlnbT0eheiblsqeRUS9tOzm729RBhrdMxClW26aXnsfJb/sJnF/5AVPF3qvzhbPhJcUghcMVFPW+3JKJqaoAywTRjkR+w9vfVHBuiG3m4Pv3Wu2Qy0V5uQHQ=
Date: Fri, 21 Dec 2007 17:01:22 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>
Subject: [PATCH 3/5] udf: fix coding style of dir.c
Message-ID: <20071221160117.GC8575@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix coding style, checkpatch warned about:
- "braces {} are not necessary for single statement blocks"
- "line over 80 characters"
- "do not use assignment in if condition"
- "use tabs not spaces"

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
Acked-by: Jan Kara <jack@suse.cz>
---
 fs/udf/dir.c |   46 +++++++++++++++++++++++++++-------------------
 1 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/fs/udf/dir.c b/fs/udf/dir.c
index c26e281..c5e38d6 100644
--- a/fs/udf/dir.c
+++ b/fs/udf/dir.c
@@ -65,24 +65,26 @@ static int do_udf_readdir(struct inode *dir, struct file *filp,
 	if (nf_pos == 0)
 		nf_pos = (udf_ext0_offset(dir) >> 2);

-	fibh.soffset = fibh.eoffset = (nf_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
+	fibh.soffset = fibh.eoffset =
+		(nf_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
 	bits = dir->i_sb->s_blocksize_bits;

-	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB) {
+	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB)
 		fibh.sbh = fibh.ebh = NULL;
-	} else if (inode_bmap(dir, nf_pos >> (bits - 2),
-			      &epos, &eloc, &elen, &offset) == (EXT_RECORDED_ALLOCATED >> 30)) {
+	else if (inode_bmap(dir, nf_pos >> (bits - 2),
+			    &epos, &eloc, &elen, &offset) ==
+			(EXT_RECORDED_ALLOCATED >> 30)) {
 		block = udf_get_lb_pblock(dir->i_sb, eloc, offset);
 		if ((++offset << bits) < elen) {
 			if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_SHORT)
 				epos.offset -= sizeof(short_ad);
 			else if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_LONG)
 				epos.offset -= sizeof(long_ad);
-		} else {
+		} else
 			offset = 0;
-		}

-		if (!(fibh.sbh = fibh.ebh = udf_tread(dir->i_sb, block))) {
+		fibh.sbh = fibh.ebh = udf_tread(dir->i_sb, block);
+		if (!fibh.sbh) {
 			brelse(epos.bh);
 			return -EIO;
 		}
@@ -92,9 +94,11 @@ static int do_udf_readdir(struct inode *dir, struct file *filp,
 			if (i + offset > (elen >> bits))
 				i = (elen >> bits) - offset;
 			for (num = 0; i > 0; i--) {
-				block = udf_get_lb_pblock(dir->i_sb, eloc, offset + i);
+				block = udf_get_lb_pblock(dir->i_sb, eloc,
+							  offset + i);
 				tmp = udf_tgetblk(dir->i_sb, block);
-				if (tmp && !buffer_uptodate(tmp) && !buffer_locked(tmp))
+				if (tmp && !buffer_uptodate(tmp) &&
+					!buffer_locked(tmp))
 					bha[num++] = tmp;
 				else
 					brelse(tmp);
@@ -126,16 +130,18 @@ static int do_udf_readdir(struct inode *dir, struct file *filp,
 		liu = le16_to_cpu(cfi.lengthOfImpUse);
 		lfi = cfi.lengthFileIdent;

-		if (fibh.sbh == fibh.ebh) {
+		if (fibh.sbh == fibh.ebh)
 			nameptr = fi->fileIdent + liu;
-		} else {
+		else {
 			int poffset;	/* Unpaded ending offset */

-			poffset = fibh.soffset + sizeof(struct fileIdentDesc) + liu + lfi;
+			poffset = fibh.soffset + sizeof(struct fileIdentDesc) +
+					liu + lfi;

-			if (poffset >= lfi) {
-				nameptr = (char *)(fibh.ebh->b_data + poffset - lfi);
-			} else {
+			if (poffset >= lfi)
+				nameptr = (char *)(fibh.ebh->b_data +
+						   poffset - lfi);
+			else {
 				nameptr = fname;
 				memcpy(nameptr, fi->fileIdent + liu,
 				       lfi - poffset);
@@ -168,12 +174,13 @@ static int do_udf_readdir(struct inode *dir, struct file *filp,
 		}

 		if (flen) {
-			if (filldir(dirent, fname, flen, filp->f_pos, iblock, dt_type) < 0) {
+			if (filldir(dirent, fname, flen, filp->f_pos, iblock,
+				    dt_type) < 0) {
 				if (fibh.sbh != fibh.ebh)
 					brelse(fibh.ebh);
 				brelse(fibh.sbh);
 				brelse(epos.bh);
-	 			return 0;
+				return 0;
 			}
 		}
 	} /* end while */
@@ -222,7 +229,8 @@ static int udf_readdir(struct file *filp, void *dirent, filldir_t filldir)
 	lock_kernel();

 	if (filp->f_pos == 0) {
-		if (filldir(dirent, ".", 1, filp->f_pos, dir->i_ino, DT_DIR) < 0) {
+		if (filldir(dirent, ".", 1, filp->f_pos, dir->i_ino,
+			    DT_DIR) < 0) {
 			unlock_kernel();
 			return 0;
 		}
@@ -231,7 +239,7 @@ static int udf_readdir(struct file *filp, void *dirent, filldir_t filldir)

 	result = do_udf_readdir(dir, filp, filldir, dirent);
 	unlock_kernel();
- 	return result;
+	return result;
 }

 /* readdir and lookup functions */
--
1.5.3.4

