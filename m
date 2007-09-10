Return-Path: <linux-kernel-owner+w=401wt.eu-S1756476AbXIJH2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476AbXIJH2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 03:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755240AbXIJH2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 03:28:13 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:61952 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945AbXIJH2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 03:28:12 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kexec-ml <kexec@lists.infradead.org>, lkml <linux-kernel@vger.kernel.org>,
       "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
Subject: [PATCH 3/3] [-mm patch] Use the existing ia64_tpa() instead of asm code
In-reply-to: <20070910162305oomichi@mail.jp.nec.com>
Message-Id: <20070910162813oomichi@mail.jp.nec.com>
References: <20070910162305oomichi@mail.jp.nec.com>
Mime-Version: 1.0
X-Mailer: WeMail32[2.51] ID:5W0000
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
Date: Mon, 10 Sep 2007 16:28:13 +0900
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[3/3] Use the existing ia64_tpa() instead of asm code.


Thanks
Ken'ichi Ohmichi

---
Signed-off-by: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>

---
diff -rpuN a/arch/ia64/kernel/machine_kexec.c b/arch/ia64/kernel/machine_kexec.c
--- a/arch/ia64/kernel/machine_kexec.c	2007-09-10 23:30:33.000000000 +0900
+++ b/arch/ia64/kernel/machine_kexec.c	2007-09-10 23:31:37.000000000 +0900
@@ -21,6 +21,7 @@
 #include <asm/setup.h>
 #include <asm/delay.h>
 #include <asm/meminit.h>
+#include <asm/processor.h>
 
 typedef NORET_TYPE void (*relocate_new_kernel_t)(
 					unsigned long indirection_page,
@@ -149,9 +150,6 @@ void arch_crash_save_vmcoreinfo(void)
 
 unsigned long paddr_vmcoreinfo_note(void)
 {
-	unsigned long vaddr, paddr;
-	vaddr = (unsigned long)(char *)&vmcoreinfo_note;
-	asm volatile ("tpa %0 = %1" : "=r"(paddr) : "r"(vaddr) : "memory");
-	return paddr;
+	return ia64_tpa((unsigned long)(char *)&vmcoreinfo_note);
 }
 
_
