Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbYJCJlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbYJCJlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 05:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbYJCJlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 05:41:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33464 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953AbYJCJlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 05:41:03 -0400
Date: Fri, 3 Oct 2008 11:40:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dean Nelson <dcn@sgi.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Alan Mayer <ajm@sgi.com>,
       jeremy@goop.org, rusty@rustcorp.com.au, suresh.b.siddha@intel.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <Yinghai.lu@amd.com>
Subject: x86, UV: add uv_setup_irq() and uv_teardown_irq() functions, v3,
	fix
Message-ID: <20081003094028.GA18748@elte.hu>
References: <20081001114415.GA3281@sgi.com> <86802c440810020919p4391cbebva0eaa5591e7915be@mail.gmail.com> <48E4FA53.7050401@zytor.com> <20081002171821.GA31601@sgi.com> <20081003085943.GC27551@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081003085943.GC27551@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Dean Nelson <dcn@sgi.com> wrote:
> 
> > Provide a means for UV interrupt MMRs to be setup with the message to be sent
> > when an MSI is raised.
> > 
> > Signed-off-by: Dean Nelson <dcn@sgi.com>
> 
> v3 looks good - applied to tip/x86/uv, thanks Dean!

-tip testing found a build error - fixlet below.

	Ingo

------------>
>From 1b2127d363a68a388e7c57610bb5ceeb743c89d2 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 3 Oct 2008 11:38:37 +0200
Subject: [PATCH] x86, UV: add uv_setup_irq() and uv_teardown_irq() functions, v3, fix

fix:

 arch/x86/kernel/uv_irq.c: In function 'uv_ack_apic':
 arch/x86/kernel/uv_irq.c:26: error: implicit declaration of function 'ack_APIC_irq'

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/uv_irq.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/uv_irq.c b/arch/x86/kernel/uv_irq.c
index 6bd26c9..aeef529 100644
--- a/arch/x86/kernel/uv_irq.c
+++ b/arch/x86/kernel/uv_irq.c
@@ -10,6 +10,8 @@
 
 #include <linux/module.h>
 #include <linux/irq.h>
+
+#include <asm/apic.h>
 #include <asm/uv/uv_irq.h>
 
 static void uv_noop(unsigned int irq)
