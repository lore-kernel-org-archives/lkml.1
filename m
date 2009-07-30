Return-Path: <linux-kernel-owner+w=401wt.eu-S1751912AbZG3RQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbZG3RQi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 13:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbZG3RQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 13:16:38 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:44373 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbZG3RQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 13:16:37 -0400
Subject: Re: [RFC][patch 00/12] clocksource / timekeeping rework V2
From: john stultz <johnstul@us.ibm.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1248961750.6046.35.camel@desktop>
References: <200907291717.n6THHG6f001426@d06av06.portsmouth.uk.ibm.com>
	 <20090730125351.6f16e9ec@skybase> <1248958173.6046.32.camel@desktop>
	 <20090730150456.6c87b997@skybase>  <1248961750.6046.35.camel@desktop>
Content-Type: text/plain
Date: Thu, 30 Jul 2009 10:16:27 -0700
Message-Id: <1248974187.3331.6.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-30 at 06:49 -0700, Daniel Walker wrote:
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

Clocksources as modules was one of the initial design goals I had way
back. The benefit being that an older distro kernel could be made to
support newer stranger hardware via a clocksource driver. While the
hardware vendors have for the most part consolidated on HPET/ACPI PM
which has mostly avoided the need, I still think its worth preserving.

thanks
-john


