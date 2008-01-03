Return-Path: <linux-kernel-owner+w=401wt.eu-S1761466AbYACBBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761466AbYACBBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 20:01:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759941AbYACBBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 20:01:38 -0500
Received: from mga10.intel.com ([192.55.52.92]:46686 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759668AbYACBBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 20:01:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,237,1196668800"; 
   d="scan'208";a="268516256"
Message-ID: <477C3375.1000809@linux.intel.com>
Date: Thu, 03 Jan 2008 01:59:33 +0100
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 3/3] consolidate oops end/ID printing code in panic.c
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: consolidate oops end/ID printing code in panic.c
From: Arjan van de Ven <arjan@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>

This patch consolidates the 2 places that print an oops end marker and ID
into a single function; this patch follows the WARN_ON uninline and the
WARN_ON enhancement patches.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

---
  kernel/panic.c |   15 +++++++++------
  1 file changed, 9 insertions(+), 6 deletions(-)

Index: linux-2.6.24-rc6/kernel/panic.c
===================================================================
--- linux-2.6.24-rc6.orig/kernel/panic.c
+++ linux-2.6.24-rc6/kernel/panic.c
@@ -281,6 +281,13 @@ static int init_oops_id(void)
  }
  late_initcall(init_oops_id);

+static void print_oops_end_marker(void)
+{
+	init_oops_id();
+	printk(KERN_WARNING "---[ end trace %016llx ]---\n",
+		(unsigned long long)oops_id);
+}
+
  /*
   * Called when the architecture exits its oops handler, after printing
   * everything.
@@ -288,9 +295,7 @@ late_initcall(init_oops_id);
  void oops_exit(void)
  {
  	do_oops_enter_exit();
-	init_oops_id();
-	printk(KERN_WARNING "---[ end trace %016llx ]---\n",
-		(unsigned long long)oops_id);
+	print_oops_end_marker();
  }

  int do_warn_on(const unsigned long condition, const char *file,
@@ -302,9 +307,7 @@ int do_warn_on(const unsigned long condi
  			__FILE__, __LINE__, __FUNCTION__);
  		print_modules();
  		dump_stack();
-		init_oops_id();
-		printk(KERN_WARNING "---[ end trace %016llx ]---\n",
-			(unsigned long long)oops_id);
+		print_oops_end_marker();
  	}
  	return !!condition;
  }
