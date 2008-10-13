Return-Path: <linux-kernel-owner+w=401wt.eu-S1760436AbYJMW7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760436AbYJMW7m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 18:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755978AbYJMW7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 18:59:33 -0400
Received: from smtp.cs.aau.dk ([130.225.194.6]:46259 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760164AbYJMW7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 18:59:32 -0400
Subject: [PATCH] x86: fix compile warning for !CONFIG_X86_RESERVE_LOW_64K
	builds
From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=utf-8
Date: Tue, 14 Oct 2008 01:01:24 +0200
Message-Id: <1223938884.21717.22.camel@odie.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following compile warning for !CONFIG_X86_RESERVE_LOW_64K builds

arch/x86/kernel/setup.c:736: warning: 'dmi_low_memory_corruption' defined but not used

that was introduced by fc381519 (x86: add X86_RESERVE_LOW_64K).

Signed-off-by: Simon Holm Thøgersen <odie@cs.aau.dk>
---
 arch/x86/kernel/setup.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 2255782..dac8325 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -732,6 +732,7 @@ void start_periodic_check_for_corruption(void)
 }
 #endif
 
+#ifdef CONFIG_X86_RESERVE_LOW_64K
 static int __init dmi_low_memory_corruption(const struct dmi_system_id *d)
 {
 	printk(KERN_NOTICE
@@ -746,7 +747,6 @@ static int __init dmi_low_memory_corruption(const struct dmi_system_id *d)
 
 /* List of systems that have known low memory corruption BIOS problems */
 static struct dmi_system_id __initdata bad_bios_dmi_table[] = {
-#ifdef CONFIG_X86_RESERVE_LOW_64K
 	{
 		.callback = dmi_low_memory_corruption,
 		.ident = "AMI BIOS",
@@ -761,9 +761,12 @@ static struct dmi_system_id __initdata bad_bios_dmi_table[] = {
 			DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies, LTD"),
 		},
 	},
-#endif
 	{}
 };
+#else
+static struct dmi_system_id __initdata bad_bios_dmi_table[] = {{}};
+#endif
+
 
 /*
  * Determine if we were loaded by an EFI loader.  If so, then we have also been
-- 
1.5.6.2.255.gbed62

