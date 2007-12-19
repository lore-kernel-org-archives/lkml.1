Return-Path: <linux-kernel-owner+w=401wt.eu-S1756620AbXLSUzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbXLSUzK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 15:55:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752997AbXLSUy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 15:54:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43350 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752660AbXLSUy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 15:54:58 -0500
Date: Wed, 19 Dec 2007 21:54:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Len Brown <lenb@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Voluntary leave_mm before entering ACPI C3
Message-ID: <20071219205431.GA8370@elte.hu>
References: <20071219183443.GA547@linux-os.sc.intel.com> <20071219193255.GA2158@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071219193255.GA2158@elte.hu>
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


FYI, your patch needed the fix below for !SMP. It works fine otherwise.

	Ingo

---
 include/asm-x86/mmu.h |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux/include/asm-x86/mmu.h
===================================================================
--- linux.orig/include/asm-x86/mmu.h
+++ linux/include/asm-x86/mmu.h
@@ -20,6 +20,12 @@ typedef struct { 
 	void *vdso;
 } mm_context_t;
 
+#ifdef CONFIG_SMP
 void leave_mm(int cpu);
+#else
+static inline void leave_mm(int cpu)
+{
+}
+#endif
 
 #endif /* _ASM_X86_MMU_H */
