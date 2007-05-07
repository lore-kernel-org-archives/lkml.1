Return-Path: <linux-kernel-owner+w=401wt.eu-S966124AbXEGSN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966124AbXEGSN5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 14:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966092AbXEGSNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 14:13:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:30927 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966098AbXEGSNy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 14:13:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,502,1170662400"; 
   d="scan'208";a="242998811"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 0/2] Add percpu smp cacheline align section
Date: Mon, 7 May 2007 11:13:51 -0700
Message-ID: <A29F7A5700A7EA4380E08C1F68C3B6D802B03E97@scsmsx411.amr.corp.intel.com>
In-Reply-To: <20070507174608.GB21638@linux-os.sc.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 0/2] Add percpu smp cacheline align section
Thread-Index: AceQz+5CGu2FLNeBQNusmGCknR8PzwAAd54A
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Christoph Lameter" <clameter@sgi.com>
CC: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 07 May 2007 18:13:51.0846 (UTC) FILETIME=[775D7060:01C790D3]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2007 at 10:30:16AM -0700, Christoph Lameter wrote:
> Call this area "cpu shared" or so?

There are some fields in percpu section which are accessed by other
cpu's but not cache line aligned, e.g. cpu_idle_state, flush_state in
x86-64. We don't want to place those fields into same subsection as
cacheline aligned fields.

So perhaps, I can change the section name
.data.percpu.cacheline_aligned_in_smp to
.data.percpu.shared_cacheline_aligned. And change macro
DEFINE_PER_CPU_CACHELINE_ALIGNED_IN_SMP to
DEFINE_PER_CPU_SHARED_CACHELINE_ALIGNED.

.data.percpu.shared_cacheline_aligned contains only cpu shared percpu
fields which are cacheline aligned. In future (or in a separate patch
series), we can define another percpu section .data.percpu.shared and
its macro DEFINE_PER_CPU_SHARED_CACHELINE_ALIGNED which store all of cpu
shared percpu fields. The new .data.percpu.shared and
DEFINE_PER_CPU_SHARED_CACHELINE_ALIGNED are for better coding and
understanding.

Thanks.

-Fenghua
