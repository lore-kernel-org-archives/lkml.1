Return-Path: <linux-kernel-owner+w=401wt.eu-S1030672AbXCSVrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030672AbXCSVrc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030624AbXCSVm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:42:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59385 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030634AbXCSVmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:42:06 -0400
Date: Mon, 19 Mar 2007 14:40:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 22/31] Fix sparc64 hugepage bugs
Message-ID: <20070319214018.GX9261@kroah.com>
References: <20070319213047.710101653@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-sparc64-hugepage-bugs.patch"
In-Reply-To: <20070319213647.GB9261@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Miller <davem@davemloft.net>

[SPARC64]: Add missing HPAGE_MASK masks on address parameters.

These pte loops all assume the passed in address is HPAGE
aligned, make sure that is actually true.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc64/mm/hugetlbpage.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/sparc64/mm/hugetlbpage.c
+++ b/arch/sparc64/mm/hugetlbpage.c
@@ -248,6 +248,7 @@ void set_huge_pte_at(struct mm_struct *m
 	if (!pte_present(*ptep) && pte_present(entry))
 		mm->context.huge_pte_count++;
 
+	addr &= HPAGE_MASK;
 	for (i = 0; i < (1 << HUGETLB_PAGE_ORDER); i++) {
 		set_pte_at(mm, addr, ptep, entry);
 		ptep++;
@@ -266,6 +267,8 @@ pte_t huge_ptep_get_and_clear(struct mm_
 	if (pte_present(entry))
 		mm->context.huge_pte_count--;
 
+	addr &= HPAGE_MASK;
+
 	for (i = 0; i < (1 << HUGETLB_PAGE_ORDER); i++) {
 		pte_clear(mm, addr, ptep);
 		addr += PAGE_SIZE;

-- 
