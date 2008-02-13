Return-Path: <linux-kernel-owner+w=401wt.eu-S932090AbYBMJlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090AbYBMJlz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 04:41:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754642AbYBMJlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 04:41:47 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:46386 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbYBMJlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 04:41:47 -0500
Message-ID: <47B2BB58.5040401@tiscali.nl>
Date: Wed, 13 Feb 2008 10:41:44 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: marcin.slusarz@gmail.com
CC: LKML <linux-kernel@vger.kernel.org>, Evgeniy Dushistov <dushistov@mail.ru>
Subject: Re: [PATCH] ufs: [bl]e*_add_cpu conversion
References: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com> <1202857582-15450-18-git-send-email-marcin.slusarz@gmail.com>
In-Reply-To: <1202857582-15450-18-git-send-email-marcin.slusarz@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

marcin.slusarz@gmail.com wrote:
> replace all:
> big/little_endian_variable = cpu_to_[bl]eX([bl]eX_to_cpu(big/little_endian_variable) +
> 					expression_in_cpu_byteorder);
> with:
> 	[bl]eX_add_cpu(&big/little_endian_variable, expression_in_cpu_byteorder);

you may also want these:
---
[bl]e_add_cpu conversion in return

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/fs/ufs/swab.h b/fs/ufs/swab.h
index 1683d2b..a1e3000 100644
--- a/fs/ufs/swab.h
+++ b/fs/ufs/swab.h
@@ -44,18 +44,22 @@ static __inline u32
 fs64_add(struct super_block *sbp, u32 *n, int d)
 {
 	if (UFS_SB(sbp)->s_bytesex == BYTESEX_LE)
-		return *n = cpu_to_le64(le64_to_cpu(*n)+d);
+		le64_add_cpu(n, d);
 	else
-		return *n = cpu_to_be64(be64_to_cpu(*n)+d);
+		be64_add_cpu(n, d);
+
+	return *n;
 }
 
 static __inline u32
 fs64_sub(struct super_block *sbp, u32 *n, int d)
 {
 	if (UFS_SB(sbp)->s_bytesex == BYTESEX_LE)
-		return *n = cpu_to_le64(le64_to_cpu(*n)-d);
+		le64_add_cpu(n, -d);
 	else
-		return *n = cpu_to_be64(be64_to_cpu(*n)-d);
+		be64_add_cpu(n, -d);
+
+	return *n;
 }
 
 static __inline u32

