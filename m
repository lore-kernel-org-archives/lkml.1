Return-Path: <linux-kernel-owner+w=401wt.eu-S933200AbZLJGTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933200AbZLJGTR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 01:19:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933111AbZLJGTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 01:19:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:34858 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933024AbZLJGTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 01:19:07 -0500
Date: Thu, 10 Dec 2009 06:18:33 GMT
From: tip-bot for Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, xiaoguangrong@cn.fujitsu.com,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, peterz@infradead.org,
       xiaoguangrong@cn.fujitsu.com, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4B208E93.1010801@cn.fujitsu.com>
References: <4B208E93.1010801@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf_event: Fix perf_swevent_hrtimer() variable initialization
Message-ID: <tip-21140f4d3387aa2213f1deea0128df1dbf924379@git.kernel.org>
Git-Commit-ID: 21140f4d3387aa2213f1deea0128df1dbf924379
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  21140f4d3387aa2213f1deea0128df1dbf924379
Gitweb:     http://git.kernel.org/tip/21140f4d3387aa2213f1deea0128df1dbf924379
Author:     Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
AuthorDate: Thu, 10 Dec 2009 14:00:51 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 10 Dec 2009 07:11:05 +0100

perf_event: Fix perf_swevent_hrtimer() variable initialization

fix:

 [<c0477471>] ? printk+0x1d/0x24
 [<c01c98f9>] ? perf_prepare_sample+0x269/0x280
 [<c0149231>] warn_slowpath_common+0x71/0xd0
 [<c01c98f9>] ? perf_prepare_sample+0x269/0x280
 [<c01492aa>] warn_slowpath_null+0x1a/0x20
 [<c01c98f9>] perf_prepare_sample+0x269/0x280
 [<c016e9f3>] ? cpu_clock+0x53/0x90
 [<c01cc368>] __perf_event_overflow+0x2a8/0x300
 [<c01ccc3b>] perf_event_overflow+0x1b/0x30
 [<c01ccccf>] perf_swevent_hrtimer+0x7f/0x120

This is because 'data.raw' variable not initialize.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <4B208E93.1010801@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 94e1b28..3a5d6c4 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4010,6 +4010,7 @@ static enum hrtimer_restart perf_swevent_hrtimer(struct hrtimer *hrtimer)
 	event->pmu->read(event);
 
 	data.addr = 0;
+	data.raw = NULL;
 	data.period = event->hw.last_period;
 	regs = get_irq_regs();
 	/*
