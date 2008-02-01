Return-Path: <linux-kernel-owner+w=401wt.eu-S1765931AbYBAE5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765931AbYBAE5O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 23:57:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932325AbYBAEnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 23:43:10 -0500
Received: from mga10.intel.com ([192.55.52.92]:46275 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763369AbYBAEmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 23:42:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,288,1199692800"; 
   d="scan'208";a="511516637"
From: Len Brown <lenb@kernel.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <len.brown@intel.com>
Subject: [PATCH 34/37] Suspend: Clean up suspend_64.c
Date: Thu, 31 Jan 2008 23:37:05 -0500
Message-Id: <31210f178861d7584cab1bca12ccd5547194d9eb.1201840183.git.len.brown@intel.com>
X-Mailer: git-send-email 1.5.4.rc5.16.gc0279
In-Reply-To: <1201840628-23136-1-git-send-email-lenb@kernel.org>
References: <1201840628-23136-1-git-send-email-lenb@kernel.org>
In-Reply-To: <edae89f5d1eb1fbe1cab74333db5a8e29776900e.1201840183.git.len.brown@intel.com>
References: <edae89f5d1eb1fbe1cab74333db5a8e29776900e.1201840183.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bbpetkov@yahoo.de>

There's a freakishly long comment in suspend_64.c, shorten it.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/x86/kernel/suspend_64.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/suspend_64.c b/arch/x86/kernel/suspend_64.c
index 0919951..7ac7130 100644
--- a/arch/x86/kernel/suspend_64.c
+++ b/arch/x86/kernel/suspend_64.c
@@ -140,7 +140,12 @@ static void fix_processor_context(void)
 	int cpu = smp_processor_id();
 	struct tss_struct *t = &per_cpu(init_tss, cpu);
 
-	set_tss_desc(cpu,t);	/* This just modifies memory; should not be necessary. But... This is necessary, because 386 hardware has concept of busy TSS or some similar stupidity. */
+	/*
+	 * This just modifies memory; should not be necessary. But... This
+	 * is necessary, because 386 hardware has concept of busy TSS or some
+	 * similar stupidity.
+	 */
+	set_tss_desc(cpu, t);
 
 	get_cpu_gdt_table(cpu)[GDT_ENTRY_TSS].type = 9;
 
@@ -160,7 +165,6 @@ static void fix_processor_context(void)
                 loaddebug(&current->thread, 6);
                 loaddebug(&current->thread, 7);
 	}
-
 }
 
 #ifdef CONFIG_HIBERNATION
-- 
1.5.4.rc5.16.gc0279

