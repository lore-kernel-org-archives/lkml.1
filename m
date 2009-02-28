Return-Path: <linux-kernel-owner+w=401wt.eu-S1753069AbZB1Hf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069AbZB1Hf0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 02:35:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbZB1HfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 02:35:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:42008 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbZB1HfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 02:35:11 -0500
Date: Sat, 28 Feb 2009 02:35:07 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Subject: [PATCH][git pull] tracing: replace kzalloc with kcalloc
Message-ID: <alpine.DEB.2.00.0902280233410.2116@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Steven Rostedt (1):
      tracing: replace kzalloc with kcalloc

----
 kernel/trace/trace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
---------------------------
commit 0cfe82451dfa3ebf4e69158f2eb450f2fbb6b715
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Fri Feb 27 10:51:10 2009 -0500

    tracing: replace kzalloc with kcalloc
    
    Impact: clean up
    
    kcalloc is a better approach to allocate a NULL array.
    
    Reported-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Steven Rostedt <srostedt@redhat.com>

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 5db7485..9c5987a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3328,7 +3328,7 @@ create_trace_option_files(struct tracer *tracer)
 	for (cnt = 0; opts[cnt].name; cnt++)
 		;
 
-	topts = kzalloc(sizeof(*topts) * (cnt + 1), GFP_KERNEL);
+	topts = kcalloc(cnt + 1, sizeof(*topts), GFP_KERNEL);
 	if (!topts)
 		return NULL;
 

