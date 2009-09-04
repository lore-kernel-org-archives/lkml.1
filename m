Return-Path: <linux-kernel-owner+w=401wt.eu-S933334AbZIDJ1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933334AbZIDJ1g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 05:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933306AbZIDJ1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 05:27:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:48555 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933301AbZIDJ1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:27:34 -0400
Subject: Re: [RFC][PATCH 10/14] x86: generic aperf/mperf code.
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Renninger <trenn@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Gautham R Shenoy <ego@in.ibm.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Balbir Singh <balbir@in.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>, Dave Jones <davej@redhat.com>,
       Len Brown <len.brown@intel.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       cpufreq@vger.kernel.org
In-Reply-To: <1252056311.7564.3.camel@twins>
References: <20090903132145.482814810@chello.nl>
	 <20090903132213.006719409@chello.nl>  <200909041119.06979.trenn@suse.de>
	 <1252056311.7564.3.camel@twins>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 04 Sep 2009 11:27:19 +0200
Message-Id: <1252056439.7564.4.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-04 at 11:25 +0200, Peter Zijlstra wrote:
> On Fri, 2009-09-04 at 11:19 +0200, Thomas Renninger wrote:
> > You still use struct perf_pair split/hi/lo members in #ifdef __i386__ 
> > case which you deleted above.
> 
> > >               shift_count = fls(h);
> > >  
> > > -             cur.aperf.whole >>= shift_count;
> > > -             cur.mperf.whole >>= shift_count;
> > > +             cur.aperf >>= shift_count;
> > > +             cur.mperf >>= shift_count;
> > >       }
> > >  
> > >       if (((unsigned long)(-1) / 100) < cur.aperf.split.lo) {
> > Same here, possibly still elsewhere.
> > Is this only x86_64 compile tested?
> 
> Of course, who still has 32bit only hardware anyway ;-)
> 
> Will fix, thanks for spotting that.

Hrmm, on that, does it really make sense to maintain the i386 code path?

How frequently is that code called and what i386 only chips support
aperf/mperf, atom?
