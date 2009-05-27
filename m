Return-Path: <linux-kernel-owner+w=401wt.eu-S1763895AbZE0Hhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763895AbZE0Hhu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763417AbZE0Hd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:33:58 -0400
Received: from mga06.intel.com ([134.134.136.21]:7158 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762359AbZE0Hd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:33:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,258,1241420400"; 
   d="scan'208";a="415981564"
Date: Wed, 27 May 2009 15:17:36 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: One question about perf_counter on IA
Message-ID: <20090527071736.GA26774@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that the LVT error register is masked and then unmasked during
perf_counter initialization on IA in arch/x86/kernel/cpu/perf_counter.c

void perf_counters_lapic_init(int nmi)
{
	u32 apic_val;

	if (!x86_pmu_initialized())
		return;

	/*
	 * Enable the performance counter vector in the APIC LVT:
	 */
	apic_val = apic_read(APIC_LVTERR);

	apic_write(APIC_LVTERR, apic_val | APIC_LVT_MASKED);
	if (nmi)
		apic_write(APIC_LVTPC, APIC_DM_NMI);
	else
		apic_write(APIC_LVTPC, LOCAL_PERF_VECTOR);
	apic_write(APIC_LVTERR, apic_val);
}

Why is this needed? Is this documented somewhere in the spec? I tried
commenting out the masking and unmasking operations and I did not any
error interrupt generated.

Thanks
-Yong
