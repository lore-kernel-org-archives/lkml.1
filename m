Return-Path: <linux-kernel-owner+w=401wt.eu-S1755447AbZGPK5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447AbZGPK5L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 06:57:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbZGPK5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 06:57:08 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:58112 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755286AbZGPKyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 06:54:39 -0400
Message-Id: <20090716104817.697698033@samba.org>
References: <20090716104247.536695580@samba.org>
User-Agent: quilt/0.46-1
Date: Thu, 16 Jul 2009 20:42:51 +1000
From: Anton Blanchard <anton@samba.org>
To: a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
       fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [patch 4/5] perf_counter: Add perf record option to log addresses.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the -d or --data option to log event addresses (eg page faults).

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux.trees.git/tools/perf/builtin-record.c
===================================================================
--- linux.trees.git.orig/tools/perf/builtin-record.c	2009-07-15 11:31:53.000000000 +1000
+++ linux.trees.git/tools/perf/builtin-record.c	2009-07-15 11:34:26.000000000 +1000
@@ -43,6 +43,7 @@
 static int			verbose				= 0;
 static int			inherit_stat			= 0;
 static int			no_samples			= 0;
+static int			sample_address			= 0;
 
 static long			samples;
 static struct timeval		last_read;
@@ -405,6 +406,9 @@
 	if (inherit_stat)
 		attr->inherit_stat = 1;
 
+	if (sample_address)
+		attr->sample_type	|= PERF_SAMPLE_ADDR;
+
 	if (call_graph)
 		attr->sample_type	|= PERF_SAMPLE_CALLCHAIN;
 
@@ -649,6 +653,8 @@
 		    "be more verbose (show counter open errors, etc)"),
 	OPT_BOOLEAN('s', "stat", &inherit_stat,
 		    "per thread counts"),
+	OPT_BOOLEAN('d', "data", &sample_address,
+		    "Sample addresses"),
 	OPT_BOOLEAN('n', "no-samples", &no_samples,
 		    "don't sample"),
 	OPT_END()

-- 

