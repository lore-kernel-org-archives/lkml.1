Return-Path: <linux-kernel-owner+w=401wt.eu-S1753105AbXEGCkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbXEGCkX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 22:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670AbXEGCkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 22:40:23 -0400
Received: from mail.z-net.ru ([89.113.80.10]:4016 "EHLO mail.z-net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105AbXEGCkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 22:40:22 -0400
Date: Mon, 7 May 2007 06:40:15 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: David Brownell <david-b@pacbell.net>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/7] [RFC] Common power driver for Linux gadgets
Message-ID: <20070507024015.GA13571@zarina>
Reply-To: cbou@mail.ru
References: <200704122306.46518.david-b@pacbell.net> <200705061839.27477.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <200705061839.27477.david-b@pacbell.net>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 06, 2007 at 06:39:27PM -0700, David Brownell wrote:
> On Thursday 12 April 2007, David Brownell wrote:
> > > This driver used to stop code/logic duplication through different
> > > machines we porting at handhelds.org. pda_power register machs' power
> > > supplies, and will take care about notifying batteries about power
> > > changes through external power interface.
> > 
> > It gets USB power management wrong though. ...
> 
> And that seems not to have been resolved in the version you
> reposted and then put into your GIT tree, either ... what's
> your plan for addressing the feedback, then?

pda_power have nothing to do with USB at all, as I've said. It
*monitors* MAINS/USB power supply state through *platform hooks*, and
platform hooks will do things as caring how much current to draw, if
charger used.

There is nothing wrong with pda_power. If you're hinting that for
pda_power we can use not some platform hooks, but some generic
USB/UDC/OTG/whatever api - okay, patches are welcome. I'm not usb
expert.

Please, speak code, not USB words. I don't understand USB language.
All I've understood, that we could not get as much current as we
want/expect from USB. And I believe you.

> > Key points:
> > 
> >  - The API needs to say *how much power* can be drawn.  ...
> > 
> >  - Sensing VBUS power is not the same thing as being allowed to consume
> >    it.  Again, USB OTG devices are different...
> > 
> > In general, no component other than the USB peripheral (or host) controller
> > driver has any business trying to control how VBUS power is used.  It's
> > likely to get it wrong ... as shown by this patch.  ;)
> 
> I see on other LKML threads that folk are spreading misinformation
> about USB, like "no control signaling over USB for power control".
> I sincerly hope you're not believing that's correct!

And again, I believe you. But you're not helping.

> Plus, I'm wondering why this doesn't try to leverage the voltage
> framework that's been posted (to the ARM list, most recently).

(1)

> At some level there's not a lot different between saying "turn on
> the 3V3 supply to this MMC card slot, budgeting 80mA" and saying
> instead "let the system draw up to 200 mA from USB VBUS".  The
> current goes in different directions in those examples, sure.  Plus
> the usage of VBUS as a power _input_ is of course board-specific:
> battery charging, or powering specific circuits (like USB), etc.
> 
> Then there are devices which _output_ power on VBUS of course ...
> so the only difference between that and the MMC example being how
> much of the power budget is consumed.  Plus devices which either
> use VBUS as an input or an output, based on how they're hooked up.
> 
> All of those are differences that seem to fit better into the notion
> of a general purpose voltage framework than this "power" thing
> you've provided.  (Batter management being a separate issue.)

^^^ This

> Also that whole notion that there's only a handful of power "supplies"
> to manage ("ac", "main-battery", "usb") just flies in the face of
> how most boards actually work -- multiple voltage rails and switches,
> more types than battery/UPS/"AC"/USB, etc -- and the mechanisms needed
> to manage power when it's critical to eke out every last milliWatt.

And this ^^^ shows that you've completely misunderstood whole power
supply (was battery) class. This is mostly monitoring class, think of
hwmon. This class *monitors* what power supplies *attached* to the
board, monitors state of the power. Drivers to this class is mostly
*passive*.

pda_power is "active" in sense that it controls charger (usually
through one GPIO pin) via platform code. Not more.

And if some driver will want to be "active" (i.e. battery driver can
can control its voltage/current output), patches are welcome to do
(1), i.e. registering "voltage provider" inside power supply class.

> - Dave

Thanks,

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.org/bd2
