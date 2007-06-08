Return-Path: <linux-kernel-owner+w=401wt.eu-S937902AbXFHHR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937902AbXFHHR3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936791AbXFHHQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:16:55 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:33059 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936734AbXFHHQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:16:54 -0400
Message-Id: <20070608071532.588665000@sous-sol.org>
References: <20070608071511.159309000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:15:14 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andi Kleen <ak@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 03/32] x86-64: Always flush all pages in change_page_attr
Content-Disposition: inline; filename=x86-64-always-flush-all-pages-in-change_page_attr.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Andi Kleen <ak@suse.de>

change_page_attr on x86-64 only flushed the TLB for pages that got
reverted. That's not correct: it has to be flushed in all cases.

This bug was added in some earlier changes.

Just flush all pages for now.

This could be done more efficiently, but for this late in the release
this seem to be the best fix.

Pointed out by Jan Beulich

Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86_64/mm/pageattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.20.13.orig/arch/x86_64/mm/pageattr.c
+++ linux-2.6.20.13/arch/x86_64/mm/pageattr.c
@@ -81,8 +81,8 @@ static void flush_kernel_map(void *arg)
 		void *adr = page_address(pg);
 		if (cpu_has_clflush)
 			cache_flush_page(adr);
-		__flush_tlb_one(adr);
 	}
+	__flush_tlb_all();
 }
 
 static inline void flush_map(struct list_head *l)

-- 
