Return-Path: <linux-kernel-owner+w=401wt.eu-S935026AbZKYUUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935026AbZKYUUx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 15:20:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935010AbZKYUUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 15:20:53 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:52133 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935004AbZKYUUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 15:20:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hXwtfc0eDMeLnfVTduPe5OxupoZBhL1PA4lK+xQ4UqNrMg3djgE03vCrIaF3WfSMrx
         E89vaMYHpe3mVoFRGah9kyPRL1AQttaeXWKH/LwAFCU0gxCWRe0ZS0FkOXj413qoXz/C
         qU7pw6jOqSMt75RfgcNsXDrJBxDxuIwNEpQeM=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] hw-breakpoints: Fix unused function in off-case
Date: Wed, 25 Nov 2009 21:20:53 +0100
Message-Id: <1259180453-5813-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <20091125215338.d07a95b9.sfr@canb.auug.org.au>
References: <20091125215338.d07a95b9.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bp_perf_event_destroy() is unused in its off-case version, let's remove
it to fix the following warning:

kernel/perf_event.c:4306: warning: 'bp_perf_event_destroy' defined but not used

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 kernel/perf_event.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 35df94e..b119e4e 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4303,10 +4303,6 @@ void perf_bp_event(struct perf_event *bp, void *data)
 		perf_swevent_add(bp, 1, 1, &sample, regs);
 }
 #else
-static void bp_perf_event_destroy(struct perf_event *event)
-{
-}
-
 static const struct pmu *bp_perf_event_init(struct perf_event *bp)
 {
 	return NULL;
-- 
1.6.2.3

