Return-Path: <linux-kernel-owner+w=401wt.eu-S1762695AbZCQIvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762695AbZCQIvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 04:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753177AbZCQIu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 04:50:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:33888 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304AbZCQIu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 04:50:58 -0400
Subject: Re: [git-pull -tip] x86: cleanup 20090317
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0903170930311.29264@localhost.localdomain>
References: <1237229111.2827.2.camel@ht.satnam>
	 <alpine.LFD.2.00.0903162128010.29264@localhost.localdomain>
	 <1237267595.2480.9.camel@ht.satnam>
	 <alpine.LFD.2.00.0903170930311.29264@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 17 Mar 2009 14:20:33 +0530
Message-Id: <1237279833.3464.4.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-17 at 09:38 +0100, Thomas Gleixner wrote:
> On Tue, 17 Mar 2009, Jaswinder Singh Rajput wrote:
> > On Mon, 2009-03-16 at 23:33 +0100, Thomas Gleixner wrote:
> > > On Tue, 17 Mar 2009, Jaswinder Singh Rajput wrote:
> > > 
> > > > -static struct clock_event_device pit_clockevent = {
> > > > +static struct clock_event_device pit_dev = {
> > > 
> > >   Why do we need to change the name of the variable ? Just for fun or
> > >   is pit_dev more self explaining than pit_clockevent ?
> > 
> > pit already means it is a clock event, but with this change:
> > 
> > 1. we save 8 characters per declaration
> > 2. It solves various 80 characters problem
> 
> There is not a single 80 character problem in that file.

Here are 80 character problems:

1.        pit_clockevent.mult = div_sc(CLOCK_TICK_RATE, NSEC_PER_SEC,
                                     pit_clockevent.shift);
2.        pit_clockevent.max_delta_ns =
                clockevent_delta2ns(0x7FFF, &pit_clockevent);
3.        pit_clockevent.min_delta_ns =
                clockevent_delta2ns(0xF, &pit_clockevent);

4.        clocksource_pit.mult = clocksource_hz2mult(CLOCK_TICK_RATE,
                                                   clocksource_pit.shift);


--
JSR

