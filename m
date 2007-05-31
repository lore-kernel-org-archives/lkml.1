Return-Path: <linux-kernel-owner+w=401wt.eu-S1762108AbXEaUHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762108AbXEaUHU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 16:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753593AbXEaUHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 16:07:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49885 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbXEaUHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 16:07:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Document the hotplug code is incompatible with x86 irq handling
Date: Thu, 31 May 2007 22:12:33 +0200
User-Agent: KMail/1.9.5
Cc: Robert Hancock <hancockr@shaw.ca>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Zwane Mwaikambo <zwane@linuxpower.ca>
References: <fa.tUMR7tAB+jMgtfyl/LJ7U9QMgBs@ifi.uio.no> <465EDCF4.7010700@shaw.ca> <m1abvl3shh.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1abvl3shh.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705312212.34053.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 31 May 2007 17:47, Eric W. Biederman wrote:
> Robert Hancock <hancockr@shaw.ca> writes:
> 
> > Eric W. Biederman wrote:
> >> I just realized that except for doing the code review and noticing
> >> that the current cpu hotplug code is fundamentally incompatible
> >> with x86 I haven't done anything about it.  So here is my patch
> >> to document what is wrong.
> >>
> >> The current cpu hotplug code requires irqs to be migrated from a cpu
> >> outside of irq context.  On x86 ioapics simply do not support this,
> >> making the code unfixable without major redesign of the generic cpu
> >> hotplug code.
> >>
> >> So this patch makes CPU_HOTPLUG on x86 depend on CONFIG_BROKEN
> >> and adds a WARN_ON so people that do enable it are not in doubt about
> >> which part of the code is broken, even if it does work for them.
> >>
> >> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> >
> > I don't think this is useful, though the code may be problematic, this patch
> > will break suspend on all SMP machines with an existing config, which is a major
> > regression..
> 
> 
> Cool.
> 
> My patch does not change the functionality of the code just complains
> very loudly that it is broken.
> 
> Further the code is broken at a design level.  The code isn't
> problematic the code is impossible.  The cpu hotplug code can not be
> fixed on x86 without a redesign of the generic cpu hotplug code.
> 
> Suspend does not need to use cpu hotplug because it already gets in
> deep with the drivers, and can stop interrupts at the source.  I know
> there was some talk about this doing this earlier, but I don't know if
> anything came of that discussion.
> 
> Regardless if you care about this being a problem feel free to fix the
> relevant code so it attempts to do something that the hardware
> actually supports.
> 
> But if the suspend needs this code for smp support it is also broken.

Well, from the functionality point of view, it's not.  We have no problems
with it, at least not that I know of.

Greetings,
Rafael
