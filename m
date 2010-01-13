Return-Path: <linux-kernel-owner+w=401wt.eu-S932109Ab0AMKfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab0AMKfp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:35:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932087Ab0AMKfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:35:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:34623 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755004Ab0AMKfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:35:41 -0500
Date: Wed, 13 Jan 2010 10:34:44 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, dle-develop@lists.sourceforge.net,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu,
       systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, peterz@infradead.org, efault@gmx.de,
       fweisbec@gmail.com, dle-develop@lists.sourceforge.net,
       tglx@linutronix.de, mhiramat@redhat.com, systemtap@sources.redhat.com,
       mingo@elte.hu
In-Reply-To: <20100105224710.19431.61542.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20100105224710.19431.61542.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Show probe list in pager
Message-ID: <tip-72041334b8c75ae7e1da2f17ba2b7afee8f2abd7@git.kernel.org>
Git-Commit-ID: 72041334b8c75ae7e1da2f17ba2b7afee8f2abd7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jan 2010 10:34:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  72041334b8c75ae7e1da2f17ba2b7afee8f2abd7
Gitweb:     http://git.kernel.org/tip/72041334b8c75ae7e1da2f17ba2b7afee8f2abd7
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 5 Jan 2010 17:47:10 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 13 Jan 2010 10:09:13 +0100

perf probe: Show probe list in pager

Show probe list in pager, because the list can be longer than
a page.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <20100105224710.19431.61542.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
