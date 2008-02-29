Return-Path: <linux-kernel-owner+w=401wt.eu-S933882AbYB2T70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933882AbYB2T70 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 14:59:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760406AbYB2T7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 14:59:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58546 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758666AbYB2T7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 14:59:07 -0500
Date: Fri, 29 Feb 2008 20:58:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>, lguest@ozlabs.org,
       akpm <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: Re: [BUG + PATCH/Bugfix] x86/lguest: fix pgdir pmd index
	calculation
Message-ID: <20080229195838.GB21494@elte.hu>
References: <20080224155515.GA24831@ubuntu> <20080224161814.GA29556@elte.hu> <20080224162653.GA30364@ubuntu> <20080225001816.GA2933@ubuntu> <20080229003224.GA18821@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080229003224.GA18821@ubuntu>
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


* Ahmed S. Darwish <darwish.07@gmail.com> wrote:

> On the lguest _guest_ side, 'cpu_has_tsc' is _always_ false (due to 
> lguest using his own clocksource ?), thus a guest with a pentium+ cpu 
> always panics with:

does the "RDTSC" instruction work in an lguest guest? If not, then the 
lguest kernel is correct in not exposing it - and then the solution is 
to build a non-TSC guest kernel. Does the patch below help?

but if the RDTSC instruction does work in an lguest guest, then the 
proper approach would be to expose it in the CPU features.

	Ingo
---
 arch/x86/Kconfig.cpu |    1 +
 1 file changed, 1 insertion(+)

Index: linux-x86.q/arch/x86/Kconfig.cpu
===================================================================
--- linux-x86.q.orig/arch/x86/Kconfig.cpu
+++ linux-x86.q/arch/x86/Kconfig.cpu
@@ -393,6 +393,7 @@ config X86_P6_NOP
 config X86_TSC
 	def_bool y
 	depends on ((MWINCHIP3D || MWINCHIP2 || MCRUSOE || MEFFICEON || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || MK8 || MVIAC3_2 || MVIAC7 || MGEODEGX1 || MGEODE_LX || MCORE2) && !X86_NUMAQ) || X86_64
+	depends on !LGUEST_GUEST
 
 # this should be set for all -march=.. options where the compiler
 # generates cmov.
