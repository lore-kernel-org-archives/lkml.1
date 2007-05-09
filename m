Return-Path: <linux-kernel-owner+w=401wt.eu-S1760043AbXEIXKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760043AbXEIXKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 19:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754858AbXEIXKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 19:10:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:54322 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbXEIXKH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 19:10:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,512,1170662400"; 
   d="scan'208";a="243993436"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2/2] Call percpu smp cacheline algin interface
Date: Wed, 9 May 2007 16:10:05 -0700
Message-ID: <A29F7A5700A7EA4380E08C1F68C3B6D802B5F7CA@scsmsx411.amr.corp.intel.com>
In-Reply-To: <Pine.LNX.4.64.0705091556260.1221@schroedinger.engr.sgi.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/2] Call percpu smp cacheline algin interface
Thread-Index: AceSjVmj3EyvZt+UR0O5WRl7LLieXQAAH1YA
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "Christoph Lameter" <clameter@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
CC: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 09 May 2007 23:10:06.0227 (UTC) FILETIME=[2E8C3E30:01C7928F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 9 May 2007, Andrew Morton wrote:

>> erm, it's not obviosu from all this that the patches are worth
proceeding
>> with, are they?

>What was it? 0.5% performance improvement on a synthetic benchmark? 
>Process wakeup I believe?

The initial patch and discussion is from:
http://www.uwsg.iu.edu/hypermail/linux/kernel/0704.1/0340.html

Yes, the runqueue patch has a 0.5% perf improvement on database
workload(which is a good improvement for this workload).

The theory behind the patches is:

1. Minimize number of cache lines that are touched during a remote
access. On Numa system, remote access is more expensive than local.
2. Do not share cache line between remote accessed data and local
accessed data. Local data update may cause remote access cache miss and
wait for longer time.

Although the patches themselves don't save or waste per_cpu size, the
above two reasons are good to have them in.

Thanks.

-Fenghua
