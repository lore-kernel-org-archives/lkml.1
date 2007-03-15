Return-Path: <linux-kernel-owner+w=401wt.eu-S965233AbXCOFSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965233AbXCOFSl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 01:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965418AbXCOFRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 01:17:42 -0400
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:52067 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965254AbXCOFQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 01:16:49 -0400
Message-Id: <20070315051532.935868806@goodmis.org>
References: <20070315051337.488091591@goodmis.org>
User-Agent: quilt/0.45-1
Date: Thu, 15 Mar 2007 01:13:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH take3 19/20] hugetlbpage.c switch
Content-Disposition: inline; filename=20-hugetlbpage.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move the hugetlbpage.c to the common area.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/arch/i386/Makefile b/arch/i386/Makefile
index d73a830..06dd07e 100644
--- a/arch/i386/Makefile
+++ b/arch/i386/Makefile
@@ -102,6 +102,7 @@ libs-y 					+= arch/i386/lib/
 core-y					+= arch/i386/kernel/ \
 					   arch/x86/kernel/ \
 					   arch/i386/mm/ \
+					   arch/x86/mm/ \
 					   arch/i386/$(mcore-y)/ \
 					   arch/i386/crypto/
 drivers-$(CONFIG_MATH_EMULATION)	+= arch/i386/math-emu/
diff --git a/arch/i386/mm/Makefile b/arch/i386/mm/Makefile
index 80908b5..0cb01e6 100644
--- a/arch/i386/mm/Makefile
+++ b/arch/i386/mm/Makefile
@@ -5,6 +5,5 @@
 obj-y	:= init.o pgtable.o fault.o ioremap.o extable.o pageattr.o mmap.o
 
 obj-$(CONFIG_NUMA) += discontig.o
-obj-$(CONFIG_HUGETLB_PAGE) += hugetlbpage.o
 obj-$(CONFIG_HIGHMEM) += highmem.o
 obj-$(CONFIG_BOOT_IOREMAP) += boot_ioremap.o
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
new file mode 100644
index 0000000..1b6e922
--- /dev/null
+++ b/arch/x86/mm/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_HUGETLB_PAGE) += hugetlbpage.o
diff --git a/arch/i386/mm/hugetlbpage.c b/arch/x86/mm/hugetlbpage.c
similarity index 100%
rename from arch/i386/mm/hugetlbpage.c
rename to arch/x86/mm/hugetlbpage.c
diff --git a/arch/x86_64/Makefile b/arch/x86_64/Makefile
index 3cf9198..abf1829 100644
--- a/arch/x86_64/Makefile
+++ b/arch/x86_64/Makefile
@@ -81,6 +81,7 @@ libs-y 					+= arch/x86_64/lib/
 core-y					+= arch/x86_64/kernel/ \
 					   arch/x86/kernel/ \
 					   arch/x86_64/mm/ \
+					   arch/x86/mm/ \
 					   arch/x86_64/crypto/
 core-$(CONFIG_IA32_EMULATION)		+= arch/x86_64/ia32/
 drivers-$(CONFIG_PCI)			+= arch/x86_64/pci/
diff --git a/arch/x86_64/mm/Makefile b/arch/x86_64/mm/Makefile
index d25ac86..b6f1f43 100644
--- a/arch/x86_64/mm/Makefile
+++ b/arch/x86_64/mm/Makefile
@@ -3,9 +3,7 @@
 #
 
 obj-y	 := init.o fault.o ioremap.o extable.o pageattr.o mmap.o
-obj-$(CONFIG_HUGETLB_PAGE) += hugetlbpage.o
 obj-$(CONFIG_NUMA) += numa.o
 obj-$(CONFIG_K8_NUMA) += k8topology.o
 obj-$(CONFIG_ACPI_NUMA) += srat.o
 
-hugetlbpage-y = ../../i386/mm/hugetlbpage.o

--
