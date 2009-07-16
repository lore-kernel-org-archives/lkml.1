Return-Path: <linux-kernel-owner+w=401wt.eu-S932118AbZGPKyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118AbZGPKyo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 06:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755267AbZGPKym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 06:54:42 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:58130 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755312AbZGPKyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 06:54:39 -0400
Message-Id: <20090716104817.803604373@samba.org>
References: <20090716104247.536695580@samba.org>
User-Agent: quilt/0.46-1
Date: Thu, 16 Jul 2009 20:42:52 +1000
From: Anton Blanchard <anton@samba.org>
To: a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
       fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [patch 5/5] perf_counter: Make call graph option consistent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf record uses -g for logging call graph data but perf report uses -c
to print call graph data. Be consistent and use -g everywhere for call graph
data.

Also update the help text to reflect the current default - fractal,0.5

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Im not sure if it's too late to make this change, but I've tripped
up a number of times when I cycle between perf record and perf report.

Index: linux.trees.git/tools/perf/builtin-report.c
===================================================================
--- linux.trees.git.orig/tools/perf/builtin-report.c	2009-07-16 19:41:41.000000000 +1000
+++ linux.trees.git/tools/perf/builtin-report.c	2009-07-16 19:41:49.000000000 +1000
@@ -2005,9 +2005,9 @@
 		   "regex filter to identify parent, see: '--sort parent'"),
 	OPT_BOOLEAN('x', "exclude-other", &exclude_other,
 		    "Only display entries with parent-match"),
-	OPT_CALLBACK_DEFAULT('c', "callchain", NULL, "output_type,min_percent",
+	OPT_CALLBACK_DEFAULT('g', "call-graph", NULL, "output_type,min_percent",
 		     "Display callchains using output_type and min percent threshold. "
-		     "Default: flat,0", &parse_callchain_opt, callchain_default_opt),
+		     "Default: fractal,0.5", &parse_callchain_opt, callchain_default_opt),
 	OPT_STRING('d', "dsos", &dso_list_str, "dso[,dso...]",
 		   "only consider symbols in these dsos"),
 	OPT_STRING('C', "comms", &comm_list_str, "comm[,comm...]",

-- 

