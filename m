Return-Path: <linux-kernel-owner+w=401wt.eu-S1753896AbZITHrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbZITHrQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 03:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbZITHrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 03:47:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46394 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753153AbZITHrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 03:47:15 -0400
Date: Sun, 20 Sep 2009 09:47:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT pull] timers/timekeeping for 2.6.32
Message-ID: <20090920074706.GA32245@elte.hu>
References: <alpine.LFD.2.00.0909161555360.8957@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0909161555360.8957@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> Linus,
> 
> Please pull the latest timers-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-for-linus
> 
> The changes in arch/arm, m68knommu, mips, powerpc, s390, sh, x86 and
> xtensa are fixups due to API changes in the core code.

Linus,

When pulling this you did a merge resolution to 
arch/mips/loongson/common/time.c in commit a03fdb761, but it looks 
suspicious:

 void read_persistent_clock(struct timespec *ts)
 {
         ts->tv_sec = return mc146818_get_cmos_time();
         ts->tv_nsec = 0;
 }

that 'return' looks stray, so shouldnt we do the fix below?

	Ingo

Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/mips/loongson/common/time.c b/arch/mips/loongson/common/time.c
index 0edbef3..6e08c82 100644
--- a/arch/mips/loongson/common/time.c
+++ b/arch/mips/loongson/common/time.c
@@ -23,6 +23,6 @@ void __init plat_time_init(void)
 
 void read_persistent_clock(struct timespec *ts)
 {
-	ts->tv_sec = return mc146818_get_cmos_time();
+	ts->tv_sec = mc146818_get_cmos_time();
 	ts->tv_nsec = 0;
 }
