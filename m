Return-Path: <linux-kernel-owner+w=401wt.eu-S1758819AbXGPFDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758819AbXGPFDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 01:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbXGPFDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 01:03:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:56157 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbXGPFDG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 01:03:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,540,1175497200"; 
   d="scan'208";a="266653909"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Re: [ANNOUNCE][RFC] PlugSched-6.5.1 for  2.6.22
Date: Sun, 15 Jul 2007 22:03:02 -0700
Message-ID: <5FD5754DDBA0B1499B5A0B4BB54194850164B27C@fmsmsx411.amr.corp.intel.com>
In-Reply-To: <20070715234543.GN3565@stusta.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Re: [ANNOUNCE][RFC] PlugSched-6.5.1 for  2.6.22
Thread-Index: AcfHOlvXkbl099b0RKm1/xPcnr45qQAIC9Hw
From: "Li, Tong N" <tong.n.li@intel.com>
To: "Adrian Bunk" <bunk@stusta.de>
Cc: "Giuseppe Bilotta" <giuseppe.bilotta@gmail.com>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 16 Jul 2007 05:03:04.0411 (UTC) FILETIME=[9767EAB0:01C7C766]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Adrian Bunk [mailto:bunk@stusta.de]
> Sent: Sunday, July 15, 2007 4:46 PM
> To: Li, Tong N
> Cc: Giuseppe Bilotta; linux-kernel@vger.kernel.org
> Subject: Re: Re: [ANNOUNCE][RFC] PlugSched-6.5.1 for 2.6.22
> 
> On Sun, Jul 15, 2007 at 10:47:51AM -0700, Li, Tong N wrote:
> > > On Thursday 12 July 2007 00:17, Al Boldi wrote:
> > >
> > > > Peter Williams wrote:
> > > >>
> > > >> Probably the last one now that CFS is in the main line :-(.
> > > >
> > > > What do you mean?  A pluggable scheduler framework is
indispensible
> > even
> > > in
> > > > the presence of CFS or SD.
> > >
> > > Indeed, and I hope it gets merged, giving people the chance to
test
> > out
> > > different schedulers easily, without having to do patching,
> > de-patching,
> > > re-patching and blah blah blah.
> > >
> >
> > Yes, such a framework would be invaluable, especially given that
> > scheduling often has conflicting goals and different workloads have
> > different requirements. No single solution fits all.
> >...
> 
> Having a framework for giving people the choice between different
> solutions usually sounds good in theory, but in practice there's the
> often underestimated high price of people using a different solution
> instead of reporting a problem with one solution or people adding
> features to only one of the solutions resulting in different solutions
> having different features and bugs instead of one solution with all
> features and bug fixes.
> 
> So you should give a good technical explanation why it's not
technically
> possible or not desirable for one solution to work well for everyone.

There are various metrics a scheduler may want to optimize for, such as
throughput, response time, power consumption, fairness, and so on. Each
of these may also be defined differently in different environments. Take
fairness as an example. People have traditionally talked about it in
terms of CPU time. Now it'd also make sense to talk about scheduling
that enables fair usage of other types of resources, such as shared
caches. Different metrics may require different scheduling policies.
Plus, many metrics may in fact conflict, e.g., a scheduling policy
optimized for throughput may not be power efficient. As a result, Linux,
and all general-purpose OSes, strive to achieve a balance, but it's
conceivable that different hardware platforms and different application
workloads may want to have different scheduling policies to meet their
own needs.

Given that the scheduling policies can be diverse, the mechanisms to
enforce them can also be different. The per-cpu runqueue model may be
best for many scenarios, some scheduling policies (like many real-time
ones) might want global knowledge about all tasks in the system and thus
prefer a global task queue at the cost of being less scalable and
cache-efficient. HPC systems may also want to gang-schedule. And, in
terms of implementation, O(1) might be desirable for large-scale MP
systems while O(log N) might be good enough for small systems. These are
just examples that indicate the scheduler data structures, algorithms,
and implementation can have a variety of possibilities in different
usage models. A single scheduler that is easily extensible for
incorporating different policies would be ideal, but IMO this is not yet
the case and may not even be possible. Therefore, I think having a
framework that enables multiple schedulers to co-exist would be
invaluable and PlugSched seems to be one good step towards this.

  tong
