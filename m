Return-Path: <linux-kernel-owner+w=401wt.eu-S1753940Ab0ASMgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab0ASMgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 07:36:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753826Ab0ASMgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 07:36:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:42046 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab0ASMg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 07:36:27 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jamie Iles <jamie.iles@picochip.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/2] perf symbols: Set dso->kernel when handling the fake vmlinux MMAP event
Date: Tue, 19 Jan 2010 10:36:13 -0200
Message-Id: <1263904574-30732-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Because it may be possible that there was no buildid section, where we
would set this to 1.

Found while analysing a perf.data file collected on an ARM machine where
an explicitely specified vmlinux was being disregarded.

Reported-by: Jamie Iles <jamie.iles@picochip.com>
Cc: Jamie Iles <jamie.iles@picochip.com>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index dc13cad..bbaee61 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -373,6 +373,7 @@ int event__process_mmap(event_t *self, struct perf_session *session)
 			if (kernel == NULL)
 				goto out_problem;
 
+			kernel->kernel = 1;
 			if (__map_groups__create_kernel_maps(&session->kmaps,
 							     session->vmlinux_maps,
 							     kernel) < 0)
-- 
1.6.2.5

