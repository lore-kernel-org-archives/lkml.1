Return-Path: <linux-kernel-owner+w=401wt.eu-S965006AbYBWI3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965006AbYBWI3d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:29:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759083AbYBWIT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:19:28 -0500
Received: from qb-out-0506.google.com ([72.14.204.234]:40294 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935960AbYBWIT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:19:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=S0plUvulN7knpbliDkZzlB6E93anHHu7wMjvStuZuEhkcW7DREyJyZLNFdoNarzkc3s2Xpa4tVRJaFiZYoxuSL3Qvgmpe/w2mmVFeNyB3K1l3yTW7mEfYlAllp6qH3UdoLsP1lpJLtpW1vexFk0YDsrqjNKUS6oh0rWV0o5NjKU=
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, WANG Cong <xiyou.wangcong@gmail.com>,
       Christoph Hellwig <hch@infradead.org>, Bryan Wu <bryan.wu@analog.com>,
       David Howells <dhowells@redhat.com>
Subject: [PATCH 01/16] Make the macro get_personality function-like.
Date: Sat, 23 Feb 2008 16:14:04 +0800
Message-Id: <12037544671847-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <12037544592096-git-send-email-xiyou.wangcong@gmail.com>
References: <12037544592096-git-send-email-xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the macro get_personality function-like.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Bryan Wu <bryan.wu@analog.com>
Cc: David Howells <dhowells@redhat.com>

---
 arch/blackfin/kernel/signal.c |    2 +-
 arch/frv/kernel/signal.c      |    4 ++--
 include/linux/personality.h   |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/blackfin/kernel/signal.c b/arch/blackfin/kernel/signal.c
index 5564c95..f3ef4ee 100644
--- a/arch/blackfin/kernel/signal.c
+++ b/arch/blackfin/kernel/signal.c
@@ -224,7 +224,7 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t * info,
 
 	/* Set up registers for signal handler */
 	wrusp((unsigned long)frame);
-	if (get_personality & FDPIC_FUNCPTRS) {
+	if (get_personality() & FDPIC_FUNCPTRS) {
 		struct fdpic_func_descriptor __user *funcptr =
 			(struct fdpic_func_descriptor *) ka->sa.sa_handler;
 		__get_user(regs->pc, &funcptr->text);
diff --git a/arch/frv/kernel/signal.c b/arch/frv/kernel/signal.c
index d64bcaf..7e4405d 100644
--- a/arch/frv/kernel/signal.c
+++ b/arch/frv/kernel/signal.c
@@ -297,7 +297,7 @@ static int setup_frame(int sig, struct k_sigaction *ka, sigset_t *set)
 	__frame->lr   = (unsigned long) &frame->retcode;
 	__frame->gr8  = sig;
 
-	if (get_personality & FDPIC_FUNCPTRS) {
+	if (get_personality() & FDPIC_FUNCPTRS) {
 		struct fdpic_func_descriptor __user *funcptr =
 			(struct fdpic_func_descriptor __user *) ka->sa.sa_handler;
 		__get_user(__frame->pc, &funcptr->text);
@@ -396,7 +396,7 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	__frame->gr8 = sig;
 	__frame->gr9 = (unsigned long) &frame->info;
 
-	if (get_personality & FDPIC_FUNCPTRS) {
+	if (get_personality() & FDPIC_FUNCPTRS) {
 		struct fdpic_func_descriptor __user *funcptr =
 			(struct fdpic_func_descriptor __user *) ka->sa.sa_handler;
 		__get_user(__frame->pc, &funcptr->text);
diff --git a/include/linux/personality.h b/include/linux/personality.h
index 012cd55..1891b31 100644
--- a/include/linux/personality.h
+++ b/include/linux/personality.h
@@ -108,7 +108,7 @@ struct exec_domain {
 /*
  * Personality of the currently running process.
  */
-#define get_personality		(current->personality)
+#define get_personality()	(current->personality)
 
 /*
  * Change personality of the currently running process.
-- 
1.5.3.8

