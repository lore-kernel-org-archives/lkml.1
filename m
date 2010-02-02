Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab0BBIZf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 03:25:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:36387 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736Ab0BBIZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 03:25:33 -0500
Date: Tue, 2 Feb 2010 08:24:38 GMT
From: tip-bot for Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, akinobu.mita@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, peterz@infradead.org, tglx@linutronix.de,
       akinobu.mita@gmail.com, mingo@elte.hu
In-Reply-To: <1264938810-4173-1-git-send-email-akinobu.mita@gmail.com>
References: <1264938810-4173-1-git-send-email-akinobu.mita@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Use for_each_bit
Message-ID: <tip-90fdbdb48442a03c72cae5463e6edb64cb3a3a7d@git.kernel.org>
Git-Commit-ID: 90fdbdb48442a03c72cae5463e6edb64cb3a3a7d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 02 Feb 2010 08:24:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  90fdbdb48442a03c72cae5463e6edb64cb3a3a7d
Gitweb:     http://git.kernel.org/tip/90fdbdb48442a03c72cae5463e6edb64cb3a3a7d
Author:     Akinobu Mita <akinobu.mita@gmail.com>
AuthorDate: Sun, 31 Jan 2010 20:53:24 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 2 Feb 2010 06:58:27 +0100

sched: Use for_each_bit

No change in functionality.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <1264938810-4173-1-git-send-email-akinobu.mita@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_cpupri.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/kernel/sched_cpupri.c b/kernel/sched_cpupri.c
index 597b330..eeb3506 100644
--- a/kernel/sched_cpupri.c
+++ b/kernel/sched_cpupri.c
@@ -47,9 +47,7 @@ static int convert_prio(int prio)
 }
 
 #define for_each_cpupri_active(array, idx)                    \
-  for (idx = find_first_bit(array, CPUPRI_NR_PRIORITIES);     \
-       idx < CPUPRI_NR_PRIORITIES;                            \
-       idx = find_next_bit(array, CPUPRI_NR_PRIORITIES, idx+1))
+	for_each_bit(idx, array, CPUPRI_NR_PRIORITIES)
 
 /**
  * cpupri_find - find the best (lowest-pri) CPU in the system
