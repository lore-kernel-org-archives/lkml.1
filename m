Return-Path: <linux-kernel-owner+w=401wt.eu-S966723AbYCSWnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966723AbYCSWnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761924AbYCSVN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:13:58 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:40044 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965655AbYCSVN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:13:56 -0400
Date: Wed, 19 Mar 2008 19:48:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, ak@suse.de
Subject: Re: [PATCH 0/79] smpboot integration
Message-ID: <20080319184812.GA7646@elte.hu>
References: <12059475744092-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12059475744092-git-send-email-gcosta@redhat.com>
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


the small fix below was needed - it is possible to build ACPI on 32-bit 
with APIC support disabled. Otherwise it's looking good in my testing.

	Ingo

-----------------
Subject: x86: smp unify2 include mach apic h in smpboot 64 c and smpboot c fix
From: Ingo Molnar <mingo@elte.hu>
Date: Wed Mar 19 19:25:58 CET 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/acpi/boot.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-x86.q/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/acpi/boot.c
+++ linux-x86.q/arch/x86/kernel/acpi/boot.c
@@ -40,7 +40,9 @@
 #include <asm/io.h>
 #include <asm/mpspec.h>
 
-#include <mach_apic.h>
+#ifdef CONFIG_X86_LOCAL_APIC
+# include <mach_apic.h>
+#endif
 
 static int __initdata acpi_force = 0;
 
