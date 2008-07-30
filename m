Return-Path: <linux-kernel-owner+w=401wt.eu-S1754033AbYGaAZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbYGaAZl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762735AbYGaAXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:23:24 -0400
Received: from ns2.suse.de ([195.135.220.15]:37629 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756314AbYGaAXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:23:22 -0400
Date: Wed, 30 Jul 2008 16:59:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Oliver Pinter <oliver.pntr@gmail.com>
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
       alan@lxorguk.ukuu.org.uk, linux-mm@kvack.org,
       Jack Steiner <steiner@sgi.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 51/62] x86: fix kernel_physical_mapping_init() for large
	x86 systems
Message-ID: <20080730235946.GY12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-fix-kernel_physical_mapping_init-for-large-x86-systems.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: Ingo Molnar <mingo@elte.hu>

based on e22146e610bb7aed63282148740ab1d1b91e1d90 upstream

Fix bug in kernel_physical_mapping_init() that causes kernel
page table to be built incorrectly for systems with greater
than 512GB of memory.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Cc: linux-mm@kvack.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Oliver Pinter <oliver.pntr@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/mm/init_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -579,7 +579,7 @@ unsigned long __init_refok init_memory_m
 		else
 			pud = alloc_low_page(&pud_phys);
 
-		next = start + PGDIR_SIZE;
+		next = (start + PGDIR_SIZE) & PGDIR_MASK;
 		if (next > end)
 			next = end;
 		last_map_addr = phys_pud_init(pud, __pa(start), __pa(next));

-- 
