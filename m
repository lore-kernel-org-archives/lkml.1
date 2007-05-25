Return-Path: <linux-kernel-owner+w=401wt.eu-S1752912AbXEYPYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbXEYPYc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 11:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789AbXEYPYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 11:24:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:50769 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754AbXEYPYY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 11:24:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,580,1170662400"; 
   d="scan'208";a="247286111"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/2] Define new percpu interface for shared data -- version 3
Date: Fri, 25 May 2007 08:24:12 -0700
Message-ID: <79E93560F4A5FD42BB769DAAF8BEF62A01ADBF81@scsmsx411.amr.corp.intel.com>
In-Reply-To: <20070525094323.GB20090@flint.arm.linux.org.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/2] Define new percpu interface for shared data -- version 3
Thread-Index: AceesSzCMjJbL+ejRPGxe6QF16AocgALAhSA
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "Russell King" <rmk+lkml@arm.linux.org.uk>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Ravikiran G Thirumalai" <kiran@scalex86.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, <clameter@sgi.com>,
       <linux-kernel@vger.kernel.org>, <schwidefsky@de.ibm.com>,
       <heiko.carstens@de.ibm.com>
X-OriginalArrivalTime: 25 May 2007 15:24:14.0347 (UTC) FILETIME=[C089D5B0:01C79EE0]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>What's "shared percpu data" ?  It sounds to me like a contradiction in
>terms.  Isn't percpu data supposed to only be accessed by the CPU which
>owns it to prevent cache line bouncing?  In which case, what's the
point
>of sharing that data with other CPUs?  Surely "shared percpu data" is
>just the same as normal data?

Like said in the patch description:
"per cpu data section contains two types of data. One set which is
exclusively accessed by the local cpu and the other set which is  per
cpu,
but also shared by remote cpus."

The patches separate shared and aligned per cpu data from others to
eliminate cache pouncing between remote and local access.

The patches do not separate shared but non-aligned percpu data, e.g.
cpu_idle_state, flush_state in x86-64. We can do that later if needed.

I think the shared percpu data are "mainly" accessed by local cpu. We
need
to concentrate on their local cpu access i.e. define in percpu. If we
treat them as "normal" data, we may lose percpu benefits e.g. numa
allocation.

Thanks.

-Fenghua
