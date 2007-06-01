Return-Path: <linux-kernel-owner+w=401wt.eu-S1763791AbXFAU3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763791AbXFAU3Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 16:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762327AbXFAU3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 16:29:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57460 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762258AbXFAU3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 16:29:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Document the hotplug code is incompatible with x86 irq handling
Date: Fri, 1 Jun 2007 22:34:15 +0200
User-Agent: KMail/1.9.5
Cc: Robert Hancock <hancockr@shaw.ca>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Zwane Mwaikambo <zwane@linuxpower.ca>
References: <fa.tUMR7tAB+jMgtfyl/LJ7U9QMgBs@ifi.uio.no> <200705312212.34053.rjw@sisk.pl> <m1d50fzcaa.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1d50fzcaa.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706012234.16882.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 1 June 2007 21:48, Eric W. Biederman wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> >> Cool.
> >> 
> >> My patch does not change the functionality of the code just complains
> >> very loudly that it is broken.
> >> 
> >> Further the code is broken at a design level.  The code isn't
> >> problematic the code is impossible.  The cpu hotplug code can not be
> >> fixed on x86 without a redesign of the generic cpu hotplug code.
> >> 
> >> Suspend does not need to use cpu hotplug because it already gets in
> >> deep with the drivers, and can stop interrupts at the source.  I know
> >> there was some talk about this doing this earlier, but I don't know if
> >> anything came of that discussion.
> >> 
> >> Regardless if you care about this being a problem feel free to fix the
> >> relevant code so it attempts to do something that the hardware
> >> actually supports.
> >> 
> >> But if the suspend needs this code for smp support it is also broken.
> >
> > Well, from the functionality point of view, it's not.  We have no problems
> > with it, at least not that I know of.
> 
> Luck, or enough other issues someone hasn't tracked their problems
> down to this.  On the pure cpu hotplug path I just got a bug
> report about it not working:  http://lkml.org/lkml/2007/5/31/419

[Apart from what I said in the other message:]

In the hibernation/suspend code paths we call the CPU hotplug quite late,
actually right before we turn off local IRQs on the only CPU that is not
offlined.  I think that at this point the majority of interrupt sources should
have been turned off already.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
