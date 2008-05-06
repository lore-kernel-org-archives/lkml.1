Return-Path: <linux-kernel-owner+w=401wt.eu-S1763037AbYEFMoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763037AbYEFMoW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 08:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761974AbYEFMoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 08:44:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55789 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761882AbYEFMn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 08:43:59 -0400
Date: Tue, 6 May 2008 14:43:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org, tglx@linutronix.de,
       venkatesh.pallipadi@intel.com
Subject: Re: x86: Clean up computation of HPET .mult variables
Message-ID: <20080506124348.GR32591@elte.hu>
References: <20080505231016.GA29072@beyonder.ift.unesp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505231016.GA29072@beyonder.ift.unesp.br>
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


* Carlos R. Mafra <crmafra2@gmail.com> wrote:

> While reading through the HPET code I realized that the computation of 
> .mult variables could be done with less lines of code, resulting in a 
> 1.6% text size saving for hpet.o
> 
> So I propose the following patch, which applies against today's Linus 
> -git tree.

applied to x86.git for more testing, thanks Carlos.

since you seem to be interested in HPET topics, what do you think about 
the patch below from akpm? It had a build failure with this config:

  http://redhat.com/~mingo/misc/config-Sun_May__4_09_41_21_CEST_2008.bad

but the general cleanliness point Andrew raises is valid i think.

	Ingo

------------->
From: Andrew Morton <akpm@linux-foundation.org>

Should already be available via the hpet.h inclusion.

Could go further, by defining the do-nothing stub in hpet.h as well, perhaps.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rtc.c     |    2 --
 drivers/rtc/rtc-cmos.c |    1 -
 2 files changed, 3 deletions(-)

diff -puN drivers/char/rtc.c~rtc-remove-unneeded-declarations-of-hpet_rtc_interrupt drivers/char/rtc.c
--- a/drivers/char/rtc.c~rtc-remove-unneeded-declarations-of-hpet_rtc_interrupt
+++ a/drivers/char/rtc.c
@@ -119,8 +119,6 @@ static irqreturn_t hpet_rtc_interrupt(in
 	return 0;
 }
 #endif
-#else
-extern irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id);
 #endif
 
 /*
diff -puN drivers/rtc/rtc-cmos.c~rtc-remove-unneeded-declarations-of-hpet_rtc_interrupt drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-remove-unneeded-declarations-of-hpet_rtc_interrupt
+++ a/drivers/rtc/rtc-cmos.c
@@ -52,7 +52,6 @@
 #define hpet_rtc_timer_init() 			do { } while (0)
 #define hpet_register_irq_handler(h) 		0
 #define hpet_unregister_irq_handler(h)		do { } while (0)
-extern irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id);
 #endif
 
 struct cmos_rtc {
_
