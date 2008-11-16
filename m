Return-Path: <linux-kernel-owner+w=401wt.eu-S1754402AbYKPUwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402AbYKPUwX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 15:52:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbYKPUwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 15:52:15 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:43444 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbYKPUwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 15:52:14 -0500
Date: Sun, 16 Nov 2008 20:52:22 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andrew Morton <akpm@linux-foundation.org>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH mmotm] memcg: handle swap caches build fix
Message-ID: <Pine.LNX.4.64.0811162046080.5813@blonde.site>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-2118584039-1226868742=:5813"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-2118584039-1226868742=:5813
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

Fix to build error when CONFIG_SHMEM=3Dy but CONFIG_SWAP is not set:
mm/shmem.c: In function =E2=80=98shmem_unuse_inode=E2=80=99:
mm/shmem.c:927: error: implicit declaration of function =E2=80=98mem_cgroup=
_cache_charge_swapin=E2=80=99

Yes, there's a lot of code in mm/shmem.c which only comes into play when
CONFIG_SWAP=3Dy: better than this quick fix would be to restructure shmem.c
with all swap stuff in a separate file; that's on my mind, but now is not
the moment for it.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
Fix should follow or be merged into memcg-handle-swap-caches.patch

 include/linux/swap.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- mmotm/include/linux/swap.h=092008-11-16 17:33:25.000000000 +0000
+++ linux/include/linux/swap.h=092008-11-16 20:18:27.000000000 +0000
@@ -442,6 +442,12 @@ static inline swp_entry_t get_swap_page(
 #define has_swap_token(x) 0
 #define disable_swap_token() do { } while(0)
=20
+static inline int mem_cgroup_cache_charge_swapin(struct page *page,
+=09=09=09struct mm_struct *mm, gfp_t mask, bool locked)
+{
+=09return 0;
+}
+
 #endif /* CONFIG_SWAP */
 #endif /* __KERNEL__*/
 #endif /* _LINUX_SWAP_H */
--8323584-2118584039-1226868742=:5813--
