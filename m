Return-Path: <linux-kernel-owner+w=401wt.eu-S1752777Ab0AUPFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab0AUPFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 10:05:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592Ab0AUPE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 10:04:57 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53249 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab0AUPE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 10:04:56 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/2] perf top: Fix sample counting
Date: Thu, 21 Jan 2010 13:04:43 -0200
Message-Id: <1264086284-1431-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Broken since "5b2bb75 perf top: Support userspace symbols too".

Reported-by: Mike Galbraith <efault@gmx.de>
Tested-by: Mike Galbraith <efault@gmx.de>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 7a8a77e..8b04988 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -934,8 +934,11 @@ static void event__process_sample(const event_t *self,
 	struct addr_location al;
 	u8 origin = self->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 
+	++samples;
+
 	switch (origin) {
 	case PERF_RECORD_MISC_USER:
+		++userspace_samples;
 		if (hide_user_symbols)
 			return;
 		break;
@@ -960,9 +963,6 @@ static void event__process_sample(const event_t *self,
 		if (list_empty(&syme->node) || !syme->node.next)
 			__list_insert_active_sym(syme);
 		pthread_mutex_unlock(&active_symbols_lock);
-		if (origin == PERF_RECORD_MISC_USER)
-			++userspace_samples;
-		++samples;
 	}
 }
 
-- 
1.6.2.5

