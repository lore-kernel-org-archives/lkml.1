Return-Path: <linux-kernel-owner+w=401wt.eu-S1759286AbZANUmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759286AbZANUmo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 15:42:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755163AbZANUmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 15:42:15 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:51457 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943AbZANUmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 15:42:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition
         :message-id;
        b=B9OK9pLrYcSCn+RCMYV+yuFIe8/StT8UX5wTauat31OYtcPYxdjuywXYRv0odSrSzn
         f7MAEDnHHgt2Mh4hyGe9tXDMcwuLt06bF+8AFyyimFHQcFHddOpM2I66keLpSvQmHBiq
         fpG0FiZjprbtRfDxDuRazHW6RpHDyQyl0AAHk=
References: <20090114203745.285473388@gmail.com>>
User-Agent: quilt/0.46-1
Date: Wed, 14 Jan 2009 23:37:46 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, hpa@zytor.com, linux-kernel@vger.kernel.org
Cc: harvey.harrison@gmail.com, sam@ravnborg.org, jaswinderrajput@gmail.com,
       Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 1/5] x86: headers cleanup - boot.h
Content-Disposition: inline; filename=x86-header-boot-h
Message-ID: <496e4e23.1358560a.0b42.ffff8588@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

'make headers_check' warn us about leaking of kernel private
(mostly compile time vars) data to userspace in headers. Fix it.

Neither BOOT_HEAP_SIZE, BOOT_STACK_SIZE refs
was found by searching thru net (ie in user-space area)
so fence this all by __KERNEL__ guard.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

---
 arch/x86/include/asm/boot.h |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

Index: linux-2.6.git/arch/x86/include/asm/boot.h
===================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/boot.h
+++ linux-2.6.git/arch/x86/include/asm/boot.h
@@ -10,14 +10,16 @@
 #define EXTENDED_VGA	0xfffe		/* 80x50 mode */
 #define ASK_VGA		0xfffd		/* ask for it at bootup */
 
+#ifdef __KERNEL__
+
 /* Physical address where kernel should be loaded. */
 #define LOAD_PHYSICAL_ADDR ((CONFIG_PHYSICAL_START \
 				+ (CONFIG_PHYSICAL_ALIGN - 1)) \
 				& ~(CONFIG_PHYSICAL_ALIGN - 1))
 
-#if (defined CONFIG_KERNEL_BZIP2)
+#ifdef CONFIG_KERNEL_BZIP2
 #define BOOT_HEAP_SIZE             0x400000
-#else
+#else /* !CONFIG_KERNEL_BZIP2 */
 
 #ifdef CONFIG_X86_64
 #define BOOT_HEAP_SIZE	0x7000
@@ -25,7 +27,7 @@
 #define BOOT_HEAP_SIZE	0x4000
 #endif
 
-#endif
+#endif /* !CONFIG_KERNEL_BZIP2 */
 
 #ifdef CONFIG_X86_64
 #define BOOT_STACK_SIZE	0x4000
@@ -33,4 +35,6 @@
 #define BOOT_STACK_SIZE	0x1000
 #endif
 
+#endif /* __KERNEL__ */
+
 #endif /* _ASM_X86_BOOT_H */

-- 
