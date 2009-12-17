Return-Path: <linux-kernel-owner+w=401wt.eu-S936375AbZLQEPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936375AbZLQEPf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:15:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936165AbZLQEFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:05:37 -0500
Received: from kroah.org ([198.145.64.141]:55943 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935987AbZLQEFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:05:31 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:59 2009
Message-Id: <20091217035658.924129678@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:57:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [123/151] memcg: fix memory.memsw.usage_in_bytes for root cgroup
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kirill A. Shutemov <kirill@shutemov.name>

commit cd9b45b78a61e8df250e69385c74e729e5b66abf upstream.

A memory cgroup has a memory.memsw.usage_in_bytes file.  It shows the sum
of the usage of pages and swapents in the cgroup.  Presently the root
cgroup's memsw.usage_in_bytes shows the wrong value - the number of
swapents are not added.

So take MEM_CGROUP_STAT_SWAPOUT into account.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/memcontrol.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2541,6 +2541,7 @@ static u64 mem_cgroup_read(struct cgroup
 			val += idx_val;
 			mem_cgroup_get_recursive_idx_stat(mem,
 				MEM_CGROUP_STAT_SWAPOUT, &idx_val);
+			val += idx_val;
 			val <<= PAGE_SHIFT;
 		} else
 			val = res_counter_read_u64(&mem->memsw, name);


