Return-Path: <linux-kernel-owner+w=401wt.eu-S1755798AbZG2QiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798AbZG2QiA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 12:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755784AbZG2Qh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 12:37:59 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:39226 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781AbZG2Qh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 12:37:59 -0400
Date: Wed, 29 Jul 2009 18:37:56 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>
Subject: Re: [RFC][patch 02/12] remove clocksource inline functions
Message-ID: <20090729183756.7c1314ce@skybase>
In-Reply-To: <1248882770.28841.236.camel@desktop>
References: <200907291457.n6TEvDAt003701@d06av06.portsmouth.uk.ibm.com>
	<20090729173231.012d0b89@skybase>
	<1248882770.28841.236.camel@desktop>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jul 2009 08:52:50 -0700
Daniel Walker <dwalker@fifo99.com> wrote:

> On Wed, 2009-07-29 at 17:32 +0200, Martin Schwidefsky wrote:
> > Hmm, you have an object of type struct clocksource and you do
> > cs->read(cs). If that is not clear enough then I don't know what is.
> 
> It's not as clear as it could be .. In the case above you have to look
> in at least two places to know what's going on.. First to see the
> cs->read() , and second to see if "cs" is actually a clocksource or
> something else.. "cs" could be declared anyplace with any name.

Well you have something like that in the code:

	struct clocksource *clock;

	clock = timekeeper.clock;
	cycle_now = clock->read(clock);

If I read the function top to bottom I immediately see that clock is a
clocksource and that the code does a read on it. That is not the case
if I need to lookup the clocksource_read wrapper.

> If you see clocksource_read(cs) , you might need to once check what
> clocksource_read() is actually doing, but only once.. After that when
> you see that function you know that variable is a clocksource, and it's
> "read()" is getting called. So you only need to review one line in the
> simplest case.

After you learned (once) that timekeeper.clock is a clock source you
have no trouble to understand the 6 occurrences of clock->read(clock)
there are in the code.

Anyway this seems to be a matter of personal preference, in the end I
don't care too much about the inline functions.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

