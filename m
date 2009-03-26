Return-Path: <linux-kernel-owner+w=401wt.eu-S1757643AbZCZIkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643AbZCZIkP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 04:40:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757517AbZCZIjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 04:39:44 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54931 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757310AbZCZIjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 04:39:42 -0400
Message-ID: <49CB3F38.7090703@jp.fujitsu.com>
Date: Thu, 26 Mar 2009 17:39:20 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH -tip 2/3] x86, mce: Cleanup param parser
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Fix the comment formatting.
- The error path does not return 0, and printk lacks level and "\n".
- Move __setup("nomce") next to mcheck_disable().
- Improve readability etc.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/mcheck/mce_64.c |   24 ++++++++++++++----------
 1 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_64.c b/arch/x86/kernel/cpu/mcheck/mce_64.c
index 863f895..33d612e 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -838,25 +838,29 @@ static int __init mcheck_disable(char *str)
 	mce_dont_init = 1;
 	return 1;
 }
+__setup("nomce", mcheck_disable);
 
-/* mce=off disables machine check.
-   mce=TOLERANCELEVEL (number, see above)
-   mce=bootlog Log MCEs from before booting. Disabled by default on AMD.
-   mce=nobootlog Don't log MCEs from before booting. */
+/*
+ * mce=off disables machine check
+ * mce=TOLERANCELEVEL (number, see above)
+ * mce=bootlog Log MCEs from before booting. Disabled by default on AMD.
+ * mce=nobootlog Don't log MCEs from before booting.
+ */
 static int __init mcheck_enable(char *str)
 {
 	if (!strcmp(str, "off"))
 		mce_dont_init = 1;
-	else if (!strcmp(str, "bootlog") || !strcmp(str,"nobootlog"))
-		mce_bootlog = str[0] == 'b';
+	else if (!strcmp(str, "bootlog") || !strcmp(str, "nobootlog"))
+		mce_bootlog = (str[0] == 'b');
 	else if (isdigit(str[0]))
 		get_option(&str, &tolerant);
-	else
-		printk("mce= argument %s ignored. Please use /sys", str);
+	else {
+		printk(KERN_INFO "mce= argument %s ignored. Please use /sys\n",
+		       str);
+		return 0;
+	}
 	return 1;
 }
-
-__setup("nomce", mcheck_disable);
 __setup("mce=", mcheck_enable);
 
 /*
-- 
1.6.2.1


