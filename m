Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab0CCQr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 11:47:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:46193 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650Ab0CCQpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 11:45:24 -0500
Message-Id: <20100303163936.906011640@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 03 Mar 2010 17:39:36 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: paulus@samba.org, eranian@google.com, robert.richter@amd.com,
       fweisbec@gmail.com, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 00/11] Another stab at PEBS and LBR support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sorta works, the PEBS-LBR-fixup stuff makes my machine unhappy, but I could
have made a silly mistake there..

Can be tested using the below patchlet and something like: perf top -e r00c0p

---
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 05d0c5c..f8314e6 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -656,6 +656,11 @@ parse_raw_event(const char **strp, struct perf_event_attr *attr)
 		return EVT_FAILED;
 	n = hex2u64(str + 1, &config);
 	if (n > 0) {
+		if (str[n+1] == 'p') {
+			attr->precise = 1;
+			printf("precise\n");
+			n++;
+		}
 		*strp = str + n + 1;
 		attr->type = PERF_TYPE_RAW;
 		attr->config = config;


