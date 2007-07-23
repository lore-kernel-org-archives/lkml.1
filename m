Return-Path: <linux-kernel-owner+w=401wt.eu-S1760036AbXGWOOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760036AbXGWOOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 10:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753503AbXGWOOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 10:14:25 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58005 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbXGWOOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 10:14:23 -0400
Subject: Re: [linux-pm] Power Management framework proposal
From: Arjan van de Ven <arjan@infradead.org>
To: david@lang.hm
Cc: Igor Stoppa <igor.stoppa@nokia.com>,
       "ext linux-pm-bounces@lists.linux-foundation.org" 
	<linux-pm-bounces@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0707222207210.6350@asgard.lang.hm>
References: <Pine.LNX.4.64.0707212339550.6350@asgard.lang.hm>
	 <1185091022.19678.28.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0707220057210.6350@asgard.lang.hm>
	 <1185105911.29238.43.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0707221156210.6350@asgard.lang.hm>
	 <1185145766.2714.27.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.64.0707221914550.6350@asgard.lang.hm>
	 <1185162647.2714.35.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.64.0707222054060.6350@asgard.lang.hm>
	 <1185164357.2714.49.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.64.0707222207210.6350@asgard.lang.hm>
Content-Type: text/plain
Organization: Intel International BV
Date: Mon, 23 Jul 2007 07:12:09 -0700
Message-Id: <1185199929.2714.54.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-22 at 22:25 -0700, david@lang.hm wrote:
> >>
> >> only if the transitions don't cost anything significant,
> >
> > these are second order effects though. On a pc, the transition costs are
> > quite low (as I said, single or low double digit microseconds).
> 
> including pausing all drivers before the transition and unpausing them 
> aftrwords?

on a PC you don't need to do that.

> 
> >> and the
> >> computation capacity per watt of power is the same at all frequencies. the
> >> chip performance numbers I've been seeing (which I admit are mostly
> >> embedded datasheets) indicate that neither of these hold true.
> >
> > let me give you a real world example then, and the numbers I'm using are
> > ballpark the same as you'll find in a (mobile) core 2 duo datasheet, I
> > just rounded them a little so that the math works out nice.
> >
> > power at full speed: 34W
> > power at half speed: 24W
> > power at idle: 1W
> 
> are these numbers for the CPU itself or for the a larger chunk?

the cpu at full load.

> > this works for all systems where the idle power is more lower than the
> > power you save by dropping speed... and that is almost all of them in
> > the PC world.
> 
> if you can idle the system as a whole I agree with you fully. most PC 
> hardware (including the mobile stuff) doesn't change it's power 
> consumption much with load.

even if the rest of the PC is unchanging (which it's not), it is just an
offset to both sides of the equation, and the same on both sides at
that.

>  at Usenix there was a presentiation (I don't 
> remember if it was by Amazon or Google) about this subject, showing that 
> current PC hardware only goes down to 50% power when idle (short of 
> switching power modes) and that they and other big companies were pushing 
> vendors to improve their hardware, aiming to get the idle power down to 
> 10% (again without suspending anything). so there's some chance that this 
> will change before too long.

on servers and such, there is a huge offset, sure, but still the effect
is there. And it really isn't 50%.

> 
> > now you can argue that 0.5 seconds is a really really long time, and
> > you'd be right. so for really really short stints (say a timer
> > interrupt) you don't want to change the voltage at all (nor would
> you
> > want to change the plls to change frequency for that matter). But
> once
> > you start chaning those, you might as well go full speed.
> 
> this assumes that you can cache 1 second of video, if you have more 
> real-time requirements you have a much harder time (say video
> confrancing 
> where you don't get the frame until just before you need to display
> it)

the same basic math holds for just 1 frame at a fixed rate. At some
point transition costs will get you (and that's where things like
ondemand delayed speedup will save us); but to get back to your
interface, the interface doesnt nearly give the info needed to make
these decisions...

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

