Return-Path: <linux-kernel-owner+w=401wt.eu-S1756647AbYEPCAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647AbYEPCAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 22:00:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbYEPB74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 21:59:56 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:2000 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195AbYEPB74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 21:59:56 -0400
Message-ID: <482CEA9A.7010504@ct.jp.nec.com>
Date: Thu, 15 May 2008 18:59:54 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] print RT watchdog message
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

It's useful to detect which process is killed by RT watchdog.
---
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
-- 
1.5.4.1

