Return-Path: <linux-kernel-owner+w=401wt.eu-S1754391AbYJTWX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbYJTWX4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 18:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752390AbYJTWXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 18:23:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:5322 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208AbYJTWXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 18:23:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,454,1220252400"; 
   d="scan'208";a="629532568"
Date: Mon, 20 Oct 2008 15:23:40 -0700
Message-Id: <200810202223.m9KMNeSY024823@agluck-lia64.sc.intel.com>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] kexec build fix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/kexec.c: In function 'crash_save_vmcoreinfo_init':
kernel/kexec.c:1374: error: 'vmlist' undeclared (first use in this function)
kernel/kexec.c:1374: error: (Each undeclared identifier is reported only once
kernel/kexec.c:1374: error: for each function it appears in.)
kernel/kexec.c:1410: error: invalid use of undefined type 'struct vm_struct'
make[1]: *** [kernel/kexec.o] Error 1

Signed-off-by: Tony Luck <tony.luck@intel.com>

---

diff --git a/kernel/kexec.c b/kernel/kexec.c
index 777ac45..ac0fde7 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -30,6 +30,7 @@
 #include <linux/pm.h>
 #include <linux/cpu.h>
 #include <linux/console.h>
+#include <linux/vmalloc.h>
 
 #include <asm/page.h>
 #include <asm/uaccess.h>
