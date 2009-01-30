Return-Path: <linux-kernel-owner+w=401wt.eu-S1755883AbZA3QvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbZA3QvN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 11:51:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbZA3Qu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 11:50:57 -0500
Received: from relay1.sgi.com ([192.48.179.29]:49005 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752384AbZA3Qu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 11:50:56 -0500
Date: Fri, 30 Jan 2009 10:50:54 -0600
From: Martin Hicks <mort@sgi.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       heukelum@mailshack.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: push old stack address on irqstack for unwinder
Message-ID: <20090130165053.GE7872@alcatraz.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

KDB was using this information.  Could this be pushed towards 2.6.29 please?

This re-adds the old stack pointer to the top of the irqstack to help
with unwinding.  It was removed in commit d99015b1abbad743aa049b439c1e1dede6d0fa49
as part of the save_args out-of-line work.

Signed-off-by: Martin Hicks <mort@sgi.com>
---
 arch/x86/kernel/entry_64.S |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index e28c7a9..a134621 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -346,6 +346,7 @@ ENTRY(save_args)
 	popq_cfi %rax			/* move return address... */
 	mov %gs:pda_irqstackptr,%rsp
 	EMPTY_FRAME 0
+	pushq_cfi %rbp			/* backlink for unwinder */
 	pushq_cfi %rax			/* ... to the new stack */
 	/*
 	 * We entered an interrupt context - irqs are off:


