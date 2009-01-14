Return-Path: <linux-kernel-owner+w=401wt.eu-S1756492AbZANMbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492AbZANMbA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 07:31:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762458AbZANMaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 07:30:46 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:52864 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762433AbZANMap convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 07:30:45 -0500
Message-Id: <496DE927.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Wed, 14 Jan 2009 12:31:19 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: simplify HIGHMEM-related Kconfig entries
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Additionally remove the dependency of X86_PAE on !HIGHMEM4G - at least
I can't understand why that dependency existed.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.29-rc1/arch/x86/Kconfig	2009-01-14 11:36:05.000000000 +0100
+++ 2.6.29-rc1-x86-kconfig-highmem/arch/x86/Kconfig	2009-01-08 09:03:21.000000000 +0100
@@ -896,8 +896,8 @@ config X86_CPUID
 
 choice
 	prompt "High Memory Support"
-	default HIGHMEM4G if !X86_NUMAQ
 	default HIGHMEM64G if X86_NUMAQ
+	default HIGHMEM4G
 	depends on X86_32
 
 config NOHIGHMEM
@@ -1004,7 +1004,7 @@ config HIGHMEM
 
 config X86_PAE
 	bool "PAE (Physical Address Extension) Support"
-	depends on X86_32 && !HIGHMEM4G
+	depends on X86_32
 	help
 	  PAE is required for NX support, and furthermore enables
 	  larger swapspace support for non-overcommit purposes. It
@@ -1147,7 +1147,7 @@ source "mm/Kconfig"
 
 config HIGHPTE
 	bool "Allocate 3rd-level pagetables from highmem"
-	depends on X86_32 && (HIGHMEM4G || HIGHMEM64G)
+	depends on HIGHMEM
 	help
 	  The VM uses one page table entry for each page of physical memory.
 	  For systems with a lot of RAM, this can be wasteful of precious



