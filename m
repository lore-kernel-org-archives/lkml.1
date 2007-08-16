Return-Path: <linux-kernel-owner+w=401wt.eu-S1762499AbXHPNVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762499AbXHPNVA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 09:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758925AbXHPNTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 09:19:55 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1276 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761970AbXHPNTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 09:19:53 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@xenotime.net>, Andrew Morton <akpm@osdl.org>,
       Andy Whitcroft <apw@shadowen.org>, Andy Whitcroft <apw@shadowen.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org
Subject: [PATCH 2/6] powerpc: hash_preload fails to preload under CONFIG_PPC_MM_SLICES
References: <exportbomb.1187270320@pinky>
InReply-To: <exportbomb.1187270320@pinky>
Message-ID: <8b4c69b92d61b5a840468f07e0ec1320@pinky>
Date: Thu, 16 Aug 2007 14:18:51 +0100
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Seems that a trailing ';' has slipped onto the end of the
get_slice_psize checks under CONFIG_PPC_MM_SLICES causing us to
return unconditionally and never preload.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@ozlabs.org
---
 arch/powerpc/mm/hash_utils_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
diff --git a/arch/powerpc/mm/hash_utils_64.c b/arch/powerpc/mm/hash_utils_64.c
index f178957..a47151e 100644
--- a/arch/powerpc/mm/hash_utils_64.c
+++ b/arch/powerpc/mm/hash_utils_64.c
@@ -795,7 +795,7 @@ void hash_preload(struct mm_struct *mm, unsigned long ea,
 
 #ifdef CONFIG_PPC_MM_SLICES
 	/* We only prefault standard pages for now */
-	if (unlikely(get_slice_psize(mm, ea) != mm->context.user_psize));
+	if (unlikely(get_slice_psize(mm, ea) != mm->context.user_psize))
 		return;
 #endif
 
