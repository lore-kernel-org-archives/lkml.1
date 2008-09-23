Return-Path: <linux-kernel-owner+w=401wt.eu-S1755456AbYIWUql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbYIWUql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 16:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754611AbYIWUpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 16:45:54 -0400
Received: from gir.skynet.ie ([193.1.99.77]:48853 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651AbYIWUpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 16:45:51 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Linux-MM <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Dave Hansen <dave@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 0/3] Report the size of pages backing VMAs in /proc V2
Date: Tue, 23 Sep 2008 21:45:25 +0100
Message-Id: <1222202728-13192-1-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following three patches add support for printing the size of pages to
back VMAs in maps and smaps. This can be used by a user to verify that a
hugepage-aware application is using the expected page sizes.

The first patch prints the size of page used by the kernel when allocating
pages for a VMA in /proc/pid/smaps and should not be considered too contentious
as it is highly unlikely to break any parsers. The second patch reports on
the size of page used by the MMU as it can differ - for example on POWER
using 64K as a base pagesize on older processors. The final patch reports
the size of page used by hugetlbfs regions in /proc/pid/maps. There is a
possibility that the final patch will break parsers but they are arguably
already broken. More details are in the patches themselves.

Changelog since V1
  o Fix build failure on !CONFIG_HUGETLB_PAGE
  o Uninline helper functions
  o Distinguish between base pagesize and MMU pagesize

 arch/powerpc/include/asm/hugetlb.h |    6 ++++++
 arch/powerpc/mm/hugetlbpage.c      |    7 +++++++
 fs/proc/task_mmu.c                 |   32 ++++++++++++++++++++++++--------
 include/linux/hugetlb.h            |    6 ++++++
 mm/hugetlb.c                       |   30 ++++++++++++++++++++++++++++++
 5 files changed, 73 insertions(+), 8 deletions(-)

