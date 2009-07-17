Return-Path: <linux-kernel-owner+w=401wt.eu-S965010AbZGQR3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965010AbZGQR3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 13:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964980AbZGQR3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 13:29:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49189 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933583AbZGQR1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 13:27:54 -0400
From: Izik Eidus <ieidus@redhat.com>
To: akpm@linux-foundation.org
Cc: hugh.dickins@tiscali.co.uk, aarcange@redhat.com, chrisw@redhat.com,
       avi@redhat.com, riel@redhat.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, nickpiggin@yahoo.com.au, ieidus@redhat.com
Subject: [PATCH 00/10] ksm resend
Date: Fri, 17 Jul 2009 20:30:40 +0300
Message-Id: <1247851850-4298-1-git-send-email-ieidus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

First for who that is not familier with what is ksm please take a look at:
http://lkml.org/lkml/2009/4/19/210

About this send:

After modifications by Hugh Dickins to make the ksm code fit more to the
internal strctures / interfaces of the kernel, I am resending the whole seires
again.

The biggest change from previous version that was sent is: the moving into
madvise interface for registering the application memory to be scan.
Now when application want its memory to be merged with another applications
what it do is to call to madvise() with the MADV_MERGEABLE flag set.

In addition to changes to the interfaces of ksm,. there was a major code
clean / optimizations made by Hugh.

There is more work to be taken in the area of documentions, as well as some
questions regerding to how ksm should handle the way it break the SharedPages
when it need to do so, but the code seems to be ready to be in the MM tree
right now to get more testing and reviews from other developers.

The code still need to get Andrea Arcangeli acks.
(he was busy and will ack it later).

Thanks.

Izik Eidus (10):
  ksm: add mmu_notifier set_pte_at_notify()
  ksm: first tidy up madvise_vma()
  ksm: define MADV_MERGEABLE and MADV_UNMERGEABLE
  ksm: the mm interface to ksm
  ksm: no debug in page_dup_rmap()
  ksm: identify PageKsm pages
  ksm: Kernel SamePage Merging
  ksm: prevent mremap move poisoning
  ksm: change copyright message
  ksm: change ksm nice level to be 5

 arch/alpha/include/asm/mman.h     |    3 +
 arch/mips/include/asm/mman.h      |    3 +
 arch/parisc/include/asm/mman.h    |    3 +
 arch/xtensa/include/asm/mman.h    |    3 +
 fs/proc/page.c                    |    5 +
 include/asm-generic/mman-common.h |    3 +
 include/linux/ksm.h               |   79 ++
 include/linux/mm.h                |    1 +
 include/linux/mmu_notifier.h      |   34 +
 include/linux/rmap.h              |    6 +-
 include/linux/sched.h             |    7 +
 kernel/fork.c                     |    8 +-
 mm/Kconfig                        |   11 +
 mm/Makefile                       |    1 +
 mm/ksm.c                          | 1543 +++++++++++++++++++++++++++++++++++++
 mm/madvise.c                      |   53 +-
 mm/memory.c                       |   14 +-
 mm/mmu_notifier.c                 |   20 +
 mm/mremap.c                       |   12 +
 mm/rmap.c                         |   21 -
 20 files changed, 1773 insertions(+), 57 deletions(-)
 create mode 100644 include/linux/ksm.h
 create mode 100644 mm/ksm.c

