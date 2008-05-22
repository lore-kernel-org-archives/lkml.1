Return-Path: <linux-kernel-owner+w=401wt.eu-S1755501AbYEVQGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501AbYEVQGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 12:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753775AbYEVQGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 12:06:47 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:62002 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753599AbYEVQGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 12:06:46 -0400
Date: Thu, 22 May 2008 17:02:23 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Jean Delvare <khali@linux-fr.org>
cc: Alessandro Zummo <a.zummo@towertech.it>,
       Andrew Morton <akpm@linux-foundation.org>,
       Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       David Woodhouse <dwmw2@infradead.org>,
       Ralf Baechle <ralf@linux-mips.org>,
       Thomas Gleixner <tglx@linutronix.de>, rtc-linux@googlegroups.com,
       i2c@lm-sensors.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH 6/6] RTC: Trivially probe for an M41T80 (#2)
In-Reply-To: <20080522113258.3dff7eed@hyperion.delvare>
Message-ID: <Pine.LNX.4.55.0805221627560.13339@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805130303430.535@cliff.in.clinika.pl>
 <20080513142829.2d737424@hyperion.delvare> <Pine.LNX.4.55.0805131759580.7267@cliff.in.clinika.pl>
 <20080519223718.3c89aa40@hyperion.delvare> <Pine.LNX.4.55.0805202057380.31790@cliff.in.clinika.pl>
 <20080522113258.3dff7eed@hyperion.delvare>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

> Whether the unneeded module can be removed or not, is a side problem
> (which I didn't even have in mind at first, thanks for pointing it
> out.) The main problem is that, even if you can remove the module, the
> device you declared is still visible, even though it's not on the
> system - and that's confusing.

 No need to repeat this -- it was a side note of mine already and I agreed 
with you about the visibility of a phantom device.

> What you describe here doesn't fit in the platform device declaration
> model. The platform code is supposed to know what hardware is present,
> with all the required configuration details. Not being certain that a
> given device is there or not, as was the case for your RTC chip, is
> already a variation from the standard theme. Being uncertain what chip
> is at a given address would be completely off-track IMHO. That would be
> much like the PC SMBus' realm where the hardware monitoring chips are
> probed automatically, i.e. we do not follow the device driver model at
> all. These are the legacy i2c device drivers we are trying to get rid
> of at the moment, even though the plan on how to do this is still vague.

 Too bad for the reality it does not agree then?  While you might desire
system designers record the configuration somewhere in some software
accessible way (unless it is entirely fixed), as you can see with the
SWARM, it may not necessarily be the case and you may have to ask the
hardware directly.

> >  That sounds like a limitation, although perhaps there is not enough
> > justification to lift it.  I can certainly imagine a flag telling the
> > driver: "Please check if this device is there for me [=the core] as the
> > complication behind that is beyond my capabilities."
> 
> Again this would not fit well within the device driver model, as you
> would have to load the driver before you know if you really need it.
> I agree that we might have to resort to this in some cases (I have
> hwmon drivers in mind as I write this.) However, my original idea was
> rather to have a single module dedicated to identification of a given
> type of I2C devices (say hwmon), that would act as an helper for
> i2c-core, letting it instantiate the right I2C devices (in turn
> triggering the loading of the appropriate device drivers.)

 By all means it sounds reasonable and desirable, but I do not think this
an excuse for saying: "Let's not support this board, system, etc. because
the designers did not follow our way of thinking." -- I think if a piece
of hardware does not fit our model, then we should either adjust the model
or come up with a solution which makes the device work with as little
negative impact to the model as possible.

 Fortunately, as I mentioned previously, we can escape the dilemma for the 
SWARM for now.  I should come up with updated patches tonight.

> An alternative would be to delegate the identification task to a
> user-space helper. This would however require that new-style I2C
> devices can be created and removed from user-space, which isn't the
> case yet.

 That might make sense, although in the case of a RTC chip we have some 
desire to use it before userland is run.

> Anyway, I don't expect embedded platforms to need this. That's more
> likely to be needed only by hwmon drivers on the PC, and possibly some
> old v4l drivers.

 Hmm, an ATX-form board like the SWARM, with SDRAM and PCI slots, IDE,
Gigabit Ethernet, USB and sound ports onboard, and keyboard and VGA
support in the firmware can hardly be called embedded. ;-)  It even comes
in a desktop enclosure with drive bays, etc.  It makes quite a nice PC
based on a decent processor architecture. :-)  The only difference making
it a bit more embedded is most of the functionality is implemented in the
SOC leaving off-chip features mainly to a bunch of I2C peripherals and
then boring stuff like line drivers and passive components. ;-)

 I agree for truly embedded systems it should not matter as I would expect
them to come in a fixed configuration.

  Maciej
