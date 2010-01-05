Return-Path: <linux-kernel-owner+w=401wt.eu-S1754996Ab0AEWlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996Ab0AEWlN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 17:41:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754601Ab0AEWlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 17:41:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152Ab0AEWlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 17:41:10 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 5/8] perf probe: Show probe list in pager
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>
Date: Tue, 05 Jan 2010 17:47:10 -0500
Message-ID: <20100105224710.19431.61542.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20100105224634.19431.3259.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20100105224634.19431.3259.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Show probe list in pager, because the list can be longer than
a page.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
---

 tools/perf/util/probe-event.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 8e532d9..a22141a 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -37,6 +37,7 @@
 #include "string.h"
 #include "strlist.h"
 #include "debug.h"
+#include "cache.h"
 #include "parse-events.h"  /* For debugfs_path */
 #include "probe-event.h"
 
@@ -455,6 +456,8 @@ void show_perf_probe_events(void)
 	struct strlist *rawlist;
 	struct str_node *ent;
 
+	setup_pager();
+
 	fd = open_kprobe_events(O_RDONLY, 0);
 	rawlist = get_trace_kprobe_event_rawlist(fd);
 	close(fd);


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
