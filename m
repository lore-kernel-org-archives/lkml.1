Return-Path: <linux-kernel-owner+w=401wt.eu-S1761980AbZAWKCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761980AbZAWKCG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 05:02:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758924AbZAWKBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 05:01:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58149 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756354AbZAWKBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 05:01:53 -0500
Date: Fri, 23 Jan 2009 11:01:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] x86, xen: fix hardirq.h merge fallout
Message-ID: <20090123100135.GA18491@elte.hu>
References: <73c1f2160901220533n53cdbb33q2eec14d47176533d@mail.gmail.com> <497926C2.4090203@kernel.org> <20090123091658.GA29820@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090123091658.GA29820@elte.hu>
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


Find small 32-bit fixlet below.

	Ingo

--------------->
>From 99d0000f710f3432182761f65f9658f1cf0bf455 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 23 Jan 2009 11:09:15 +0100
Subject: [PATCH] x86, xen: fix hardirq.h merge fallout

Impact: build fix

This build error:

 arch/x86/xen/suspend.c:22: error: implicit declaration of function 'fix_to_virt'
 arch/x86/xen/suspend.c:22: error: 'FIX_PARAVIRT_BOOTMAP' undeclared (first use in this function)
 arch/x86/xen/suspend.c:22: error: (Each undeclared identifier is reported only once
 arch/x86/xen/suspend.c:22: error: for each function it appears in.)

triggers because the hardirq.h unification removed an implicit fixmap.h
include - on which arch/x86/xen/suspend.c depended. Add the fixmap.h
include explicitly.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/xen/suspend.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/suspend.c b/arch/x86/xen/suspend.c
index 212ffe0..95be7b4 100644
--- a/arch/x86/xen/suspend.c
+++ b/arch/x86/xen/suspend.c
@@ -6,6 +6,7 @@
 
 #include <asm/xen/hypercall.h>
 #include <asm/xen/page.h>
+#include <asm/fixmap.h>
 
 #include "xen-ops.h"
 #include "mmu.h"
