Return-Path: <linux-kernel-owner+w=401wt.eu-S1755161AbYGVMSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbYGVMSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 08:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbYGVMSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 08:18:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39206 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbYGVMSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 08:18:07 -0400
Date: Tue, 22 Jul 2008 14:17:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Roland McGrath <roland@redhat.com>,
       Mikulas Patocka <mpatocka@redhat.com>,
       Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [patch] Fix crash due to missing debugctlmsr on AMD K6-3
Message-ID: <20080722121749.GC5806@elte.hu>
References: <20080722120047.GA6795@host0.dyn.jankratochvil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080722120047.GA6795@host0.dyn.jankratochvil.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Jan Kratochvil <jan.kratochvil@redhat.com> wrote:

> Hi,
> 
> currently if you use PTRACE_SINGLEBLOCK on AMD K6-3 (i586) it will 
> crash. Kernel now wrongly assumes existing DEBUGCTLMSR MSR register 
> there.
> 
> Removed the assumption also for some other non-K6 CPUs but I am not 
> sure there (but it can only bring small inefficiency there if my 
> assumption is wrong).
> 
> Based on info from Roland McGrath, Chuck Ebbert and Mikulas Patocka. 
> More info at:
> 	https://bugzilla.redhat.com/show_bug.cgi?id=456175
> 
> Please Cc me in a reply.

applied to tip/x86/urgent, thanks Jan! The commit below is also for 
-stable.

	Ingo

----------------->
commit d536b1f86591fb081c7a56eab04e711eb4dab951
Author: Jan Kratochvil <jan.kratochvil@redhat.com>
Date:   Tue Jul 22 14:00:47 2008 +0200

    x86: fix crash due to missing debugctlmsr on AMD K6-3
    
    currently if you use PTRACE_SINGLEBLOCK on AMD K6-3 (i586) it will crash.
    Kernel now wrongly assumes existing DEBUGCTLMSR MSR register there.
    
    Removed the assumption also for some other non-K6 CPUs but I am not sure there
    (but it can only bring small inefficiency there if my assumption is wrong).
    
    Based on info from Roland McGrath, Chuck Ebbert and Mikulas Patocka.
    More info at:
    	https://bugzilla.redhat.com/show_bug.cgi?id=456175
    
    Signed-off-by: Jan Kratochvil <jan.kratochvil@redhat.com>
    Cc: <stable@kernel.org>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig.cpu |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 54b8c02..2c518fb 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -414,4 +414,4 @@ config X86_MINIMUM_CPU_FAMILY
 
 config X86_DEBUGCTLMSR
 	def_bool y
-	depends on !(M586MMX || M586TSC || M586 || M486 || M386)
+	depends on !(MK6 || MWINCHIPC6 || MWINCHIP2 || MWINCHIP3D || MCYRIXIII || M586MMX || M586TSC || M586 || M486 || M386)
