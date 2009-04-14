Return-Path: <linux-kernel-owner+w=401wt.eu-S1755790AbZDNPxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790AbZDNPxP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 11:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755344AbZDNPvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 11:51:47 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45967 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754965AbZDNPvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 11:51:45 -0400
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 03/14] [VOYAGER] x86: add prefill_possible_map to x86_quirks
Date: Tue, 14 Apr 2009 10:51:29 -0500
Message-Id: <1239724300-16371-4-git-send-email-James.Bottomley@HansenPartnership.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1239724300-16371-3-git-send-email-James.Bottomley@HansenPartnership.com>
References: <1239724300-16371-1-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-2-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-3-git-send-email-James.Bottomley@HansenPartnership.com>
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
index bdc2ada..56c99eb 100644
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
index b415843..17fc85f 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -960,7 +960,10 @@ void __init setup_arch(char **cmdline_p)
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
1.6.2.1

