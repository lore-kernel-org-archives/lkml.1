Return-Path: <linux-kernel-owner+w=401wt.eu-S1752906AbZLRBRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbZLRBRb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 20:17:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751215AbZLRBR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 20:17:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6495 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383AbZLRBRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 20:17:25 -0500
Date: Fri, 18 Dec 2009 02:11:28 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com
Subject: [PATCH 3/7] ptrace_signal: check PT_PTRACED before reporting a
	signal
Message-ID: <20091218011128.GA29552@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes, preparation for utrace-ptrace.

Change ptrace_signal() to check PT_PTRACED instead of task_ptrace() != 0.
Currently this is the same, PT_PTRACED must be always set if the task is
ptraced.

This change is needed to make sure ptrace_signal() does nothing if ptrace
is implemented on top of utrace, eventually this code will be removed
completely.

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/signal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- V1/kernel/signal.c~3_PTRACE_SIGNAL_CK_PTRACED	2009-12-18 00:20:50.000000000 +0100
+++ V1/kernel/signal.c	2009-12-18 00:48:35.000000000 +0100
@@ -1764,7 +1764,7 @@ static int do_signal_stop(int signr)
 static int ptrace_signal(int signr, siginfo_t *info,
 			 struct pt_regs *regs, void *cookie)
 {
-	if (!task_ptrace(current))
+	if (!(task_ptrace(current) & PT_PTRACED))
 		return signr;
 
 	ptrace_signal_deliver(regs, cookie);

