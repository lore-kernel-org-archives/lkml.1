Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab0CBObM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 09:31:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:43163 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352Ab0CBObK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 09:31:10 -0500
Date: Tue, 2 Mar 2010 14:30:34 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu,
       dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, dzickus@redhat.com,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/nmi] nmi_watchdog: Tell the world we're active
Message-ID: <tip-5671a10e2bc7f99d9157c6044faf8be2ef302361@git.kernel.org>
Git-Commit-ID: 5671a10e2bc7f99d9157c6044faf8be2ef302361
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 02 Mar 2010 14:30:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5671a10e2bc7f99d9157c6044faf8be2ef302361
Gitweb:     http://git.kernel.org/tip/5671a10e2bc7f99d9157c6044faf8be2ef302361
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 2 Mar 2010 14:20:14 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 2 Mar 2010 15:02:05 +0100

nmi_watchdog: Tell the world we're active

Because I was wondering why perf stat wasn't working as expected..

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Don Zickus <dzickus@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/nmi_watchdog.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/nmi_watchdog.c b/kernel/nmi_watchdog.c
index 0a6f57f..a79d211 100644
--- a/kernel/nmi_watchdog.c
+++ b/kernel/nmi_watchdog.c
@@ -244,6 +244,8 @@ static int __init spawn_nmi_watchdog_task(void)
 	if (nonmi_watchdog)
 		return 0;
 
+	printk(KERN_INFO "NMI watchdog enabled, takes one hw-pmu counter.\n");
+
 	err = cpu_callback(&cpu_nfb, CPU_UP_PREPARE, cpu);
 	if (err == NOTIFY_BAD) {
 		BUG();
