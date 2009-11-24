Return-Path: <linux-kernel-owner+w=401wt.eu-S933204AbZKXUHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933204AbZKXUHw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 15:07:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933053AbZKXUHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 15:07:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933025AbZKXUHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 15:07:47 -0500
Date: Tue, 24 Nov 2009 21:02:04 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org, utrace-devel@redhat.com
Subject: [RFC,PATCH 10/14] ptrace_signal: check PT_PTRACED before reporting
	a signal
Message-ID: <20091124200204.GA5808@redhat.com>
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

--- V1/kernel/signal.c~10_PTRACE_SIGNAL_CK_PTRACED	2009-11-24 20:29:06.000000000 +0100
+++ V1/kernel/signal.c	2009-11-24 20:30:15.000000000 +0100
@@ -1731,7 +1731,7 @@ static int do_signal_stop(int signr)
 static int ptrace_signal(int signr, siginfo_t *info,
 			 struct pt_regs *regs, void *cookie)
 {
-	if (!task_ptrace(current))
+	if (!(task_ptrace(current) & PT_PTRACED))
 		return signr;
 
 	ptrace_signal_deliver(regs, cookie);

