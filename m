Return-Path: <linux-kernel-owner+w=401wt.eu-S1758145AbYLVV7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145AbYLVV7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 16:59:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755888AbYLVVtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 16:49:39 -0500
Received: from ns2.suse.de ([195.135.220.15]:38665 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756046AbYLVVti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 16:49:38 -0500
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 29/56] ocfs2: Use BH_JBDPrivateStart instead of BH_Unshadow
Date: Mon, 22 Dec 2008 13:48:10 -0800
Message-Id: <1229982517-3455-30-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is safer. We no longer have to worry about tracking changes to
jbd_state_bits.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/buffer_head_io.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
index 0e9eed0..15c8e6d 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -42,11 +42,10 @@
 /*
  * Bits on bh->b_state used by ocfs2.
  *
- * These MUST be after the JBD2 bits.  Currently BH_Unshadow is the last
- * JBD2 bit.
+ * These MUST be after the JBD2 bits.  Hence, we use BH_JBDPrivateStart.
  */
 enum ocfs2_state_bits {
-	BH_NeedsValidate = BH_Unshadow + 1,
+	BH_NeedsValidate = BH_JBDPrivateStart,
 };
 
 /* Expand the magic b_state functions */
-- 
1.5.6

