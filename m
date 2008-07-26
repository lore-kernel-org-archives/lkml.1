Return-Path: <linux-kernel-owner+w=401wt.eu-S1758193AbYGZVp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193AbYGZVp1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 17:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756026AbYGZVpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 17:45:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52428 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756109AbYGZVpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 17:45:19 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] tracehook: comment fixes
X-Fcc: ~/Mail/linus
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20080726214512.5FD9115427E@magilla.localdomain>
Date: Sat, 26 Jul 2008 14:45:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit a048d3aff8b828b6c0fa7ddd90a531248ab4e0f9:
  Linus Torvalds (1):
        Merge branch 'tracing-fixes-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frob/linux-2.6-utrace.git tracehook

Roland McGrath (1):
      tracehook: comment fixes

 include/linux/tracehook.h |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

---
This fixes some typos and errors in <linux/tracehook.h> comments.
No code changes.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/linux/tracehook.h |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index 589f429..b187558 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -244,7 +244,7 @@ static inline int tracehook_prepare_clone(unsigned clone_flags)
  * tracehook_finish_clone - new child created and being attached
  * @child:		new child task
  * @clone_flags:	%CLONE_* flags from clone/fork/vfork system call
- * @trace:		return value from tracehook_clone_prepare()
+ * @trace:		return value from tracehook_prepare_clone()
  *
  * This is called immediately after adding @child to its parent's children list.
  * The @trace value is that returned by tracehook_prepare_clone().
@@ -259,19 +259,20 @@ static inline void tracehook_finish_clone(struct task_struct *child,
 
 /**
  * tracehook_report_clone - in parent, new child is about to start running
- * @trace:		return value from tracehook_clone_prepare()
+ * @trace:		return value from tracehook_prepare_clone()
  * @regs:		parent's user register state
  * @clone_flags:	flags from parent's system call
  * @pid:		new child's PID in the parent's namespace
  * @child:		new child task
  *
- * Called after a child is set up, but before it has been started running.
- * The @trace value is that returned by tracehook_clone_prepare().
- * This is not a good place to block, because the child has not started yet.
- * Suspend the child here if desired, and block in tracehook_clone_complete().
- * This must prevent the child from self-reaping if tracehook_clone_complete()
- * uses the @child pointer; otherwise it might have died and been released by
- * the time tracehook_report_clone_complete() is called.
+ * Called after a child is set up, but before it has been started
+ * running.  @trace is the value returned by tracehook_prepare_clone().
+ * This is not a good place to block, because the child has not started
+ * yet.  Suspend the child here if desired, and then block in
+ * tracehook_report_clone_complete().  This must prevent the child from
+ * self-reaping if tracehook_report_clone_complete() uses the @child
+ * pointer; otherwise it might have died and been released by the time
+ * tracehook_report_report_clone_complete() is called.
  *
  * Called with no locks held, but the child cannot run until this returns.
  */
@@ -290,7 +291,7 @@ static inline void tracehook_report_clone(int trace, struct pt_regs *regs,
 
 /**
  * tracehook_report_clone_complete - new child is running
- * @trace:		return value from tracehook_clone_prepare()
+ * @trace:		return value from tracehook_prepare_clone()
  * @regs:		parent's user register state
  * @clone_flags:	flags from parent's system call
  * @pid:		new child's PID in the parent's namespace
@@ -347,7 +348,7 @@ static inline void tracehook_prepare_release_task(struct task_struct *task)
 }
 
 /**
- * tracehook_finish_release_task - task is being reaped, clean up tracing
+ * tracehook_finish_release_task - final tracing clean-up
  * @task:		task in %EXIT_DEAD state
  *
  * This is called in release_task() when @task is being in the middle of
