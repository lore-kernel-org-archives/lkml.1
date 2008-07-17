Return-Path: <linux-kernel-owner+w=401wt.eu-S1757862AbYGQH2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862AbYGQH2q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754840AbYGQH2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:28:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53478 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754795AbYGQH2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:28:33 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 03/23] tracehook: unexport ptrace_notify
In-Reply-To: Roland McGrath's message of  Thursday, 17 July 2008 00:25:41 -0700 <20080717072541.F390E15411D@magilla.localdomain>
References: <20080717072541.F390E15411D@magilla.localdomain>
X-Windows: you'll envy the dead.
Message-Id: <20080717072829.30A6E1541A5@magilla.localdomain>
Date: Thu, 17 Jul 2008 00:28:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ptrace_notify() function should not be called by any modules.
It was only ever exported to be called by binfmt exec functions.
But that is no longer necessary since fs/exec.c deals with that
generically now.  There should be no calls to ptrace_notify() from
outside the core kernel.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 kernel/signal.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 6c0958e..02d3a11 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1921,7 +1921,6 @@ EXPORT_SYMBOL_GPL(dequeue_signal);
 EXPORT_SYMBOL(flush_signals);
 EXPORT_SYMBOL(force_sig);
 EXPORT_SYMBOL(kill_proc);
-EXPORT_SYMBOL(ptrace_notify);
 EXPORT_SYMBOL(send_sig);
 EXPORT_SYMBOL(send_sig_info);
 EXPORT_SYMBOL(sigprocmask);
