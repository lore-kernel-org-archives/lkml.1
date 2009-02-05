Return-Path: <linux-kernel-owner+w=401wt.eu-S1756270AbZBEWxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270AbZBEWxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 17:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753349AbZBEWwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 17:52:14 -0500
Received: from everest.las.ic.unicamp.br ([143.106.60.118]:52321 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752514AbZBEWwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 17:52:13 -0500
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: linux-kernel@vger.kernel.org
Cc: glommer@redhat.com, mingo@elte.hu
Subject: [PATCH 2/6] x86: define FIXADDR_BOOT_* and redefine FIX_ADDR_SIZE
Date: Thu,  5 Feb 2009 20:39:42 -0200
Message-Id: <1233873586-7149-3-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1233873586-7149-2-git-send-email-gustavo@las.ic.unicamp.br>
References: <1233873586-7149-1-git-send-email-gustavo@las.ic.unicamp.br>
 <1233873586-7149-2-git-send-email-gustavo@las.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, with these macros, x86_64 code can know where start the
permanent and non-permanent fixed mapped address.
This patch make these macros equal fixmap_32.h for future
x86 integration.

Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
Acked-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/include/asm/fixmap_64.h |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/fixmap_64.h b/arch/x86/include/asm/fixmap_64.h
index 00a30ab..678b9c5 100644
--- a/arch/x86/include/asm/fixmap_64.h
+++ b/arch/x86/include/asm/fixmap_64.h
@@ -73,8 +73,11 @@ enum fixed_addresses {
 };
 
 #define FIXADDR_TOP	(VSYSCALL_END-PAGE_SIZE)
-#define FIXADDR_SIZE	(__end_of_fixed_addresses << PAGE_SHIFT)
-#define FIXADDR_START	(FIXADDR_TOP - FIXADDR_SIZE)
+
+#define FIXADDR_SIZE	(__end_of_permanent_fixed_addresses << PAGE_SHIFT)
+#define FIXADDR_BOOT_SIZE	(__end_of_fixed_addresses << PAGE_SHIFT)
+#define FIXADDR_START		(FIXADDR_TOP - FIXADDR_SIZE)
+#define FIXADDR_BOOT_START	(FIXADDR_TOP - FIXADDR_BOOT_SIZE)
 
 /* Only covers 32bit vsyscalls currently. Need another set for 64bit. */
 #define FIXADDR_USER_START	((unsigned long)VSYSCALL32_VSYSCALL)
-- 
1.5.6.4

