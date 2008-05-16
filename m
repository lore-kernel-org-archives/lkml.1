Return-Path: <linux-kernel-owner+w=401wt.eu-S1754368AbYEPCnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368AbYEPCnY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 22:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751645AbYEPCnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 22:43:16 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:34036 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbYEPCnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 22:43:15 -0400
Message-Id: <482CF4A9.1020504@ct.jp.nec.com>
Date: Thu, 15 May 2008 19:42:49 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] print RT watchdog message
References: <482CEA9A.7010504@ct.jp.nec.com>
In-Reply-To: <482CEA9A.7010504@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

It's useful to detect which process is killed by RT watchdog.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
Oops, I forgot to add S-O-B.

 kernel/posix-cpu-timers.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index f1525ad..c42a03a 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1037,6 +1037,9 @@ static void check_thread_timers(struct task_struct *tsk,
 				sig->rlim[RLIMIT_RTTIME].rlim_cur +=
 								USEC_PER_SEC;
 			}
+			printk(KERN_INFO
+				"RT Watchdog Timeout: %s[%d]\n",
+				tsk->comm, task_pid_nr(tsk));
 			__group_send_sig_info(SIGXCPU, SEND_SIG_PRIV, tsk);
 		}
 	}
