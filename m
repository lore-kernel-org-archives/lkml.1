Return-Path: <linux-kernel-owner+w=401wt.eu-S932462AbZIDOmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932462AbZIDOmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 10:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756896AbZIDOmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 10:42:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59556 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756879AbZIDOmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 10:42:19 -0400
Subject: Re: [RFC][PATCH 10/14] x86: generic aperf/mperf code.
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Jones <davej@redhat.com>
Cc: Thomas Renninger <trenn@suse.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Gautham R Shenoy <ego@in.ibm.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Balbir Singh <balbir@in.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>, Len Brown <len.brown@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, cpufreq@vger.kernel.org
In-Reply-To: <20090904142212.GA3093@redhat.com>
References: <20090903132145.482814810@chello.nl>
	 <20090903132213.006719409@chello.nl> <200909041119.06979.trenn@suse.de>
	 <1252056311.7564.3.camel@twins> <1252056439.7564.4.camel@twins>
	 <20090904142212.GA3093@redhat.com>
Content-Type: text/plain
Date: Fri, 04 Sep 2009 16:42:07 +0200
Message-Id: <1252075327.8976.3.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-04 at 10:22 -0400, Dave Jones wrote:
> On Fri, Sep 04, 2009 at 11:27:19AM +0200, Peter Zijlstra wrote:
>  > On Fri, 2009-09-04 at 11:25 +0200, Peter Zijlstra wrote:
>  > > On Fri, 2009-09-04 at 11:19 +0200, Thomas Renninger wrote:
>  > > > You still use struct perf_pair split/hi/lo members in #ifdef __i386__ 
>  > > > case which you deleted above.
>  > > 
>  > > > >               shift_count = fls(h);
>  > > > >  
>  > > > > -             cur.aperf.whole >>= shift_count;
>  > > > > -             cur.mperf.whole >>= shift_count;
>  > > > > +             cur.aperf >>= shift_count;
>  > > > > +             cur.mperf >>= shift_count;
>  > > > >       }
>  > > > >  
>  > > > >       if (((unsigned long)(-1) / 100) < cur.aperf.split.lo) {
>  > > > Same here, possibly still elsewhere.
>  > > > Is this only x86_64 compile tested?
>  > > 
>  > > Of course, who still has 32bit only hardware anyway ;-)
>  > > 
>  > > Will fix, thanks for spotting that.
>  > 
>  > Hrmm, on that, does it really make sense to maintain the i386 code path?
>  > 
>  > How frequently is that code called and what i386 only chips support
>  > aperf/mperf, atom?
> 
> any 64-bit cpu that supports it can have a 32bit kernel installed on it.
> (and a significant number of users actually do this).

1) we really should be pushing those people to run 64bit kernels

[ I'm still hoping distros will start shipping 64bit kernels and have
  the bootloader pick the 64bit one when the hardware supports lm ]

2) those cpus aren't real bad at 64bit divisions :-)

