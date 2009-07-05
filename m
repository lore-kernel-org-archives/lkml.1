Return-Path: <linux-kernel-owner+w=401wt.eu-S1754921AbZGEU1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbZGEU1S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 16:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753190AbZGEU1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 16:27:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47127 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992AbZGEU1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 16:27:07 -0400
Date: Sun, 5 Jul 2009 22:26:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Joseph Cihula <joseph.cihula@intel.com>, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, hpa@zytor.com, andi@firstfloor.org,
       chrisw@sous-sol.org, jmorris@namei.org, jbeulich@novell.com,
       peterm@redhat.com, gang.wei@intel.com, shane.wang@intel.com
Subject: Re: [RFC v6][PATCH 4/4] intel_txt: force IOMMU on for Intel(R) TXT
	launch
Message-ID: <20090705202646.GA4330@elte.hu>
References: <4A4ACA6E.6080702@intel.com> <20090702213013.GC1419@ucw.cz> <20090703082111.GD21833@elte.hu> <20090705202316.GH17910@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090705202316.GH17910@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@ucw.cz> wrote:

> On Fri 2009-07-03 10:21:11, Ingo Molnar wrote:
> > 
> > * Pavel Machek <pavel@ucw.cz> wrote:
> > 
> > > 
> > > On Tue 2009-06-30 19:31:10, Joseph Cihula wrote:
> > > > The tboot module will DMA protect all of memory in order to ensure the that
> > > > kernel will be able to initialize without compromise (from DMA).  Consequently,
> > > > the kernel must enable Intel(R) Virtualization Technology for Directed I/O
> > > > (VT-d or Intel IOMMU) in order to replace this broad protection with the
> > > > appropriate page-granular protection.  Otherwise DMA devices will be unable
> > > > to read or write from memory and the kernel will eventually panic.
> > > > 
> > > > Because runtime IOMMU support is configurable by command line options, this
> > > > patch will force it to be enabled regardless of the options specified, and will
> > > > log a message if it was required to force it on.
> > > > 
> > > > 
> > > >  dmar.c        |    7 +++++++
> > > >  intel-iommu.c |   17 +++++++++++++++--
> > > >  2 files changed, 22 insertions(+), 2 deletions(-)
> > > > 
> > > > Signed-off-by: Joseph Cihula <joseph.cihula@intel.com>
> > > > Signed-off-by: Shane Wang <shane.wang@intel.com>
> > > 
> > > NAK. Breaks user expectations, misses docs updates.
> > 
> > What's your proposed solution? If an incompatible IOMMU option 
> > is specified should the kernel to disable TXT and panic?
> 
> Yes.
> 
> ...and whether we decide one way or another, it needs to be 
> documented.a

But the user already specified another thing as well: that we should 
boot with TXT.

So we have conflicting user options. Wouldnt it be the proper 
engineering solution to print a warning about the incompatible IOMMU 
option and disable it, but not crash the bootup? We generally prefer 
to boot up.

Anyway, this is a small detail clearly.

	Ingo
