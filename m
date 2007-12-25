Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbXLYOvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbXLYOvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 09:51:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbXLYOvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 09:51:15 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:30965 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbXLYOvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 09:51:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=SMhXNWkB0JTYgfsP5nGCjEzRrCoQQRGMpzLHTJlJlDdTZvLXwiOAK6QjvViazZlPDmrW8v213L+6IqEs6oJstgolBphmKOQPcBuzDrQot2enF1b0OLlyUgia+ViXRb+A8hpg1BKER8MvWqgPtToTHAGaJYOtK0XVwO03N/lvk4w=
Date: Tue, 25 Dec 2007 15:52:59 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: ocfs2-devel@oss.oracle.com
Cc: Mark Fasheh <mark.fasheh@oracle.com>, Kurt Hackel <kurt.hackel@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ocfs2: convert byte order of constant instead of variable
Message-ID: <20071225145256.GD24373@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

convert byte order of constant instead of variable
it will be done at compile time (vs run time)
remove unused le32_and_cpu

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Mark Fasheh <mark.fasheh@oracle.com>
CC: Kurt Hackel <kurt.hackel@oracle.com>
---
 fs/ocfs2/endian.h |    5 -----
 fs/ocfs2/inode.c  |    2 +-
 2 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/endian.h b/fs/ocfs2/endian.h
index ff25762..1942e09 100644
--- a/fs/ocfs2/endian.h
+++ b/fs/ocfs2/endian.h
@@ -37,11 +37,6 @@ static inline void le64_add_cpu(__le64 *var, u64 val)
 	*var = cpu_to_le64(le64_to_cpu(*var) + val);
 }

-static inline void le32_and_cpu(__le32 *var, u32 val)
-{
-	*var = cpu_to_le32(le32_to_cpu(*var) & val);
-}
-
 static inline void be32_add_cpu(__be32 *var, u32 val)
 {
 	*var = cpu_to_be32(be32_to_cpu(*var) + val);
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index ebb2bbe..ccea366 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -617,7 +617,7 @@ static int ocfs2_remove_inode(struct inode *inode,
 	}

 	di->i_dtime = cpu_to_le64(CURRENT_TIME.tv_sec);
-	le32_and_cpu(&di->i_flags, ~(OCFS2_VALID_FL | OCFS2_ORPHANED_FL));
+	di->i_flags &= cpu_to_le32(~(OCFS2_VALID_FL | OCFS2_ORPHANED_FL));

 	status = ocfs2_journal_dirty(handle, di_bh);
 	if (status < 0) {
--
1.5.3.4

