Return-Path: <linux-kernel-owner+w=401wt.eu-S1758109AbZLIWKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109AbZLIWKI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 17:10:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758041AbZLIWKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 17:10:06 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58201 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbZLIWKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 17:10:05 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/2] perf symbols: dsos__read_build_ids should read both user and kernel buildids
Date: Wed,  9 Dec 2009 20:09:37 -0200
Message-Id: <1260396578-19116-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.5.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index fffcb93..e7508ad 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -938,8 +938,9 @@ static bool __dsos__read_build_ids(struct list_head *head)
 
 bool dsos__read_build_ids(void)
 {
-	return __dsos__read_build_ids(&dsos__kernel) ||
-	       __dsos__read_build_ids(&dsos__user);
+	bool kbuildids = __dsos__read_build_ids(&dsos__kernel),
+	     ubuildids = __dsos__read_build_ids(&dsos__user);
+	return kbuildids || ubuildids;
 }
 
 /*
-- 
1.6.5.2

