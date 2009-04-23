Return-Path: <linux-kernel-owner+w=401wt.eu-S1759920AbZDWTmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759920AbZDWTmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 15:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbZDWTmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 15:42:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43850 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844AbZDWTmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 15:42:42 -0400
Date: Thu, 23 Apr 2009 21:32:11 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Cc: Chris Zankel <chris@zankel.net>, David Howells <dhowells@redhat.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Ungerer <gerg@uclinux.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Helge Deller <deller@gmx.de>, Hirokazu Takata <takata@linux-m32r.org>,
       Jeff Dike <jdike@addtoit.com>, Kyle McMartin <kyle@mcmartin.ca>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] ptrace: remove PT_DTRACE from m68k, m68knommu
Message-ID: <20090423193211.GA14892@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

m68k sets PT_DTRACE in trap_c() but never uses it.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

 arch/m68k/kernel/traps.c            |    1 -
 arch/m68knommu/kernel/asm-offsets.c |    1 -
 arch/m68knommu/kernel/traps.c       |    1 -
 3 files changed, 3 deletions(-)

--- PTRACE/arch/m68k/kernel/traps.c~DT_3_SET	2009-04-06 00:03:35.000000000 +0200
+++ PTRACE/arch/m68k/kernel/traps.c	2009-04-22 21:52:23.000000000 +0200
@@ -1057,7 +1057,6 @@ asmlinkage void trap_c(struct frame *fp)
 	if (fp->ptregs.sr & PS_S) {
 		if ((fp->ptregs.vector >> 2) == VEC_TRACE) {
 			/* traced a trapping instruction */
-			current->ptrace |= PT_DTRACE;
 		} else
 			bad_super_trap(fp);
 		return;
--- PTRACE/arch/m68knommu/kernel/asm-offsets.c~DT_3_SET	2009-04-06 00:03:35.000000000 +0200
+++ PTRACE/arch/m68knommu/kernel/asm-offsets.c	2009-04-22 21:53:46.000000000 +0200
@@ -79,7 +79,6 @@ int main(void)
 	DEFINE(TRAP_TRACE, TRAP_TRACE);
 
 	DEFINE(PT_PTRACED, PT_PTRACED);
-	DEFINE(PT_DTRACE, PT_DTRACE);
 
 	DEFINE(THREAD_SIZE, THREAD_SIZE);
 
--- PTRACE/arch/m68knommu/kernel/traps.c~DT_3_SET	2009-04-06 00:03:35.000000000 +0200
+++ PTRACE/arch/m68knommu/kernel/traps.c	2009-04-22 21:54:29.000000000 +0200
@@ -200,7 +200,6 @@ asmlinkage void trap_c(struct frame *fp)
 	if (fp->ptregs.sr & PS_S) {
 		if ((fp->ptregs.vector >> 2) == VEC_TRACE) {
 			/* traced a trapping instruction */
-			current->ptrace |= PT_DTRACE;
 		} else
 			bad_super_trap(fp);
 		return;

