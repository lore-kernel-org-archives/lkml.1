Return-Path: <linux-kernel-owner+w=401wt.eu-S1753532AbZIQWot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbZIQWot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 18:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753398AbZIQWor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 18:44:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52143 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753361AbZIQWol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 18:44:41 -0400
Date: Thu, 17 Sep 2009 15:44:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric B Munson <ebmunson@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-man@vger.kernel.org, mtk.manpages@gmail.com,
       randy.dunlap@oracle.com, ebmunson@us.ibm.com,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH 2/3] Add MAP_HUGETLB for mmaping pseudo-anonymous huge
 page regions
Message-Id: <20090917154404.e1d3694e.akpm@linux-foundation.org>
In-Reply-To: <8504342f7be19e416ef769d1edd24b8549f8dc39.1251197514.git.ebmunson@us.ibm.com>
References: <cover.1251197514.git.ebmunson@us.ibm.com>
	<25614b0d0581e2d49e1024dc1671b282f193e139.1251197514.git.ebmunson@us.ibm.com>
	<8504342f7be19e416ef769d1edd24b8549f8dc39.1251197514.git.ebmunson@us.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Aug 2009 12:14:53 +0100
Eric B Munson <ebmunson@us.ibm.com> wrote:

> This patch adds a flag for mmap that will be used to request a huge
> page region that will look like anonymous memory to user space.  This
> is accomplished by using a file on the internal vfsmount.  MAP_HUGETLB
> is a modifier of MAP_ANONYMOUS and so must be specified with it.  The
> region will behave the same as a MAP_ANONYMOUS region using small pages.
> 
> Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>
> ---
>  include/asm-generic/mman-common.h |    1 +
>  include/linux/hugetlb.h           |    7 +++++++
>  mm/mmap.c                         |   19 +++++++++++++++++++

alpha fix:

From: Andrew Morton <akpm@linux-foundation.org>

mm/mmap.c: In function 'do_mmap_pgoff':
mm/mmap.c:953: error: 'MAP_HUGETLB' undeclared (first use in this function)
mm/mmap.c:953: error: (Each undeclared identifier is reported only once
mm/mmap.c:953: error: for each function it appears in.)

Cc: Adam Litke <agl@us.ibm.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric B Munson <ebmunson@us.ibm.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/mman.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/alpha/include/asm/mman.h~hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions-alpha-fix arch/alpha/include/asm/mman.h
--- a/arch/alpha/include/asm/mman.h~hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions-alpha-fix
+++ a/arch/alpha/include/asm/mman.h
@@ -28,6 +28,7 @@
 #define MAP_NORESERVE	0x10000		/* don't check for reservations */
 #define MAP_POPULATE	0x20000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x40000		/* do not block on IO */
+#define MAP_HUGETLB	0x80000		/* create a huge page mapping */
 
 #define MS_ASYNC	1		/* sync memory asynchronously */
 #define MS_SYNC		2		/* synchronous memory sync */
_

