Return-Path: <linux-kernel-owner+w=401wt.eu-S936506AbZDJMem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936506AbZDJMem (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 08:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756796AbZDJMe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 08:34:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:41633 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763304AbZDJMeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 08:34:24 -0400
Date: Fri, 10 Apr 2009 12:33:46 GMT
From: Andy Grover <andy.grover@oracle.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andy.grover@oracle.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andy.grover@oracle.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1239320729-3262-1-git-send-email-andy.grover@oracle.com>
References: <1239320729-3262-1-git-send-email-andy.grover@oracle.com>
Subject: [tip:x86/pat] x86: Document get_user_pages_fast()
Message-ID: <tip-a0d22f485af1553060b4094ee0154537a8f6a8a6@git.kernel.org>
Git-Commit-ID: a0d22f485af1553060b4094ee0154537a8f6a8a6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Apr 2009 12:33:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a0d22f485af1553060b4094ee0154537a8f6a8a6
Gitweb:     http://git.kernel.org/tip/a0d22f485af1553060b4094ee0154537a8f6a8a6
Author:     Andy Grover <andy.grover@oracle.com>
AuthorDate: Thu, 9 Apr 2009 16:45:29 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Apr 2009 13:14:08 +0200

x86: Document get_user_pages_fast()

While better than get_user_pages(), the usage of gupf(),
especially the return values and the fact that it can
potentially only partially pin the range, warranted some
documentation.

Signed-off-by: Andy Grover <andy.grover@oracle.com>
Cc: npiggin@suse.de
Cc: akpm@linux-foundation.org
LKML-Reference: <1239320729-3262-1-git-send-email-andy.grover@oracle.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/gup.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
index be54176..6340cef 100644
--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -219,6 +219,22 @@ static int gup_pud_range(pgd_t pgd, unsigned long addr, unsigned long end,
 	return 1;
 }
 
+/**
+ * get_user_pages_fast() - pin user pages in memory
+ * @start:	starting user address
+ * @nr_pages:	number of pages from start to pin
+ * @write:	whether pages will be written to
+ * @pages:	array that receives pointers to the pages pinned.
+ * 		Should be at least nr_pages long.
+ *
+ * Attempt to pin user pages in memory without taking mm->mmap_sem.
+ * If not successful, it will fall back to taking the lock and
+ * calling get_user_pages().
+ *
+ * Returns number of pages pinned. This may be fewer than the number
+ * requested. If nr_pages is 0 or negative, returns 0. If no pages
+ * were pinned, returns -errno.
+ */
 int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			struct page **pages)
 {
