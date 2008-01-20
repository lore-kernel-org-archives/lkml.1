Return-Path: <linux-kernel-owner+w=401wt.eu-S1756119AbYATUxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbYATUxv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 15:53:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755386AbYATUxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 15:53:43 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:44168 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755310AbYATUxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 15:53:42 -0500
Date: Sun, 20 Jan 2008 15:53:41 -0500
To: David Newall <davidn@davidnewall.com>
Cc: Andi Kleen <andi@firstfloor.org>, Matt Mackall <mpm@selenic.com>,
       Chodorenko Michail <misha@one.by>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: Celeron Core
Message-ID: <20080120205341.GR2310@csclub.uwaterloo.ca>
References: <p73prvyalfl.fsf@bingen.suse.de> <1200702477.25782.41.camel@cinder.waste.org> <20080119011506.GA23798@one.firstfloor.org> <1200715842.25782.95.camel@cinder.waste.org> <20080119042750.GA24481@one.firstfloor.org> <1200717635.25782.107.camel@cinder.waste.org> <20080119045415.GA27628@one.firstfloor.org> <4792CF9A.2030601@davidnewall.com> <20080120051338.GA19784@one.firstfloor.org> <4792DADD.70504@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4792DADD.70504@davidnewall.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2008 at 03:53:41PM +1030, David Newall wrote:
> Then why would it run cooler?  What generates the heat when not
> throttled?  What stops generating heat when throttled?  And you say this
> happens without reducing power consumption?  I'm not convinced.  I'm a
> long way from that.

If your P4 runs along at 100% and starts getting hot it can start
throthling to only run half the clock cycles.  This of course makes the
task running take twice as long to complete, but will reduce the heat
produced by the chip to perhaps 60 or 70% of what it was at 100% load at
normal speed.  This lets the chip cool of a bit although the user won't
appreaciate the fact their program now runs slower, but such was life
with the P4 (at least if you didn't have a good cooling system in
place).

In cases where your system is not running at 100% load, but perhaps only
50% load you can instead save some power (and hence heat production) if
you slow the actual clock rate of the cpu and lower the voltage at the
same time, both things the throthling on the P4 did not do, since your
task only neds the chip running at 50% of normal speed in order to
complete the task in the minimum amount of time.

The throthling is about protecting the CPU from damage, not about saving
power (since it does cause the work to take longer to complete
preventing the cpu from going back to idling for a longer period of
time), while the other case is all about saving power when the system
isn't under enough load to require the full performance.  Throthling had
nothing to do with an idle CPU where it should make no difference
(although it may actually affect in negatively), it was only about what
to do when under high load and getting too hot.

Sure the power consumption dropped while throthlin was active, since the
idea was to reduce heat output, but the performance dropped more than
the power consumption.

If you have a CPU that uses 100W at full load at full clock rate, and
uses 5W when idle, and uses 70W when throthled 50% under full load, then
a program using the cpu for full load for an hour without throthling and
then idles for an hour, would use less overall power than if you
throthled the system 50% and the program finishes in 2 hours.  100W for
an hour + 5W for an hour = 105Wh while 70W for two hours = 140Wh.

If you only need 50% then a modern CPU should use less than 50% of its
maximum power if you drop it's clock frequency to half and at the same
time reduce it's core voltage a bit.  It may be able to run 50% load
with power management in 30W or 40W instead, which is much better than
what throthling did and it only does it when the cpu load is low enough
to not slow down the user, while throughling only applied when it would
slow down the user while under high load.

--
Len Sorensen
