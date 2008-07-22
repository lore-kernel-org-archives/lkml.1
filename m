Return-Path: <linux-kernel-owner+w=401wt.eu-S1755337AbYGVRV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbYGVRV4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 13:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144AbYGVRUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 13:20:51 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:39661 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754791AbYGVRUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 13:20:49 -0400
Date: Tue, 22 Jul 2008 20:20:38 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make ptrace_untrace() static
Message-ID: <20080722172038.GR14846@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ptrace_untrace() can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 include/linux/ptrace.h |    1 -
 kernel/ptrace.c        |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

819e9b617ffe996a61a150598050973911acd7e7 
diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index c6f5f9d..fe0d5a4 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -94,7 +94,6 @@ extern void ptrace_notify(int exit_code);
 extern void __ptrace_link(struct task_struct *child,
 			  struct task_struct *new_parent);
 extern void __ptrace_unlink(struct task_struct *child);
-extern void ptrace_untrace(struct task_struct *child);
 #define PTRACE_MODE_READ   1
 #define PTRACE_MODE_ATTACH 2
 /* Returns 0 on success, -errno on denial. */
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 8392a9d..cfcfde4 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -45,7 +45,7 @@ void __ptrace_link(struct task_struct *child, struct task_struct *new_parent)
  * TASK_TRACED, resume it now.
  * Requires that irqs be disabled.
  */
-void ptrace_untrace(struct task_struct *child)
+static void ptrace_untrace(struct task_struct *child)
 {
 	spin_lock(&child->sighand->siglock);
 	if (task_is_traced(child)) {

