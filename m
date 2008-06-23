Return-Path: <linux-kernel-owner+w=401wt.eu-S1761822AbYFWUWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761822AbYFWUWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 16:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754887AbYFWUWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 16:22:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41180 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753062AbYFWUWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 16:22:46 -0400
Date: Mon, 23 Jun 2008 22:22:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: cleanup using max_low_pfn for 32 bit
Message-ID: <20080623202235.GA14743@elte.hu>
References: <200806180215.53755.yhlu.kernel@gmail.com> <200806220245.39289.yhlu.kernel@gmail.com> <200806220246.58958.yhlu.kernel@gmail.com> <200806230305.30944.yhlu.kernel@gmail.com> <20080623195616.GA3670@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080623195616.GA3670@elte.hu>
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


>       x86: clean up using max_low_pfn on 32-bit

this one needed the small fix below.

	Ingo

----------->
commit 749cffb6c81f6637bbd054a4db246196eaa69ccc
Author: Ingo Molnar <mingo@elte.hu>
Date:   Mon Jun 23 22:19:22 2008 +0200

    x86: build fix
    
    fix:
    
    arch/x86/kernel/setup_32.c:409: error: 'enable_local_apic' undeclared (first use in this function)
    arch/x86/kernel/setup_32.c:409: error: (Each undeclared identifier is reported only once
    arch/x86/kernel/setup_32.c:409: error: for each function it appears in.)
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/kernel/setup_32.c b/arch/x86/kernel/setup_32.c
index b42f570..1e67037 100644
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -406,7 +406,9 @@ void __init setup_arch(char **cmdline_p)
 	parse_early_param();
 
 	if (acpi_mps_check()){
+#ifdef CONFIG_X86_LOCAL_APIC
 		enable_local_apic = -1;
+#endif
 		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
 	}
 
