Return-Path: <linux-kernel-owner+w=401wt.eu-S1755917AbZKJJnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbZKJJnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 04:43:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755803AbZKJJnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 04:43:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:42584 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755746AbZKJJnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 04:43:15 -0500
Date: Tue, 10 Nov 2009 09:42:47 GMT
From: tip-bot for Xiaotian Feng <dfeng@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, dfeng@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, dfeng@redhat.com, mingo@elte.hu
In-Reply-To: <1257844987-7906-1-git-send-email-dfeng@redhat.com>
References: <1257844987-7906-1-git-send-email-dfeng@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/pat] x86: pat: Clean up req_type special case for reserve_memtype()
Message-ID: <tip-83ea05ea69290b2e30da795527dbe304db1e2331@git.kernel.org>
Git-Commit-ID: 83ea05ea69290b2e30da795527dbe304db1e2331
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  83ea05ea69290b2e30da795527dbe304db1e2331
Gitweb:     http://git.kernel.org/tip/83ea05ea69290b2e30da795527dbe304db1e2331
Author:     Xiaotian Feng <dfeng@redhat.com>
AuthorDate: Tue, 10 Nov 2009 17:23:07 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 10 Nov 2009 10:34:04 +0100

x86: pat: Clean up req_type special case for reserve_memtype()

Commit:

  b6ff32d: x86, PAT: Consolidate code in pat_x_mtrr_type() and reserve_memtype()

consolidated code in pat_x_mtrr_type() and reserve_memtype(),
which removed the special case (req_type is -1) for the
PAT-enabled part.

We should also change comments and the PAT-disabled part.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
LKML-Reference: <1257844987-7906-1-git-send-email-dfeng@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
