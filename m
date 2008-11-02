Return-Path: <linux-kernel-owner+w=401wt.eu-S1754159AbYKBCY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbYKBCY7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 22:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbYKBCXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 22:23:45 -0400
Received: from argonath.las.ic.unicamp.br ([143.106.60.116]:34655 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbYKBCXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 22:23:44 -0400
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: linux-kernel@vger.kernel.org
Cc: glommer@redhat.com, mingo@elte.hu
Subject: [PATCH 4/6] x86: Add CONFIG_X86_{LOCAL,IO}_APIC
Date: Sun,  2 Nov 2008 00:23:51 -0200
Message-Id: <1225592633-9948-5-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1225592633-9948-4-git-send-email-gustavo@las.ic.unicamp.br>
References: <1225592633-9948-1-git-send-email-gustavo@las.ic.unicamp.br>
 <1225592633-9948-2-git-send-email-gustavo@las.ic.unicamp.br>
 <1225592633-9948-3-git-send-email-gustavo@las.ic.unicamp.br>
 <1225592633-9948-4-git-send-email-gustavo@las.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add CONFIG_X86_{LOCAL,IO}_APIC to enum fixed_address.
FIX_APIC_BASE is used only when CONFIG_X86_LOCAL_APIC is
enabled and FIX_IO_APIC_BASE_* are used only when
CONFIG_X86_IO_APIC is enabled.

Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
Acked-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/include/asm/fixmap_64.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/fixmap_64.h b/arch/x86/include/asm/fixmap_64.h
index 773b657..8a328fc 100644
--- a/arch/x86/include/asm/fixmap_64.h
+++ b/arch/x86/include/asm/fixmap_64.h
@@ -40,9 +40,13 @@ enum fixed_addresses {
 	VSYSCALL_HPET,
 	FIX_DBGP_BASE,
 	FIX_EARLYCON_MEM_BASE,
+#ifdef CONFIG_X86_LOCAL_APIC
 	FIX_APIC_BASE,	/* local (CPU) APIC) -- required for SMP or not */
+#endif
+#ifdef CONFIG_X86_IO_APIC
 	FIX_IO_APIC_BASE_0,
 	FIX_IO_APIC_BASE_END = FIX_IO_APIC_BASE_0 + MAX_IO_APICS - 1,
+#endif
 	FIX_EFI_IO_MAP_LAST_PAGE,
 	FIX_EFI_IO_MAP_FIRST_PAGE = FIX_EFI_IO_MAP_LAST_PAGE
 				  + MAX_EFI_IO_PAGES - 1,
-- 
1.5.6.4

