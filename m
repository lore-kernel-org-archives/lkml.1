Return-Path: <linux-kernel-owner+w=401wt.eu-S932926AbXGKTAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932926AbXGKTAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 15:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932723AbXGKTAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 15:00:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932628AbXGKTAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 15:00:32 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, Richard Henderson <rth@twiddle.net>
Subject: [PATCH 3/7] alpha: Put allocated ELF notes in read-only data segment
X-Windows: let it get in *your* way.
Message-Id: <20070711190026.699744D0555@magilla.localdomain>
Date: Wed, 11 Jul 2007 12:00:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This changes the alpha linker script to use the asm-generic NOTES macro so
that ELF note sections with SHF_ALLOC set are linked into the kernel image
along with other read-only data.  The PT_NOTE also points to their location.

This paves the way for putting useful build-time information into ELF notes
that can be found easily later in a kernel memory dump.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/alpha/kernel/vmlinux.lds.S |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/alpha/kernel/vmlinux.lds.S b/arch/alpha/kernel/vmlinux.lds.S
index 449e76f..34a5ac9 100644
--- a/arch/alpha/kernel/vmlinux.lds.S
+++ b/arch/alpha/kernel/vmlinux.lds.S
@@ -3,7 +3,7 @@
 OUTPUT_FORMAT("elf64-alpha")
 OUTPUT_ARCH(alpha)
 ENTRY(__start)
-PHDRS { kernel PT_LOAD ; }
+PHDRS { kernel PT_LOAD; note PT_NOTE; }
 jiffies = jiffies_64;
 SECTIONS
 {
@@ -28,6 +28,9 @@ SECTIONS
   __ex_table : { *(__ex_table) }
   __stop___ex_table = .;
 
+  NOTES :kernel :note
+  .dummy : { *(.dummy) } :kernel
+
   RODATA
 
   /* Will be freed after init */
