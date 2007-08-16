Return-Path: <linux-kernel-owner+w=401wt.eu-S932319AbXHPVJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319AbXHPVJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 17:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757149AbXHPVI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 17:08:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:5403 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbXHPVIz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 17:08:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,273,1183359600"; 
   d="scan'208";a="282055688"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH 0/24] make atomic_read() behave consistently across all architectures
Date: Thu, 16 Aug 2007 14:08:52 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A02322189@scsmsx411.amr.corp.intel.com>
In-Reply-To: <46C4ABA5.9010804@redhat.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 0/24] make atomic_read() behave consistently across all architectures
Thread-Index: AcfgP+h4NE7tV3qERTCao/+FuEPZ8AACPhnA
References: <20070816003948.GY9645@linux.vnet.ibm.com> <Pine.LNX.4.64.0708151740570.10497@schroedinger.engr.sgi.com> <18115.44462.622801.683446@cargo.ozlabs.ibm.com> <20070816020042.GA30650@gondor.apana.org.au> <18115.45316.702491.681906@cargo.ozlabs.ibm.com> <alpine.LFD.0.999.0708160800130.24380@enigma.security.iitk.ac.in> <alpine.LFD.0.999.0708160815510.24380@enigma.security.iitk.ac.in> <18115.52863.638655.658466@cargo.ozlabs.ibm.com> <20070816053945.GB32442@gondor.apana.org.au> <18115.62741.807704.969977@cargo.ozlabs.ibm.com> <20070816070907.GA964@gondor.apana.org.au> <Pine.LNX.4.64.0708161743500.13267@kivilampi-30.cs.helsinki.fi> <46C4ABA5.9010804@redhat.com>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chris Snook" <csnook@redhat.com>,
       =?iso-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>,
       "Paul Mackerras" <paulus@samba.org>,
       "Satyam Sharma" <satyam@infradead.org>,
       "Christoph Lameter" <clameter@sgi.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       <linux-arch@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Netdev" <netdev@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, <ak@suse.de>,
       <heiko.carstens@de.ibm.com>, "David Miller" <davem@davemloft.net>,
       <schwidefsky@de.ibm.com>, <wensong@linux-vs.org>, <horms@verge.net.au>,
       <wjiang@resilience.com>, <cfriesen@nortel.com>, <zlynx@acm.org>,
       <rpjday@mindspring.com>, <jesper.juhl@gmail.com>,
       <segher@kernel.crashing.org>
X-OriginalArrivalTime: 16 Aug 2007 21:08:53.0078 (UTC) FILETIME=[A64F0760:01C7E049]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> 6674:   while (atomic_read(&j->DSPWrite) > 0)
>> 6675-           atomic_dec(&j->DSPWrite);
>
> If the maintainer of this code doesn't see a compelling reason to add 
> cpu_relax() in this loop, then it should be patched.

Shouldn't it be just re-written without the loop:

	if ((tmp = atomic_read(&j->DSPWrite)) > 0)
		atomic_sub(&j->DSPWrite, tmp);

Has all the same bugs, but runs much faster :-)

-Tony
