Return-Path: <linux-kernel-owner+w=401wt.eu-S1763191AbZFMOu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763191AbZFMOu5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 10:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbZFMOuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 10:50:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:49077 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762235AbZFMOuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 10:50:01 -0400
Date: Sat, 13 Jun 2009 14:49:21 GMT
From: tip-bot for Jaswinder Singh Rajput <jaswinder@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       jaswinder@kernel.org, jaswinderrajput@gmail.com, robert.richter@amd.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       jaswinder@kernel.org, efault@gmx.de, jaswinderrajput@gmail.com,
       robert.richter@amd.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1244714289.6923.0.camel@ht.satnam>
References: <1244714289.6923.0.camel@ht.satnam>
Subject: [tip:perfcounters/core] perf_counter, x86: Check old-AMD performance monitoring support
Message-ID: <tip-4d2be1267fcfb3a4d2198fd696aec5e3dcbce60e@git.kernel.org>
Git-Commit-ID: 4d2be1267fcfb3a4d2198fd696aec5e3dcbce60e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 13 Jun 2009 14:49:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4d2be1267fcfb3a4d2198fd696aec5e3dcbce60e
Gitweb:     http://git.kernel.org/tip/4d2be1267fcfb3a4d2198fd696aec5e3dcbce60e
Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
AuthorDate: Thu, 11 Jun 2009 15:28:09 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 13 Jun 2009 12:58:25 +0200

perf_counter, x86: Check old-AMD performance monitoring support

AMD supports performance monitoring start from K7 (i.e. family 6),
so disable it for earlier AMD CPUs.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1244714289.6923.0.camel@ht.satnam>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 275bc14..3c37c39 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -1459,6 +1459,10 @@ static int intel_pmu_init(void)
 
 static int amd_pmu_init(void)
 {
+	/* Performance-monitoring supported from K7 and later: */
+	if (boot_cpu_data.x86 < 6)
+		return -ENODEV;
+
 	x86_pmu = amd_pmu;
 
 	switch (boot_cpu_data.x86) {
