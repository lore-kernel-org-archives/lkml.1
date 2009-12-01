Return-Path: <linux-kernel-owner+w=401wt.eu-S1753272AbZLAAU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbZLAAU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 19:20:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753068AbZLAAUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 19:20:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753088AbZLAAUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 19:20:24 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 5/9] perf probe: Fix probe array index for multiple probe
	point
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Mon, 30 Nov 2009 19:19:51 -0500
Message-ID: <20091201001950.10235.54781.stgit@harusame>
In-Reply-To: <20091201001912.10235.79411.stgit@harusame>
References: <20091201001912.10235.79411.stgit@harusame>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the index of formatted probe array for multiple probe
point, which should be probes[i] instead of probes[0].

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---

 tools/perf/builtin-probe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 510fdd4..5f47e62 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -428,7 +428,7 @@ end_dwarf:
 					pp->retprobe ? 'r' : 'p',
 					PERFPROBE_GROUP,
 					pp->function, pp->offset, i,
-					pp->probes[0]);
+					pp->probes[i]);
 				write_new_event(fd, buf);
 			}
 	}


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
