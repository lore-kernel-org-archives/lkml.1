Return-Path: <linux-kernel-owner+w=401wt.eu-S1751819AbZG3Pmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819AbZG3Pmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 11:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbZG3Pmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 11:42:54 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:46906 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbZG3Pmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 11:42:53 -0400
Date: Thu, 30 Jul 2009 17:42:51 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: dwalker@fifo99.com
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>
Subject: Re: [RFC][patch 00/12] clocksource / timekeeping rework V2
Message-ID: <20090730174251.3e175c40@skybase>
In-Reply-To: <200907301349.n6UDnCpx008890@d06av06.portsmouth.uk.ibm.com>
References: <200907301349.n6UDnCpx008890@d06av06.portsmouth.uk.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jul 2009 07:49:12 -0600
dwalker@fifo99.com wrote:

> On Thu, 2009-07-30 at 15:04 +0200, Martin Schwidefsky wrote:
> > On Thu, 30 Jul 2009 05:49:33 -0700
> > Daniel Walker <dwalker@fifo99.com> wrote:
> > 
> > > On Thu, 2009-07-30 at 12:53 +0200, Martin Schwidefsky wrote:
> > > 
> > > > > I'm not sure allowing that type of override a good idea tho .. I don't
> > > > > think it's considered a usable clock when the rating goes to zero.
> > > > 
> > > > Override as the root user -> your foot, no? The whole override stuff is
> > > > there for the case that the clocksource selection picked a broken clock
> > > > and you want to force the system into a semi-working state. Ideally the
> > > > whole override would go away, but that is probably wishful thinking..
> > > 
> > > I would agree if the system doesn't crash as a result, if it just starts
> > > to operate funny then that's maybe acceptable. If you keep the change
> > > rating function, you could potentially remove the unregister path..
> > 
> > Why shouldn't it be possible to have a clocksource as a module? I think
> > that the unregister path should stay. To really make it work we'd need
> > a function to force the system out of the one-shot mode though.
> 
> Because I don't think there is a sane reason to allow it. It should be
> more like if someone has a need for it, then let them add back the
> unregister path and explain why they need it.

I hear your. Without the need to unregister a clock the whole watchdog
unregistration can be dropped as well before it ever has been added.

There are currently two clocksources that use clocksource_unregister,
the pit clock and the sgi_rtc clock. The sgi_rtc clock in
arch/x86/kernel/uv_time.c could be modified slightly to avoid the
clocksource_unregister call. The pit clock in arch/x86/kernel/i8253.c
is odd, it uses clocksource_unregister in the set_mode callback if the
mode is set to SHUTDOWN, UNUSED or ONESHOT. Very strange..

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

