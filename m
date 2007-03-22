Return-Path: <linux-kernel-owner+w=401wt.eu-S932953AbXCVOQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932953AbXCVOQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 10:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932929AbXCVOQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 10:16:28 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:37994 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932879AbXCVOQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 10:16:27 -0400
Date: Thu, 22 Mar 2007 15:16:30 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ray Lee <ray-lk@madrabbit.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
       Len Brown <len.brown@intel.com>, Andi Kleen <ak@suse.de>,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.21-rc[123] regression with NOAPIC
Message-ID: <20070322141630.GA752@stusta.de>
References: <4601573A.8070602@madrabbit.org> <20070322134238.GY752@stusta.de> <1174572603.10840.162.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1174572603.10840.162.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2007 at 03:10:03PM +0100, Thomas Gleixner wrote:
> On Thu, 2007-03-22 at 14:42 +0100, Adrian Bunk wrote:
> > > Starting with head as of yesterday and reverting two commits (that are
> > > duplicates of each other -- the same commit came into Linus's tree via
> > > two different paths) 'fixes' the problem for me. I'll let those with the
> > > big brains decide just why.
> > > 
> > > The two commits are 5c95d3f5783ab184f64b7848f0a871352c35c3cf and
> > > 3434933b17fa64adddf83059603c61296f6e1ee2 . The net reverse diff of those
> > > two is below.
> > >...
> > 
> > Thanks for tracking it down.
> > 
> > It's quite possible that these commits trigger your problem.
> > 
> > Does it work if you do _not_ revert the commits, and instead replace in
> > drivers/acpi/processor_idle.c the
> >   #ifdef ARCH_APICTIMER_STOPS_ON_C3
> > with an
> >   #if 0
> > ?
> 
> Then NOAPIC probably works again, but booting w/o NOAPIC fails.

But we'll know that it's this code that has a problen with noapic
in the CONFIG_GENERIC_CLOCKEVENTS=n case.

> 	tglx

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

