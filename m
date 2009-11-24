Return-Path: <linux-kernel-owner+w=401wt.eu-S932093AbZKXBN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093AbZKXBN0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 20:13:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757613AbZKXBNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 20:13:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:59135 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757599AbZKXBNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 20:13:23 -0500
Date: Tue, 24 Nov 2009 01:13:15 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
In-Reply-To: <20091119202341.GA4420@sgi.com>
References: <20091119202341.GA4420@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86: Change is_ISA_range() into an inline function
Message-ID: <tip-65f116f5f16dc3371fce24fb24bc4843b5380ba5@git.kernel.org>
Git-Commit-ID: 65f116f5f16dc3371fce24fb24bc4843b5380ba5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  65f116f5f16dc3371fce24fb24bc4843b5380ba5
Gitweb:     http://git.kernel.org/tip/65f116f5f16dc3371fce24fb24bc4843b5380ba5
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Mon, 23 Nov 2009 14:44:39 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 23 Nov 2009 17:09:59 -0800

x86: Change is_ISA_range() into an inline function

Change is_ISA_range() from a macro to an inline function.  This makes
it type safe, and also allows it to be assigned to a function pointer
if necessary.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <20091119202341.GA4420@sgi.com>
---
 arch/x86/include/asm/e820.h |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
index 40b4e61..68b4e0e 100644
--- a/arch/x86/include/asm/e820.h
+++ b/arch/x86/include/asm/e820.h
@@ -61,6 +61,12 @@ struct e820map {
 	struct e820entry map[E820_X_MAX];
 };
 
+#define ISA_START_ADDRESS	0xa0000
+#define ISA_END_ADDRESS		0x100000
+
+#define BIOS_BEGIN		0x000a0000
+#define BIOS_END		0x00100000
+
 #ifdef __KERNEL__
 /* see comment in arch/x86/kernel/e820.c */
 extern struct e820map e820;
@@ -126,15 +132,14 @@ extern void e820_reserve_resources(void);
 extern void e820_reserve_resources_late(void);
 extern void setup_memory_map(void);
 extern char *default_machine_specific_memory_setup(void);
-#endif /* __KERNEL__ */
-#endif /* __ASSEMBLY__ */
 
-#define ISA_START_ADDRESS	0xa0000
-#define ISA_END_ADDRESS		0x100000
-#define is_ISA_range(s, e) ((s) >= ISA_START_ADDRESS && (e) < ISA_END_ADDRESS)
+static inline bool is_ISA_range(u64 s, u64 e)
+{
+	return s >= ISA_START_ADDRESS && e < ISA_END_ADDRESS;
+}
 
-#define BIOS_BEGIN		0x000a0000
-#define BIOS_END		0x00100000
+#endif /* __KERNEL__ */
+#endif /* __ASSEMBLY__ */
 
 #ifdef __KERNEL__
 #include <linux/ioport.h>
