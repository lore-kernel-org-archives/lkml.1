Return-Path: <linux-kernel-owner+w=401wt.eu-S1422908AbXBGTzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422908AbXBGTzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 14:55:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422915AbXBGTzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 14:55:01 -0500
Received: from [198.99.130.12] ([198.99.130.12]:34297 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1422907AbXBGTy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 14:54:57 -0500
Message-Id: <200702071947.l17JlnMY006620@ccure.user-mode-linux.org>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.0.4
To: akpm@osdl.org
cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH 5/7] UML - ELF locking commentary
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Wed, 07 Feb 2007 14:47:49 -0500
From: Jeff Dike <jdike@addtoit.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Comment the lack of locking of the elf data extracted from the ELF headers
passed to UML.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
--
 arch/um/os-Linux/elf_aux.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6.18-mm/arch/um/os-Linux/elf_aux.c
===================================================================
--- linux-2.6.18-mm.orig/arch/um/os-Linux/elf_aux.c	2006-06-17 21:49:35.000000000 -0400
+++ linux-2.6.18-mm/arch/um/os-Linux/elf_aux.c	2007-01-09 15:33:31.000000000 -0500
@@ -21,12 +21,11 @@ typedef Elf32_auxv_t elf_auxv_t;
 typedef Elf64_auxv_t elf_auxv_t;
 #endif
 
+/* These are initialized very early in boot and never changed */
 char * elf_aux_platform;
 long elf_aux_hwcap;
-
 unsigned long vsyscall_ehdr;
 unsigned long vsyscall_end;
-
 unsigned long __kernel_vsyscall;
 
 __init void scan_elf_aux( char **envp)

