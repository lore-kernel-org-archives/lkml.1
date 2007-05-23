Return-Path: <linux-kernel-owner+w=401wt.eu-S1761011AbXEWVNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761011AbXEWVNj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 17:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756613AbXEWVNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 17:13:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:30664 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756624AbXEWVNa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 17:13:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,571,1170662400"; 
   d="scan'208";a="248989056"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/2] Define new percpu interface for shared data -- version 3
Date: Wed, 23 May 2007 14:13:24 -0700
Message-ID: <79E93560F4A5FD42BB769DAAF8BEF62A01AA8E7C@scsmsx411.amr.corp.intel.com>
In-Reply-To: <20070523123153.c4f8c7e6.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/2] Define new percpu interface for shared data -- version 3
Thread-Index: AcedcRJD1cY9XQLTQM2hrn2Fec6MpQABbo6Q
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       "Ravikiran G Thirumalai" <kiran@scalex86.org>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>, <clameter@sgi.com>,
       <rmk@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>,
       <schwidefsky@de.ibm.com>, <heiko.carstens@de.ibm.com>
X-OriginalArrivalTime: 23 May 2007 21:13:26.0034 (UTC) FILETIME=[33E40F20:01C79D7F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>> So what we have now is space wastage on some architectures, space
savings on
>> some, but with no measurable performance benefit due to the
infrastructure
>> itself.  Why not push the infrastructure when we really need it, as
against
>> pushing it now when we are not sure if it benefits?
> 

>It makes sense from a theoretical POV and is pretty much a no-op in
terms
>of resource consumption.

>The problem with the wait-until-it-hurts approach is that by the time
>someone hurts from this and we find out about it, they may well be
using
>some year-old enterprise kernel and it's too late to fix it for them.

Yes, in theory, sharing shared percpu data with local percpu data in one
cache line can cause cache line contention between remote and local
access.
And this undesirable sharing does happen in current git.

On x86, without the patch, runqueue shares cacheline with cpu_domains.
c0633e80 d per_cpu__runqueues
c06347e0 d per_cpu__cpu_domains

Other architectures also have this undesired sharing. IA64 is an
example.

In future, this undesired sharing could happen with other data if we do 
not have a methodology to prevent it.

I just do not have data to show the performance hit for this sharing
now.

Thanks.

-Fenghua
