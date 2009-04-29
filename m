Return-Path: <linux-kernel-owner+w=401wt.eu-S1753205AbZD2Q0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbZD2Q0M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 12:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239AbZD2QZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 12:25:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:55200 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbZD2QZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 12:25:56 -0400
Subject: Re: Mainline kernel OLTP performance update
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Styner, Douglas W" <douglas.w.styner@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Tripathi, Sharad C" <sharad.c.tripathi@intel.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Ma, Chinang" <chinang.ma@intel.com>,
       "Wang, Peter Xihong" <peter.xihong.wang@intel.com>,
       "Nueckel, Hubert" <hubert.nueckel@intel.com>,
       "Recalde, Luis F" <luis.f.recalde@intel.com>,
       "Nelson, Doug" <doug.nelson@intel.com>,
       "Cheng, Wu-sun" <wu-sun.cheng@intel.com>,
       "Prickett, Terry O" <terry.o.prickett@intel.com>,
       "Shunmuganathan, Rajalakshmi" <rajalakshmi.shunmuganathan@intel.com>,
       "Garg, Anil K" <anil.k.garg@intel.com>,
       "Chilukuri, Harita" <harita.chilukuri@intel.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20090429090706.bc5f462f.akpm@linux-foundation.org>
References: <D7C42C27E6CB1E4D8CBDF2F81EA92A2603459F3D6A@azsmsx501.amr.corp.intel.com>
	 <20090429002930.b786348b.akpm@linux-foundation.org>
	 <D7C42C27E6CB1E4D8CBDF2F81EA92A260345A63F45@azsmsx501.amr.corp.intel.com>
	 <20090429090706.bc5f462f.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 29 Apr 2009 18:25:36 +0200
Message-Id: <1241022336.8021.573.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-29 at 09:07 -0700, Andrew Morton wrote:
> On Wed, 29 Apr 2009 08:48:19 -0700 "Styner, Douglas W" <douglas.w.styner@intel.com> wrote:
> 
> > >-----Original Message-----
> > >From: Andrew Morton [mailto:akpm@linux-foundation.org]
> > >Sent: Wednesday, April 29, 2009 12:30 AM
> > >To: Styner, Douglas W
> > >Cc: linux-kernel@vger.kernel.org; Tripathi, Sharad C;
> > >arjan@linux.intel.com; Wilcox, Matthew R; Kleen, Andi; Siddha, Suresh B;
> > >Ma, Chinang; Wang, Peter Xihong; Nueckel, Hubert; Recalde, Luis F; Nelson,
> > >Doug; Cheng, Wu-sun; Prickett, Terry O; Shunmuganathan, Rajalakshmi; Garg,
> > >Anil K; Chilukuri, Harita; chris.mason@oracle.com
> > >Subject: Re: Mainline kernel OLTP performance update
> > >
> > >On Tue, 28 Apr 2009 10:08:22 -0700 "Styner, Douglas W"
> > ><douglas.w.styner@intel.com> wrote:
> > >
> > >> Summary: Measured the mainline kernel from kernel.org (2.6.30-rc3).
> > >>
> > >> The regression for 2.6.30-rc3 against the baseline, 2.6.24.2 is 1.91%.
> > >Oprofile reports 71.1626% user, 28.8295% system.
> > >>
> > >> Linux OLTP Performance summary
> > >> Kernel#            Speedup(x)   Intr/s  CtxSw/s us%     sys%    idle%
> > >iowait%
> > >> 2.6.24.2                1.000   22106   43709   75      24      0       0
> > >> 2.6.30-rc3              0.981   30645   43027   75      25      0       0
> > >
> > >The main difference there is the interrupt frequency.  Do we know which
> > >interrupt source(s) caused this?
> >
> > Our analysis of the interrupts shows that rescheduling interrupts are
> > up 2.2x from 2.6.24.2 --> 2.6.30-rc3.  Qla2xxx interrupts are roughly
> > the same.
> 
> (top-posting repaired)
> 
> OK, thanks.  Seems odd that the rescheduling interrupt rate increased
> while the context-switch rate actually fell a couple of percent.
> 
> This came up a few weeks ago and iirc Peter was mainly involved, and I
> don't believe that anything conclusive ended up happening.  Peter,
> could you please remind us of (and summarise) the story here?

I've had several reports about the resched-ipi going in overdrive, but
nobody bothered to bisect it, nor have I yet done so -- no clear ideas
on why it is doing so.

I'll put it somewhere higher on the todo list.

