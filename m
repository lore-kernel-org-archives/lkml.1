Return-Path: <linux-kernel-owner+w=401wt.eu-S932750AbXGKS7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750AbXGKS7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 14:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758467AbXGKS7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 14:59:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbXGKS7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 14:59:07 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
Subject: [PATCH 2/7] x86_64: Put allocated ELF notes in read-only data segment
X-Windows: even your dog won't like it.
Message-Id: <20070711185902.A82A44D0555@magilla.localdomain>
Date: Wed, 11 Jul 2007 11:59:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This changes the x86_64 linker script to use the asm-generic NOTES macro so
that ELF note sections with SHF_ALLOC set are linked into the kernel image
along with other read-only data.  The PT_NOTE also points to their location.

This paves the way for putting useful build-time information into ELF notes
that can be found easily later in a kernel memory dump.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86_64/kernel/vmlinux.lds.S |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86_64/kernel/vmlinux.lds.S b/arch/x86_64/kernel/vmlinux.lds.S
index dbccfda..287e525 100644
--- a/arch/x86_64/kernel/vmlinux.lds.S
+++ b/arch/x86_64/kernel/vmlinux.lds.S
@@ -48,7 +48,9 @@ SECTIONS
   __ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) { *(__ex_table) }
   __stop___ex_table = .;
 
-  BUG_TABLE
+  NOTES :text :note
+
+  BUG_TABLE :text
 
   RODATA
 
