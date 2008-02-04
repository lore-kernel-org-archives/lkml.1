Return-Path: <linux-kernel-owner+w=401wt.eu-S1754428AbYBDLwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbYBDLwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 06:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751811AbYBDLwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 06:52:05 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53144 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbYBDLwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 06:52:03 -0500
Date: Mon, 4 Feb 2008 12:51:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       petr@vandrovec.name
Subject: Re: Commit f06e4ec breaks vmware
Message-ID: <20080204115144.GA17850@elte.hu>
References: <Pine.LNX.4.64.0802020120150.18790@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802020120150.18790@fbirervta.pbzchgretzou.qr>
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


* Jan Engelhardt <jengelh@computergmbh.de> wrote:

> sad to say, but f06e4ec... breaks booting the kernel in vmware 
> (bisected). Booting just stops after
> 
> 	Checking for 'hlt' instruction...
> 
> commit f06e4ec1c15691b0cfd2397ae32214fa36c90d71
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Wed Jan 30 13:32:39 2008 +0100
> 
>     x86: read_tsc sync
>     
>     make native_read_tsc() always non-speculative.

could you send us the /proc/cpuinfo data of the guest CPU?

if latest -git still fails, does the patch below solve the problem?

	Ingo

---
 include/asm-x86/system.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-x86.q/include/asm-x86/system.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/system.h
+++ linux-x86.q/include/asm-x86/system.h
@@ -407,8 +407,7 @@ void default_idle(void);
  */
 static inline void rdtsc_barrier(void)
 {
-	alternative(ASM_NOP3, "mfence", X86_FEATURE_MFENCE_RDTSC);
-	alternative(ASM_NOP3, "lfence", X86_FEATURE_LFENCE_RDTSC);
+	smp_mb();
 }
 
 #endif
