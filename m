Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab0BWCGo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 21:06:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992Ab0BWCFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 21:05:23 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v3 3/9] perf probe: Fix bugs in line range finder
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>
Date: Mon, 22 Feb 2010 21:08:39 -0500
Message-ID: <20100223020839.26668.91987.stgit@localhost6.localdomain6>
In-Reply-To: <20100223020818.26668.79685.stgit@localhost6.localdomain6>
References: <20100223020818.26668.79685.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix find_line_range_by_line() to init line_list and remove
misconseptional found marking which should be done when
real lines are found (if there is no lines probe-able,
find_line_range() should return 0).

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
---

 tools/perf/util/probe-finder.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 1b2124d..3e10dbe 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -788,6 +788,7 @@ static void find_line_range_by_line(struct line_finder *lf)
 	Dwarf_Addr addr;
 	int ret;
 
+	INIT_LIST_HEAD(&lf->lr->line_list);
 	ret = dwarf_srclines(lf->cu_die, &lines, &cnt, &__dw_error);
 	DIE_IF(ret != DW_DLV_OK);
 
@@ -848,8 +849,6 @@ static int linefunc_callback(struct die_link *dlink, void *data)
 		lr->start = lf->lno_s;
 		lr->end = lf->lno_e;
 		find_line_range_by_line(lf);
-		/* If we find a target function, this should be end. */
-		lf->found = 1;
 		return 1;
 	}
 	return 0;


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
