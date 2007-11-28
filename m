Return-Path: <linux-kernel-owner+w=401wt.eu-S1760639AbXK1KlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760639AbXK1KlS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 05:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758172AbXK1KlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 05:41:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49198 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756442AbXK1KlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 05:41:06 -0500
Date: Wed, 28 Nov 2007 11:40:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [patch] Fix hpet wrong values
Message-ID: <20071128104040.GA20113@elte.hu>
References: <20071127122308.GA2640@elf.ucw.cz> <20071128103851.GA19701@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071128103851.GA19701@elte.hu>
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
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

>  ---------------->
>  e09e9089131ca0227a716aee143f49d084977e32 is first bad commit
>  commit e09e9089131ca0227a716aee143f49d084977e32
>  Author: Pavel Machek <pavel@ucw.cz>
>  Date:   Wed Nov 28 03:06:03 2007 +0100
> 
>       x86: fix wrong hpet values
>  <----------------

it's the hpet_enable() returning non-0 that is causing the crash. The 
current patch that is in x86.git is below.

	Ingo

------------------->
Subject: x86: fix wrong hpet values
From: Pavel Machek <pavel@ucw.cz>

If hpet is not enabled in config, its init should not pretend to work,
and people should not try to get time from it.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/asm-x86/hpet.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-x86.q/include/asm-x86/hpet.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/hpet.h
+++ linux-x86.q/include/asm-x86/hpet.h
@@ -82,8 +82,7 @@ extern irqreturn_t hpet_rtc_interrupt(in
 
 #else
 
-static inline int hpet_enable(void) { return 0; }
-static inline unsigned long hpet_readl(unsigned long a) { return 0; }
+static inline int hpet_enable(void) { return -ENODEV; }
 
 #endif /* CONFIG_HPET_TIMER */
 #endif /* ASM_X86_HPET_H */
