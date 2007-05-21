Return-Path: <linux-kernel-owner+w=401wt.eu-S1762886AbXEUKMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762886AbXEUKMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761627AbXEUKJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:09:22 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:1813 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757407AbXEUKJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:09:13 -0400
X-IronPort-AV: i="4.14,560,1170651600"; 
   d="scan'208"; a="30505447:sNHT22367982"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Mike Frysinger <michael.frysinger@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 24/32] Blackfin arch: cache SWRST value at bootup so other things like watchdog can non-destructively query it
Date: Mon, 21 May 2007 18:09:32 +0800
Message-Id: <11797421872382-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1179742180228-git-send-email-bryan.wu@analog.com>
References: <1179742180228-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <michael.frysinger@analog.com>

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/kernel/setup.c       |    8 ++++++++
 include/asm-blackfin/bfin-global.h |    1 +
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index b6ac6f8..02dc743 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -43,6 +43,8 @@
 #include <asm/blackfin.h>
 #include <asm/cplbinit.h>
 
+u16 _bfin_swrst;
+
 unsigned long memory_start, memory_end, physical_mem_end;
 unsigned long reserved_mem_dcache_on;
 unsigned long reserved_mem_icache_on;
@@ -381,6 +383,12 @@ void __init setup_arch(char **cmdline_p)
 	if (l1_length > L1_DATA_A_LENGTH)
 		panic("L1 memory overflow\n");
 
+#ifdef BF561_FAMILY
+	_bfin_swrst = bfin_read_SICA_SWRST();
+#else
+	_bfin_swrst = bfin_read_SWRST();
+#endif
+
 	bf53x_cache_init();
 
 	printk(KERN_INFO "Hardware Trace Enabled\n");
diff --git a/include/asm-blackfin/bfin-global.h b/include/asm-blackfin/bfin-global.h
index e37f816..57f37cc 100644
--- a/include/asm-blackfin/bfin-global.h
+++ b/include/asm-blackfin/bfin-global.h
@@ -104,6 +104,7 @@ extern unsigned long dpdt_swapcount_table[];
 
 extern unsigned long table_start, table_end;
 
+extern u16 _bfin_swrst; /* shadow for Software Reset Register (SWRST) */
 extern struct file_operations dpmc_fops;
 extern char _start;
 extern unsigned long _ramstart, _ramend, _rambase;
-- 
1.5.1.2
