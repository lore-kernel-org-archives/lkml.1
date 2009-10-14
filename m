Return-Path: <linux-kernel-owner+w=401wt.eu-S1762064AbZJNWMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762064AbZJNWMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 18:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761722AbZJNWMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 18:12:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760908AbZJNWMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 18:12:39 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, <hpa@zytor.com>
Cc: Ian Lance Taylor <iant@google.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] x86: linker script syntax nits
X-Fcc: ~/Mail/linus
X-Zippy-Says: ..  or were you driving the PONTIAC that HONKED at me in MIAMI last
    Tuesday?
Message-Id: <20091014221024.EFA79E2F@magilla.sf.frob.com>
Date: Wed, 14 Oct 2009 15:10:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 80f506918fdaaca6b574ba931536a58ce015c7be:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.dk/linux-2.6-block

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frob/linux-2.6-roland.git topic/x86-lds-nits

Roland McGrath (1):
      x86: linker script syntax nits

 arch/x86/kernel/acpi/realmode/wakeup.lds.S |    4 ++--
 arch/x86/kernel/vmlinux.lds.S              |   17 ++++++++---------
 2 files changed, 10 insertions(+), 11 deletions(-)
---
[PATCH] x86: linker script syntax nits

The linker scripts grew some use of weirdly wrong linker script syntax.
It happens to work, but it's not what the syntax is documented to be.
Clean it up to use the official syntax.

Signed-off-by: Roland McGrath <roland@redhat.com>
CC: Ian Lance Taylor <iant@google.com>
---
 arch/x86/kernel/acpi/realmode/wakeup.lds.S |    4 ++--
 arch/x86/kernel/vmlinux.lds.S              |   17 ++++++++---------
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/acpi/realmode/wakeup.lds.S b/arch/x86/kernel/acpi/realmode/wakeup.lds.S
index 7da00b7..0e50e1e 100644
--- a/arch/x86/kernel/acpi/realmode/wakeup.lds.S
+++ b/arch/x86/kernel/acpi/realmode/wakeup.lds.S
@@ -56,6 +56,6 @@ SECTIONS
 	/DISCARD/ : {
 		*(.note*)
 	}
-
-	. = ASSERT(_end <= WAKEUP_SIZE, "Wakeup too big!");
 }
+
+ASSERT(_end <= WAKEUP_SIZE, "Wakeup too big!");
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 92929fb..8d6001a 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -305,8 +305,8 @@ SECTIONS
 
 
 #ifdef CONFIG_X86_32
-. = ASSERT((_end - LOAD_OFFSET <= KERNEL_IMAGE_SIZE),
-	   "kernel image bigger than KERNEL_IMAGE_SIZE");
+ASSERT((_end - LOAD_OFFSET <= KERNEL_IMAGE_SIZE),
+       "kernel image bigger than KERNEL_IMAGE_SIZE");
 #else
 /*
  * Per-cpu symbols which need to be offset from __per_cpu_load
@@ -319,12 +319,12 @@ INIT_PER_CPU(irq_stack_union);
 /*
  * Build-time check on the image size:
  */
-. = ASSERT((_end - _text <= KERNEL_IMAGE_SIZE),
-	   "kernel image bigger than KERNEL_IMAGE_SIZE");
+ASSERT((_end - _text <= KERNEL_IMAGE_SIZE),
+       "kernel image bigger than KERNEL_IMAGE_SIZE");
 
 #ifdef CONFIG_SMP
-. = ASSERT((per_cpu__irq_stack_union == 0),
-           "irq_stack_union is not at start of per-cpu area");
+ASSERT((per_cpu__irq_stack_union == 0),
+       "irq_stack_union is not at start of per-cpu area");
 #endif
 
 #endif /* CONFIG_X86_32 */
@@ -332,7 +332,6 @@ INIT_PER_CPU(irq_stack_union);
 #ifdef CONFIG_KEXEC
 #include <asm/kexec.h>
 
-. = ASSERT(kexec_control_code_size <= KEXEC_CONTROL_CODE_MAX_SIZE,
-           "kexec control code size is too big");
+ASSERT(kexec_control_code_size <= KEXEC_CONTROL_CODE_MAX_SIZE,
+       "kexec control code size is too big");
 #endif
-
