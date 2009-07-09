Return-Path: <linux-kernel-owner+w=401wt.eu-S1753671AbZGIR3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671AbZGIR3l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 13:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564AbZGIR3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 13:29:34 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:51379 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751066AbZGIR3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 13:29:33 -0400
Subject: [GIT PULL] Kmemleak fixes
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 09 Jul 2009 18:29:20 +0100
Message-Id: <1247160560.11409.96.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Jul 2009 17:29:21.0551 (UTC) FILETIME=[CBBC41F0:01CA00BA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Would you please consider merging the kmemleak branch?

It contains several fixes to bugs raised recently and also reduces the
number of false positives to nearly 0 (actually making the tool usable -
one of the slub kmalloc calls for large blocks was completely missed and
bootmem allocations would need to be tracked as well since many of them
contain valid pointers).

Thanks.


The following changes since commit 34f25476ace556263784ea2f8173e22b25557a13:
  Linus Torvalds (1):
        Merge branch 'fixes' of git://git.kernel.org/.../davej/cpufreq

are available in the git repository at:

  git://linux-arm.org/linux-2.6 kmemleak

Catalin Marinas (9):
      kmemleak: Renice the scanning thread to +10
      kmemleak: Add more cond_resched() calls in the scanning thread
      kmemleak: Remove the reported leaks number limitation
      kmemleak: Do not acquire scan_mutex in kmemleak_open()
      kmemleak: Scan objects allocated during a scanning episode
      kmemleak: Trace the kmalloc_large* functions in slub
      kmemleak: Allow partial freeing of memory blocks
      kmemleak: Add callbacks to the bootmem allocator
      kmemleak: Remove alloc_bootmem annotations introduced in the past

 include/linux/kmemleak.h |    4 +
 include/linux/slub_def.h |    2 +
 kernel/pid.c             |    7 --
 mm/bootmem.c             |    6 +
 mm/kmemleak.c            |  236 ++++++++++++++++++++++++++++++++--------------
 mm/page_alloc.c          |   14 +--
 mm/slub.c                |   10 +-
 7 files changed, 185 insertions(+), 94 deletions(-)

-- 
Catalin

