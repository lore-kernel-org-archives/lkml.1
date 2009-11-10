Return-Path: <linux-kernel-owner+w=401wt.eu-S1754610AbZKJJXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbZKJJXV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 04:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbZKJJXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 04:23:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348AbZKJJXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 04:23:18 -0500
From: Xiaotian Feng <dfeng@redhat.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dfeng@redhat.com>,
       Ingo Molnar <mingo@redhat.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [PATCH -tip 1/2] x86: PAT cleanup req_type special case for pat reserve_memtype
Date: Tue, 10 Nov 2009 17:23:07 +0800
Message-Id: <1257844987-7906-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit b6ff32 consolidates code in pat_x_mtrr_type and reserve_memtype,
which removes the special case (req_type is -1) for pat enabled part.
We should also change comments and pat disabled part.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com> 
---
 arch/x86/mm/pat.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index e78cd0e..81fb753 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -355,9 +355,6 @@ static int free_ram_pages_type(u64 start, u64 end)
  * - _PAGE_CACHE_UC_MINUS
  * - _PAGE_CACHE_UC
  *
- * req_type will have a special case value '-1', when requester want to inherit
- * the memory type from mtrr (if WB), existing PAT, defaulting to UC_MINUS.
- *
  * If new_type is NULL, function will return an error if it cannot reserve the
  * region with req_type. If new_type is non-NULL, function will return
  * available type in new_type in case of no error. In case of any error
@@ -377,9 +374,7 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 	if (!pat_enabled) {
 		/* This is identical to page table setting without PAT */
 		if (new_type) {
-			if (req_type == -1)
-				*new_type = _PAGE_CACHE_WB;
-			else if (req_type == _PAGE_CACHE_WC)
+			if (req_type == _PAGE_CACHE_WC)
 				*new_type = _PAGE_CACHE_UC_MINUS;
 			else
 				*new_type = req_type & _PAGE_CACHE_MASK;
-- 
1.6.2.5

