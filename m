Return-Path: <linux-kernel-owner+w=401wt.eu-S1760066AbYHNOIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760066AbYHNOIF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 10:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750840AbYHNOHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 10:07:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38565 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbYHNOHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 10:07:53 -0400
Date: Thu, 14 Aug 2008 16:07:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] irq: sparse irqs, fix #3
Message-ID: <20080814140733.GA31829@elte.hu>
References: <1218705441-21838-1-git-send-email-yhlu.kernel@gmail.com> <20080814132638.GA18743@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080814132638.GA18743@elte.hu>
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


>From 1b53f0444df394e4448ba56694f0bc4dda2bece0 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 14 Aug 2008 16:07:04 +0200
Subject: [PATCH] irq: sparse irqs, fix #3

fix non-APIC UP build:

 arch/x86/kernel/built-in.o: In function `setup_arch':
 : undefined reference to `pin_map_size'
 arch/x86/kernel/built-in.o: In function `setup_arch':
 : undefined reference to `first_free_entry'

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/setup.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 24e984e..8318a35 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -863,8 +863,10 @@ void __init setup_arch(char **cmdline_p)
 		nr_irqs = 32 * nr_cpu_ids + 224;
 	init_cpu_to_node();
 #endif
+#ifdef CONFIG_X86_LOCAL_APIC
 	pin_map_size = nr_irqs * 2;
 	first_free_entry = nr_irqs;
+#endif
 
 	init_apic_mappings();
 	ioapic_init_mappings();
