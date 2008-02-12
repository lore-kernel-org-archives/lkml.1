Return-Path: <linux-kernel-owner+w=401wt.eu-S1764883AbYBLXO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764883AbYBLXO5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 18:14:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760069AbYBLXMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 18:12:35 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:46643 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763284AbYBLXMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 18:12:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=bsiprqjFcPxQ47aR03l0Lrd02mwBreeiPTVFuzGEnArxRrjGlNo0YISHw5lGH9QIQp5RnJHsuSeTG2sjL679MjmPl9xdsGG5ss/QfiLHVvVsRYFhPTG3MgFqaeRLZ3tap7hj1Q8B7zBsIT4DtYodX0OqMhM9I+B4Df58JcmyrjI=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Evgeniy Dushistov <dushistov@mail.ru>
Subject: [PATCH] ufs: [bl]e*_add_cpu conversion
Date: Wed, 13 Feb 2008 00:06:22 +0100
Message-Id: <1202857582-15450-18-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com>
References: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcin Slusarz <marcin.slusarz@gmail.com>

replace all:
big/little_endian_variable = cpu_to_[bl]eX([bl]eX_to_cpu(big/little_endian_variable) +
					expression_in_cpu_byteorder);
with:
	[bl]eX_add_cpu(&big/little_endian_variable, expression_in_cpu_byteorder);
generated with semantic patch

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
---
 fs/ufs/swab.h |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/ufs/swab.h b/fs/ufs/swab.h
index 1683d2b..a4340d0 100644
--- a/fs/ufs/swab.h
+++ b/fs/ufs/swab.h
@@ -80,18 +80,18 @@ static inline void
 fs32_add(struct super_block *sbp, __fs32 *n, int d)
 {
 	if (UFS_SB(sbp)->s_bytesex == BYTESEX_LE)
-		*(__le32 *)n = cpu_to_le32(le32_to_cpu(*(__le32 *)n)+d);
+		le32_add_cpu((__le32 *)n, d);
 	else
-		*(__be32 *)n = cpu_to_be32(be32_to_cpu(*(__be32 *)n)+d);
+		be32_add_cpu((__be32 *)n, d);
 }
 
 static inline void
 fs32_sub(struct super_block *sbp, __fs32 *n, int d)
 {
 	if (UFS_SB(sbp)->s_bytesex == BYTESEX_LE)
-		*(__le32 *)n = cpu_to_le32(le32_to_cpu(*(__le32 *)n)-d);
+		le32_add_cpu((__le32 *)n, -d);
 	else
-		*(__be32 *)n = cpu_to_be32(be32_to_cpu(*(__be32 *)n)-d);
+		be32_add_cpu((__be32 *)n, -d);
 }
 
 static inline u16
@@ -116,18 +116,18 @@ static inline void
 fs16_add(struct super_block *sbp, __fs16 *n, int d)
 {
 	if (UFS_SB(sbp)->s_bytesex == BYTESEX_LE)
-		*(__le16 *)n = cpu_to_le16(le16_to_cpu(*(__le16 *)n)+d);
+		le16_add_cpu((__le16 *)n, d);
 	else
-		*(__be16 *)n = cpu_to_be16(be16_to_cpu(*(__be16 *)n)+d);
+		be16_add_cpu((__be16 *)n, d);
 }
 
 static inline void
 fs16_sub(struct super_block *sbp, __fs16 *n, int d)
 {
 	if (UFS_SB(sbp)->s_bytesex == BYTESEX_LE)
-		*(__le16 *)n = cpu_to_le16(le16_to_cpu(*(__le16 *)n)-d);
+		le16_add_cpu((__le16 *)n, -d);
 	else
-		*(__be16 *)n = cpu_to_be16(be16_to_cpu(*(__be16 *)n)-d);
+		be16_add_cpu((__be16 *)n, -d);
 }
 
 #endif /* _UFS_SWAB_H */
-- 
1.5.3.7

