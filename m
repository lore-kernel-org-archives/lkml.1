Return-Path: <linux-kernel-owner+w=401wt.eu-S936416AbYEBTJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936416AbYEBTJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 15:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965098AbYEBTFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 15:05:47 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:39016 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965059AbYEBTFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 15:05:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=dgRenuOSmJL0s2dK38ZG447aN3qpuTjzcaJxKnt4cczmLxBXQuwqZspKhMBnj1bnyh8g3KVWl16/8GHmHeOEEnF7n4VscmXsR/k5FSJfi59GUWmA67F++TQEaKdqhwcmC1NwgIMOmMj5xcfWRgBp8Uqd5z9FqZlsF3Z3TuG/xu4=
Subject: [PATCH 06/14] xfs: use get_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 02 May 2008 12:05:56 -0700
Message-Id: <1209755156.26173.72.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/xfs/xfs_inode.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index cf0bb9c..c6327c4 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -580,8 +580,8 @@ xfs_iformat_extents(
 		xfs_validate_extents(ifp, nex, XFS_EXTFMT_INODE(ip));
 		for (i = 0; i < nex; i++, dp++) {
 			xfs_bmbt_rec_host_t *ep = xfs_iext_get_ext(ifp, i);
-			ep->l0 = be64_to_cpu(get_unaligned(&dp->l0));
-			ep->l1 = be64_to_cpu(get_unaligned(&dp->l1));
+			ep->l0 = get_unaligned_be64(&dp->l0);
+			ep->l1 = get_unaligned_be64(&dp->l1);
 		}
 		XFS_BMAP_TRACE_EXLIST(ip, nex, whichfork);
 		if (whichfork != XFS_DATA_FORK ||
-- 
1.5.5.1.350.gbbbf


