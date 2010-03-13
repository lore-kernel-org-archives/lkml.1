Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156Ab0CMKpt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 05:45:49 -0500
Received: from mail.in-ulm.de ([217.10.8.10]:34593 "HELO mail.in-ulm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751226Ab0CMKps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 05:45:48 -0500
Date: Sat, 13 Mar 2010 11:45:46 +0100
From: Christian Ehrhardt <lk@c--e.de>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Rik van Riel <riel@redhat.com>
Subject: [PATCH 0/2] rmap: Fix Bugzilla Bug #5493
Message-ID: <20100313104546.GA16643@lisa.in-ulm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

this set of two patches fixes Bugzilla Bug #5493.

      http://bugzilla.kernel.org/show_bug.cgi?id=5493

The first patch makes the vma prio tree code reusable. This patch
should not contain any functional changes.

The second patch uses the prio tree code for the vmas associated with
an anon_vma. This allows us to replace the linear searches in rmap.c
with prio tree iterations that are much more efficient if there are
many vmas associated with an anon_vma.

The runtime of the test program in the bug report reduces from half an
hour to about two minutes on the VBox instance used for testing.

The patch is against a current vanilla kernel that already includes the
vma linking patches from Rik.

Diffstat for both patches combined:

 arch/arm/mm/fault-armv.c   |    3 +-
 arch/arm/mm/flush.c        |    3 +-
 arch/parisc/kernel/cache.c |    3 +-
 arch/x86/mm/hugetlbpage.c  |    3 +-
 fs/hugetlbfs/inode.c       |    3 +-
 fs/inode.c                 |    2 +-
 include/linux/mm.h         |   32 ++++++++--
 include/linux/mm_types.h   |   10 +---
 include/linux/prio_tree.h  |   17 +++++-
 include/linux/rmap.h       |   88 +++++++++++++++++---------
 kernel/fork.c              |    2 +-
 lib/prio_tree.c            |   14 +++-
 mm/filemap_xip.c           |    3 +-
 mm/fremap.c                |    2 +-
 mm/hugetlb.c               |    3 +-
 mm/ksm.c                   |   25 ++++++--
 mm/memory-failure.c        |    9 ++-
 mm/memory.c                |    5 +-
 mm/mmap.c                  |   43 ++++++++-----
 mm/nommu.c                 |   12 ++--
 mm/prio_tree.c             |  148 +++++++++++++++++++++-----------------------
 mm/rmap.c                  |   41 ++++++++----
 22 files changed, 284 insertions(+), 187 deletions(-)

     regards    Christian

