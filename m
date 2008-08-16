Return-Path: <linux-kernel-owner+w=401wt.eu-S1754357AbYHPIXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357AbYHPIXZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 04:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbYHPIXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 04:23:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57983 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140AbYHPIXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 04:23:15 -0400
Date: Sat, 16 Aug 2008 10:22:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: io_apic.c, build fix
Message-ID: <20080816082258.GA5915@elte.hu>
References: <1218843762-14650-1-git-send-email-yhlu.kernel@gmail.com> <1218843762-14650-2-git-send-email-yhlu.kernel@gmail.com> <1218843762-14650-3-git-send-email-yhlu.kernel@gmail.com> <1218843762-14650-4-git-send-email-yhlu.kernel@gmail.com> <1218843762-14650-5-git-send-email-yhlu.kernel@gmail.com> <1218843762-14650-6-git-send-email-yhlu.kernel@gmail.com> <1218843762-14650-7-git-send-email-yhlu.kernel@gmail.com> <20080816080221.GA8415@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080816080221.GA8415@elte.hu>
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


>From 306bb46f92d326c5afae3fa04860bdccb879b6b8 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sat, 16 Aug 2008 10:18:31 +0200
Subject: [PATCH] x86: io_apic.c, build fix

fix:

 arch/x86/kernel/io_apic.c: In function 'MPBIOS_trigger':
 arch/x86/kernel/io_apic.c:1105: error: implicit declaration of function 'default_MCA_trigger'

the MCA defines got lost in the unification.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/io_apic.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 2043cd8..929429f 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -1025,6 +1025,12 @@ static int EISA_ELCR(unsigned int irq)
 #define default_EISA_trigger(idx)       (EISA_ELCR(mp_irqs[idx].mp_srcbusirq))
 #define default_EISA_polarity(idx)      default_ISA_polarity(idx)
 
+/* MCA interrupts are always polarity zero level triggered,
+ * when listed as conforming in the MP table. */
+
+#define default_MCA_trigger(idx)	(1)
+#define default_MCA_polarity(idx)	default_ISA_polarity(idx)
+
 
 static int MPBIOS_polarity(int idx)
 {
