Return-Path: <linux-kernel-owner+w=401wt.eu-S1754046AbYL0KHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbYL0KHS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 05:07:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbYL0KHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 05:07:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60241 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619AbYL0KHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 05:07:02 -0500
Date: Sat, 27 Dec 2008 11:06:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sparseirq: set lock_class for legacy irq when
	sparse_irq is selected
Message-ID: <20081227100645.GA14639@elte.hu>
References: <495067E9.9000904@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <495067E9.9000904@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> 
> Impact: fix
> 
> that is used to call init_one_irq_desc, after we use static one 
> directly, that line need to be duplicated too.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

applied to tip/irq/sparseirq, thanks Yinghai. I updated the changelog to 
the one below.

	Ingo

----------------->
>From 46f2e2de343fa15374fa95e3b1f1d53443803b48 Mon Sep 17 00:00:00 2001
From: Yinghai Lu <yinghai@kernel.org>
Date: Mon, 22 Dec 2008 20:24:09 -0800
Subject: [PATCH] sparseirq: set lock_class for legacy irq when sparse_irq is selected

Impact: add lockdep annotation to legacy IRQ descs

Warnings resulting out of this were not seen in practice, but it's prudent
to initialize the legacy descriptors to the lock class as well, symmetric
to how we do it with other descriptors.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/irq/handle.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 1a01f91..157c04c 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -145,6 +145,7 @@ int __init early_irq_init(void)
 	for (i = 0; i < legacy_count; i++) {
 		desc[i].irq = i;
 		desc[i].kstat_irqs = kstat_irqs_legacy[i];
+		lockdep_set_class(&desc[i].lock, &irq_desc_lock_class);
 
 		irq_desc_ptrs[i] = desc + i;
 	}
