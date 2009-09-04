Return-Path: <linux-kernel-owner+w=401wt.eu-S1756893AbZIDOWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893AbZIDOWq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 10:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756847AbZIDOWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 10:22:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17870 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756835AbZIDOWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 10:22:42 -0400
Date: Fri, 4 Sep 2009 10:22:12 -0400
From: Dave Jones <davej@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Renninger <trenn@suse.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Gautham R Shenoy <ego@in.ibm.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Balbir Singh <balbir@in.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>, Len Brown <len.brown@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, cpufreq@vger.kernel.org
Subject: Re: [RFC][PATCH 10/14] x86: generic aperf/mperf code.
Message-ID: <20090904142212.GA3093@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Renninger <trenn@suse.de>, Ingo Molnar <mingo@elte.hu>,
	linux-kernel@vger.kernel.org, Gautham R Shenoy <ego@in.ibm.com>,
	Andreas Herrmann <andreas.herrmann3@amd.com>,
	Balbir Singh <balbir@in.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	Yanmin <yanmin_zhang@linux.intel.com>,
	Len Brown <len.brown@intel.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
	cpufreq@vger.kernel.org
References: <20090903132145.482814810@chello.nl> <20090903132213.006719409@chello.nl> <200909041119.06979.trenn@suse.de> <1252056311.7564.3.camel@twins> <1252056439.7564.4.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252056439.7564.4.camel@twins>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 04, 2009 at 11:27:19AM +0200, Peter Zijlstra wrote:
 > On Fri, 2009-09-04 at 11:25 +0200, Peter Zijlstra wrote:
 > > On Fri, 2009-09-04 at 11:19 +0200, Thomas Renninger wrote:
 > > > You still use struct perf_pair split/hi/lo members in #ifdef __i386__ 
 > > > case which you deleted above.
 > > 
 > > > >               shift_count = fls(h);
 > > > >  
 > > > > -             cur.aperf.whole >>= shift_count;
 > > > > -             cur.mperf.whole >>= shift_count;
 > > > > +             cur.aperf >>= shift_count;
 > > > > +             cur.mperf >>= shift_count;
 > > > >       }
 > > > >  
 > > > >       if (((unsigned long)(-1) / 100) < cur.aperf.split.lo) {
 > > > Same here, possibly still elsewhere.
 > > > Is this only x86_64 compile tested?
 > > 
 > > Of course, who still has 32bit only hardware anyway ;-)
 > > 
 > > Will fix, thanks for spotting that.
 > 
 > Hrmm, on that, does it really make sense to maintain the i386 code path?
 > 
 > How frequently is that code called and what i386 only chips support
 > aperf/mperf, atom?

any 64-bit cpu that supports it can have a 32bit kernel installed on it.
(and a significant number of users actually do this).

	Dave
