Return-Path: <linux-kernel-owner+w=401wt.eu-S1763288AbYA3SpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763288AbYA3SpI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 13:45:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753724AbYA3Sox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 13:44:53 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37564 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753586AbYA3Sow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 13:44:52 -0500
Date: Wed, 30 Jan 2008 19:44:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: arch/x86/kernel/test_nx.c compile error
Message-ID: <20080130184432.GA31485@elte.hu>
References: <20080130182537.GD29368@does.not.exist> <20080130184218.GB27168@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080130184218.GB27168@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> does the patch below help?

uhm, the one below instead.

	Ingo

------------>
Subject: x86: fix arch/x86/kernel/test_nx.c modular build bug
From: Ingo Molnar <mingo@elte.hu>

fix this modular build bug:

>   CC [M]  arch/x86/kernel/test_nx.o
> {standard input}: Assembler messages:
> {standard input}:58: Error: cannot represent relocation type BFD_RELOC_64
> {standard input}:59: Error: cannot represent relocation type BFD_RELOC_64
> make[2]: *** [arch/x86/kernel/test_nx.o] Error 1
> make[1]: *** [arch/x86/kernel] Error 2

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/test_nx.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-x86.q/arch/x86/kernel/test_nx.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/test_nx.c
+++ linux-x86.q/arch/x86/kernel/test_nx.c
@@ -91,8 +91,13 @@ static noinline int test_address(void *a
 		".previous\n"
 		".section __ex_table,\"a\"\n"
 		"       .align 8\n"
+#ifdef CONFIG_X86_32
+		"	.long 0b\n"
+		"	.long 2b\n"
+#endif
 		"	.quad 0b\n"
 		"	.quad 2b\n"
+#else
 		".previous\n"
 		: [rslt] "=r" (result)
 		: [fake_code] "r" (address), [zero] "r" (0UL), "0" (result)
