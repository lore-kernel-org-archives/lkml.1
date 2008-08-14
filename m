Return-Path: <linux-kernel-owner+w=401wt.eu-S1758851AbYHNJFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851AbYHNJFf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 05:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758508AbYHNJEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 05:04:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57627 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758775AbYHNJEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 05:04:52 -0400
Date: Thu, 14 Aug 2008 11:04:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: crane cai <crane.cai@amd.com>
Cc: vojtech@suse.cz, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] HPET: Workaround for a BIOS workaround on AMD SB700
	platform
Message-ID: <20080814090440.GF1650@elte.hu>
References: <1218683616.20466.13.camel@crane-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218683616.20466.13.camel@crane-laptop>
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


small build fix:

>From c107f81791afa9f749cf242944c90a18faf69fda Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 14 Aug 2008 11:03:24 +0200
Subject: [PATCH] x86, hpet: workaround for a BIOS workaround on AMD SB700 platform, fix

fix:

 arch/x86/kernel/early-quirks.c: In function 'amd_sb700_hpet':
 arch/x86/kernel/early-quirks.c:105: error: 'sb700_hpet_workaround' undeclared (first use in this function)
 arch/x86/kernel/early-quirks.c:105: error: (Each undeclared identifier is reported only once
 arch/x86/kernel/early-quirks.c:105: error: for each function it appears in.)

which triggers in the !HPET + !HPET_TIMER case.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/asm-x86/hpet.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-x86/hpet.h b/include/asm-x86/hpet.h
index 8f9a4e2..261fb68 100644
--- a/include/asm-x86/hpet.h
+++ b/include/asm-x86/hpet.h
@@ -55,8 +55,6 @@
  */
 #define HPET_MIN_PERIOD		100000UL
 
-extern int sb700_hpet_workaround;
-
 /* hpet memory map physical address */
 extern unsigned long hpet_address;
 extern unsigned long force_hpet_address;
@@ -87,6 +85,8 @@ extern void hpet_unregister_irq_handler(rtc_irq_handler handler);
 
 #else /* CONFIG_HPET_TIMER */
 
+extern int sb700_hpet_workaround;
+
 static inline int hpet_enable(void) { return 0; }
 static inline int is_hpet_enabled(void) { return 0; }
 #define hpet_readl(a) 0

