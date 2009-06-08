Return-Path: <linux-kernel-owner+w=401wt.eu-S1754391AbZFHR0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbZFHR0J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 13:26:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754050AbZFHRZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 13:25:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36640 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467AbZFHRZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 13:25:49 -0400
Subject: [PATCH] perf_counter: extensible perf_counter_attr
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 08 Jun 2009 19:25:41 +0200
Message-Id: <1244481941.13761.9119.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow extending the perf_counter_attr structure by linking extended
structures to it.

Also, should we grow the directly reserved space in the structure a
little more?

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_counter.h |    7 +++++++
 kernel/perf_counter.c        |    1 +
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 3586df8..781d8ce 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -175,6 +175,13 @@ struct perf_counter_attr {
 	__u32			__reserved_3;
 
 	__u64			__reserved_4;
+
+	struct perf_counter_attr_ext *ext_attrs;
+};
+
+struct perf_counter_attr_ext {
+	struct perf_counter_attr_ext 	*next;
+	__u64				perf_attr_ext_type;
 };
 
 /*
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 5eacaaf..606f662 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -3467,6 +3467,7 @@ perf_counter_alloc(struct perf_counter_attr *attr,
 
 	counter->cpu		= cpu;
 	counter->attr		= *attr;
+	counter->attr.ext_attrs	= NULL;
 	counter->group_leader	= group_leader;
 	counter->pmu		= NULL;
 	counter->ctx		= ctx;

