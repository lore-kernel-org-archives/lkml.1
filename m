Return-Path: <linux-kernel-owner+w=401wt.eu-S1753903AbZG2KQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbZG2KQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 06:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753726AbZG2KQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 06:16:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45808 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389AbZG2KQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 06:16:29 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 0/4] Fix periodic itimers precision -v4
Date: Wed, 29 Jul 2009 12:15:25 +0200
Message-Id: <1248862529-6063-1-git-send-email-sgruszka@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm resending patches for fixing itimers periodic ticks precision,
for reference see: http://lkml.org/lkml/2009/4/2/230

Changelog:

v3 -> v4
- Rebase for 2.6.31

v2 -> v3 (resend 5):
- Use CPUCLOCK_PROF CPUCLOCK_VIRT defines in kernel/fork.c
- Using inline function cputime_sub_ns() with sanity check against negative
  results instead of macro.
- Add patch which optimize jiffies_to_cputime(1) for PowerPC with
  CONFIG_VIRT_CPU_ACCOUNTING 

v1 -> v2 (resend 4):
- Add comment about CPUCLOCK_PROF and CPUCLOCK_VIRT are 0 and 1 respectively and
  can be used for indexing itimers array.
- Remove not needed BUG().
- Coding style fixes.
- Better algorithm (idea form Thomas) to calculate next signal time for periodic
  itimers,  we use now precomputed nanosecond value of cputime 1 tick.
- Add patch with simplify arm_timer() function.

v0 -> v1 (resend 3):
- Fix bug: using utime instead of sum stime + utime when setup PROF itimer.
- Fix bug: using value->it_interval instead of ovalue->it_interavl.
- No new definitions IT_PROF and IT_VIRT only CPUCLOCK_PROF and CPUCLOCK_VIRT
  are used.

Cheers
Stanislaw
