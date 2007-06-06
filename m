Return-Path: <linux-kernel-owner+w=401wt.eu-S934251AbXFFEbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934251AbXFFEbo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 00:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755345AbXFFEbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 00:31:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:58198 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755328AbXFFEbg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 00:31:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,387,1175497200"; 
   d="scan'208";a="251310965"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [RFC] Extend Linux to support proportional-share scheduling
Date: Tue, 5 Jun 2007 21:31:33 -0700
Message-ID: <5FD5754DDBA0B1499B5A0B4BB5419485013068A4@fmsmsx411.amr.corp.intel.com>
In-Reply-To: <20070606033330.GB3266@1wt.eu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC] Extend Linux to support proportional-share scheduling
Thread-Index: Acen65ASTX6DhX85Q2+viHQRL2lPQAABWQKw
From: "Li, Tong N" <tong.n.li@intel.com>
To: "Willy Tarreau" <w@1wt.eu>
Cc: <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Con Kolivas" <kernel@kolivas.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       "William Lee Irwin III" <wli@holomorphy.com>,
       "Bill Huey \(hui\)" <billh@gnuppy.monkey.org>, <vatsa@in.ibm.com>,
       <balbir@in.ibm.com>, "Nick Piggin" <npiggin@suse.de>,
       "Bill Davidsen" <davidsen@tmr.com>,
       "John Kingman" <kingman@storagegear.com>,
       "Peter Williams" <pwil3058@bigpond.net.au>, <seuler.shi@gmail.com>
X-OriginalArrivalTime: 06 Jun 2007 04:31:34.0652 (UTC) FILETIME=[907F93C0:01C7A7F3]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Willy,

These are all good comments. Regarding the cache penalty, I've done some
measurements using benchmarks like SPEC OMP on an 8-processor SMP and
the performance with this patch was nearly identical to that with the
mainline. I'm sure some apps may suffer from the potentially more
migrations with this design. In the end, I think what we want is to
balance fairness and performance. This design currently emphasizes on
fairness, but it could be changed to relax fairness when performance
does become an issue (which could even be a user-tunable knob depending
on which aspect the user cares more).

Thanks,

  tong

> -----Original Message-----
> From: Willy Tarreau [mailto:w@1wt.eu]
> Sent: Tuesday, June 05, 2007 8:33 PM
> To: Li, Tong N
> Cc: linux-kernel@vger.kernel.org; Ingo Molnar; Con Kolivas; Linus
Torvalds;
> Arjan van de Ven; Siddha, Suresh B; Barnes, Jesse; William Lee Irwin
III;
> Bill Huey (hui); vatsa@in.ibm.com; balbir@in.ibm.com; Nick Piggin;
Bill
> Davidsen; John Kingman; Peter Williams; seuler.shi@gmail.com
> Subject: Re: [RFC] Extend Linux to support proportional-share
scheduling
> 
> Hi Tong,
> 
> On Tue, Jun 05, 2007 at 06:56:17PM -0700, Li, Tong N wrote:
> > Hi all,
> >
> > I've ported my code to mainline 2.6.21.3. You can get it at
> > http://www.cs.duke.edu/~tongli/linux/.
> 
> as much as possible, you should post your patch for others to comment
> on it. Posting just a URL is often fine to inform people that there's
> an update to *try*, but at this stage, it may be more important to
> comment on your design and code than trying it.
> 
> [...]
> 
> > Trio has two unique features: (1) it enables users to control shares
of
> > CPU time for any thread or group of threads (e.g., a process, an
> > application, etc.), and (2) it enables fair sharing of CPU time
across
> > multiple CPUs. For example, with ten tasks running on eight CPUs,
Trio
> > allows each task to take an equal fraction of the total CPU time,
> 
> While this looks interesting, doesn't it make threads jump to random
> CPUs all the time, thus reducing cache efficiency ? Or maybe it would
> be good to consider two or three criteria to group CPUs :
>   - those which share the same caches (multi-core)
>   - those which share the same local memory on the same mainboard
>     (multi-socket)
>   - those which are so far away from each others that it's really
>     not worth migrating a task
> 
> > whereas no existing scheduler achieves such fairness. These features
> > enable Trio to complement the mainline scheduler and other proposals
> > such as CFS and SD to enable greater user flexibility and stronger
> > fairness.
> 
> Right now, I think that only benchmarks could tell which design is
> better. I understand that running 10 tasks on 8 CPUs may result in
> the last batch involving only 2 CPUs with 1 task each, thus increasing
> the overall wall time. But maybe cache thrashing between CPUs will
> also increase the wall time.
> 
> Regards,
> Willy
