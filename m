Return-Path: <linux-kernel-owner+w=401wt.eu-S1762182AbXEUKKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762182AbXEUKKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757983AbXEUKJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:09:13 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:5145 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756769AbXEUKJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:09:10 -0400
X-IronPort-AV: i="4.14,560,1170651600"; 
   d="scan'208"; a="30505439:sNHT22193983"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 12/32] Blackfin arch: Fix bug using usb keyboard crashes kernel
Date: Mon, 21 May 2007 18:09:20 +0800
Message-Id: <11797421843248-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1179742180228-git-send-email-bryan.wu@analog.com>
References: <1179742180228-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/kernel/setup.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index 342bb8d..c456ee5 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -33,7 +33,6 @@
 #include <linux/seq_file.h>
 #include <linux/cpu.h>
 #include <linux/module.h>
-#include <linux/console.h>
 #include <linux/tty.h>
 
 #include <linux/ext2_fs.h>
@@ -175,6 +174,9 @@ void __init setup_arch(char **cmdline_p)
 	unsigned long mtd_phys = 0;
 #endif
 
+#ifdef CONFIG_DUMMY_CONSOLE
+	conswitchp = &dummy_con;
+#endif
 	cclk = get_cclk();
 	sclk = get_sclk();
 
-- 
1.5.1.2
