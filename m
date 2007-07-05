Return-Path: <linux-kernel-owner+w=401wt.eu-S1760305AbXGEL4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760305AbXGEL4d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 07:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756143AbXGEL4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 07:56:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756121AbXGEL4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 07:56:24 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FRV: Remove some dead code
To: torvalds@osdl.org, akpm@osdl.org, rpjday@mindspring.com
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Thu, 05 Jul 2007 12:56:18 +0100
Message-ID: <20070705115618.13484.24957.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Remove some dead chunks of code that are bounded by preprocessor conditionals
controlled by apparently no-longer available config options.

These are:

	CONFIG_BLK_DEV_BLKMEM
	CONFIG_CHR_DEV_FLASH
	CONFIG_BLK_DEV_FLASH
	CONFIG_CONSOLE

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/kernel/setup.c |   16 ----------------
 1 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/arch/frv/kernel/setup.c b/arch/frv/kernel/setup.c
index aa3c795..c1c32e4 100644
--- a/arch/frv/kernel/setup.c
+++ b/arch/frv/kernel/setup.c
@@ -60,10 +60,6 @@ static void __init setup_linux_memory(void);
 static void __init setup_uclinux_memory(void);
 #endif
 
-#ifdef CONFIG_CONSOLE
-extern struct consw *conswitchp;
-#endif
-
 #ifdef CONFIG_MB93090_MB00
 static char __initdata mb93090_banner[] = "FJ/RH FR-V Linux";
 static char __initdata mb93090_version[] = UTS_RELEASE;
@@ -795,13 +791,6 @@ void __init setup_arch(char **cmdline_p)
 #endif
 #endif
 
-#if defined(CONFIG_CHR_DEV_FLASH) || defined(CONFIG_BLK_DEV_FLASH)
-	/* we need to initialize the Flashrom device here since we might
-	 * do things with flash early on in the boot
-	 */
-	flash_probe();
-#endif
-
 	/* deal with the command line - RedBoot may have passed one to the kernel */
 	memcpy(command_line, boot_command_line, sizeof(command_line));
 	*cmdline_p = &command_line[0];
@@ -837,11 +826,6 @@ void __init setup_arch(char **cmdline_p)
 #endif
 #endif
 
-#ifdef CONFIG_BLK_DEV_BLKMEM
-	ROOT_DEV = MKDEV(BLKMEM_MAJOR,0);
-#endif
-	/*rom_length = (unsigned long)&_flashend - (unsigned long)&_romvec;*/
-
 #ifdef CONFIG_MMU
 	setup_linux_memory();
 #else

