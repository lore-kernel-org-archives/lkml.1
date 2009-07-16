Return-Path: <linux-kernel-owner+w=401wt.eu-S932185AbZGPKyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185AbZGPKyq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 06:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932127AbZGPKyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 06:54:44 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:58108 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755281AbZGPKyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 06:54:39 -0400
Message-Id: <20090716104817.517264409@samba.org>
References: <20090716104247.536695580@samba.org>
User-Agent: quilt/0.46-1
Date: Thu, 16 Jul 2009 20:42:49 +1000
From: Anton Blanchard <anton@samba.org>
To: a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
       fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [patch 2/5] perf_counter: Synthesize VDSO mmap event
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf record synthesizes mmap events for the running process. Right now
it just catches file mappings, but we can check for the vdso symbol
and add that too.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Only tested on PowerPC, but I assume x86 has the same issue.

Index: linux.trees.git/tools/perf/builtin-record.c
===================================================================
--- linux.trees.git.orig/tools/perf/builtin-record.c	2009-07-13 12:33:49.000000000 +1000
+++ linux.trees.git/tools/perf/builtin-record.c	2009-07-13 13:25:00.000000000 +1000
@@ -313,6 +313,10 @@
 		if (*pbf == 'x') { /* vm_exec */
 			char *execname = strchr(bf, '/');
 
+			/* Catch VDSO */
+			if (execname == NULL)
+				execname = strstr(bf, "[vdso]");
+
 			if (execname == NULL)
 				continue;
 

-- 

