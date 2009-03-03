Return-Path: <linux-kernel-owner+w=401wt.eu-S1758012AbZCCGGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012AbZCCGGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 01:06:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbZCCGF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 01:05:59 -0500
Received: from ozlabs.org ([203.10.76.45]:51234 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889AbZCCGF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 01:05:59 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] Trivial macros to help cpumask conversion in linux-next: tsk_cpumask and mm_cpumask
Date: Tue, 3 Mar 2009 16:35:53 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903031635.54296.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 2450cf51a1bdba7037e91b1bcc494b01c58aaf66:
  Linus Torvalds (1):
        Revert "menu: fix embedded menu snafu"

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master

Rusty Russell (2):
      cpumask: tsk_cpumask for accessing the struct task_struct's cpus_allowed.
      cpumask: mm_cpumask for accessing the struct mm_struct's cpu_vm_mask.

 include/linux/mm_types.h |    3 +++
 include/linux/sched.h    |    3 +++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 92915e8..d84feb7 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -276,4 +276,7 @@ struct mm_struct {
 #endif
 };
 
+/* Future-safe accessor for struct mm_struct's cpu_vm_mask. */
+#define mm_cpumask(mm) (&(mm)->cpu_vm_mask)
+
 #endif /* _LINUX_MM_TYPES_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8981e52..9c274d7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1419,6 +1419,9 @@ struct task_struct {
 #endif
 };
 
+/* Future-safe accessor for struct task_struct's cpus_allowed. */
+#define tsk_cpumask(tsk) (&(tsk)->cpus_allowed)
+
 /*
  * Priority of a process goes from 0..MAX_PRIO-1, valid RT
  * priority is 0..MAX_RT_PRIO-1, and SCHED_NORMAL/SCHED_BATCH
