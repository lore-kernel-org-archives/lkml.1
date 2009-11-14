Return-Path: <linux-kernel-owner+w=401wt.eu-S1757773AbZKNEMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757773AbZKNEMl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 23:12:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756749AbZKNEMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 23:12:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:38539 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757182AbZKNEMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 23:12:40 -0500
Subject: [PATCH][GIT PULL][v2.6.32] tracing: Fix event format export
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20091113224009.GB23942@elte.hu>
References: <1258115870.6167.4.camel@johannes.local>
	 <20091113224009.GB23942@elte.hu>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Fri, 13 Nov 2009 23:12:44 -0500
Message-Id: <1258171964.22249.234.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/urgent


Johannes Berg (1):
      tracing: Fix event format export

----
 include/trace/ftrace.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
---------------------------
commit 811cb50baf63461ce0bdb234927046131fc7fa8b
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Fri Nov 13 23:40:09 2009 +0100

    tracing: Fix event format export
    
    For some reason the export of the event print format to userspace
    uses '#fmt' which breaks if the format string is anything but a plain
    string, for example if it is built with macros then the macro names
    are exported instead of their contents.
    
    Use
    	"\"%s\"", fmt
    instead of
    	"%s", #fmt
    to export the string and not the way it is built.
    
    For example, in net/mac80211/driver-trace.h for the trace event drv_start
    there is:
    
            TP_printk(
                    LOCAL_PR_FMT, LOCAL_PR_ARG
            )
    
    Which use to produce:
    
     print fmt: LOCAL_PR_FMT, REC->wiphy_name
    
    Now produces:
    
     print fmt: "%s", REC->wiphy_name
    
    Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
    LKML-Reference: <20091113224009.GB23942@elte.hu>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index cc0d966..dacb8ef 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -159,7 +159,7 @@
 #undef __get_str
 
 #undef TP_printk
-#define TP_printk(fmt, args...) "%s, %s\n", #fmt, __stringify(args)
+#define TP_printk(fmt, args...) "\"%s\", %s\n", fmt, __stringify(args)
 
 #undef TP_fast_assign
 #define TP_fast_assign(args...) args


