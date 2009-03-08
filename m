Return-Path: <linux-kernel-owner+w=401wt.eu-S1753822AbZCHQt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbZCHQt0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 12:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbZCHQsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 12:48:38 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52169 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753206AbZCHQsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 12:48:37 -0400
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 03/13] [VOYAGER] x86: add prefill_possible_map to x86_quirks
Date: Sun,  8 Mar 2009 11:48:16 -0500
Message-Id: <1236530906-7175-4-git-send-email-James.Bottomley@HansenPartnership.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1236530906-7175-3-git-send-email-James.Bottomley@HansenPartnership.com>
References: <1236530906-7175-1-git-send-email-James.Bottomley@HansenPartnership.com>
 <1236530906-7175-2-git-send-email-James.Bottomley@HansenPartnership.com>
 <1236530906-7175-3-git-send-email-James.Bottomley@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Voyager needs a different prefill of the possible map, so abstract the
operation through the x86 quirks mechanism.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 arch/x86/include/asm/setup.h |    1 +
 arch/x86/kernel/setup.c      |    5 ++++-
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index 05c6f6b..7782327 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -31,6 +31,7 @@ struct x86_quirks {
 	void (*smp_read_mpc_oem)(struct mpc_oemtable *oemtable,
 				unsigned short oemsize);
 	int (*setup_ioapic_ids)(void);
+	void (*prefill_possible_map)(void);
 };
 
 extern void x86_quirk_pre_intr_init(void);
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 4c54bc0..797f7d7 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -937,7 +937,10 @@ void __init setup_arch(char **cmdline_p)
 		get_smp_config();
 #endif
 
-	prefill_possible_map();
+	if (x86_quirks->prefill_possible_map)
+		x86_quirks->prefill_possible_map();
+	else
+		prefill_possible_map();
 
 #ifdef CONFIG_X86_64
 	init_cpu_to_node();
-- 
1.6.1.3

