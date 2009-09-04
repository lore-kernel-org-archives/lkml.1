Return-Path: <linux-kernel-owner+w=401wt.eu-S1756705AbZIDJeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705AbZIDJeq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 05:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755770AbZIDJeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 05:34:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53726 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755740AbZIDJen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:34:43 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH 10/14] x86: generic aperf/mperf code.
Date: Fri, 4 Sep 2009 11:34:42 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.23-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Gautham R Shenoy <ego@in.ibm.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Balbir Singh <balbir@in.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>, Dave Jones <davej@redhat.com>,
       Len Brown <len.brown@intel.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       cpufreq@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
References: <20090903132145.482814810@chello.nl> <1252056311.7564.3.camel@twins> <1252056439.7564.4.camel@twins>
In-Reply-To: <1252056439.7564.4.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909041134.43452.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 September 2009 11:27:19 Peter Zijlstra wrote:
> On Fri, 2009-09-04 at 11:25 +0200, Peter Zijlstra wrote:
> > On Fri, 2009-09-04 at 11:19 +0200, Thomas Renninger wrote:
> > > You still use struct perf_pair split/hi/lo members in #ifdef 
__i386__ 
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
> Hrmm, on that, does it really make sense to maintain the i386 code
> path?
> 
> How frequently is that code called and what i386 only chips support
> aperf/mperf, atom?
Venki should know best.

   Thomas
