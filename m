Return-Path: <linux-kernel-owner+w=401wt.eu-S1753673AbYHSCWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673AbYHSCWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 22:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbYHSCWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 22:22:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42295 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395AbYHSCWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 22:22:07 -0400
Date: Tue, 19 Aug 2008 04:21:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] sparse irqs: UP build fix
Message-ID: <20080819022150.GA14684@elte.hu>
References: <1219108476-30501-1-git-send-email-yhlu.kernel@gmail.com> <20080819012044.GE14821@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080819012044.GE14821@elte.hu>
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


>From 8ed1307017efa10960e4ad1650b931eb70d6434c Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 19 Aug 2008 04:27:17 +0200
Subject: [PATCH] sparse irqs: UP build fix

fix:

 In file included from arch/x86/kernel/early-quirks.c:18:
 include/asm/io_apic.h: In function 'probe_nr_irqs':
 include/asm/io_apic.h:209: error: 'NR_IRQS' undeclared (first use in this function)
 include/asm/io_apic.h:209: error: (Each undeclared identifier is reported only once
 include/asm/io_apic.h:209: error: for each function it appears in.)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/asm-x86/io_apic.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/asm-x86/io_apic.h b/include/asm-x86/io_apic.h
index 92a8308..d35cbd7 100644
--- a/include/asm-x86/io_apic.h
+++ b/include/asm-x86/io_apic.h
@@ -4,6 +4,7 @@
 #include <linux/types.h>
 #include <asm/mpspec.h>
 #include <asm/apicdef.h>
+#include <asm/irq_vectors.h>
 
 /*
  * Intel IO-APIC support for SMP and UP systems.
