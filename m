Return-Path: <linux-kernel-owner+w=401wt.eu-S1762742AbZE2SzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762742AbZE2SzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 14:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbZE2SzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 14:55:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:57257 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363AbZE2SzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 14:55:11 -0400
Date: Fri, 29 May 2009 18:54:32 GMT
From: tip-bot for Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       seto.hidetoshi@jp.fujitsu.com, ak@linux.intel.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       seto.hidetoshi@jp.fujitsu.com, ak@linux.intel.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <49CB3F38.7090703@jp.fujitsu.com>
References: <49CB3F38.7090703@jp.fujitsu.com>
Subject: [tip:x86/mce3] x86, mce: Cleanup param parser
Message-ID: <tip-13503fa9137d9708d52214e9506c671dbf2fbdce@git.kernel.org>
Git-Commit-ID: 13503fa9137d9708d52214e9506c671dbf2fbdce
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 29 May 2009 18:54:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  13503fa9137d9708d52214e9506c671dbf2fbdce
Gitweb:     http://git.kernel.org/tip/13503fa9137d9708d52214e9506c671dbf2fbdce
Author:     Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
AuthorDate: Thu, 26 Mar 2009 17:39:20 +0900
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 28 May 2009 09:24:09 -0700

x86, mce: Cleanup param parser

- Fix the comment formatting.

- The error path does not return 0, and printk lacks level and "\n".

- Move __setup("nomce") next to mcheck_disable().

- Improve readability etc.

[ Impact: cleanup ]

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <49CB3F38.7090703@jp.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>


---
 arch/x86/kernel/cpu/mcheck/mce_64.c |   24 ++++++++++++++----------
 1 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_64.c b/arch/x86/kernel/cpu/mcheck/mce_64.c
index 6fb0b35..77effb5 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -839,25 +839,29 @@ static int __init mcheck_disable(char *str)
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
