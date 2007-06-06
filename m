Return-Path: <linux-kernel-owner+w=401wt.eu-S1765035AbXFFMMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765035AbXFFMMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 08:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758645AbXFFMMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 08:12:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:57006 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbXFFMMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 08:12:33 -0400
Date: Wed, 6 Jun 2007 14:12:22 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: Andi Kleen <andi@firstfloor.org>, tmoore@spatial.ca,
       linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] Re: 4Gb ram not showing up
Message-ID: <Pine.LNX.4.58.0706061356310.2657@be1.lrz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX19riBO5t1H5AXjfPCDwCYXlplM/+tpXT0IXtl6
 5bN1lXLOiV9fFowgHDncOavlIeyizzuC9DC2gNaeGvFkTmLU2Z
 5yt9SzFr/1wFvsRECnYJw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Change the description of CONFIG_*HIGHMEM* to reflect "lost" memory due to 
PCI space and the existence of the NX flag.

Signed-Off-By: Bodo Eggert <7eggert@gmx.de>
---
I made this quick patch using the information from LKML as I remembered 
it. Please verify.

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
+	  If the machine has between 1 and 3.5 Gigabytes physical RAM, then
 	  answer "4GB" here.
+	  
+	  The PCI address space will usurally take 512 MB or 1 GB of address
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
+	  Select this if you have a 32-bit processor and between 1 and 3.5
 	  gigabytes of physical RAM.
 
 config HIGHMEM64G
-	bool "64GB"
+	bool "64GB (enables no-execute memory protection if available)"
 	depends on X86_CMPXCHG64
 	help
-	  Select this if you have a 32-bit processor and more than 4
+	  Select this if you have a 32-bit processor and more than 3.5
 	  gigabytes of physical RAM.
 
 endchoice
-- 
RAM DISK is not an installation procedure! 
