Return-Path: <linux-kernel-owner+w=401wt.eu-S1752372AbZJUGYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372AbZJUGYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 02:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbZJUGYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 02:24:22 -0400
Received: from ozlabs.org ([203.10.76.45]:47607 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890AbZJUGYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 02:24:22 -0400
Date: Wed, 21 Oct 2009 17:19:25 +1100
From: Anton Blanchard <anton@samba.org>
To: mingo@elte.hu, paulus@samba.org, a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] perf record: Enable PERF_SAMPLE_ID when sampling multiple
	events
Message-ID: <20091021061925.GW4808@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If we are sampling multiple events we need the id in each sample so we can
differentiate between them in a perf data file.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux.trees.git/tools/perf/builtin-record.c
===================================================================
--- linux.trees.git.orig/tools/perf/builtin-record.c	2009-10-21 14:58:33.000000000 +1100
+++ linux.trees.git/tools/perf/builtin-record.c	2009-10-21 17:12:33.000000000 +1100
@@ -413,6 +413,9 @@ static void create_counter(int counter, 
 		attr->sample_type	|= PERF_SAMPLE_CPU;
 	}
 
+	if (nr_counters > 1)
+		attr->sample_type	|= PERF_SAMPLE_ID;
+
 	attr->mmap		= track;
 	attr->comm		= track;
 	attr->inherit		= (cpu < 0) && inherit;
