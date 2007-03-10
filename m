Return-Path: <linux-kernel-owner+w=401wt.eu-S1030579AbXCJJcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030579AbXCJJcP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 04:32:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030515AbXCJJcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 04:32:14 -0500
Received: from mx2-2.mail.ru ([194.67.23.122]:20248 "EHLO mx2.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030579AbXCJJcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 04:32:12 -0500
Date: Sat, 10 Mar 2007 12:32:55 +0300
From: Evgeniy Dushistov <dushistov@mail.ru>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Subject: [PATCH 4/4]: ufs2 tindirect truncate fix
Message-ID: <20070310093255.GA822@rain>
Mail-Followup-To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

During modification of code to support UFS2 writing,
the case with "three indirect" blocks in truncate path was missed,
this patch fixes this situation.

Signed-off-by: Evgeniy Dushistov <dushistov@mail.ru>

---

Index: linux-2.6.21-rc3-git6/fs/ufs/truncate.c
===================================================================
--- linux-2.6.21-rc3-git6.orig/fs/ufs/truncate.c
+++ linux-2.6.21-rc3-git6/fs/ufs/truncate.c
@@ -348,7 +348,7 @@ static int ufs_trunc_tindirect(struct in
 	}
 
 	for (i = tindirect_block ; i < uspi->s_apb ; i++) {
-		tind = ubh_get_addr32 (tind_bh, i);
+		tind = ubh_get_data_ptr(uspi, tind_bh, i);
 		retry |= ufs_trunc_dindirect(inode, UFS_NDADDR + 
 			uspi->s_apb + ((i + 1) << uspi->s_2apbshift), tind);
 		ubh_mark_buffer_dirty(tind_bh);
-- 
/Evgeniy

