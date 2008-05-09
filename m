Return-Path: <linux-kernel-owner+w=401wt.eu-S1764638AbYEIQV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764638AbYEIQV7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 12:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755167AbYEIQVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 12:21:51 -0400
Received: from saeurebad.de ([85.214.36.134]:37341 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754986AbYEIQVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 12:21:50 -0400
X-Mailbox-Line: From hannes@saeurebad.de Fri May  9 17:22:45 2008
Message-Id: <20080509151713.939253437@saeurebad.de>
User-Agent: quilt/0.46-1
Date: Fri, 09 May 2008 17:17:13 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 0/3] bootmem2 III
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is bootmem2, a memory block-oriented boot time allocator.

Recent NUMA topologies broke the current bootmem's assumption that
memory nodes provide non-overlapping and contiguous ranges of pages.

To cope with these configurations, bootmem2 operates on contiguous
memory blocks.

The node model is implemented on top of this scheme, every node
provides zero or more blocks of memory.

The usage of bootmem2 is almost the same as that of the current
allocator. On architectures that allow non-contiguous nodes the arch
code must register memory blocks instead of nodes, right now these
architectures are x86 and ia64.  For all other archs it is enough to
select bootmem2 and stop using pgdat->bdata.

bootmem can be dropped completely when those two architectures have
been migrated to bootmem2.

The first patch in this series makes the maximum number of memory
blocks (and the resulting number of blocks per node) available to
generic code as bootmem2 needs to work with those.

The second patch is bootmem2 itself.  Although the logical complexity
increased, I think the code is quite compact.  Every public interface
has been documented.

The third patch is trivial, it enables bootmem2 for x86_32 machines.

The allocator works on my X86_32 UMA computer, everything else is only
theory, please give it a test.

	Hannes

 arch/x86/Kconfig           |    1
 b/include/linux/bootmem2.h |  174 +++++++++++++
 b/mm/bootmem2.c            |  575 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/bootmem.h    |    6
 include/linux/numa.h       |   12
 mm/Kconfig                 |    3
 mm/Makefile                |    7
 mm/page_alloc.c            |    4
 8 files changed, 776 insertions(+), 6 deletions(-)

