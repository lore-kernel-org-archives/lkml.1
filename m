Return-Path: <linux-kernel-owner+w=401wt.eu-S1752565AbZLVEAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbZLVEAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 23:00:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751723AbZLVEAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 23:00:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32924 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbZLVEAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 23:00:07 -0500
X-Authority-Analysis: v=1.0 c=1 a=Bp6AohddP10A:10 a=7U3hwN5JcxgA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=JfrnYn6hAAAA:8 a=omOdbC7AAAAA:8 a=meVymXHHAAAA:8 a=lriSGrjynLXjsU4WBXQA:9 a=EsqysNpT-s_Sc2ijiJoA:7 a=e8PRgjeNPJRlyFJ-DC3kRAZusDYA:4 a=jEp0ucaQiEUA:10 a=3Rfx1nUSh_UA:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: [PATCH][GIT PULL] tracing: Fix setting tracer specific options
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Li Zefan <lizf@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 21 Dec 2009 23:00:04 -0500
Message-ID: <1261454404.25193.471.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/urgent


Steven Rostedt (1):
      tracing: Fix setting tracer specific options

----
 kernel/trace/trace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
---------------------------
commit c757bea93bea4b77ebd181cc6dca60c15e3b1a2c
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Mon Dec 21 22:35:16 2009 -0500

    tracing: Fix setting tracer specific options
    
    The function __set_tracer_option() takes as its last parameter a
    "neg" value. If set it should negate the value of the option.
    
    The trace_options_write() passed the value written to the file
    which is what the new value needs to be set as. But since this
    is not the negative, it never sets the value.
    
    Reported-by: Peter Zijlstra <peterz@infradead.org>
    Cc: Li Zefan <lizf@cn.fujitsu.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ee61915..d0a4c12 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3949,7 +3949,7 @@ trace_options_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	if (!!(topt->flags->val & topt->opt->bit) != val) {
 		mutex_lock(&trace_types_lock);
 		ret = __set_tracer_option(current_trace, topt->flags,
-					  topt->opt, val);
+					  topt->opt, !val);
 		mutex_unlock(&trace_types_lock);
 		if (ret)
 			return ret;


