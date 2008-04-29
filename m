Return-Path: <linux-kernel-owner+w=401wt.eu-S1760337AbYD2SLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760337AbYD2SLV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 14:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756709AbYD2SLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 14:11:04 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:13200 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756309AbYD2SLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 14:11:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=CztInToxVBVGINIa2oINPymMRut74KqyWuTHsxiOC8WHiC/C4r78tBKuP3sHgyCgq0jJHFd35uVRUZtAmI3Pqlybm9AQnSa0v+lVOAdr0GbCWZkQ5yrHzRIPhF1UEbIj0U8xlknTAld3ZFEo4LwNuIshVQfTE+ioXLZXzN+w8F0=
Date: Tue, 29 Apr 2008 22:10:11 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       David Woodhouse <dwmw2@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86 - hide X86_VM_MASK from userland programs v3
Message-ID: <20080429181011.GG6837@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

X86_VM_MASK is kernel specific flags so hide it from userland programs.

It should be defined *before* ptrace.h inclusion because of circular
link between these files

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

David as you see we can't use existing CONFIG_VM86 for this purpose.
But that is my fault - I was to check this before cooking the patch.

Index: linux-2.6.git/include/asm-x86/vm86.h
===================================================================
--- linux-2.6.git.orig/include/asm-x86/vm86.h	2008-04-29 21:57:04.000000000 +0400
+++ linux-2.6.git/include/asm-x86/vm86.h	2008-04-29 21:59:15.000000000 +0400
@@ -14,12 +14,6 @@
 
 #include <asm/processor-flags.h>
 
-#ifdef CONFIG_VM86
-#define X86_VM_MASK	X86_EFLAGS_VM
-#else
-#define X86_VM_MASK	0 /* No VM86 support */
-#endif
-
 #define BIOSSEG		0x0f000
 
 #define CPU_086		0
@@ -133,6 +127,13 @@ struct vm86plus_struct {
 };
 
 #ifdef __KERNEL__
+
+#ifdef CONFIG_VM86
+#define X86_VM_MASK	X86_EFLAGS_VM
+#else
+#define X86_VM_MASK	0 /* No VM86 support */
+#endif
+
 /*
  * This is the (kernel) stack-layout when we have done a "SAVE_ALL" from vm86
  * mode - the main change is that the old segment descriptors aren't
