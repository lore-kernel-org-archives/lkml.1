Return-Path: <linux-kernel-owner+w=401wt.eu-S1764076AbZCYRkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764076AbZCYRkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 13:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764008AbZCYRkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 13:40:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50027 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763929AbZCYRkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 13:40:09 -0400
Date: Wed, 25 Mar 2009 18:38:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: mark gross <mgross@linux.intel.com>
Cc: Andrew Lutomirski <amluto@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kyle McMartin <kyle@redhat.com>, Fenghua Yu <fenghua.yu@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yinghai@kernel.org>,
       David Woodhouse <David.Woodhouse@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.29: can't resume from suspend with DMAR (intel iommu)
	enabled
Message-ID: <20090325173850.GD14250@elte.hu>
References: <cb0375e10903241258x32c9d0f3g35a4f56793eb8677@mail.gmail.com> <20090324203259.GC26930@elte.hu> <20090325173212.GA30701@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325173212.GA30701@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* mark gross <mgross@linux.intel.com> wrote:

> On Tue, Mar 24, 2009 at 09:32:59PM +0100, Ingo Molnar wrote:
> > 
> > (Cc:s added)
> > 
> > * Andrew Lutomirski <amluto@gmail.com> wrote:
> > 
> > > On vanilla 2.6.29 (on Ubuntu 8.10), on a Lenovo x200s, my system 
> > > is completely hosed on resume.  It appears that even hard disk IO 
> > > didn't work (trying to do *anything* including getting a dmesg 
> > > trace just spewed sda io errors to the console).  Hence no trace.  
> > > I did an alt-sysrq-b and the screen went blank and the machine 
> > > just started beeping at me.
> > > 
> > > Resume works much better with intel_iommu=off.  (I remember seeing 
> > > a patch go by that purported to fix resume with IOMMU enabled, but 
> > > it didn't work for me.)
> > > 
> > > I'd be happy to try to make a better bug report if anyone has any 
> > > bright ideas.
> > 
> > i have a Lenovo T500 that does not even boot with with DMAR enabled 
> > in the BIOS (it's default-off), i get this panic in early bootup:
> > 
> >     DMAR hardware is malfunctioning
> 
> That happens when the polling of the IOMMU registers fail to 
> behave as expected in the VT-d specification.  Typically its been 
> a bios issue when this happens.

it's hugely problematic to panic() the box early during bootup. 
IOMMU code should be disabled instead, a warning emitted - and life 
should continue.

With the current method you only ensure that distros turn DMAR 
support off and that users disable it in their BIOS. That's a double 
disadvantage.

	Ingo
