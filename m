Return-Path: <linux-kernel-owner+w=401wt.eu-S1753903AbZCJI6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbZCJI6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 04:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753403AbZCJI6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 04:58:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:41567 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027AbZCJI6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 04:58:09 -0400
Date: Tue, 10 Mar 2009 08:57:31 GMT
From: Stoyan Gaydarov <stoyboyker@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       stoyboyker@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       stoyboyker@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1236661850-8237-8-git-send-email-stoyboyker@gmail.com>
References: <1236661850-8237-8-git-send-email-stoyboyker@gmail.com>
Subject: [tip:x86/debug] x86: BUG to BUG_ON changes
Message-ID: <tip-8c5dfd25519bf302ba43daa59976c4d675a594a7@git.kernel.org>
Git-Commit-ID: 8c5dfd25519bf302ba43daa59976c4d675a594a7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 10 Mar 2009 08:57:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8c5dfd25519bf302ba43daa59976c4d675a594a7
Gitweb:     http://git.kernel.org/tip/8c5dfd25519bf302ba43daa59976c4d675a594a7
Author:     "Stoyan Gaydarov" <stoyboyker@gmail.com>
AuthorDate: Tue, 10 Mar 2009 00:10:32 -0500
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 10 Mar 2009 09:55:18 +0100

x86: BUG to BUG_ON changes

Impact: cleanup

Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
LKML-Reference: <1236661850-8237-8-git-send-email-stoyboyker@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/common.c |    6 ++----
 arch/x86/kernel/quirks.c     |    3 +--
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 826d5c8..f886997 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1078,8 +1078,7 @@ void __cpuinit cpu_init(void)
 
 	atomic_inc(&init_mm.mm_count);
 	me->active_mm = &init_mm;
-	if (me->mm)
-		BUG();
+	BUG_ON(me->mm);
 	enter_lazy_tlb(&init_mm, me);
 
 	load_sp0(t, &current->thread);
@@ -1145,8 +1144,7 @@ void __cpuinit cpu_init(void)
 	 */
 	atomic_inc(&init_mm.mm_count);
 	curr->active_mm = &init_mm;
-	if (curr->mm)
-		BUG();
+	BUG_ON(curr->mm);
 	enter_lazy_tlb(&init_mm, curr);
 
 	load_sp0(t, thread);
diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index 309949e..6a5a297 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -74,8 +74,7 @@ static void ich_force_hpet_resume(void)
 	if (!force_hpet_address)
 		return;
 
-	if (rcba_base == NULL)
-		BUG();
+	BUG_ON(rcba_base == NULL);
 
 	/* read the Function Disable register, dword mode only */
 	val = readl(rcba_base + 0x3404);
