Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935AbYLEEbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbYLEEbQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 23:31:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbYLEEbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 23:31:00 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:37146 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbYLEEa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 23:30:59 -0500
Date: Thu, 4 Dec 2008 23:30:56 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, containers@lists.osdl.org,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH] ftrace: use init_struct_pid as swapper pid
In-Reply-To: <m1vdtzr4zn.fsf@frodo.ebiederm.org>
Message-ID: <alpine.DEB.1.10.0812042323120.26316@gandalf.stny.rr.com>
References: <20081204052638.425740534@goodmis.org> <20081204052735.362609481@goodmis.org> <20081204001803.598063f5.akpm@linux-foundation.org> <20081204091023.GJ32594@elte.hu> <m1vdu0t7tz.fsf@frodo.ebiederm.org> <alpine.DEB.1.10.0812040946060.5240@gandalf.stny.rr.com>
 <m11vwnu10b.fsf@frodo.ebiederm.org> <alpine.DEB.1.10.0812041551590.32726@gandalf.stny.rr.com> <m1vdtzr4zn.fsf@frodo.ebiederm.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Here's a little clean up patch.

Randy Dunlap should be happy that I changed my script to combine the 
header and patch in one email if I only have a single patch.

-- Steve

The following patch is in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Steven Rostedt (1):
      ftrace: use init_struct_pid as swapper pid

----
 kernel/trace/ftrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
---------------------------
commit 954d6cd672e0e87219f0763f829345518647f293
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Thu Dec 4 23:19:12 2008 -0500

    ftrace: use init_struct_pid as swapper pid
    
    Impact: clean up
    
    Using (struct pid *)-1 as the pointer for ftrace_swapper_pid is
    a little confusing for others. This patch uses the address of the
    actual init pid structure instead. This change is only for
    clarity. It does not affect the code itself. Hopefully soon the
    swapper tasks will all have their own pid structure and then
    we can clean up the code a bit more.
    
    Signed-off-by: Steven Rostedt <srostedt@redhat.com>

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index d2b1565..2971fe4 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -49,7 +49,7 @@ static int last_ftrace_enabled;
 
 /* set when tracing only a pid */
 struct pid *ftrace_pid_trace;
-static struct pid * const ftrace_swapper_pid = (struct pid *)1;
+static struct pid * const ftrace_swapper_pid = &init_struct_pid;
 
 /* Quick disabling of function tracer. */
 int function_trace_stop;


