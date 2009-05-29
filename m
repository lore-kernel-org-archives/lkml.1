Return-Path: <linux-kernel-owner+w=401wt.eu-S1759928AbZE2NQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759928AbZE2NQ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 09:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758842AbZE2NQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 09:16:18 -0400
Received: from smtp.nokia.com ([192.100.122.230]:63998 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757677AbZE2NQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 09:16:18 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.intel.com>, linux-fsdevel@vger.kernel.org,
       Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>
Date: Fri, 29 May 2009 18:09:38 +0300
Message-Id: <20090529150938.8912.3443.sendpatchset@localhost.localdomain>
In-Reply-To: <20090529150929.8912.33879.sendpatchset@localhost.localdomain>
References: <20090529150929.8912.33879.sendpatchset@localhost.localdomain>
Subject: [PATCH 1/2] hrtimer: export ktime_add_safe
X-OriginalArrivalTime: 29 May 2009 13:15:44.0330 (UTC) FILETIME=[92A0DAA0:01C9E05F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCH 1/2] hrtimer: export ktime_add_safe

We want to use hrtimers in UBIFS (for write-buffer write-back timer).
We need the 'hrtimer_set_expires_range_ns()', which is an in-line
function which uses 'ktime_add_safe()'.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 kernel/hrtimer.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index cb8a15c..18f6906 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -332,6 +332,8 @@ ktime_t ktime_add_safe(const ktime_t lhs, const ktime_t rhs)
 	return res;
 }
 
+EXPORT_SYMBOL_GPL(ktime_add_safe);
+
 #ifdef CONFIG_DEBUG_OBJECTS_TIMERS
 
 static struct debug_obj_descr hrtimer_debug_descr;
-- 
1.6.0.6

