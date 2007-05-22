Return-Path: <linux-kernel-owner+w=401wt.eu-S966401AbXEVTBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966401AbXEVTBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 15:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758151AbXEVTBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 15:01:23 -0400
Received: from mga03.intel.com ([143.182.124.21]:12377 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757726AbXEVTBW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 15:01:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,567,1170662400"; 
   d="scan'208";a="230926897"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2/2] Use the new percpu interface for shared data -- version 3
Date: Tue, 22 May 2007 12:01:20 -0700
Message-ID: <79E93560F4A5FD42BB769DAAF8BEF62A01AA8380@scsmsx411.amr.corp.intel.com>
In-Reply-To: <Pine.LNX.4.64.0705221154510.29456@schroedinger.engr.sgi.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/2] Use the new percpu interface for shared data -- version 3
Thread-Index: AcecosIy5Mkno7czSa2EGHs2qZ+iTQAADOyQ
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "Christoph Lameter" <clameter@sgi.com>
Cc: <akpm@linux-foundation.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, <kiran@scalex86.org>,
       <rmk@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 22 May 2007 19:01:21.0687 (UTC) FILETIME=[9632EA70:01C79CA3]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> -DEFINE_PER_CPU(struct tss_struct, init_tss)
>>____cacheline_internodealigned_in_smp = INIT_TSS;
>> +DEFINE_PER_CPU_SHARED_ALIGNED(struct tss_struct, init_tss) =
INIT_TSS;

>Good work but could we call this something shorter?

>Like

>DEFINE_CPU_SHARED(...)

The PER_CPU_SHARED_ALIGNED is corresponding to
.data.per_cpu.shared_aligned section which has all shared and aligned
percpu data.

In future, another section .data.per_cpu.shared and its macro
DEFINE_PER_CPU_SHARED might be added for shared but not aligned.

BTW, DEFINE_PER_CPU_SHARED_ALIGNED is already getting shorter than
pervious version.

Thanks.

-Fenghua
