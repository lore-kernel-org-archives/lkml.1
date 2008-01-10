Return-Path: <linux-kernel-owner+w=401wt.eu-S1758574AbYAJMr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758574AbYAJMr5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 07:47:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753175AbYAJMrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 07:47:49 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:53061 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851AbYAJMrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 07:47:49 -0500
Date: Thu, 10 Jan 2008 14:47:02 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andi Kleen <ak@suse.de>
Cc: rjw@sisk.pl, pavel@suse.cz, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH x86] [15/16] Force __cpuinit on for CONFIG_PM without
	HOTPLUG_CPU
Message-ID: <20080110124702.GF28740@does.not.exist>
References: <20080103442.621670000@suse.de> <20080110111514.GS25945@bingen.suse.de> <20080110112607.GE28740@does.not.exist> <200801101242.53504.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200801101242.53504.ak@suse.de>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 12:42:53PM +0100, Andi Kleen wrote:
> On Thursday 10 January 2008 12:26:07 Adrian Bunk wrote:
> > On Thu, Jan 10, 2008 at 12:15:15PM +0100, Andi Kleen wrote:
> > > > But your patch does:
> > > > 
> > > > +config PM_CPUINIT
> > > > +       bool
> > > > +       depends on PM
> > > 
> > > That is because arch/x86/power/cpu.c where this happens is currently
> > > 
> > > obj-$(CONFIG_PM)                += cpu.o
> > > 
> > > If it was changed to CONFIG_something else then yes that dependency
> > > should be changed too.
> > 
> > 
> > Then fix this first.
> 
> Rafael indicated he would do that, but it is really outside the scope
> of my patch. I was just interested in fixing a linker warning.

Your patch description doesn't mention any linker warning.

Can you send the linker warning so that we can see the problem and not 
only the patch you wrote for fixing the undisclosed problem?

> > And the following other points you didn't bother to reply to also still 
> > stand even after this fix:
> > - already __cpuinit code will waste memory with CONFIG_PM_SLEEP=y
> 
> Don't know what your point is. Anyways if you think there is a problem
> somewhere please feel free to write patches.

Technically you are the one who has to deal with problems in your 
patches, not the people pointing at the problems.

> > - change shouldn't be x86 specific
> 
> CPU initialization is deeply architecture specific. I don't see much use
> in generalizing that.

That the code is architecture specific is clear.

But how to best annotate suspend and CPU hotplug code is a problem that 
is shared between many architectures and whose solution should not be 
architecture specific.

> -Andi

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

