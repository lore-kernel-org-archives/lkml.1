Return-Path: <linux-kernel-owner+w=401wt.eu-S932362AbZHUTlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362AbZHUTlp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 15:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932314AbZHUTln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 15:41:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932289AbZHUTlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 15:41:40 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH tracing/kprobes 3/4] tracing/kprobes: Fix format typo in
	trace_kprobes
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Avi Kivity <avi@redhat.com>, Andi Kleen <ak@linux.intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       =?utf-8?q?Przemys=C5=82aw?= =?utf-8?q?Pawe=C5=82czyk?= 
	<przemyslaw@pawelczyk.it>,
       Roland McGrath <roland@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>
Date: Fri, 21 Aug 2009 15:43:43 -0400
Message-ID: <20090821194343.12478.37618.stgit@localhost.localdomain>
In-Reply-To: <20090821000108.GC6078@nowhere>
References: <20090821000108.GC6078@nowhere>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a format typo in kprobe-tracer.

Currently, it shows 'tsize' in format;

$ cat /debug/tracing/events/kprobes/event/format 
...
        field: unsigned long ip;        offset:16;tsize:8;
        field: int nargs;       offset:24;tsize:4;
...

This should be '\tsize';

$ cat /debug/tracing/events/kprobes/event/format 
...
        field: unsigned long ip;        offset:16;	size:8;
        field: int nargs;       offset:24;	size:4;
...

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Przemysław Pawełczyk <przemyslaw@pawelczyk.it>
Cc: Roland McGrath <roland@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
---

 kernel/trace/trace_kprobe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 7cd726e..22e91c0 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1069,7 +1069,7 @@ static int __probe_event_show_format(struct trace_seq *s,
 #define SHOW_FIELD(type, item, name)					\
 	do {								\
 		ret = trace_seq_printf(s, "\tfield: " #type " %s;\t"	\
-				"offset:%u;tsize:%u;\n", name,		\
+				"offset:%u;\tsize:%u;\n", name,		\
 				(unsigned int)offsetof(typeof(field), item),\
 				(unsigned int)sizeof(type));		\
 		if (!ret)						\


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
