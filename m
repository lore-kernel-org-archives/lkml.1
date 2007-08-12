Return-Path: <linux-kernel-owner+w=401wt.eu-S938376AbXHLU51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938376AbXHLU51 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 16:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938504AbXHLU4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 16:56:34 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:52239 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935228AbXHLU4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 16:56:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=c1qz6y17H2MO7R7QKIDYx8uHygHeWGvfaICofz3yvLktcl4GzWeOyRIoMeOD6KFxTa0tDJ1Gok8vOIIk6v2f75G6ti35RLB9Vfpn6mhXgHW3w0MoiF/z31K3VQMhTsPxyaBba6DhH+MZgoc4X7IxEwC4rKkQRJcgO2+N/4OvCNU=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5] 4KSTACKS, move out of Kernel hacking menu (i386)
Date: Sun, 12 Aug 2007 22:54:07 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
References: <200708122250.58773.jesper.juhl@gmail.com>
In-Reply-To: <200708122250.58773.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708122254.07502.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Since 4KSTACKS is nolonger a debug only feature, move it out of 
the Kernel Hacking menu (i386).

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/arch/i386/Kconfig b/arch/i386/Kconfig
index f952493..d4988cd 100644
--- a/arch/i386/Kconfig
+++ b/arch/i386/Kconfig
@@ -922,6 +922,15 @@ config COMPAT_VDSO
 
 	  If unsure, say Y.
 
+config 4KSTACKS
+	bool "Use 4Kb for kernel stacks instead of 8Kb"
+	help
+	  If you say Y here the kernel will use a 4Kb stacksize for the
+	  kernel stack attached to each process/thread. This facilitates
+	  running more threads on a system and also reduces the pressure
+	  on the VM subsystem for higher order allocations. This option
+	  will also use IRQ stacks to compensate for the reduced stackspace.
+
 endmenu
 
 config ARCH_ENABLE_MEMORY_HOTPLUG
diff --git a/arch/i386/Kconfig.debug b/arch/i386/Kconfig.debug
index 7131a16..90cc3a0 100644
--- a/arch/i386/Kconfig.debug
+++ b/arch/i386/Kconfig.debug
@@ -56,15 +56,6 @@ config DEBUG_RODATA
 	  portion of the kernel code won't be covered by a 2MB TLB anymore.
 	  If in doubt, say "N".
 
-config 4KSTACKS
-	bool "Use 4Kb for kernel stacks instead of 8Kb"
-	help
-	  If you say Y here the kernel will use a 4Kb stacksize for the
-	  kernel stack attached to each process/thread. This facilitates
-	  running more threads on a system and also reduces the pressure
-	  on the VM subsystem for higher order allocations. This option
-	  will also use IRQ stacks to compensate for the reduced stackspace.
-
 config X86_FIND_SMP_CONFIG
 	bool
 	depends on X86_LOCAL_APIC || X86_VOYAGER


