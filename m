Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab0APSqt (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 13:46:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756157Ab0APSqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 13:46:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50181 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756080Ab0APSqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 13:46:47 -0500
Date: Sat, 16 Jan 2010 19:46:42 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] register MADV_HUGEPAGE
Message-ID: <20100116184642.GA5687@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrea Arcangeli <aarcange@redhat.com>

In order to allow early shipping transparent hugepage feature enabled
only inside MADV_HUGEPAGE and not globally to diminish the risk of
unexpected performance regressions on non-hypervisor related usages
I'd need this little define registered. This is also to avoid things
like this:

#define MADV_DOFORK	11	    	 /* do inherit across fork */
#define MADV_HWPOISON	100		    /* poison a page for testing */

Picking random number not so nice... and with my proof of concept
patch posted working and boosting performance equally to hugetlbfs but
without its limitations, I think it is a given that eventually KVM
will run inside MADV_HUGEPAGE madvise regions only, so I see a
negligeable risk to pollute the kernel in including this as first bit
of the full patchset.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---

The rest of the transparent hugepage patchset is very ready for
inclusion too with all cleanups requested and after full handling of
all review on linux-mm so far, with the only exception of khugepaged
that is about to be finished, expect a new submit on linux-mm in a few
days. Then we'll have to plug Mel memory compaction on top of it.

(in addition to the below, /sys/kernel/mm/transparent_hugepage also
has been moved to some other distro specific location to avoid any
possible risk of clashes or confusion with future mainline behavior)

Thanks,
Andrea

diff --git a/include/asm-generic/mman-common.h b/include/asm-generic/mman-common.h
--- a/include/asm-generic/mman-common.h
+++ b/include/asm-generic/mman-common.h
@@ -45,6 +45,8 @@
 #define MADV_MERGEABLE   12		/* KSM may merge identical pages */
 #define MADV_UNMERGEABLE 13		/* KSM may not merge identical pages */
 
+#define MADV_HUGEPAGE	14		/* Worth backing with hugepages */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
