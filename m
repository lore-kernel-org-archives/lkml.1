Return-Path: <linux-kernel-owner+w=401wt.eu-S1756569AbZBPAu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569AbZBPAu6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 19:50:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755281AbZBPAuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 19:50:21 -0500
Received: from everest.las.ic.unicamp.br ([143.106.60.118]:41730 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885AbZBPAuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 19:50:20 -0500
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: mingo@elte.hu
Cc: glommer@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] x86: define FIXADDR_BOOT_* and redefine FIX_ADDR_SIZE
Date: Sun, 15 Feb 2009 21:48:53 -0300
Message-Id: <1234745339-18587-3-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1234745339-18587-2-git-send-email-gustavo@las.ic.unicamp.br>
References: <1234745339-18587-1-git-send-email-gustavo@las.ic.unicamp.br>
 <1234745339-18587-2-git-send-email-gustavo@las.ic.unicamp.br>
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
index 298d9ba..d905de0 100644
--- a/arch/x86/include/asm/fixmap_64.h
+++ b/arch/x86/include/asm/fixmap_64.h
@@ -69,8 +69,11 @@ enum fixed_addresses {
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
1.6.0.6

