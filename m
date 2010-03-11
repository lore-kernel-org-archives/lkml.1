Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934358Ab0CKSxd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 13:53:33 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38396 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933497Ab0CKSxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 13:53:30 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/2] perf record: Mention paranoid sysctl when failing to create counter
Date: Thu, 11 Mar 2010 15:53:12 -0300
Message-Id: <1268333592-30872-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1268333592-30872-1-git-send-email-acme@infradead.org>
References: <1268333592-30872-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[acme@mica linux-2.6-tip]$ perf record -a -f
  Fatal: Permission error - are you root?
	 Consider tweaking /proc/sys/kernel/perf_event_paranoid.

[acme@mica linux-2.6-tip]$

Suggested-by: Ingo Molnar <mingo@elte.hu>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 3bf1409..b280ab5 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -283,7 +283,8 @@ try_again:
 		int err = errno;
 
 		if (err == EPERM || err == EACCES)
-			die("Permission error - are you root?\n");
+			die("Permission error - are you root?\n"
+			    "\t Consider tweaking /proc/sys/kernel/perf_event_paranoid.\n");
 		else if (err ==  ENODEV && profile_cpu != -1)
 			die("No such device - did you specify an out-of-range profile CPU?\n");
 
-- 
1.5.5.1

