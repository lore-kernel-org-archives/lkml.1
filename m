Return-Path: <linux-kernel-owner+w=401wt.eu-S1751225AbXAXLYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751225AbXAXLYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 06:24:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbXAXLYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 06:24:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60940 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbXAXLYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 06:24:49 -0500
Date: Wed, 24 Jan 2007 12:23:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       John Stultz <johnstul@us.ibm.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [patch] clocksource: fixup is_continous changes in vmitime.c
Message-ID: <20070124112326.GA9937@elte.hu>
References: <20070123211159.178138000@localhost.localdomain> <20070123211204.553722000@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070123211204.553722000@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.8 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	0.5 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4103]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


small update: the following -mm -only patch is needed as well to convert 
vmitime.c to CLOCK_SOURCE_IS_CONTINUOUS.

	Ingo

---------------------------->
Subject: [patch] clocksource: fixup is_continous changes in vmitime.c
From: Ingo Molnar <mingo@elte.hu>

convert vmitime.c to the new clocksource flag.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/i386/kernel/vmitime.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/i386/kernel/vmitime.c
===================================================================
--- linux.orig/arch/i386/kernel/vmitime.c
+++ linux/arch/i386/kernel/vmitime.c
@@ -113,7 +113,7 @@ static struct clocksource clocksource_vm
 	.mask			= CLOCKSOURCE_MASK(64),
 	.mult			= 0, /* to be set */
 	.shift			= 22,
-	.is_continuous		= 1,
+	.flags			= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
 
