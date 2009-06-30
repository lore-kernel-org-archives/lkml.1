Return-Path: <linux-kernel-owner+w=401wt.eu-S1760156AbZF3XSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760156AbZF3XSA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 19:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759627AbZF3XRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 19:17:20 -0400
Received: from ozlabs.org ([203.10.76.45]:39627 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758464AbZF3XRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 19:17:18 -0400
Message-Id: <20090630230140.995643441@samba.org>
References: <20090630230043.464194676@samba.org>
User-Agent: quilt/0.46-1
Date: Wed, 01 Jul 2009 09:00:47 +1000
From: Anton Blanchard <anton@samba.org>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [patch 4/8] perf top: Add ppc64 specific skip symbols and strip ppc64 . prefix
Content-Disposition: inline; filename=pcl_skip_symbols_pseries.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Filter out some ppc64 specific idle loop functions and remove leading '.' on
ppc64 text symbols.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Do we want to wrap them with #ifdef __PPC__ ?

Index: linux-2.6-tip/tools/perf/builtin-top.c
===================================================================
--- linux-2.6-tip.orig/tools/perf/builtin-top.c	2009-07-01 08:21:31.000000000 +1000
+++ linux-2.6-tip/tools/perf/builtin-top.c	2009-07-01 08:21:36.000000000 +1000
@@ -293,6 +293,8 @@
 	"enter_idle",
 	"exit_idle",
 	"mwait_idle",
+	"ppc64_runlatch_off",
+	"pseries_dedicated_idle_sleep",
 	NULL
 };
 
@@ -303,6 +305,13 @@
 	const char *name = sym->name;
 	int i;
 
+	/*
+	 * ppc64 uses function descriptors and appends a '.' to the
+	 * start of every instruction address. Remove it.
+	 */
+	if (name[0] == '.')
+		name++;
+
 	if (!strcmp(name, "_text") ||
 	    !strcmp(name, "_etext") ||
 	    !strcmp(name, "_sinittext") ||

-- 

