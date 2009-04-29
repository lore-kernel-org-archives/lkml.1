Return-Path: <linux-kernel-owner+w=401wt.eu-S1755253AbZD2NE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbZD2NE6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756962AbZD2NEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:04:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:44472 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755507AbZD2NEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:04:31 -0400
Date: Wed, 29 Apr 2009 13:03:53 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, robert.richter@amd.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, robert.richter@amd.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1241002046-8832-4-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-4-git-send-email-robert.richter@amd.com>
Subject: [tip:perfcounters/core] perf_counter, x86: add default path to cpu detection
Message-ID: <tip-4138960a9251a265002b5cf07e671a49f8495381@git.kernel.org>
Git-Commit-ID: 4138960a9251a265002b5cf07e671a49f8495381
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 13:03:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4138960a9251a265002b5cf07e671a49f8495381
Gitweb:     http://git.kernel.org/tip/4138960a9251a265002b5cf07e671a49f8495381
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 29 Apr 2009 12:47:00 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 29 Apr 2009 14:51:01 +0200

perf_counter, x86: add default path to cpu detection

This quits hw counter initialization immediately if no cpu is
detected.

[ Impact: cleanup ]

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Paul Mackerras <paulus@samba.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1241002046-8832-4-git-send-email-robert.richter@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 7d0f81d..d6d6529 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -997,6 +997,8 @@ void __init init_hw_perf_counters(void)
 	case X86_VENDOR_AMD:
 		pmc_ops = pmc_amd_init();
 		break;
+	default:
+		return;
 	}
 	if (!pmc_ops)
 		return;
