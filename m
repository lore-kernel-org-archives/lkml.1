Return-Path: <linux-kernel-owner+w=401wt.eu-S1753182AbYJUDgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbYJUDgz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 23:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbYJUDgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 23:36:46 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:39825 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751346AbYJUDgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 23:36:45 -0400
Date: Tue, 21 Oct 2008 12:36:23 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] mm: page_cgroup needs linux/vmalloc.h for vmalloc_node()/vfree().
Message-ID: <20081021033623.GA29105@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial build fix for:

  CC      mm/page_cgroup.o
mm/page_cgroup.c: In function 'init_section_page_cgroup':
mm/page_cgroup.c:111: error: implicit declaration of function 'vmalloc_node'
mm/page_cgroup.c:111: warning: assignment makes pointer from integer without a cast
mm/page_cgroup.c: In function '__free_page_cgroup':
mm/page_cgroup.c:140: error: implicit declaration of function 'vfree'
make[1]: *** [mm/page_cgroup.o] Error 1
make: *** [mm/page_cgroup.o] Error 2

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 mm/page_cgroup.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
index 5d86550..78242b4 100644
--- a/mm/page_cgroup.c
+++ b/mm/page_cgroup.c
@@ -5,6 +5,7 @@
 #include <linux/page_cgroup.h>
 #include <linux/hash.h>
 #include <linux/memory.h>
+#include <linux/vmalloc.h>
 
 static void __meminit
 __init_page_cgroup(struct page_cgroup *pc, unsigned long pfn)
