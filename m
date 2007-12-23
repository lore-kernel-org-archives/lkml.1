Return-Path: <linux-kernel-owner+w=401wt.eu-S1756832AbXLWPRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832AbXLWPRV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 10:17:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbXLWPRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 10:17:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34841 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843AbXLWPRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 10:17:10 -0500
Date: Sun, 23 Dec 2007 16:16:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG 2.6.24-rc6-mm1] BUG() at check_irqs_on() in fs/buffer.c .
Message-ID: <20071223151656.GA18738@elte.hu>
References: <200712232212.GII90159.tFFVSOLFJHQOOM@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712232212.GII90159.tFFVSOLFJHQOOM@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:

> Hello.
> 
> I encountered a BUG().
> I didn't encounter this bug for 2.6.24-rc5-mm1 .
> I guess this bug was introduced between 2.6.24-rc5-mm1 and 2.6.24-rc6-mm1 .

does the patch below help?

	Ingo

---
 include/asm-x86/desc.h |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux/include/asm-x86/desc.h
===================================================================
--- linux.orig/include/asm-x86/desc.h
+++ linux/include/asm-x86/desc.h
@@ -328,7 +328,11 @@ static inline void set_trap_gate(unsigne
 static inline void set_system_gate(unsigned int n, void *addr)
 {
 	BUG_ON((unsigned)n > 0xFF);
+#ifdef CONFIG_X86_32
+	_set_gate(n, GATE_TRAP, addr, 0x3, 0, __KERNEL_CS);
+#else
 	_set_gate(n, GATE_INTERRUPT, addr, 0x3, 0, __KERNEL_CS);
+#endif
 }
 
 static inline void set_task_gate(unsigned int n, unsigned int gdt_entry)
