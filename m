Return-Path: <linux-kernel-owner+w=401wt.eu-S1422963AbXDXSBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422963AbXDXSBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 14:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422967AbXDXSBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 14:01:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:15876 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422941AbXDXSBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 14:01:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,448,1170662400"; 
   d="scan'208"; a="233193257:sNHT22236928"
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
From: "Li, Tong N" <tong.n.li@intel.com>
To: Bill Huey <billh@gnuppy.monkey.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       Juliusz Chroboczek <jch@pps.jussieu.fr>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Bill Davidsen <davidsen@tmr.com>, Willy Tarreau <w@1wt.eu>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
In-Reply-To: <20070424015737.GA20413@gnuppy.monkey.org>
References: <462D37D2.3060208@goop.org>
	 <5FD5754DDBA0B1499B5A0B4BB5419485F34BEB@fmsmsx411.amr.corp.intel.com>
	 <20070424015737.GA20413@gnuppy.monkey.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 24 Apr 2007 11:01:39 -0700
Message-Id: <1177437699.3168.65.camel@tongli.jf.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
X-OriginalArrivalTime: 24 Apr 2007 18:01:40.0742 (UTC) FILETIME=[9C391260:01C7869A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-23 at 18:57 -0700, Bill Huey wrote: 
> On Mon, Apr 23, 2007 at 05:59:06PM -0700, Li, Tong N wrote:
> > I don't know if we've discussed this or not. Since both CFS and SD claim
> > to be fair, I'd like to hear more opinions on the fairness aspect of
> > these designs. In areas such as OS, networking, and real-time, fairness,
> > and its more general form, proportional fairness, are well-defined
> > terms. In fact, perfect fairness is not feasible since it requires all
> > runnable threads to be running simultaneously and scheduled with
> > infinitesimally small quanta (like a fluid system). So to evaluate if a
> 
> Unfortunately, fairness is rather non-formal in this context and probably
> isn't strictly desirable given how hack much of Linux userspace is. Until
> there's a method of doing directed yields, like what Will has prescribed
> a kind of allotment to thread doing work for another a completely strict
> mechanism, it is probably problematic with regards to corner cases.
> 
> X for example is largely non-thread safe. Until they can get their xcb
> framework in place and addition thread infrastructure to do hand off
> properly, it's going to be difficult schedule for it. It's well known to
> be problematic.

I agree. I just think calling the designs "perfectly" or "completely"
fair is too strong. It might cause unnecessary confusion that
overshadows the actual merits of these designs. If we were to evaluate
specifically the fairness aspect of a design, then I'd suggest defining
it more formally.

> You announced your scheduler without CCing any of the relevant people here
> (and risk being completely ignored in lkml traffic):
> 
> 	http://lkml.org/lkml/2007/4/20/286
> 
> What is your opinion of both CFS and SDL ? How can you work be useful
> to either scheduler mentioned or to the Linux kernel on its own ?

I like SD for its simplicity. My concern with CFS is the RB tree
structure. Log(n) seems high to me given the fact that we had an O(1)
scheduler. Many algorithms achieve strong fairness guarantees at the
cost of log(n) time. Thus, I tend to think, if log(n) is acceptable, we
might want also to look at other algorithms (e.g., start-time first)
with better fairness properties and see if they could be extended to be
general purpose.

> > I understand that via experiments we can show a design is reasonably
> > fair in the common case, but IMHO, to claim that a design is fair, there
> > needs to be some kind of formal analysis on the fairness bound, and this
> > bound should be proven to be constant. Even if the bound is not
> > constant, at least this analysis can help us better understand and
> > predict the degree of fairness that users would experience (e.g., would
> > the system be less fair if the number of threads increases? What happens
> > if a large number of threads dynamically join and leave the system?).
> 
> Will has been thinking about this, but you have to also consider the
> practicalities of your approach versus Con's and Ingo's.

I consider my work an approach to extend an existing scheduler to
support proportional fairness. I see many proportional-share designs are
lacking things such as good interactive support that Linux does well.
This is why I designed it on top of the existing scheduler so that it
can leverage things such as dynamic priorities. Regardless of the
underlying scheduler, SD or CFS, I think the algorithm I used would
still apply and thus we can extend the scheduler similarly.

> I'm all for things like proportional scheduling and the extensions
> needed to do it properly. It would be highly relevant to some version
> of the -rt patch if not that patch directly.

I'd love it to be considered for part of the -rt patch. I'm new to 
this, so would you please let me know what to do?

Thanks,

  tong
