Return-Path: <linux-kernel-owner+w=401wt.eu-S1761223AbXKMSn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761223AbXKMSn7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 13:43:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758032AbXKMSnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 13:43:09 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:52234 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757723AbXKMSnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 13:43:08 -0500
Message-Id: <20071113184249.118725616@polymtl.ca>
References: <20071113183923.190808360@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 13 Nov 2007 13:39:26 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 3/3] Linux Kernel Markers - fix samples to follow format string standard
Content-Disposition: inline; filename=markers-fix-example-format-string.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 13 Nov 2007 18:42:49 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add the field names to marker example format string.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 samples/markers/marker-example.c |    3 ++-
 samples/markers/probe-example.c  |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/samples/markers/marker-example.c
===================================================================
--- linux-2.6-lttng.orig/samples/markers/marker-example.c	2007-11-03 20:56:35.000000000 -0400
+++ linux-2.6-lttng/samples/markers/marker-example.c	2007-11-03 20:57:08.000000000 -0400
@@ -19,7 +19,8 @@ static int my_open(struct inode *inode, 
 {
 	int i;
 
-	trace_mark(subsystem_event, "%d %s", 123, "example string");
+	trace_mark(subsystem_event, "integer %d string %s", 123,
+		"example string");
 	for (i = 0; i < 10; i++)
 		trace_mark(subsystem_eventb, MARK_NOARGS);
 	return -EPERM;
Index: linux-2.6-lttng/samples/markers/probe-example.c
===================================================================
--- linux-2.6-lttng.orig/samples/markers/probe-example.c	2007-11-03 20:57:38.000000000 -0400
+++ linux-2.6-lttng/samples/markers/probe-example.c	2007-11-03 20:57:51.000000000 -0400
@@ -53,7 +53,7 @@ void probe_subsystem_eventb(const struct
 static struct probe_data probe_array[] =
 {
 	{	.name = "subsystem_event",
-		.format = "%d %s",
+		.format = "integer %d string %s",
 		.probe_func = probe_subsystem_event },
 	{	.name = "subsystem_eventb",
 		.format = MARK_NOARGS,

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
