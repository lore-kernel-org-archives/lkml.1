Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab0CDOCA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 09:02:00 -0500
Received: from casper.infradead.org ([85.118.1.10]:39701 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab0CDOB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 09:01:56 -0500
Message-Id: <20100304140100.468665803@chello.nl>
References: <20100304140046.596569763@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 04 Mar 2010 15:00:53 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: paulus@samba.org, eranian@google.com, robert.richter@amd.com,
       fweisbec@gmail.com, Arnaldo Carvalho de Melo <acme@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 07/14] perf: Add attr->precise support to raw event parsing
Content-Disposition: inline; filename=perf-tools-precise.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minimal userspace interface to the new 'precise' events flag.

Can be used like: perf top -e r00c0p
Which will use PEBS to sample retired instructions

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 tools/perf/util/parse-events.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6/tools/perf/util/parse-events.c
===================================================================
--- linux-2.6.orig/tools/perf/util/parse-events.c
+++ linux-2.6/tools/perf/util/parse-events.c
@@ -656,6 +656,10 @@ parse_raw_event(const char **strp, struc
 		return EVT_FAILED;
 	n = hex2u64(str + 1, &config);
 	if (n > 0) {
+		if (str[n+1] == 'p') {
+			attr->precise = 1;
+			n++;
+		}
 		*strp = str + n + 1;
 		attr->type = PERF_TYPE_RAW;
 		attr->config = config;

-- 

