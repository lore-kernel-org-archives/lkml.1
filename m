Return-Path: <linux-kernel-owner+w=401wt.eu-S1758155AbYAOVDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155AbYAOVDy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 16:03:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753143AbYAOVDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 16:03:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51852 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756795AbYAOVDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 16:03:41 -0500
Date: Tue, 15 Jan 2008 22:03:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: [patch] x86: lfence fix
Message-ID: <20080115210321.GA14757@elte.hu>
References: <20080114094814.GA28300@basil.nowhere.org> <20080114125638.GA9510@basil.nowhere.org> <20080114130620.GA14057@elte.hu> <20080114135811.GA16190@one.firstfloor.org> <478BDC43.6050105@goop.org> <20080114222349.GA23409@one.firstfloor.org> <478BE628.7090008@goop.org> <20080115010534.GA24854@one.firstfloor.org> <478C0D18.5020505@goop.org> <20080115013858.GA25112@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080115013858.GA25112@one.firstfloor.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> I just tested x86.git and then x86.git + patch you send (+ build fixes 
> in both cases), none of your patchkits. If you want me to test some 
> other patchkit please point me to it.
> 
> The problem happens with plain git-x86 (+ build fixes) and also with 
> git-x86 + your patch.

i was held up from debugging your problem by a bug introduced by you 
into x86.git ;-) See the fix below.

	Ingo

----------------------------->
Subject: x86: lfence fix
From: Ingo Molnar <mingo@elte.hu>

LFENCE is available on XMM2 or higher Intel CPUs - not XMM or higher...

this caused boot failures on pre-XMM2 CPUs.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/intel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-x86.q/arch/x86/kernel/cpu/intel.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/cpu/intel.c
+++ linux-x86.q/arch/x86/kernel/cpu/intel.c
@@ -206,7 +206,7 @@ static void __cpuinit init_intel(struct 
 	}
 #endif
 
-	if (cpu_has_xmm)
+	if (cpu_has_xmm2)
 		set_bit(X86_FEATURE_LFENCE_RDTSC, c->x86_capability);
 	if (c->x86 == 15) {
 		set_bit(X86_FEATURE_P4, c->x86_capability);
