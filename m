Return-Path: <linux-kernel-owner+w=401wt.eu-S1753167AbZLAAXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167AbZLAAXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 19:23:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbZLAAXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 19:23:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105AbZLAAXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 19:23:34 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 3/9] perf probe: Fix to add probe-finder.h without
	libdwarf
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
Date: Mon, 30 Nov 2009 19:19:34 -0500
Message-ID: <20091201001934.10235.44656.stgit@harusame>
In-Reply-To: <20091201001912.10235.79411.stgit@harusame>
References: <20091201001912.10235.79411.stgit@harusame>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add probe-finder.h as LIB_H without libdwarf, because that
header is included even if no libdwarf.

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

 tools/perf/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index f1537a9..76e4b04 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -369,6 +369,7 @@ LIB_H += util/sort.h
 LIB_H += util/hist.h
 LIB_H += util/thread.h
 LIB_H += util/data_map.h
+LIB_H += util/probe-finder.h
 
 LIB_OBJS += util/abspath.o
 LIB_OBJS += util/alias.o
@@ -485,7 +486,6 @@ ifneq ($(shell sh -c "(echo '\#include <libdwarf/dwarf.h>'; echo '\#include <lib
 	BASIC_CFLAGS += -DNO_LIBDWARF
 else
 	EXTLIBS += -lelf -ldwarf
-	LIB_H += util/probe-finder.h
 	LIB_OBJS += util/probe-finder.o
 endif
 


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
