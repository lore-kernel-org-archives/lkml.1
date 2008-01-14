Return-Path: <linux-kernel-owner+w=401wt.eu-S1755544AbYANKq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbYANKq5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 05:46:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbYANKqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 05:46:48 -0500
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:33154 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbYANKqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 05:46:48 -0500
Date: Mon, 14 Jan 2008 10:44:49 +0000
From: Christer Weinigel <christer@weinigel.se>
To: Bernd Petrovitsch <bernd@firmix.at>
Cc: Tuomo Valkonen <tuomov@iki.fi>, linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
Message-ID: <20080114104449.0d162707@cw05lap>
In-Reply-To: <1200304629.24517.15.camel@tara.firmix.at>
References: <18307.42821.166376.732473@stoffel.org>
	<slrnfo7auq.6m2.tuomov@jolt.modeemi.cs.tut.fi>
	<871w8r6ruc.fsf@barad-dur.regala.cx>
	<slrnfo9lqk.17l.tuomov@jolt.modeemi.cs.tut.fi>
	<20080110131659.GF10230@mit.edu>
	<20080110134111.GA6254@jolt.modeemi.cs.tut.fi>
	<20080112150621.GC6751@mit.edu>
	<20080113221301.GA18341@jolt.modeemi.cs.tut.fi>
	<20080113222310.GA20815@jolt.modeemi.cs.tut.fi>
	<20080113231150.GB23906@mit.edu>
	<20080114071555.GA6475@jolt.modeemi.cs.tut.fi>
	<1200303743.24517.6.camel@tara.firmix.at>
	<slrnfombug.lco.tuomov@jolt.modeemi.cs.tut.fi>
	<1200304629.24517.15.camel@tara.firmix.at>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jan 2008 10:57:09 +0100
Bernd Petrovitsch <bernd@firmix.at> wrote:

> On Mon, 2008-01-14 at 09:48 +0000, Tuomo Valkonen wrote:
> > On 2008-01-14, Bernd Petrovitsch <bernd@firmix.at> wrote:
> > > Yes, that is a usual bug/problem in common distributions[0] as
> > > there is no real guarantee that your clock is not far off.
> > 
> > It isn't, right after boot. But while the system is on, it sometimes
> > starts advancing very fast, 15min a day or so. To my knowledge, the
> > time the CMOS clock is not used then, but rather the kernel tracks
> > the
> 
> > time based on scheduler interrupts, with ntpd occasionally
> > correcting. However, ntpd refuses to correct when the time has
> > drifted too much, causing even further drift.
> 
> That shouldn't happen.
 
> > Nope, as explained above. ntpdate at boot wouldn't help much,
> > because the time is (approximately) correct after boot. It only
> > drifts after it.
> 
> Aha. That's also strange. `ntpd` is able to (and always does AFAIK)
> modify the speed of the clock (to keep it synchronized) so that the
> error is usually much smaller than 1 second - also if you are behind
> high-jitter links and/or an a high stratum.
> That leads to the question why the clock starts to run like crazy at
> some time so that `ntpd` can't cope with it.
> Playing with `ntpd` parameters (e.g. increasing ) doesn't help I
> assume.

NTP can't correct too large errors.  I had some similar problems
(one of many problems) with my HP Proliant desktop.  Something totally
messed up the timekeeping, so the system would drift up to an hour or
so per day.  I don't know what was wrong, I tried a lot of combinations
of timer options, but couldn't find any that fixed it.  A kernel
upgrade a couple of weeks later fixed those problems and the system
time has been stable since then. 

So upgrading to a recent kernel is probably a good idea.  

  /Christer
