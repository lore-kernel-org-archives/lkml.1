Return-Path: <linux-kernel-owner+w=401wt.eu-S1754895AbYBSNyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbYBSNyj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 08:54:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbYBSNyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 08:54:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40401 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752004AbYBSNy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 08:54:29 -0500
Date: Tue, 19 Feb 2008 14:54:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tony Breeds <tony@bakeyournoodle.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, lguest@ozlabs.org
Subject: Re: [PATCH] Fix building lguest as module.
Message-ID: <20080219135401.GA9192@elte.hu>
References: <20080201124520.GA29900@elte.hu> <20080201170551.GA3825@elte.hu> <200802040711.11280.rusty@rustcorp.com.au> <20080219034404.GT6887@bakeyournoodle.com> <20080219073205.GA12375@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219073205.GA12375@elte.hu>
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

> > +#endif
> > +
> > +#if defined(CONFIG_LGUEST) || defined(CONFIG_LGUEST_MODULE)
> > +	BLANK();
> 
> hm. Rusty's original fix is now upstream. I've done a delta to your 
> patch, find the fix is below.

the right one is below. There's no 'LGUEST_MODULE' anymore - 
'LGUEST_GUEST' is what should be used.

	Ingo

------------------->
Subject: lguest: fix build breakage
From: Tony Breeds <tony@bakeyournoodle.com>
Date: Tue Feb 19 08:16:03 CET 2008

[ mingo@elte.hu: merged to Rusty's patch ]

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/asm-offsets_32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-x86.q/arch/x86/kernel/asm-offsets_32.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/asm-offsets_32.c
+++ linux-x86.q/arch/x86/kernel/asm-offsets_32.c
@@ -128,7 +128,7 @@ void foo(void)
 	OFFSET(XEN_vcpu_info_pending, vcpu_info, evtchn_upcall_pending);
 #endif
 
-#ifdef CONFIG_LGUEST_GUEST
+#if defined(CONFIG_LGUEST) || defined(CONFIG_LGUEST_GUEST)
 	BLANK();
 	OFFSET(LGUEST_DATA_irq_enabled, lguest_data, irq_enabled);
 	OFFSET(LGUEST_DATA_pgdir, lguest_data, pgdir);
