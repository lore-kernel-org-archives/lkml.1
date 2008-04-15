Return-Path: <linux-kernel-owner+w=401wt.eu-S1764315AbYDOD27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764315AbYDOD27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 23:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762409AbYDOD2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 23:28:51 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:27448 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762099AbYDOD2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 23:28:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Cb4bb02Ft+PAAkrt+3rq58CPzSXiFoM7ZNGg3fO091AEDQdqVZTsng5j8rd5dFkZBY9G4tFNhGi9m/o7VXbwz+uM+TTG/0pHdIm4bqT1jEA0RXS7rMyitUC6m9tq10CFv4BvbywdbupK9oddoGF1yxdmV/tHpD9Y6c8BiOyOZR4=
Subject: [PATCH-possible bugfix] xfs: ensure extents are read as be64
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 20:28:51 -0700
Message-Id: <1208230131.11920.59.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The debug code reads the extents in cpu-order rather than BE.  Make the
debug code match.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Possibly 2.6.25 material....if it actually is a bug.  See elsewhere
in the same file that reads as be64. (look for ep->l0).

 fs/xfs/xfs_inode.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index f43a6e0..eacf2ca 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -85,8 +85,8 @@ xfs_validate_extents(
 
 	for (i = 0; i < nrecs; i++) {
 		xfs_bmbt_rec_host_t *ep = xfs_iext_get_ext(ifp, i);
-		rec.l0 = get_unaligned(&ep->l0);
-		rec.l1 = get_unaligned(&ep->l1);
+		rec.l0 = be64_to_cpu(get_unaligned(&ep->l0));
+		rec.l1 = be64_to_cpu(get_unaligned(&ep->l1));
 		xfs_bmbt_get_all(&rec, &irec);
 		if (fmt == XFS_EXTFMT_NOSTATE)
 			ASSERT(irec.br_state == XFS_EXT_NORM);
-- 
1.5.5.144.g3e42



