Return-Path: <linux-kernel-owner+w=401wt.eu-S1753644AbZGVL2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbZGVL2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 07:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbZGVL2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 07:28:24 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.122]:40275 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912AbZGVL2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 07:28:22 -0400
From: Jeff Layton <jlayton@redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: smfrench@gmail.com, hch@infradead.org
Subject: [PATCH] libfs: make get_sb_pseudo set s_maxbytes to value that can be cast to signed
Date: Wed, 22 Jul 2009 07:28:18 -0400
Message-Id: <1248262099-12514-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is a counterpart to the CIFS patch posted yesterday. I
believe either patch will fix the problem seen in do_sendfile since the
smaller s_maxbytes value for the two superblocks is used there.

get_sb_pseudo sets s_maxbytes to ~0ULL, which becomes negative when cast
to a signed value. Fix it to use MAX_LFS_FILESIZE which casts properly
to a positive signed value.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/libfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index ddfa899..dcec3d3 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -217,7 +217,7 @@ int get_sb_pseudo(struct file_system_type *fs_type, char *name,
 		return PTR_ERR(s);
 
 	s->s_flags = MS_NOUSER;
-	s->s_maxbytes = ~0ULL;
+	s->s_maxbytes = MAX_LFS_FILESIZE;
 	s->s_blocksize = PAGE_SIZE;
 	s->s_blocksize_bits = PAGE_SHIFT;
 	s->s_magic = magic;
-- 
1.6.0.6

