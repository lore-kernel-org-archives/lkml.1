Return-Path: <linux-kernel-owner+w=401wt.eu-S1756429AbYFPNXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429AbYFPNXN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 09:23:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbYFPNW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 09:22:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50148 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756149AbYFPNW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 09:22:57 -0400
To: torvalds@linux-foundation.org
Cc: jacmet@sunsite.dk, dhowells@redhat.com, k.shutemov@gmail.com,
       linux-kernel@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Date: Mon, 16 Jun 2008 12:18:13 +0100
In-Reply-To: <87abhl7eqo.fsf@macbook.be.48ers.dk>
Subject: [PATCH 2/4] Remove last traces of a.out support from ELF loader.
Message-Id: <E1K8EfR-0002H8-R8@pmac.infradead.org>
X-Bad-Reply: In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit d20894a23708c2af75966534f8e4dedb46d48db2, Andi removed support
for a.out interpreters from the ELF loader, which was only ever needed
for the transition from a.out to ELF.

This removes the last traces of that support, in particular the
inclusion of <linux/a.out.h>.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Acked-by: Peter Korsgaard <jacmet@sunsite.dk>
---
 fs/binfmt_elf.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 0fa95b1..d48ff5f 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -16,7 +16,6 @@
 #include <linux/time.h>
 #include <linux/mm.h>
 #include <linux/mman.h>
-#include <linux/a.out.h>
 #include <linux/errno.h>
 #include <linux/signal.h>
 #include <linux/binfmts.h>
@@ -548,7 +547,6 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	struct {
 		struct elfhdr elf_ex;
 		struct elfhdr interp_elf_ex;
-  		struct exec interp_ex;
 	} *loc;
 
 	loc = kmalloc(sizeof(*loc), GFP_KERNEL);
@@ -680,7 +678,6 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 			}
 
 			/* Get the exec headers */
-			loc->interp_ex = *((struct exec *)bprm->buf);
 			loc->interp_elf_ex = *((struct elfhdr *)bprm->buf);
 			break;
 		}
-- 
1.5.5.1

