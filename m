Return-Path: <linux-kernel-owner+w=401wt.eu-S1761808AbZEOKYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761808AbZEOKYm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 06:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758212AbZEOKYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 06:24:33 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:47504 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756447AbZEOKYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 06:24:32 -0400
Date: Fri, 15 May 2009 13:24:31 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] memcg: use ifdef for mem_cgroup_is_obsolete()
Message-ID: <Pine.LNX.4.64.0905151323560.32670@melkki.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-696229367-1309287308-1242383071=:32670"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696229367-1309287308-1242383071=:32670
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

From: Pekka Enberg <penberg@cs.helsinki.fi>

When CONFIG_DEBUG_VM is disabled, I get the following warning:

    CC      mm/memcontrol.o
  mm/memcontrol.c:318: warning: ‘mem_cgroup_is_obsolete’ defined but not
  used

Fix that up by wrapping mem_cgroup_is_obsolete() in an ifdef.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/memcontrol.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 01c2d8f..51f2dbd 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -314,12 +314,14 @@ static struct mem_cgroup *try_get_mem_cgroup_from_mm(struct mm_struct *mm)
 	return mem;
 }
 
+#ifdef CONFIG_DEBUG_VM
 static bool mem_cgroup_is_obsolete(struct mem_cgroup *mem)
 {
 	if (!mem)
 		return true;
 	return css_is_removed(&mem->css);
 }
+#endif
 
 
 /*
-- 
1.5.6.3

---696229367-1309287308-1242383071=:32670--
