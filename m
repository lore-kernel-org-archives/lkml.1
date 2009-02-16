Return-Path: <linux-kernel-owner+w=401wt.eu-S1756267AbZBPAvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267AbZBPAvU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 19:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756104AbZBPAu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 19:50:27 -0500
Received: from everest.las.ic.unicamp.br ([143.106.60.118]:41756 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756010AbZBPAu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 19:50:26 -0500
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: mingo@elte.hu
Cc: glommer@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] x86: Add CONFIG_X86_{LOCAL,IO}_APIC
Date: Sun, 15 Feb 2009 21:48:55 -0300
Message-Id: <1234745339-18587-5-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1234745339-18587-4-git-send-email-gustavo@las.ic.unicamp.br>
References: <1234745339-18587-1-git-send-email-gustavo@las.ic.unicamp.br>
 <1234745339-18587-2-git-send-email-gustavo@las.ic.unicamp.br>
 <1234745339-18587-3-git-send-email-gustavo@las.ic.unicamp.br>
 <1234745339-18587-4-git-send-email-gustavo@las.ic.unicamp.br>
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
index b6c06dd..7a518ec 100644
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
1.6.0.6

