Return-Path: <linux-kernel-owner+w=401wt.eu-S1752816AbZLFHgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbZLFHgc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 02:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754437AbZLFHfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 02:35:46 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:38724 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932213AbZLFHfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 02:35:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hPmeCsVO/UfgKNw8rPN8RiHIuHEmJBWBNL8tP3hdLCuYIs9ua0XKFG2iPNJFfqXWzp
         kZOQKWaN/VcdVnShwFlVcO4wJr2ZZZMDD9i5vxUBbT/UNlegiTpB6j2MF+bBScGY1zfy
         WEK8FwpBV284i71DlSWogsKlnuPXxyZjFqy1Q=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "K. Prasad" <prasad@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 6/9] perf: Remove the "event" callback from perf events
Date: Sun,  6 Dec 2009 08:34:55 +0100
Message-Id: <1260084898-11686-7-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1260084898-11686-1-git-send-regression-fweisbec@gmail.com>
References: <1260084898-11686-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As it is not used anymore and has been superseded by overflow_handler.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: "K. Prasad" <prasad@linux.vnet.ibm.com>
---
 include/linux/perf_event.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index d2f2667..89098e3 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -567,7 +567,6 @@ struct perf_pending_entry {
 
 struct perf_sample_data;
 
-typedef void (*perf_callback_t)(struct perf_event *, void *);
 typedef void (*perf_overflow_handler_t)(struct perf_event *, int,
 					struct perf_sample_data *,
 					struct pt_regs *regs);
@@ -669,8 +668,6 @@ struct perf_event {
 	struct event_filter		*filter;
 #endif
 
-	perf_callback_t			callback;
-
 #endif /* CONFIG_PERF_EVENTS */
 };
 
-- 
1.6.2.3

