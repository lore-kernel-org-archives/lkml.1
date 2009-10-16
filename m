Return-Path: <linux-kernel-owner+w=401wt.eu-S1752705AbZJPF3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbZJPF3z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 01:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbZJPF3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 01:29:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:52602 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161AbZJPF3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 01:29:51 -0400
Date: Fri, 16 Oct 2009 05:28:16 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       sam@ravnborg.org, torvalds@linux-foundation.org, roland@redhat.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       roland@redhat.com, torvalds@linux-foundation.org, sam@ravnborg.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4AD6523D.5030909@zytor.com>
References: <4AD6523D.5030909@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Document linker script ASSERT() quirk
Message-ID: <tip-a5912f6b3e20c137172460e6d4dd180866c00963@git.kernel.org>
Git-Commit-ID: a5912f6b3e20c137172460e6d4dd180866c00963
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 16 Oct 2009 05:28:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a5912f6b3e20c137172460e6d4dd180866c00963
Gitweb:     http://git.kernel.org/tip/a5912f6b3e20c137172460e6d4dd180866c00963
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 16 Oct 2009 07:18:46 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 16 Oct 2009 07:18:46 +0200

x86: Document linker script ASSERT() quirk

Older binutils breaks if ASSERT() is used without a sink
for the output.

For example 2.14.90.0.6 is known to be broken, the link
fails with:

  LD      .tmp_vmlinux1
  ld:arch/x86/kernel/vmlinux.lds:678: parse error

Document this quirk in all three files that use it.

  See:    http://marc.info/?l=linux-kbuild&m=124930110427870&w=2
  See[2]: d2ba8b2 ("x86: Fix assert syntax in vmlinux.lds.S")

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
LKML-Reference: <4AD6523D.5030909@zytor.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/boot/setup.ld                     |    3 +++
 arch/x86/kernel/acpi/realmode/wakeup.lds.S |    3 +++
 arch/x86/kernel/vmlinux.lds.S              |    3 +++
 3 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/boot/setup.ld b/arch/x86/boot/setup.ld
index 0f6ec45..03c0683 100644
--- a/arch/x86/boot/setup.ld
+++ b/arch/x86/boot/setup.ld
@@ -53,6 +53,9 @@ SECTIONS
 
 	/DISCARD/ : { *(.note*) }
 
+	/*
+	 * The ASSERT() sink to . is intentional, for binutils 2.14 compatibility:
+	 */
 	. = ASSERT(_end <= 0x8000, "Setup too big!");
 	. = ASSERT(hdr == 0x1f1, "The setup header has the wrong offset!");
 	/* Necessary for the very-old-loader check to work... */
diff --git a/arch/x86/kernel/acpi/realmode/wakeup.lds.S b/arch/x86/kernel/acpi/realmode/wakeup.lds.S
index 7da00b7..060fff8 100644
--- a/arch/x86/kernel/acpi/realmode/wakeup.lds.S
+++ b/arch/x86/kernel/acpi/realmode/wakeup.lds.S
@@ -57,5 +57,8 @@ SECTIONS
 		*(.note*)
 	}
 
+	/*
+	 * The ASSERT() sink to . is intentional, for binutils 2.14 compatibility:
+	 */
 	. = ASSERT(_end <= WAKEUP_SIZE, "Wakeup too big!");
 }
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 92929fb..3c68fe2 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -305,6 +305,9 @@ SECTIONS
 
 
 #ifdef CONFIG_X86_32
+/*
+ * The ASSERT() sink to . is intentional, for binutils 2.14 compatibility:
+ */
 . = ASSERT((_end - LOAD_OFFSET <= KERNEL_IMAGE_SIZE),
 	   "kernel image bigger than KERNEL_IMAGE_SIZE");
 #else
