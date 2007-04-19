Return-Path: <linux-kernel-owner+w=401wt.eu-S1766896AbXDSR2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766896AbXDSR2u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 13:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766895AbXDSR2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 13:28:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:41164 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766890AbXDSR2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 13:28:46 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: [PATCH][RFC] Kill off legacy power management stuff.
Date: Thu, 19 Apr 2007 13:27:17 -0400
User-Agent: KMail/1.9.5
Cc: Dave Jones <davej@redhat.com>, davej@codemonkey.org.uk,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0704122025380.3628@CPE00045a9c397f-CM001225dbafb6> <20070418235806.GD20204@redhat.com> <Pine.LNX.4.64.0704182028320.5826@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0704182028320.5826@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704191327.17500.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 April 2007 20:35, Robert P. J. Day wrote:
> On Wed, 18 Apr 2007, Dave Jones wrote:
> 
> > On Wed, Apr 18, 2007 at 05:23:15PM -0400, Len Brown wrote:
> >
> >  > > p.p.s.  patch improvements that will let me avoid doing any of that
> >  > > myself always welcome. :-)
> >  >
> >  > well, I'm sorry that I've known about the APM issue for a long time
> >  > and done nothing about it.  I did ping davej when he broke it,
> >  > but his to-do list is probably even longer than mine.
> >
> > ping timeout.
> >
> > I don't recall too many of the details surrounding those changes,
> > but I certainly won't stand in the way of anyone trying to fix it.
> > It sounds like you and Robert are on top of it, or do you want me to
> > poke at it ?
> 
> well, before i get even more confused by what was (once upon a time) a
> fairly straightforward removal patch, the first obvious question is --
> are there *any* circumstances that *require* a config selection of
> CONFIG_PM_LEGACY, as opposed to a selection of APM and/or ACPI?  if
> there are, then it can't simply be removed.  my original patch
> submission was based on the assumption that absolutely no one needed
> the legacy stuff anymore and absolutely everything related to it could
> be scrapped.
> 
> so, first things first:  what *needs* legacy PM at the moment?
> 
> rday
> 
> p.s.  i'm confused by the header file include/linux/pm_legacy.h,
> especially this part:
> 
> ========================
> #ifdef CONFIG_PM_LEGACY
> ...
> # else /* CONFIG_PM_LEGACY */
> 
> #define PM_IS_ACTIVE() 0
> ...
> #endif
> =======================
> 
>   so the macro "PM_IS_ACTIVE()" represents whether *legacy* PM has
> been selected.  in other words, it makes no (apparent) sense that the
> value of that macro would represent some kind of contention mechanism
> between APM and ACPI, which is entirely independent from the legacy
> stuff.  right?


yep, the problem is that PM_IS_ACTIVE() got mixed up in CONFIG_PM_LEGACY.
how about i send a patch to fix this first -- when i get back tomorrow.
and then the CONFIG_PM_LEGACY patch will not be tangled in this?

-Len

