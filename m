Return-Path: <linux-kernel-owner+w=401wt.eu-S1751248AbZHSG7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751248AbZHSG7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 02:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751109AbZHSG7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 02:59:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:44856 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbZHSG7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 02:59:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,407,1246863600"; 
   d="scan'208";a="485144231"
Date: Wed, 19 Aug 2009 14:59:29 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86: Rendezvous all the cpu's for MTRR/PAT init
Message-ID: <20090819065929.GA21824@sli10-desk.sh.intel.com>
References: <1250641835.2744.56.camel@sbs-t61.sc.intel.com> <20090818180107.29d3f39b.akpm@linux-foundation.org> <1250662857.2615.42.camel@sbs-t61>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250662857.2615.42.camel@sbs-t61>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 02:20:57PM +0800, Siddha, Suresh B wrote:
> On Tue, 2009-08-18 at 18:01 -0700, Andrew Morton wrote:
> > On Tue, 18 Aug 2009 17:30:35 -0700 Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> > > +	/*
> > > +	 * Ideally we should hold mtrr_mutex here to avoid mtrr entries changed,
> > > +	 * but this routine will be called in cpu boot time, holding the lock
> > > +	 * breaks it. This routine is called in two cases: 1.very earily time
> > > +	 * of software resume, when there absolutely isn't mtrr entry changes;
> > > +	 * 2.cpu hotadd time. We let mtrr_add/del_page hold cpuhotplug lock to
> > > +	 * prevent mtrr entry changes
> > > +	 */
> > 
> > That's a tantalising little comment.  What does "breaks it" mean?  How
> > can reviewers and later code-readers possibly suggest alternative fixes
> > to this breakage if they aren't told what it is?
> 
> This is a cut and paste comment coming from the previous code. Shaohua
> added this comment originally and I think this is the case he is trying
> to avoid.
> 
> cpu - A modifying/adding a  MTRR register
> 
> cpu - B is coming online
> 
> if cpu - A doesn't take the cpu hotplug lock, then potentially what can
> happen is that cpu B will update its mtrr's with old state and now A can
> change the state and before B comes completely online, A can do send the
> MTRR update to all cpu's except B.
> 
> So Shaohua's code is taking cpu hotplug lock before A updates MTRR's so
> that B's MTRRs are always is in sync with rest of the cpu's in the
> system. Only the mtrr_mutex is not enough.
> 
> Nevertheless as far as this patch is concerned mtrr_aps_init() gets
> called during early boot/resume time and as such we never hit this
> condition. So I removed this comment in the new patch appended.
> 
> Shaohua if you agree with my explanation we can have a separate patch to
> make the original comment more meaningful.
Yes, your explanation is correct.

Thanks,
Shaohua
