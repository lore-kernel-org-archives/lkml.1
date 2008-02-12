Return-Path: <linux-kernel-owner+w=401wt.eu-S1764738AbYBLXOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764738AbYBLXOf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 18:14:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762974AbYBLXMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 18:12:15 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:8053 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762941AbYBLXMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 18:12:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=PBJUyAEZmjGg2F7Q8GExOjU1g3xkiAHhWhHwnJVHp+NEGpddZHOuo3DFFG8T6lDzxdDUh02EMKKgCHbkVJMpDg2fHXp9uhITgQlCifRMG9c2uYoyadOGZVzJia7dKbHXFoRK5m4n/Eq7l+/ur1Yg4QmMCmsa1nBfRYjXje+meos=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] sysv: [bl]e*_add_cpu conversion
Date: Wed, 13 Feb 2008 00:06:21 +0100
Message-Id: <1202857582-15450-17-git-send-email-marcin.slusarz@gmail.com>
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
Cc: Christoph Hellwig <hch@infradead.org>
---
 fs/sysv/sysv.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/sysv/sysv.h b/fs/sysv/sysv.h
index 42d51d1..38ebe3f 100644
--- a/fs/sysv/sysv.h
+++ b/fs/sysv/sysv.h
@@ -217,9 +217,9 @@ static inline __fs32 fs32_add(struct sysv_sb_info *sbi, __fs32 *n, int d)
 	if (sbi->s_bytesex == BYTESEX_PDP)
 		*(__u32*)n = PDP_swab(PDP_swab(*(__u32*)n)+d);
 	else if (sbi->s_bytesex == BYTESEX_LE)
-		*(__le32*)n = cpu_to_le32(le32_to_cpu(*(__le32*)n)+d);
+		le32_add_cpu((__le32 *)n, d);
 	else
-		*(__be32*)n = cpu_to_be32(be32_to_cpu(*(__be32*)n)+d);
+		be32_add_cpu((__be32 *)n, d);
 	return *n;
 }
 
@@ -242,9 +242,9 @@ static inline __fs16 cpu_to_fs16(struct sysv_sb_info *sbi, __u16 n)
 static inline __fs16 fs16_add(struct sysv_sb_info *sbi, __fs16 *n, int d)
 {
 	if (sbi->s_bytesex != BYTESEX_BE)
-		*(__le16*)n = cpu_to_le16(le16_to_cpu(*(__le16 *)n)+d);
+		le16_add_cpu((__le16 *)n, d);
 	else
-		*(__be16*)n = cpu_to_be16(be16_to_cpu(*(__be16 *)n)+d);
+		be16_add_cpu((__be16 *)n, d);
 	return *n;
 }
 
-- 
1.5.3.7

