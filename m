Return-Path: <linux-kernel-owner+w=401wt.eu-S1757922AbXKYWBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922AbXKYWBA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 17:01:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757461AbXKYWA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 17:00:27 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757444AbXKYWAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 17:00:25 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 06/27] x86: single_step segment macros
In-Reply-To: Roland McGrath's message of  Sunday, 25 November 2007 13:55:07 -0800 <20071125215507.4B89226F8C5@magilla.localdomain>
References: <20071125215507.4B89226F8C5@magilla.localdomain>
Emacs: no job too big... no job.
Message-Id: <20071125215951.1BEA526F8DE@magilla.localdomain>
Date: Sun, 25 Nov 2007 13:59:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This cleans up the single-step code to use the asm/segment.h macros
for segment selector magic bits, rather than its own constant.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/step.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/step.c b/arch/x86/kernel/step.c
index cb3c8bc..3b70f20 100644
--- a/arch/x86/kernel/step.c
+++ b/arch/x86/kernel/step.c
@@ -5,8 +5,6 @@
 #include <linux/mm.h>
 #include <linux/ptrace.h>
 
-#define LDT_SEGMENT 4
-
 unsigned long convert_rip_to_linear(struct task_struct *child, struct pt_regs *regs)
 {
 	unsigned long addr, seg;
@@ -20,7 +18,7 @@ unsigned long convert_rip_to_linear(struct task_struct *child, struct pt_regs *r
 	 * TLS segments are used for data, and the PNPBIOS
 	 * and APM bios ones we just ignore here.
 	 */
-	if (seg & LDT_SEGMENT) {
+	if ((seg & SEGMENT_TI_MASK) == SEGMENT_LDT) {
 		u32 *desc;
 		unsigned long base;
 
