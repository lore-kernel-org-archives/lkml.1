Return-Path: <linux-kernel-owner+w=401wt.eu-S1754149AbZFBUQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbZFBUQa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 16:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbZFBUQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 16:16:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:59431 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300AbZFBUQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 16:16:21 -0400
Date: Tue, 2 Jun 2009 20:15:40 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter tools: Remove the last nmi bits
Message-ID: <tip-29c2810276fbf8419c9b4d942b99c873e9b7640a@git.kernel.org>
Git-Commit-ID: 29c2810276fbf8419c9b4d942b99c873e9b7640a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 02 Jun 2009 20:15:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  29c2810276fbf8419c9b4d942b99c873e9b7640a
Gitweb:     http://git.kernel.org/tip/29c2810276fbf8419c9b4d942b99c873e9b7640a
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 2 Jun 2009 15:56:26 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 2 Jun 2009 21:45:28 +0200

perf_counter tools: Remove the last nmi bits

Everything is nmi these days, remove the userspace bits so that
the kernel can drop the interface.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-stat.c |    1 -
 Documentation/perf_counter/builtin-top.c  |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/Documentation/perf_counter/builtin-stat.c b/Documentation/perf_counter/builtin-stat.c
index 5886791..644f850 100644
--- a/Documentation/perf_counter/builtin-stat.c
+++ b/Documentation/perf_counter/builtin-stat.c
@@ -84,7 +84,6 @@ static void create_perfstat_counter(int counter)
 	memset(&hw_event, 0, sizeof(hw_event));
 	hw_event.config		= event_id[counter];
 	hw_event.record_type	= 0;
-	hw_event.nmi		= 1;
 	hw_event.exclude_kernel = event_mask[counter] & EVENT_MASK_KERNEL;
 	hw_event.exclude_user   = event_mask[counter] & EVENT_MASK_USER;
 
diff --git a/Documentation/perf_counter/builtin-top.c b/Documentation/perf_counter/builtin-top.c
index 24a8879..a2cff7b 100644
--- a/Documentation/perf_counter/builtin-top.c
+++ b/Documentation/perf_counter/builtin-top.c
@@ -581,7 +581,6 @@ static int __cmd_top(void)
 			hw_event.config		= event_id[counter];
 			hw_event.irq_period	= event_count[counter];
 			hw_event.record_type	= PERF_RECORD_IP | PERF_RECORD_TID;
-			hw_event.nmi		= 1;
 			hw_event.mmap		= use_mmap;
 			hw_event.munmap		= use_munmap;
 			hw_event.freq		= freq;
