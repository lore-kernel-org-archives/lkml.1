Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbYJCQrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbYJCQrP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 12:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753025AbYJCQq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 12:46:59 -0400
Received: from gir.skynet.ie ([193.1.99.77]:52968 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796AbYJCQq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 12:46:58 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: akpm@linux-foundation.org
Cc: Mel Gorman <mel@csn.ul.ie>, kosaki.motohiro@jp.fujitsu.com,
       dave@linux.vnet.ibm.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Report the size of pages backing VMAs in /proc V3
Date: Fri,  3 Oct 2008 17:46:53 +0100
Message-Id: <1223052415-18956-1-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following two patches add support for printing the size of pages used
by the kernel to back VMAs in maps and smaps. This can be used by a user
to verify that a hugepage-aware application is using the expected page sizes.
In one case the pagesize used by the MMU differs from the size used by the
kernel. This is on PPC64 using 64K as a base page size running on a processor
that does not support 64K in the MMU. In this case, the kernel uses 64K pages
but the MMU is still using 4K.

The first patch prints the size of page used by the kernel when allocating
pages for a VMA in /proc/pid/smaps and should not be considered too
contentious as it is highly unlikely to break any parsers.  The second patch
reports the size of page used by hugetlbfs regions in /proc/pid/maps. There is
a possibility that the final patch will break parsers but they are arguably
already broken. More details are in the patches themselves.

Thanks to KOSAKI Motohiro for rebasing the patches onto mmotm, reviewing
and testing.

Changelog since V2
  o Drop printing of MMUPageSize (mel)
  o Rebase onto mmotm (KOSAKI Motohiro)

Changelog since V1
  o Fix build failure on !CONFIG_HUGETLB_PAGE
  o Uninline helper functions
  o Distinguish between base pagesize and MMU pagesize

 fs/proc/task_mmu.c      |   27 ++++++++++++++++++---------
 include/linux/hugetlb.h |    3 +++
 mm/hugetlb.c            |   17 +++++++++++++++++
 3 files changed, 38 insertions(+), 9 deletions(-)

