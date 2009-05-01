Return-Path: <linux-kernel-owner+w=401wt.eu-S1756695AbZEAK0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695AbZEAK0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 06:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753645AbZEAK0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 06:26:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:51419 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbZEAK0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 06:26:13 -0400
Message-Id: <20090501102533.196245693@chello.nl>
References: <20090501102315.367605848@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 01 May 2009 12:23:18 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/4] perf_counter: tool: handle 0-length data files
Content-Disposition: inline; filename=perf_counter-report-zero-file.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid perf-report barfing on 0-length data files.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 Documentation/perf_counter/perf-report.cc |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6/Documentation/perf_counter/perf-report.cc
===================================================================
--- linux-2.6.orig/Documentation/perf_counter/perf-report.cc
+++ linux-2.6/Documentation/perf_counter/perf-report.cc
@@ -402,6 +402,11 @@ int main(int argc, char *argv[])
 		exit(-1);
 	}
 
+	if (!stat.st_size) {
+		fprintf(stderr, "zero-sized file, nothing to do!\n");
+		exit(0);
+	}
+
 	load_kallsyms();
 
 remap:

-- 

