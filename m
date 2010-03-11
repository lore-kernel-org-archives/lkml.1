Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab0CKVAT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 16:00:19 -0500
Received: from smtp-out.google.com ([216.239.33.17]:46952 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955Ab0CKVAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 16:00:16 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:x-system-of-record;
	b=NHxVq+3eY1StRwZlX118KUMZBE3vJeukMBlcvDqtiwIXRm+4j3xCbpWVUYWOXKhbm
	VwWiJgFvT0f+Z7cqoB6xw==
From: eranian@google.com
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, fweisbec@gmail.com,
       robert.richter@amd.com, davem@davemloft.net,
       perfmon2-devel@lists.sf.net
Subject: [PATCH] perf_events: remove bogus Intel Core constraint on ITLB_MISS_RETIRED
Date: Thu, 11 Mar 2010 12:59:28 -0800
Message-Id: <1268341168-19705-1-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.0.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Contrary to what Vol3b section 30.4.3 leads to believe, there is
no constraint on ITLB_MISS_RETIRED on Intel Core-based CPU, so
remove it.

	Signed-off-by: Stephane Eranian <eranian@google.com>
--
 perf_event_intel.c |    1 -
 1 file changed, 1 deletion(-)
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 971dc6e..58e83cd 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -43,7 +43,6 @@ static struct event_constraint intel_core2_event_constraints[] =
 	INTEL_EVENT_CONSTRAINT(0x18, 0x1), /* IDLE_DURING_DIV */
 	INTEL_EVENT_CONSTRAINT(0x19, 0x2), /* DELAYED_BYPASS */
 	INTEL_EVENT_CONSTRAINT(0xa1, 0x1), /* RS_UOPS_DISPATCH_CYCLES */
-	INTEL_EVENT_CONSTRAINT(0xc9, 0x1), /* ITLB_MISS_RETIRED (T30-9) */
 	INTEL_EVENT_CONSTRAINT(0xcb, 0x1), /* MEM_LOAD_RETIRED */
 	EVENT_CONSTRAINT_END
 };
