Return-Path: <linux-kernel-owner+w=401wt.eu-S1754831AbYIHPST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831AbYIHPST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 11:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbYIHPSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 11:18:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43950 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbYIHPSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 11:18:09 -0400
Date: Mon, 8 Sep 2008 17:17:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] kmemcheck updates for tip/kmemcheck
Message-ID: <20080908151753.GE10580@elte.hu>
References: <20080907200943.GA2665@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080907200943.GA2665@localhost.localdomain>
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


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> Ingo,
> 
> Here follows a small update to the REP instruction handling and 
> removal of some obsolete code (if you worry that this is useful code, 
> git will save it for us and it can be revived if needed. I believe 
> that the code is simply a burden as it is today).

pulled into tip/kmemcheck, thanks Vegard!

> I couldn't figure out how to merge v2.6.27-rc5 without littering the 
> pull request with all the commits that were made in Linus's repository 
> since v2.6.27-rc3, but feel free to do it yourself. There should be no 
> conflicts.

yeah, merges should generally be done in the upstream repo. Obviously 
git-request-pull must list all the commits that happened - it doesnt 
know which commits are 'interesting' or not. I've done an upstream 
merge.

btw., a small build fix (see below) was needed.

	Ingo

---------------->
>From 92a9abb2c571ab8fedaee3537c5667b4e61188ce Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 8 Sep 2008 16:50:43 +0200
Subject: [PATCH] kmemcheck: build fix
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

fix:

 arch/x86/mm/kmemcheck/kmemcheck.c: In function ‘kmemcheck_init’:
 arch/x86/mm/kmemcheck/kmemcheck.c:42: error: ‘setup_max_cpus’ undeclared (first use in this function)
 arch/x86/mm/kmemcheck/kmemcheck.c:42: error: (Each undeclared identifier is reported only once
 arch/x86/mm/kmemcheck/kmemcheck.c:42: error: for each function it appears in.)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/kmemcheck/kmemcheck.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/kmemcheck/kmemcheck.c b/arch/x86/mm/kmemcheck/kmemcheck.c
index eef8c6a..75831f0 100644
--- a/arch/x86/mm/kmemcheck/kmemcheck.c
+++ b/arch/x86/mm/kmemcheck/kmemcheck.c
@@ -35,6 +35,7 @@ void __init kmemcheck_init(void)
 {
 	printk(KERN_INFO "kmemcheck: \"Bugs, beware!\"\n");
 
+#if defined(CONFIG_SMP) && !defined(CONFIG_KMEMCHECK_USE_SMP)
 	/*
 	 * Limit SMP to use a single CPU. We rely on the fact that this code
 	 * runs before SMP is set up.
@@ -44,6 +45,7 @@ void __init kmemcheck_init(void)
 			"kmemcheck: Limiting number of CPUs to 1.\n");
 		setup_max_cpus = 1;
 	}
+#endif
 }
 
 #ifdef CONFIG_KMEMCHECK_DISABLED_BY_DEFAULT
