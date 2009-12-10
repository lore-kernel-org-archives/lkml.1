Return-Path: <linux-kernel-owner+w=401wt.eu-S933038AbZLJGC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933038AbZLJGC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 01:02:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932884AbZLJGC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 01:02:27 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62014 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932875AbZLJGC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 01:02:27 -0500
Message-ID: <4B208E93.1010801@cn.fujitsu.com>
Date: Thu, 10 Dec 2009 14:00:51 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] perf_event: fix perf_swevent_hrtimer()
References: <4B2075B0.10805@cn.fujitsu.com> <1260422135.4165.3.camel@twins>
In-Reply-To: <1260422135.4165.3.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 kernel/perf_event.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 0bd0f67..e63ba9a 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4010,6 +4010,7 @@ static enum hrtimer_restart perf_swevent_hrtimer(struct hrtimer *hrtimer)
 	event->pmu->read(event);
 
 	data.addr = 0;
+	data.raw = NULL;
 	data.period = event->hw.last_period;
 	regs = get_irq_regs();
 	/*
-- 
1.6.1.2

