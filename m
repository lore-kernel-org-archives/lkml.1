Return-Path: <linux-kernel-owner+w=401wt.eu-S1757346AbZD2KxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346AbZD2KxE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 06:53:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755442AbZD2KvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 06:51:11 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:9816 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862AbZD2KvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 06:51:03 -0400
X-BigFish: VPS-1(z5edJzzz1202hzzz32i64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KIUZGM-02-18M-01
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/29] x86/perfcounters: x86 and AMD cpu updates
Date: Wed, 29 Apr 2009 12:46:57 +0200
Message-ID: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.1.3
X-OriginalArrivalTime: 29 Apr 2009 10:50:48.0977 (UTC) FILETIME=[5B66C810:01C9C8B8]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series updates the perfcounters implementation mainly for
the x86 architecture.

Also, it introduces a data structure (struct pmu) describing a generic
performance monitoring unit (pmu). This structure is a replacement for
struct hw_perf_counter_ops. Similiar, I introduced struct x86_pmu for
the x86 architecture (as a replacement for struct pmc_x86_ops).

There are patches for x86 with some fixes and cleanups, a change in
the model specific split and a complete rework of AMD pmu code. The
result is simplified model specific code and more generalized and
unified code. Features that are only supported by AMD or Intel are now
implemented in vendor specific functions.

The AMD pmu differs to Intel, especially there is no status register
and also there are no fixed counters. This makes a separate interrupt
handler for AMD cpus necessary. Also, a global disable/enable of the
performance counters (e.g. to avoid NMIs to protect the modification
of a list) is expensive on AMD cpus leading to up to 4 msr
reads/writes per counter. There is still some more work to do here to
avoid this.

This patch series bases on the tip/percounters/core branch.

I developed this patches based on 03ced43 and later rebased to
1b88991. The latest tip/percounters/core branch seems to be broken, no
nmis are delivered, only perfcounter interrupts with no results on
kerneltop. I am still debugging this. However, I could test
successfully the patch series based on 03ced43 and want to release the
patches anyway.

-Robert



