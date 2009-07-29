Return-Path: <linux-kernel-owner+w=401wt.eu-S1755829AbZG2Qos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829AbZG2Qos (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 12:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476AbZG2Qor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 12:44:47 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:61537 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbZG2Qor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 12:44:47 -0400
Date: Wed, 29 Jul 2009 18:44:44 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Will Newton <will.newton@gmail.com>
Cc: dwalker@fifo99.com, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>
Subject: Re: [RFC][patch 02/12] remove clocksource inline functions
Message-ID: <20090729184444.3937807a@skybase>
In-Reply-To: <20090729182754.2361631b@skybase>
References: <200907291457.n6TEvDAt003701@d06av06.portsmouth.uk.ibm.com>
	<20090729173231.012d0b89@skybase>
	<87a5b0800907290836n6bb6da36tb0124e6d4f0673ea@mail.gmail.com>
	<20090729182754.2361631b@skybase>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jul 2009 18:27:54 +0200
Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> On Wed, 29 Jul 2009 16:36:46 +0100
> Will Newton <will.newton@gmail.com> wrote:
> 
> > On Wed, Jul 29, 2009 at 4:32 PM, Martin
> > Schwidefsky<schwidefsky@de.ibm.com> wrote:
> > 
> > > Hmm, you have an object of type struct clocksource and you do
> > > cs->read(cs). If that is not clear enough then I don't know what is. We
> > > do that all over the place in the linux kernel. And I personally find
> > > these useless wrappers rather annoying. I don't like to have to jump to
> > > another place to find out that it just calls the read function of the
> > > object.
> > 
> > An argument for the helper is that it eases grepability. Sure you can
> > search for "->read" but that's going to turn up all kinds of
> > non-clocksource code as well. grep clocksource_read will get you
> > exactly what you want.
> 
> That would make sense if the clocksource_read calls are littered all
> over the kernel source. But they are not, the only user is
> timekeeping.c
 
And What I find odd as well is e.g. this:

offset = (clocksource_read(clock) - clock->cycle_last) & clock->mask

A mixture of a wrapper to get something out of the clock and a direct
access to other fields of the clocksource. Either it is wrapped or it
isn't, no? A proper wrapper would do all of the above and not just the
call over the read function pointer.


-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

