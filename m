Return-Path: <linux-kernel-owner+w=401wt.eu-S1762632AbYFDTgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762632AbYFDTgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 15:36:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762253AbYFDTgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 15:36:24 -0400
Received: from 66-189-124-104.dhcp.oxfr.ma.charter.com ([66.189.124.104]:40170
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1762202AbYFDTgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 15:36:23 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 2/2] sched: fix cpupri priocount
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutonix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Gregory Haskins <ghaskins@novell.com>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Date: Wed, 04 Jun 2008 15:04:10 -0400
Message-ID: <20080604190410.5108.78092.stgit@novell1.haskins.net>
In-Reply-To: <20080604185838.5108.54912.stgit@novell1.haskins.net>
References: <20080604185838.5108.54912.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A rounding error was pointed out by Peter Zijlstra which would result
in the structure holding priorities to be off by one.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
CC: Peter Zijlstra <peterz@infradead.org>
---

 kernel/sched_cpupri.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_cpupri.h b/kernel/sched_cpupri.h
index 16d29b9..817c55c 100644
--- a/kernel/sched_cpupri.h
+++ b/kernel/sched_cpupri.h
@@ -4,7 +4,7 @@
 #include <linux/sched.h>
 
 #define CPUPRI_NR_PRIORITIES 2+MAX_RT_PRIO
-#define CPUPRI_NR_PRI_WORDS CPUPRI_NR_PRIORITIES/BITS_PER_LONG
+#define CPUPRI_NR_PRI_WORDS (CPUPRI_NR_PRIORITIES + BITS_PER_LONG/2)/BITS_PER_LONG
 
 #define CPUPRI_INVALID -1
 #define CPUPRI_IDLE     0

