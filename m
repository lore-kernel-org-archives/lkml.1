Return-Path: <linux-kernel-owner+w=401wt.eu-S1755358Ab0ANFys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab0ANFys (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 00:54:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750978Ab0ANFyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 00:54:47 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52233 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab0ANFyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 00:54:47 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: [PATCH] [mmotm 0113] memcg: fix compile error
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20100114145006.672D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 14 Jan 2010 14:54:44 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This issue was introduced by memcg-move-charges-of-anonymous-swap.patch.

=================================
Now, ia64 can't compile page_cgroup.c.
because it include asm/cmpxhg.h but almost arch don't have arch specific
cmpxhg.h. they use asm-generic/cmpxhg.h.

Then, following errror occur.

  CC      mm/page_cgroup.o
  mm/page_cgroup.c:12:25: error: asm/cmpxchg.h: No such file or
  directory
  make[1]: *** [mm/page_cgroup.o] Error 1
  make: *** [mm] Error 2

Fortunately, memcg code don't use low layer cmpxchg directly. thus
this patch remove this include line simply.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/page_cgroup.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
index 213b0ee..3dd8853 100644
--- a/mm/page_cgroup.c
+++ b/mm/page_cgroup.c
@@ -9,7 +9,6 @@
 #include <linux/vmalloc.h>
 #include <linux/cgroup.h>
 #include <linux/swapops.h>
-#include <asm/cmpxchg.h>
 
 static void __meminit
 __init_page_cgroup(struct page_cgroup *pc, unsigned long pfn)
-- 
1.6.5.2



