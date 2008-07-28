Return-Path: <linux-kernel-owner+w=401wt.eu-S1758214AbYG1TRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214AbYG1TRt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 15:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbYG1TRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 15:17:25 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:35104 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897AbYG1TRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 15:17:24 -0400
From: Eric Munson <ebmunson@us.ibm.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       libhugetlbfs-devel@lists.sourceforge.net,
       Eric Munson <ebmunson@us.ibm.com>
Subject: [RFC] [PATCH 0/5 V2] Huge page backed user-space stacks
Date: Mon, 28 Jul 2008 12:17:10 -0700
Message-Id: <cover.1216928613.git.ebmunson@us.ibm.com>
X-Mailer: git-send-email 1.5.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Certain workloads benefit if their data or text segments are backed by
huge pages. The stack is no exception to this rule but there is no
mechanism currently that allows the backing of a stack reliably with
huge pages.  Doing this from userspace is excessively messy and has some
awkward restrictions.  Particularly on POWER where 256MB of address space
gets wasted if the stack is setup there.

This patch stack introduces a personality flag that indicates the kernel
should setup the stack as a hugetlbfs-backed region. A userspace utility
may set this flag then exec a process whose stack is to be backed by
hugetlb pages.

Eric Munson (5):
  Align stack boundaries based on personality
  Add shared and reservation control to hugetlb_file_setup
  Split boundary checking from body of do_munmap
  Build hugetlb backed process stacks
  [PPC] Setup stack memory segment for hugetlb pages

 arch/powerpc/mm/hugetlbpage.c |    6 +
 arch/powerpc/mm/slice.c       |   11 ++
 fs/exec.c                     |  209 ++++++++++++++++++++++++++++++++++++++---
 fs/hugetlbfs/inode.c          |   52 +++++++----
 include/asm-powerpc/hugetlb.h |    3 +
 include/linux/hugetlb.h       |   22 ++++-
 include/linux/mm.h            |    1 +
 include/linux/personality.h   |    3 +
 ipc/shm.c                     |    2 +-
 mm/mmap.c                     |   11 ++-
 10 files changed, 284 insertions(+), 36 deletions(-)

