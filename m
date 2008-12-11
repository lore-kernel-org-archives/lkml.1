Return-Path: <linux-kernel-owner+w=401wt.eu-S932124AbYLKTpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124AbYLKTpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:45:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757922AbYLKTTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:19:31 -0500
Received: from kroah.org ([198.145.64.141]:56699 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757606AbYLKTT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:19:28 -0500
Date: Thu, 11 Dec 2008 11:16:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Matt Mackall <mpm@selenic.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>
Subject: [patch 75/83] pagemap: fix 32-bit pagemap regression
Message-ID: <20081211191637.GW5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pagemap-fix-32-bit-pagemap-regression.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Matt Mackall <mpm@selenic.com>

commit 49c50342c728344b79c8f9e8293637fe80ef5ad5 upstream.

The large pages fix from bcf8039ed45 broke 32-bit pagemap by pulling the
pagemap entry code out into a function with the wrong return type.
Pagemap entries are 64 bits on all systems and unsigned long is only 32
bits on 32-bit systems.

Signed-off-by: Matt Mackall <mpm@selenic.com>
Reported-by: Doug Graham <dgraham@nortel.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/proc/task_mmu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -563,9 +563,9 @@ static u64 swap_pte_to_pagemap_entry(pte
 	return swp_type(e) | (swp_offset(e) << MAX_SWAPFILES_SHIFT);
 }
 
-static unsigned long pte_to_pagemap_entry(pte_t pte)
+static u64 pte_to_pagemap_entry(pte_t pte)
 {
-	unsigned long pme = 0;
+	u64 pme = 0;
 	if (is_swap_pte(pte))
 		pme = PM_PFRAME(swap_pte_to_pagemap_entry(pte))
 			| PM_PSHIFT(PAGE_SHIFT) | PM_SWAP;

