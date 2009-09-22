Return-Path: <linux-kernel-owner+w=401wt.eu-S1753377AbZIVHkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbZIVHkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 03:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbZIVHkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 03:40:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:44576 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbZIVHko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 03:40:44 -0400
From: Tejun Heo <tj@kernel.org>
To: Nick Piggin <npiggin@suse.de>, Tony Luck <tony.luck@intel.com>,
       Fenghua Yu <fenghua.yu@intel.com>,
       linux-ia64 <linux-ia64@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCHSET percpu#for-next] percpu: convert ia64 to dynamic percpu and drop the old one
Date: Tue, 22 Sep 2009 16:40:10 +0900
Message-Id: <1253605214-23210-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 22 Sep 2009 07:40:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, all.

This patchset converts ia64 to dynamic percpu allocator and drop the
now unused old percpu allocator.  This patchset contains the following
four patches.

 0001-vmalloc-rename-local-variables-vmalloc_start-and-vma.patch
 0002-ia64-allocate-percpu-area-for-cpu0-like-percpu-areas.patch
 0003-ia64-convert-to-dynamic-percpu-allocator.patch
 0004-percpu-kill-legacy-percpu-allocator.patch

0001 is misc prep to avoid macro / local variable collision.  0002
makes ia64 allocate percpu area for cpu0 in the same way it does for
other cpus.  0003 converts ia64 to dynamic percpu allocator and 0004
drops now unused legacy allocator.

Contig memory model was verified with ski emulator.  Discontig and
sparse models were verified on a 4-way SGI altix machine.  I've run
percpu stress test module for quite a while on the machine.

Mike Travis, it would be great if you can test this on your machine.
I'd really like to see how it would behave on a machine with that many
NUMA nodes.

This patchset is available in the following git tree.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git convert-ia64

Hmmm... kernel.org seems slow to sync today.  If the branch isn't
mirroreed, please pull from the master.

Thanks.

 arch/ia64/Kconfig              |    3 
 arch/ia64/kernel/setup.c       |   12 --
 arch/ia64/kernel/vmlinux.lds.S |   11 +-
 arch/ia64/mm/contig.c          |   87 ++++++++++++++++----
 arch/ia64/mm/discontig.c       |  120 +++++++++++++++++++++++++--
 include/linux/percpu.h         |   24 -----
 kernel/module.c                |  150 ----------------------------------
 mm/Makefile                    |    4 
 mm/allocpercpu.c               |  177 -----------------------------------------
 mm/percpu.c                    |    2 
 mm/vmalloc.c                   |   16 +--
 11 files changed, 193 insertions(+), 413 deletions(-)

--
tejun
