Return-Path: <linux-kernel-owner+w=401wt.eu-S1755785AbYGIWu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785AbYGIWu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 18:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbYGIWuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 18:50:21 -0400
Received: from old-tantale.fifi.org ([64.81.30.200]:38940 "EHLO
	old-tantale.fifi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbYGIWuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 18:50:21 -0400
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, macro@linux-mips.org
Subject: Re: 2.6.25.9: system clocks works normally then speeds up 4x...
References: <87d4lm2792.fsf@old-tantale.fifi.org>
	<1f1b08da0807091255s77033943t2b686ddb537ceaae@mail.gmail.com>
	<874p6y25es.fsf@old-tantale.fifi.org>
	<1215634125.6149.8.camel@localhost.localdomain>
	<87wsjuzsmr.fsf@old-tantale.fifi.org>
	<1215638499.6149.16.camel@localhost.localdomain>
Mail-Copies-To: nobody
From: Philippe Troin <phil@fifi.org>
Date: 09 Jul 2008 15:50:18 -0700
Message-ID: <87mykqzn85.fsf@old-tantale.fifi.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

john stultz <johnstul@us.ibm.com> writes:

> On Wed, 2008-07-09 at 13:53 -0700, Philippe Troin wrote:
> > john stultz <johnstul@us.ibm.com> writes:
> > 
> > > When you're seeing the issue, can you do the following:
> > >   cat /proc/interrupts > interrupts
> > > 
> > >   <wait 10 seconds by your wristwatch> 
> > > 
> > >   cat /proc/interrupts >> interrupts
> > > 
> > > And send the results?
> > 
> > There you are:
> > 
> >            CPU0       CPU1
> >   0:        353          0   IO-APIC-edge      timer
> > LOC:  546305845   33155722   Local timer interrupts
> > Roughly 10 seconds later:
> >   0:        353          0   IO-APIC-edge      timer
> > LOC:  546361653   33156517   Local timer interrupts
> 
> Huh. So that's a diff of:
> LOCdiff   55808        795  
> 
> So that's 55 seconds worth of ticks on cpu0 and not one on cpu1. So yea,
> something seems off with your timer interrupts.

On the still-wedged system, if I use 'tsc' as my clocksource (and the
time flows "normally", I still see the same kind of diff (same order
of magnitude).
 
> > > Could you also try booting with noapic to see if that changes anything?
> > 
> > Sure.  This will mean I will lose the "wedged" system.  Is there
> > anything else that needs to be checked on it before I lose the broken
> > state?
> > Also keep in mind that the symptoms take a while to manifest
> > themselves (a few days typically).
 
> I can't think of anything right off. But maybe we should give some
> others a chance to look.
> 
> I would like to see the same /proc/interrupt data when the system is
> properly functioning as well. So whenever you do reboot, that would be
> interesting to me.

So I just rebooted.

Now I see:

Wed Jul  9 15:47:59 PDT 2008: LOC:    2050354    2050438   Local timer
interrupts
Wed Jul  9 15:48:09 PDT 2008: LOC:    2060368    2060452   Local timer
interrupts

So about 10000 timer interrupts for 10 seconds, which sounds good with
HZ=1000.

I've rebooted without noapic, and I will monitor and log these numbers
and see how it goes.

I'm not sure noapic could help here as obviously the interrupts are
routed correctly, at least initially.

Phil.
