Return-Path: <linux-kernel-owner+w=401wt.eu-S1760001AbZKLCdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760001AbZKLCdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 21:33:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759975AbZKLCdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 21:33:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:52962 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759967AbZKLCdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 21:33:42 -0500
Subject: [PATCH][GIT PULL][v2.6.32] tracing: Fix return value of
 tracing_stats_read()
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Roel Kluin <roel.kluin@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4AFB2C0B.50605@gmail.com>
References: <4AFB2C0B.50605@gmail.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 11 Nov 2009 21:33:45 -0500
Message-Id: <1257993225.22249.24.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

I know this is late in the rc's, but this is a very minor fix. Do you
think we can slip this in before 33.

Please pull the latest tip/tracing/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/urgent


Roel Kluin (1):
      tracing: Fix return value of tracing_stats_read()

----
 kernel/trace/trace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
---------------------------
commit a646365cc330b5aaf4452c91f61b1e0d1acf68d0
Author: Roel Kluin <roel.kluin@gmail.com>
Date:   Wed Nov 11 22:26:35 2009 +0100

    tracing: Fix return value of tracing_stats_read()
    
    The function tracing_stats_read() mistakenly returns ENOMEM instead
    of the negative value -ENOMEM.
    
    Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
    LKML-Reference: <4AFB2C0B.50605@gmail.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index b20d3ec..03c7fd5 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3730,7 +3730,7 @@ tracing_stats_read(struct file *filp, char __user *ubuf,
 
 	s = kmalloc(sizeof(*s), GFP_KERNEL);
 	if (!s)
-		return ENOMEM;
+		return -ENOMEM;
 
 	trace_seq_init(s);
 


