Return-Path: <linux-kernel-owner+w=401wt.eu-S1758232AbZD2KzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758232AbZD2KzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 06:55:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755810AbZD2KvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 06:51:21 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:52569 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755319AbZD2KvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 06:51:09 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j)
X-FB-SS: 13,
X-WSS-ID: 0KIUZGQ-04-0X1-01
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 03/29] x86/perfcounters: add default path to cpu detection
Date: Wed, 29 Apr 2009 12:47:00 +0200
Message-ID: <1241002046-8832-4-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 29 Apr 2009 10:50:49.0024 (UTC) FILETIME=[5B6DF400:01C9C8B8]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This quits hw counter initialization immediately if no cpu is
detected.

Signed-off-by: Robert Richter <robert.richter@amd.com>
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
-- 
1.6.1.3


