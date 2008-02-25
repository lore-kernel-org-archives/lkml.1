Return-Path: <linux-kernel-owner+w=401wt.eu-S1755029AbYBYCTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbYBYCTi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 21:19:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760503AbYBYCT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 21:19:26 -0500
Received: from qb-out-0506.google.com ([72.14.204.233]:39105 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760357AbYBYCTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 21:19:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:message-id:to:cc:subject:from:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=srgqFF7iWG6X2pvaX+B0xlDfhsYPeVPSxBCtiPtwn45uswNchSeoIyd3NDXJAaiBQkzQXx46pqGg0O7MKlPXX2Bvb8vM1Jmxiazx2lkQkc2AoufGMquiQf0IDtWadIMAL8DbzhOkirJZWXWw654RYX8X+aAeNZPRY8jazZ+OxeU=
Date: Mon, 25 Feb 2008 10:14:11 +0800 (CST)
Message-Id: <20080225.101411.09215089.xiyou.wangcong@gmail.com>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, adobriyan@gmail.com, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>, Bryan Wu <bryan.wu@analog.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] Remove the macro get_personality
From: WANG Cong <xiyou.wangcong@gmail.com>
In-Reply-To: <20080223111629.4d8d2c7b.akpm@linux-foundation.org>
References: <20080223092710.GD2262@martell.zuzino.mipt.ru>
	<20080223183731.GA26852@infradead.org>
	<20080223111629.4d8d2c7b.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: WANG Cong <xiyou.wangcong@gmail.com>
Date: Sun, 24 Feb 2008 12:09:03 +0800
Subject: [PATCH] Remove the macro get_personality

Remove the macro get_personality, use ->personality instead.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
---
 arch/blackfin/kernel/signal.c |    2 +-
 arch/frv/kernel/signal.c      |    4 ++--
 include/linux/personality.h   |    4 ----
 3 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/blackfin/kernel/signal.c b/arch/blackfin/kernel/signal.c
index 5564c95..e8d3869 100644
--- a/arch/blackfin/kernel/signal.c
+++ b/arch/blackfin/kernel/signal.c
@@ -224,7 +224,7 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t * info,
 
 	/* Set up registers for signal handler */
 	wrusp((unsigned long)frame);
-	if (get_personality & FDPIC_FUNCPTRS) {
+	if (current->personality & FDPIC_FUNCPTRS) {
 		struct fdpic_func_descriptor __user *funcptr =
 			(struct fdpic_func_descriptor *) ka->sa.sa_handler;
 		__get_user(regs->pc, &funcptr->text);
diff --git a/arch/frv/kernel/signal.c b/arch/frv/kernel/signal.c
index d64bcaf..3bdb368 100644
--- a/arch/frv/kernel/signal.c
+++ b/arch/frv/kernel/signal.c
@@ -297,7 +297,7 @@ static int setup_frame(int sig, struct k_sigaction *ka, sigset_t *set)
 	__frame->lr   = (unsigned long) &frame->retcode;
 	__frame->gr8  = sig;
 
-	if (get_personality & FDPIC_FUNCPTRS) {
+	if (current->personality & FDPIC_FUNCPTRS) {
 		struct fdpic_func_descriptor __user *funcptr =
 			(struct fdpic_func_descriptor __user *) ka->sa.sa_handler;
 		__get_user(__frame->pc, &funcptr->text);
@@ -396,7 +396,7 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	__frame->gr8 = sig;
 	__frame->gr9 = (unsigned long) &frame->info;
 
-	if (get_personality & FDPIC_FUNCPTRS) {
+	if (current->personality & FDPIC_FUNCPTRS) {
 		struct fdpic_func_descriptor __user *funcptr =
 			(struct fdpic_func_descriptor __user *) ka->sa.sa_handler;
 		__get_user(__frame->pc, &funcptr->text);
diff --git a/include/linux/personality.h b/include/linux/personality.h
index 012cd55..a84e9ff 100644
--- a/include/linux/personality.h
+++ b/include/linux/personality.h
@@ -105,10 +105,6 @@ struct exec_domain {
  */
 #define personality(pers)	(pers & PER_MASK)
 
-/*
- * Personality of the currently running process.
- */
-#define get_personality		(current->personality)
 
 /*
  * Change personality of the currently running process.
-- 
1.5.3.8

