Return-Path: <linux-kernel-owner+w=401wt.eu-S1753975AbYKBCY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbYKBCY3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 22:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbYKBCXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 22:23:44 -0400
Received: from argonath.las.ic.unicamp.br ([143.106.60.116]:34655 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbYKBCXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 22:23:43 -0400
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: linux-kernel@vger.kernel.org
Cc: glommer@redhat.com, mingo@elte.hu
Subject: [PATCH 2/6] x86: define FIXADDR_BOOT_* and redefine FIX_ADDR_SIZE
Date: Sun,  2 Nov 2008 00:23:49 -0200
Message-Id: <1225592633-9948-3-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1225592633-9948-2-git-send-email-gustavo@las.ic.unicamp.br>
References: <1225592633-9948-1-git-send-email-gustavo@las.ic.unicamp.br>
 <1225592633-9948-2-git-send-email-gustavo@las.ic.unicamp.br>
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

