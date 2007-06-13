Return-Path: <linux-kernel-owner+w=401wt.eu-S1756771AbXFMH0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbXFMH0t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 03:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755860AbXFMH0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 03:26:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:56555 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755843AbXFMH0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 03:26:41 -0400
Date: Wed, 13 Jun 2007 09:26:30 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: William Lee Irwin III <wli@holomorphy.com>
cc: linux-kernel@vger.kernel.org, Adrian Bunk <bunk@stusta.de>
Subject: Re: divorce CONFIG_X86_PAE from CONFIG_HIGHMEM64G
Message-ID: <Pine.LNX.4.58.0706130809240.2702@be1.lrz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX189BQNyNb/wW3c0kz7g1ZWnJigrmz0v1/YUAVu
 xjiuWZN7RDs+cC4+lhc8otbq73aYeBDjOew/b2TyqRagn4Pnt7
 Vkuhst0/5ndlBXuWNxd9g==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since your (William) patch will change the kconfig files my proposed patch
would change, could you please add those changes? 

I hand-updated the patch below as recommended by the original discussion 
on LKML. It won't aply as-is because of that (and because of your changes).


--- 2.6.21/arch/i386/Kconfig.ori	2007-06-06 13:41:09.000000000 +0200
+++ 2.6.21/arch/i386/Kconfig	2007-06-06 14:07:40.000000000 +0200
@@ -495,8 +495,8 @@ config NOHIGHMEM
 	bool "off"
 	depends on !X86_NUMAQ
 	---help---
-	  Linux can use up to 64 Gigabytes of physical memory on x86 systems.
-	  However, the address space of 32-bit x86 processors is only 4
+	  Linux can use up to 64 Gigabytes of physical address space on x86
+	  systems. However, the address space of 32-bit x86 processors is only 4
 	  Gigabytes large. That means that, if you have a large amount of
 	  physical memory, not all of it can be "permanently mapped" by the
 	  kernel. The physical memory that's not permanently mapped is called
@@ -510,8 +510,15 @@ config NOHIGHMEM
 	  by the kernel to permanently map as much physical memory as
 	  possible.
 
-	  If the machine has between 1 and 4 Gigabytes physical RAM, then
+
+	  If the machine has between 1 and about 3 Gigabytes physical RAM, 
+         then
 	  answer "4GB" here.
+	  
+	  The PCI address space will usually take 512 MB or 1 GB of address
+	  space. This address space is unavailable to RAM, but depending on the
+	  chipset (and BIOS settings), memory overlapping the PCI address space
+	  may be mapped beyond the 4 GB limit and be available using "64GB".
+
 
 	  If more than 4 Gigabytes is used then answer "64GB" here. This
 	  selection turns Intel PAE (Physical Address Extension) mode on.
@@ -520,6 +527,10 @@ config NOHIGHMEM
 	  processors (Pentium Pro and better). NOTE: If you say "64GB" here,
 	  then the kernel will not boot on CPUs that don't support PAE!
 
+	  An additional benefit of the 64GB-Mode is the availability of the
+	  no-execute-pageflag, which can be used to prevent some attacks from
+	  injecting malicious code into applications.
+
 	  The actual amount of total physical memory will either be
 	  auto detected or can be forced by using a kernel command line option
 	  such as "mem=256M". (Try "man bootparam" or see the documentation of
@@ -532,14 +543,14 @@ config HIGHMEM4G
 	bool "4GB"
 	depends on !X86_NUMAQ
 	help
-	  Select this if you have a 32-bit processor and between 1 and 4
+	  Select this if you have a 32-bit processor and between 1 and 3
 	  gigabytes of physical RAM.
 
 config HIGHMEM64G
-	bool "64GB"
+	bool "64GB (enables no-execute memory protection if available)"
 	depends on X86_CMPXCHG64
 	help
-	  Select this if you have a 32-bit processor and more than 4
+	  Select this if you have a 32-bit processor and more than 3
 	  gigabytes of physical RAM.
 
 endchoice
-- 
RAM DISK is not an installation procedure! 
