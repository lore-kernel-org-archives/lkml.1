Return-Path: <linux-kernel-owner+w=401wt.eu-S939064AbXGSOHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939064AbXGSOHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 10:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763498AbXGSNtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:49:17 -0400
Received: from mail.suse.de ([195.135.220.2]:54587 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765301AbXGSNtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:49:10 -0400
From: Andi Kleen <ak@suse.de>
References: <20070719348.540885000@suse.de>
In-Reply-To: <20070719348.540885000@suse.de>
To: roland@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH for review] [38/48] x86_64: Put allocated ELF notes in read-only data segment
Message-Id: <20070719134908.F29C614E6E@wotan.suse.de>
Date: Thu, 19 Jul 2007 15:49:08 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Roland McGrath <roland@redhat.com>

This changes the x86_64 linker script to use the asm-generic NOTES macro so
that ELF note sections with SHF_ALLOC set are linked into the kernel image
along with other read-only data.  The PT_NOTE also points to their location.

This paves the way for putting useful build-time information into ELF notes
that can be found easily later in a kernel memory dump.

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/vmlinux.lds.S |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux/arch/x86_64/kernel/vmlinux.lds.S
===================================================================
--- linux.orig/arch/x86_64/kernel/vmlinux.lds.S
+++ linux/arch/x86_64/kernel/vmlinux.lds.S
@@ -48,7 +48,9 @@ SECTIONS
   __ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) { *(__ex_table) }
   __stop___ex_table = .;
 
-  BUG_TABLE
+  NOTES :text :note
+
+  BUG_TABLE :text
 
   RODATA
 
