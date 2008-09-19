Return-Path: <linux-kernel-owner+w=401wt.eu-S1756344AbYISHQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344AbYISHQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 03:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750792AbYISHQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 03:16:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39163 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbYISHQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 03:16:47 -0400
Date: Fri, 19 Sep 2008 09:16:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/mtrr: fix compiling warning
Message-ID: <20080919071629.GA3604@elte.hu>
References: <1221808310-15759-1-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221808310-15759-1-git-send-email-yhlu.kernel@gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

thx - applied the earlier version below already.

	Ingo

------------>
>From 279b0bbba2bb647348ad90e183b3960aa99eccfd Mon Sep 17 00:00:00 2001
From: Yinghai Lu <yhlu.kernel@gmail.com>
Date: Thu, 18 Sep 2008 23:55:27 -0700
Subject: [PATCH] x86: fix arch/x86/kernel/cpu/mtrr/main.c warning

fix this warning reported by Andrew Morton:

> arch/x86/kernel/cpu/mtrr/main.c: In function 'mtrr_bp_init':
> arch/x86/kernel/cpu/mtrr/main.c:1170: warning: 'extra_remove_base' may be used uninitialized in this function

the warning is bogus but the logic that prevents uninitialized use
is a bit convoluted so simplify it all.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/mtrr/main.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index b117d7f..8a7c792 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -1218,11 +1218,10 @@ static int __init mtrr_cleanup(unsigned address_bits)
 
 	memset(range, 0, sizeof(range));
 	extra_remove_size = 0;
-	if (mtrr_tom2) {
-		extra_remove_base = 1 << (32 - PAGE_SHIFT);
+	extra_remove_base = 1 << (32 - PAGE_SHIFT);
+	if (mtrr_tom2)
 		extra_remove_size =
 			(mtrr_tom2 >> PAGE_SHIFT) - extra_remove_base;
-	}
 	nr_range = x86_get_mtrr_mem_range(range, 0, extra_remove_base,
 					  extra_remove_size);
 	range_sums = sum_ranges(range, nr_range);
