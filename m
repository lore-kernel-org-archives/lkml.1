Return-Path: <linux-kernel-owner+w=401wt.eu-S932374AbXKOSsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374AbXKOSsb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 13:48:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759867AbXKOSsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 13:48:22 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:51022 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759356AbXKOSsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 13:48:22 -0500
Date: Thu, 15 Nov 2007 19:48:00 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] x86: revert X86_HT semantics change
Message-ID: <20071115184800.GT4250@stusta.de>
References: <20071115161703.GR4250@stusta.de> <20071115180436.GA23517@uranus.ravnborg.org> <alpine.LFD.0.9999.0711151904300.3112@localhost.localdomain> <20071115184255.GB23914@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071115184255.GB23914@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2007 at 07:42:55PM +0100, Sam Ravnborg wrote:
> On Thu, Nov 15, 2007 at 07:07:11PM +0100, Thomas Gleixner wrote:
> > On Thu, 15 Nov 2007, Sam Ravnborg wrote:
> > 
> > > On Thu, Nov 15, 2007 at 05:17:03PM +0100, Adrian Bunk wrote:
> > > > The x86 unification resulted in CONFIG_X86_HT no longer being
> > > > set if (X86_32 && MK8).
> > > Yup - my bad. I wrongly assumed MK8 was an X86_64 thing.
> > > 
> > > Thanks for fixing this.
> > > > 
> > > > After grep'ing through the tree I think the problem is that different 
> > > > places have different assumptions about the semantics of CONFIG_X86_HT,
> > > > either:
> > > > - hyperthreading or
> > > > - multicore
> > > > and the SCHED_SMT and SCHED_MC dependencies are just one of the 
> > > > symptoms.
> > > > 
> > > > This should be sorted out properly, but until then we should keep the 
> > > > 2.6.23 status quo.
> > > > 
> > > > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> > > Acked-by: Sam Ravnborg <sam@ravnborg.org>
> > > 
> > > I assume Thomas & Co will forward the patch.
> > 
> > After looking what does what and fixing it. 
> > 
> > Right now this patch is not a 1:1 replacement of the .23 status quo,
> > as it now makes SCHED_SMT and SCHED_HT depend on !MK8 for 64bit.
> 
> I assumed this was intentional - Adrian?

No, it was just buggy...

> 	Sam

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

