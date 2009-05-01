Return-Path: <linux-kernel-owner+w=401wt.eu-S1762264AbZEAN3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762264AbZEAN3k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 09:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761628AbZEAN2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 09:28:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:58511 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761723AbZEAN2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 09:28:48 -0400
Date: Fri, 1 May 2009 13:27:58 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090501102533.196245693@chello.nl>
References: <20090501102533.196245693@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: tool: handle 0-length data files
Message-ID: <tip-585e3374d9d29376c2c37d821c8b7637dd48ca95@git.kernel.org>
Git-Commit-ID: 585e3374d9d29376c2c37d821c8b7637dd48ca95
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 01 May 2009 13:28:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  585e3374d9d29376c2c37d821c8b7637dd48ca95
Gitweb:     http://git.kernel.org/tip/585e3374d9d29376c2c37d821c8b7637dd48ca95
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 1 May 2009 12:23:18 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 1 May 2009 13:23:44 +0200

perf_counter: tool: handle 0-length data files

Avoid perf-report barfing on 0-length data files.

[ Impact: fix perf-report SIGBUS ]

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <20090501102533.196245693@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/perf-report.cc |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/Documentation/perf_counter/perf-report.cc b/Documentation/perf_counter/perf-report.cc
index 933a075..911d7f3 100644
--- a/Documentation/perf_counter/perf-report.cc
+++ b/Documentation/perf_counter/perf-report.cc
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
