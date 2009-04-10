Return-Path: <linux-kernel-owner+w=401wt.eu-S936649AbZDJRhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936649AbZDJRhc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 13:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760130AbZDJRhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 13:37:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:34410 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757617AbZDJRhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 13:37:12 -0400
Subject: [PATCH -tip] x86: acpi/sleep.c saved_magic fix overflow
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 10 Apr 2009 23:06:55 +0530
Message-Id: <1239385015.3169.15.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix overflow

Constant 0x123456789abcdef0 is so big for a long.
So using saved_magic 0x12345678 for both 32 and 64 bit.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/acpi/sleep.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 7c243a2..1ad317a 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -94,7 +94,6 @@ int acpi_save_state_mem(void)
 #ifndef CONFIG_64BIT
 	header->pmode_entry = (u32)&wakeup_pmode_return;
 	header->pmode_cr3 = (u32)(swsusp_pg_dir - __PAGE_OFFSET);
-	saved_magic = 0x12345678;
 #else /* CONFIG_64BIT */
 	header->trampoline_segment = setup_trampoline() >> 4;
 #ifdef CONFIG_SMP
@@ -104,8 +103,8 @@ int acpi_save_state_mem(void)
 	initial_gs = per_cpu_offset(smp_processor_id());
 #endif
 	initial_code = (unsigned long)wakeup_long64;
-	saved_magic = 0x123456789abcdef0;
 #endif /* CONFIG_64BIT */
+	saved_magic = 0x12345678;
 
 	return 0;
 }
-- 
1.6.0.6



