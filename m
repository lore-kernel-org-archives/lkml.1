Return-Path: <linux-kernel-owner+w=401wt.eu-S1763536AbZCNBfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763536AbZCNBfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754144AbZCNBUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:20:43 -0400
Received: from kroah.org ([198.145.64.141]:35123 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753502AbZCNBUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:20:22 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:37 2009
Message-Id: <20090314011037.453800119@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:10:18 -0700
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
       alan@lxorguk.ukuu.org.uk, Tejun Heo <tj@kernel.org>,
       Nick Piggin <npiggin@suse.de>, "David S. Miller" <davem@davemloft.net>
Subject: [patch 041/114] vmalloc: call flush_cache_vunmap() from unmap_kernel_range()
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=vmalloc-call-flush_cache_vunmap-from-unmap_kernel_range.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit f6fcba7014f9cc535fa75ef98c008b24e49e2212 upstream.

Impact: proper vcache flush on unmap_kernel_range()

flush_cache_vunmap() should be called before pages are unmapped.  Add
a call to it in unmap_kernel_range().

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Nick Piggin <npiggin@suse.de>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/vmalloc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -997,6 +997,8 @@ void __init vmalloc_init(void)
 void unmap_kernel_range(unsigned long addr, unsigned long size)
 {
 	unsigned long end = addr + size;
+
+	flush_cache_vunmap(addr, end);
 	vunmap_page_range(addr, end);
 	flush_tlb_kernel_range(addr, end);
 }


