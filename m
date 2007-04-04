Return-Path: <linux-kernel-owner+w=401wt.eu-S2992695AbXDDG2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992695AbXDDG2A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 02:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992697AbXDDG2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 02:28:00 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:28480 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992695AbXDDG17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 02:27:59 -0400
X-IronPort-AV: i="4.14,367,1170651600"; 
   d="scan'208"; a="33682515:sNHT27514690"
Subject: [PATCH] Blackfin arch: always include linux kallsysms header file
	in trap c
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Wed, 04 Apr 2007 14:27:23 +0800
Message-Id: <1175668043.10608.34.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] Just include linux/kallsyms.h all the time as the header will
handle prototypes/defines when CONFIG_KALLSYMS is disabled ... fixes
build error when disabled due to print_ip_sym not being macroed away

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/kernel/traps.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index f168521..9556b73 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -35,6 +35,8 @@
 #include <asm/irq_handler.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
+#include <linux/kallsyms.h>
+
 #ifdef CONFIG_KGDB
 # include <linux/debugger.h>
 # include <linux/kgdb.h>
@@ -52,9 +54,6 @@ asmlinkage void trap_c(struct pt_regs *fp);
 
 int kstack_depth_to_print = 48;
 
-#ifdef CONFIG_KALLSYMS
-#include <linux/kallsyms.h>
-#endif
 static int printk_address(unsigned long address)
 {
 	struct vm_list_struct *vml;
-- 
1.5.0.5

