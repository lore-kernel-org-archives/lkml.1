Return-Path: <linux-kernel-owner+w=401wt.eu-S933317AbYBGAPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933317AbYBGAPc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:15:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932217AbYBFX6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:58:15 -0500
Received: from ns1.suse.de ([195.135.220.2]:46251 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932206AbYBFX6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:58:13 -0500
Date: Wed, 6 Feb 2008 15:53:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, dhaval@linux.vnet.ibm.com, clameter@sgi.com
Subject: [patch 43/73] quicklists: do not release off node pages early
Message-ID: <20080206235326.GR13121@suse.de>
References: <20080206234302.769849277@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="quicklists-do-not-release-off-node-pages-early.patch"
In-Reply-To: <20080206235015.GA13121@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.23-stable review patch.  If anyone has any objections, please let us know.
------------------
From: Christoph Lameter <clameter@sgi.com>

patch ed367fc3a7349b17354c7acef551533337764859 in mainline.

quicklists must keep even off node pages on the quicklists until the TLB
flush has been completed.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/quicklist.h |    8 --------
 1 file changed, 8 deletions(-)

--- a/include/linux/quicklist.h
+++ b/include/linux/quicklist.h
@@ -56,14 +56,6 @@ static inline void __quicklist_free(int 
 	struct page *page)
 {
 	struct quicklist *q;
-	int nid = page_to_nid(page);
-
-	if (unlikely(nid != numa_node_id())) {
-		if (dtor)
-			dtor(p);
-		__free_page(page);
-		return;
-	}
 
 	q = &get_cpu_var(quicklist)[nr];
 	*(void **)p = q->page;

-- 
