Return-Path: <linux-kernel-owner+w=401wt.eu-S1754778AbYJPP6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778AbYJPP6p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 11:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754522AbYJPP6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 11:58:36 -0400
Received: from gir.skynet.ie ([193.1.99.77]:54150 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255AbYJPP6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 11:58:36 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 0/2] Report the size of pages backing VMAs in /proc V3
Date: Thu, 16 Oct 2008 16:58:33 +0100
Message-Id: <1224172715-17667-1-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following two patches add support for printing the size of pages used by
the kernel and the MMU to back VMAs. This can be used by a user to verify
that a hugepage-aware application is using the expected page sizes.

The first patch prints the size of page used by the kernel when allocating
pages for a VMA in /proc/pid/smaps. The second patch reports on
the size of page used by the MMU as it can differ - for example on POWER
using 64K as a base pagesize on older processors.

Changelog since V2
  o Drop changes to /proc/pid/maps - could not get agreement and it affects
    procps. Patch to procps was posted but fell into silence. Dropping
    patch as smaps gives the necessary information, just with a bit more
    legwork by the user
  o Drop redundant VM_BUG_ON (Alexey)

Changelog since V1
  o Fix build failure on !CONFIG_HUGETLB_PAGE
  o Uninline helper functions
  o Distinguish between base pagesize and MMU pagesize

 arch/powerpc/include/asm/hugetlb.h |    6 ++++++
 arch/powerpc/mm/hugetlbpage.c      |    7 +++++++
 fs/proc/task_mmu.c                 |    8 ++++++--
 include/linux/hugetlb.h            |    6 ++++++
 mm/hugetlb.c                       |   29 +++++++++++++++++++++++++++++
 5 files changed, 54 insertions(+), 2 deletions(-)

