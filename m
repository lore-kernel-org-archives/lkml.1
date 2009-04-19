Return-Path: <linux-kernel-owner+w=401wt.eu-S1756081AbZDSJcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbZDSJcb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 05:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752916AbZDSJcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 05:32:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:39972 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326AbZDSJcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 05:32:17 -0400
Date: Sun, 19 Apr 2009 09:30:40 GMT
From: tip-bot for Rakib Mullick <rakib.mullick@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rakib.mullick@gmail.com, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rakib.mullick@gmail.com, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <b9df5fa10904181941u4a73fc97i80dfa90a50b8daf5@mail.gmail.com>
References: <b9df5fa10904181941u4a73fc97i80dfa90a50b8daf5@mail.gmail.com>
Subject: [tip:x86/urgent] x86: Fix false positive section mismatch warnings in the apic code
Message-ID: <tip-aa57a15ad17d284e62fbd24cf7e0eb628b2cb3f7@git.kernel.org>
Git-Commit-ID: aa57a15ad17d284e62fbd24cf7e0eb628b2cb3f7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 19 Apr 2009 09:30:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aa57a15ad17d284e62fbd24cf7e0eb628b2cb3f7
Gitweb:     http://git.kernel.org/tip/aa57a15ad17d284e62fbd24cf7e0eb628b2cb3f7
Author:     Rakib Mullick <rakib.mullick@gmail.com>
AuthorDate: Sun, 19 Apr 2009 08:41:17 +0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 19 Apr 2009 11:28:18 +0200

x86: Fix false positive section mismatch warnings in the apic code

find_unisys_acpi_oem_table() and unmap_unisys_acpi_oem_table() are non
init functions, but these functions calls some init functions. But we
need these functions as non-init functions.

So annotate them via __ref.

The following false positive warnings are fixed via this:

  WARNING: vmlinux.o(.text+0x16250): Section mismatch in reference from
  the function find_unisys_acpi_oem_table() to the function
  .init.text:early_acpi_os_unmap_memory()
  The function find_unisys_acpi_oem_table() references
  the function __init early_acpi_os_unmap_memory().
  This is often because find_unisys_acpi_oem_table lacks a __init
  annotation or the annotation of early_acpi_os_unmap_memory is wrong.

  WARNING: vmlinux.o(.text+0x16269): Section mismatch in reference from
  the function find_unisys_acpi_oem_table() to the function
  .init.text:early_acpi_os_unmap_memory()
  The function find_unisys_acpi_oem_table() references
  the function __init early_acpi_os_unmap_memory().
  This is often because find_unisys_acpi_oem_table lacks a __init
  annotation or the annotation of early_acpi_os_unmap_memory is wrong.

  WARNING: vmlinux.o(.text+0x16279): Section mismatch in reference from
  the function find_unisys_acpi_oem_table() to the function
  .init.text:__acpi_map_table()
  The function find_unisys_acpi_oem_table() references
  the function __init __acpi_map_table().
  This is often because find_unisys_acpi_oem_table lacks a __init
  annotation or the annotation of __acpi_map_table is wrong.

  WARNING: vmlinux.o(.text+0x16297): Section mismatch in reference from
  the function unmap_unisys_acpi_oem_table() to the function
  .init.text:__acpi_unmap_table()
  The function unmap_unisys_acpi_oem_table() references
  the function __init __acpi_unmap_table().
  This is often because unmap_unisys_acpi_oem_table lacks a __init
  annotation or the annotation of __acpi_unmap_table is wrong.

[ Impact: annotate away section mismatch warnings ]

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <b9df5fa10904181941u4a73fc97i80dfa90a50b8daf5@mail.gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/es7000_32.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 1c11b81..96c150c 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -254,7 +254,7 @@ static int parse_unisys_oem(char *oemptr)
 }
 
 #ifdef CONFIG_ACPI
-static int find_unisys_acpi_oem_table(unsigned long *oem_addr)
+static int __ref find_unisys_acpi_oem_table(unsigned long *oem_addr)
 {
 	struct acpi_table_header *header = NULL;
 	struct es7000_oem_table *table;
@@ -285,7 +285,7 @@ static int find_unisys_acpi_oem_table(unsigned long *oem_addr)
 	return 0;
 }
 
-static void unmap_unisys_acpi_oem_table(unsigned long oem_addr)
+static void __ref unmap_unisys_acpi_oem_table(unsigned long oem_addr)
 {
 	if (!oem_addr)
 		return;
