Return-Path: <linux-kernel-owner+w=401wt.eu-S1756166AbZKRDos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166AbZKRDos (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 22:44:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbZKRDor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 22:44:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35473 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053AbZKRDor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 22:44:47 -0500
From: Xiaotian Feng <dfeng@redhat.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dfeng@redhat.com>,
       Ingo Molnar <mingo@redhat.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [PATCH] x86/pat: no need to check overlaps with more than one entry in chk_conflict
Date: Wed, 18 Nov 2009 10:47:35 +0800
Message-Id: <1258512455-1891-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memtype list is built via reserve_memtype, for the overlapped areas, they're
all the same type, otherwise reserve_memtype will fail to insert it into the
list. So there's no need to check overlaps with more than one entry in the
chk_conflict code.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
---
 arch/x86/mm/pat.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 81fb753..8178763 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -247,13 +247,6 @@ chk_conflict(struct memtype *new, struct memtype *entry, unsigned long *type)
 			goto conflict;
 	}
 
-	 /* check overlaps with more than one entry in the list */
-	list_for_each_entry_continue(entry, &memtype_list, nd) {
-		if (new->end <= entry->start)
-			break;
-		else if (new->type != entry->type)
-			goto conflict;
-	}
 	return 0;
 
  conflict:
-- 
1.6.2.5

