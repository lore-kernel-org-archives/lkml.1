Return-Path: <linux-kernel-owner+w=401wt.eu-S965627AbXIGUiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965627AbXIGUiS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 16:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbXIGUiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 16:38:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:39339 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbXIGUiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 16:38:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,222,1186383600"; 
   d="scan'208";a="128411174"
Date: Sat, 8 Sep 2007 13:50:45 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: akpm@osdl.org, Linux Kernel <linux-kernel@vger.kernel.org>
Cc: suresh.b.siddha@intel.com
Subject: [patch] Fix BIOS-e820 end address
Message-ID: <20070908205044.GA16419@askeshav-devel.jf.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [patch] Fix BIOS-e820 end address

--snip of boot message--
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007fe8cc00 (usable)
----end snip---

As you see from above the address 0000000000100000 is both
shown as reserved and usable which is confusing.

This patch fixes the BIOS-e820 end address.

Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>

---
 arch/i386/kernel/e820.c   |    2 +-
 arch/x86_64/kernel/e820.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: work/arch/i386/kernel/e820.c
===================================================================
--- work.orig/arch/i386/kernel/e820.c	2007-09-08 12:00:33.000000000 -0700
+++ work/arch/i386/kernel/e820.c	2007-09-08 13:39:12.000000000 -0700
@@ -753,7 +753,7 @@
 	for (i = 0; i < e820.nr_map; i++) {
 		printk(" %s: %016Lx - %016Lx ", who,
 			e820.map[i].addr,
-			e820.map[i].addr + e820.map[i].size);
+			e820.map[i].addr + e820.map[i].size - 1);
 		switch (e820.map[i].type) {
 		case E820_RAM:	printk("(usable)\n");
 				break;
Index: work/arch/x86_64/kernel/e820.c
===================================================================
--- work.orig/arch/x86_64/kernel/e820.c	2007-09-08 12:00:46.000000000 -0700
+++ work/arch/x86_64/kernel/e820.c	2007-09-08 13:38:57.000000000 -0700
@@ -368,7 +368,7 @@
 	for (i = 0; i < e820.nr_map; i++) {
 		printk(KERN_INFO " %s: %016Lx - %016Lx ", who,
 			(unsigned long long) e820.map[i].addr,
-			(unsigned long long) (e820.map[i].addr + e820.map[i].size));
+			(unsigned long long) (e820.map[i].addr + e820.map[i].size - 1));
 		switch (e820.map[i].type) {
 		case E820_RAM:	printk("(usable)\n");
 				break;
