Return-Path: <linux-kernel-owner+w=401wt.eu-S1760148AbZBDT0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760148AbZBDT0c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 14:26:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758488AbZBDT0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 14:26:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39901 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758738AbZBDT0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 14:26:09 -0500
Date: Wed, 4 Feb 2009 20:25:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [git pull] timer fix
Message-ID: <20090204192551.GA19539@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

Linus,

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

 Thanks,

	Ingo

------------------>
Pavel Emelyanov (1):
      x86: fix hpet timer reinit for x86_64


 arch/x86/kernel/hpet.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 64d5ad0..ec319d1 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -1075,7 +1075,7 @@ static void hpet_rtc_timer_reinit(void)
 		hpet_t1_cmp += delta;
 		hpet_writel(hpet_t1_cmp, HPET_T1_CMP);
 		lost_ints++;
-	} while ((long)(hpet_readl(HPET_COUNTER) - hpet_t1_cmp) > 0);
+	} while ((long)(hpet_readl(HPET_COUNTER) - (u32)hpet_t1_cmp) > 0);
 
 	if (lost_ints) {
 		if (hpet_rtc_flags & RTC_PIE)
