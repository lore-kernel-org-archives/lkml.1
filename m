Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934720Ab0CLXOP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 18:14:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932279Ab0CLXOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 18:14:11 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 3/3] [BUGFIX] perf probe: Set need_dwarf if lazy matching
	is used
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>
Date: Fri, 12 Mar 2010 18:22:24 -0500
Message-ID: <20100312232224.2017.54550.stgit@localhost6.localdomain6>
In-Reply-To: <20100312232208.2017.55337.stgit@localhost6.localdomain6>
References: <20100312232208.2017.55337.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set need_dwarf if lazy matching pattern is specified, because
lazy matching requires real source path for which we must use
debuginfo.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
---

 tools/perf/util/probe-event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 53181db..7c004b6 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -242,7 +242,7 @@ void parse_perf_probe_event(const char *str, struct probe_point *pp,
 
 	/* Parse probe point */
 	parse_perf_probe_probepoint(argv[0], pp);
-	if (pp->file || pp->line)
+	if (pp->file || pp->line || pp->lazy_line)
 		*need_dwarf = true;
 
 	/* Copy arguments and ensure return probe has no C argument */


-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
