Return-Path: <linux-kernel-owner+w=401wt.eu-S1765456AbXINC6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765456AbXINC6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 22:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754845AbXINC6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 22:58:11 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:54603 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbXINC6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 22:58:09 -0400
Message-Id: <46E9F8C3.3070105@mxs.nes.nec.co.jp>
Date: Fri, 14 Sep 2007 11:58:11 +0900
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Adrian Bunk <bunk@kernel.org>, kexec-ml <kexec@lists.infradead.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] [-mm patch]  Use the existing ia64_tpa() instead of asm
 code.
References: <46E9F6A9.8060500@mxs.nes.nec.co.jp>
In-Reply-To: <46E9F6A9.8060500@mxs.nes.nec.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[3/4] Use the existing ia64_tpa() instead of asm code.


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

