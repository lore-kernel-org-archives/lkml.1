Return-Path: <linux-kernel-owner+w=401wt.eu-S1756222AbYGIUJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222AbYGIUJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087AbYGIUIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:08:52 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:50315 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbYGIUIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:08:51 -0400
Subject: Re: 2.6.25.9: system clocks works normally then speeds up 4x...
From: john stultz <johnstul@us.ibm.com>
To: Philippe Troin <phil@fifi.org>
Cc: linux-kernel@vger.kernel.org, macro@linux-mips.org
In-Reply-To: <874p6y25es.fsf@old-tantale.fifi.org>
References: <87d4lm2792.fsf@old-tantale.fifi.org>
	 <1f1b08da0807091255s77033943t2b686ddb537ceaae@mail.gmail.com>
	 <874p6y25es.fsf@old-tantale.fifi.org>
Content-Type: text/plain
Date: Wed, 09 Jul 2008 13:08:45 -0700
Message-Id: <1215634125.6149.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-07-09 at 13:01 -0700, Philippe Troin wrote:
> "john stultz" <johnstul@us.ibm.com> writes:
> 
> > On Wed, Jul 9, 2008 at 12:21 PM, Philippe Troin <phil@fifi.org> wrote:
> > >
> > > Symptoms:
> > >
> > >  The system boots fine. Clock seems to run normally.
> > >
> > >  Then after a random amount of time (on the current boot, 3 days),
> > >  clock starts to be running 2-4x faster (on the current boot, 4x).
> > >
> > >  I have tried booting with "nohz=off highres=off" but it does not
> > >  help.
> > 
> > Could you provide the output from the following:
> >    sudo cat /sys/devices/system/clocksource/clocksource0/*
> 
> Sure.
> 
> It is:
> available: jiffies tsc 
> current:   jiffies
> 
> > Did this issue occur with 2.6.24 or earlier kernels?
> 
> No.  It started with 2.6.25.
> 
> Interestingly:
> 
>   I've just modified the current clocksource to tsc and the clock went
>   back to its normal speed.
> 
>   Then I reset the current clocksource to jiffies, and the clock went
>   back to its (wrong) 4x speed.
> 
> So it looks like the kernel is counting jiffies 4x too fast.

When you're seeing the issue, can you do the following:
  cat /proc/interrupts > interrupts

  <wait 10 seconds by your wristwatch> 

  cat /proc/interrupts >> interrupts

And send the results?

Could you also try booting with noapic to see if that changes anything?

Maciej: Does this sound related to the recent APIC setup changes?

thanks
-john

