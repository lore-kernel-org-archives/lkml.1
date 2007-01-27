Return-Path: <linux-kernel-owner+w=401wt.eu-S1752385AbXA0Urg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385AbXA0Urg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 15:47:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbXA0Urg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 15:47:36 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:3471 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385AbXA0Urf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 15:47:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=k9K92HNRRCIGPRgaQtz+V6DhmAHmrOWTR0Yf7c4jjPomWfXXBNo/G+2VkDX3FKfyKImUUcVarXCvUC7rfY504+/fErX2hedzHCIX5dcgdlQcU10i/jJ8YFhes6ES47hgrdZrsfLOFWSvBPY5Uhbi/c3H7w+OhA59IrZkF1nl2WE=
From: Alon Bar-Lev <alon.barlev@gmail.com>
To: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Dynamic kernel command-line - fixups
Date: Sat, 27 Jan 2007 22:49:26 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, "Bernhard Walle" <bwalle@suse.de>,
       Jeff Dike <jdike@addtoit.com>
References: <200701230010.34323.alon.barlev@gmail.com> <9e0cf0bf0701270034w491ff69dnb6019b4dd30f6d54@mail.gmail.com> <20070127004411.b0d5872e.akpm@osdl.org>
In-Reply-To: <20070127004411.b0d5872e.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701272249.28163.alon.barlev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Remove in-source externs, linux/init.h is included in all cases.
This is a fixups for "Dynamic kernel command-line" patch.

It includes the ia64 fixup already added.
It also includes some uml __init fixups so that we can __initdata also its command_line.

[[[  I will resubmit it to next mm version as you requested,
I don't mean to bother you. if you find this simple
enough you have an option to include this. ]]]

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>

---

diff -urNp linux-2.6.20-rc4-mm1.dyn-cmdline/arch/ia64/kernel/efi.c linux-2.6.20-rc4-mm1.dyn-cmdline.fixups/arch/ia64/kernel/efi.c
--- linux-2.6.20-rc4-mm1.dyn-cmdline/arch/ia64/kernel/efi.c	2007-01-22 23:32:30.000000000 +0200
+++ linux-2.6.20-rc4-mm1.dyn-cmdline.fixups/arch/ia64/kernel/efi.c	2007-01-27 21:56:07.000000000 +0200
@@ -413,7 +413,6 @@ efi_init (void)
 	efi_char16_t *c16;
 	u64 efi_desc_size;
 	char *cp, vendor[100] = "unknown";
-	extern char __initdata boot_command_line[];
 	int i;
 
 	/* it's too early to be able to use the standard kernel command line support... */
diff -urNp linux-2.6.20-rc4-mm1.dyn-cmdline/arch/ia64/kernel/sal.c linux-2.6.20-rc4-mm1.dyn-cmdline.fixups/arch/ia64/kernel/sal.c
--- linux-2.6.20-rc4-mm1.dyn-cmdline/arch/ia64/kernel/sal.c	2007-01-22 23:32:30.000000000 +0200
+++ linux-2.6.20-rc4-mm1.dyn-cmdline.fixups/arch/ia64/kernel/sal.c	2007-01-27 21:57:07.000000000 +0200
@@ -194,7 +194,6 @@ static void __init
 chk_nointroute_opt(void)
 {
 	char *cp;
-	extern char __initdata boot_command_line[];
 
 	for (cp = boot_command_line; *cp; ) {
 		if (memcmp(cp, "nointroute", 10) == 0) {
diff -urNp linux-2.6.20-rc4-mm1.dyn-cmdline/arch/parisc/mm/init.c linux-2.6.20-rc4-mm1.dyn-cmdline.fixups/arch/parisc/mm/init.c
--- linux-2.6.20-rc4-mm1.dyn-cmdline/arch/parisc/mm/init.c	2007-01-22 23:32:30.000000000 +0200
+++ linux-2.6.20-rc4-mm1.dyn-cmdline.fixups/arch/parisc/mm/init.c	2007-01-27 22:06:51.000000000 +0200
@@ -77,7 +77,6 @@ static void __init mem_limit_func(void)
 {
 	char *cp, *end;
 	unsigned long limit;
-	extern char __initdata boot_command_line[];
 
 	/* We need this before __setup() functions are called */
 
diff -urNp linux-2.6.20-rc4-mm1.dyn-cmdline/arch/um/include/user_util.h linux-2.6.20-rc4-mm1.dyn-cmdline.fixups/arch/um/include/user_util.h
--- linux-2.6.20-rc4-mm1.dyn-cmdline/arch/um/include/user_util.h	2007-01-22 23:32:31.000000000 +0200
+++ linux-2.6.20-rc4-mm1.dyn-cmdline.fixups/arch/um/include/user_util.h	2007-01-27 21:57:41.000000000 +0200
@@ -38,8 +38,6 @@ extern unsigned long long highmem;
 
 extern char host_info[];
 
-extern char __initdata boot_command_line[];
-
 extern unsigned long _stext, _etext, _sdata, _edata, __bss_start, _end;
 extern unsigned long _unprotected_end;
 extern unsigned long brk_start;
diff -urNp linux-2.6.20-rc4-mm1.dyn-cmdline/arch/um/kernel/um_arch.c linux-2.6.20-rc4-mm1.dyn-cmdline.fixups/arch/um/kernel/um_arch.c
--- linux-2.6.20-rc4-mm1.dyn-cmdline/arch/um/kernel/um_arch.c	2007-01-22 23:32:31.000000000 +0200
+++ linux-2.6.20-rc4-mm1.dyn-cmdline.fixups/arch/um/kernel/um_arch.c	2007-01-27 22:28:48.000000000 +0200
@@ -44,9 +44,9 @@
 #define DEFAULT_COMMAND_LINE "root=98:0"
 
 /* Changed in linux_main and setup_arch, which run before SMP is started */
-static char command_line[COMMAND_LINE_SIZE] = { 0 };
+static char __initdata command_line[COMMAND_LINE_SIZE] = { 0 };
 
-static void add_arg(char *arg)
+static void __init add_arg(char *arg)
 {
 	if (strlen(command_line) + strlen(arg) + 1 > COMMAND_LINE_SIZE) {
 		printf("add_arg: Too many command line arguments!\n");
@@ -331,7 +331,7 @@ EXPORT_SYMBOL(end_iomem);
 
 extern char __binary_start;
 
-int linux_main(int argc, char **argv)
+int __init linux_main(int argc, char **argv)
 {
 	unsigned long avail, diff;
 	unsigned long virtmem_size, max_physmem;
diff -urNp linux-2.6.20-rc4-mm1.dyn-cmdline/arch/x86_64/kernel/head64.c linux-2.6.20-rc4-mm1.dyn-cmdline.fixups/arch/x86_64/kernel/head64.c
--- linux-2.6.20-rc4-mm1.dyn-cmdline/arch/x86_64/kernel/head64.c	2007-01-22 23:32:31.000000000 +0200
+++ linux-2.6.20-rc4-mm1.dyn-cmdline.fixups/arch/x86_64/kernel/head64.c	2007-01-27 21:57:26.000000000 +0200
@@ -34,8 +34,6 @@ static void __init clear_bss(void)
 #define OLD_CL_BASE_ADDR        0x90000
 #define OLD_CL_OFFSET           0x90022
 
-extern char __initdata boot_command_line[];
-
 static void __init copy_bootdata(char *real_mode_data)
 {
 	int new_data;
