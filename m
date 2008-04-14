Return-Path: <linux-kernel-owner+w=401wt.eu-S1754565AbYDNEUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbYDNEUs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 00:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750976AbYDNEUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 00:20:39 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:28090 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbYDNEUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 00:20:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=pWDFhqwOxYYdEDZWZfdwa3GEN31nwo3PSC6UKUSCMts1zccPXXyDKOHYfZeNBHDWFUhP8y5ED609XTxIBvKW7liZqNyRK41U8vtcvuxL2+OBj0XS6cDt0CuSm7nELMX4mtIbqTBoWsxUN/ytrIlBYeNCCtD58anEDFK/qQs4JiY=
Date: Mon, 14 Apr 2008 00:20:27 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
       Inaky Perez-Gonzalez <inaky@linux.intel.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 6/8] rfkill: add the WWAN radio type
Message-ID: <20080414042027.GB655@anvil.corenet.prv>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br> <200804121623.17453.inaky@linux.intel.com> <20080413172554.GA31364@khazad-dum.debian.net> <200804131937.13385.IvDoorn@gmail.com> <20080413181621.GC31364@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080413181621.GC31364@khazad-dum.debian.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2008 at 03:16:21PM -0300, Henrique de Moraes Holschuh wrote:
> On Sun, 13 Apr 2008, Ivo van Doorn wrote:
> > On Sunday 13 April 2008, Henrique de Moraes Holschuh wrote:
> > > On Sat, 12 Apr 2008, Inaky Perez-Gonzalez wrote:
> > > > Most rfkill hw keys are attached to the device. So I can plug wifi, wimax,
> > > > 3G, UWB and BT dongles (or cards) into a system and they each provide a HW
> > > > switch (or should provide).
> > > > 
> > > > If each overrides another one, we have a problem.
> > > 
> > > Yeah, and we have to avoid such problems.
> > > 
> > > But let me ask you one thing.  Are we talking of different rfkill
> > > switches, OR are we talking about different KEYs or BUTTONS in the
> > > keyboard/keypad/console/remote control?
> > > 
> > > Because one thing has very little to do with the other.  No network
> > > device driver shall generate an input event after I am done with the
> > > next patch set...
> > 
> > Not sure if that will be the desired course of action.
> > The original rfkill function didn't work with input devices either and just
> > handled everything in rfkill.
> > But the input layer people requested the change to use input devices and let
> > rfkill hook into that, because a rfkill switch/key can be considered an input device.
> > 
> > I've CC'ed Dmitry into this discussion since he was the one who suggested the
> > input device interaction initialy (and created the rfkill-input module).
> 
> In order to avoid a lot of misunderstandings, we better name the
> "enable/disable radio apparatus" (the circuit/config register that
> causes a radio to disable its RF path) and the "input hardware rf-switch
> device" (the thing the user presses/moves) in different ways, at least
> when we are talking about them.
> 
> Right now both are usually called rfkill switch, and much of the mess
> comes from that...
> 
> "input hardware rf-switch devices" ARE input devices, belong to the
> input layer, and issue input events.
> 

Exactly. And some times they are completely separated from the RF switch
itself, in the same fashion some keyboards have sleep key that is not
directly wired into ACPI. That was the reason I wanted the radio control
and key/switch/sliter to be separated.

> "enable/disable radio apparatus" don't, and the input layer should not
> be abused as a "status reporting" feature for those.  We certainly will
> benefit from those issuing kernel notifications through a notification
> chain for them, though.
> 
> And many devices are both at the same time (e.g. a b43 in certain
> hardware configurations), and many drivers have both types (e.g.
> thinkpad-acpi's hotkey subsystem has "input hardare rf-switch devices"
> functions, and thinkpad-acpi's bluetooth firmware handling have
> "enable/disable radio apparatus" functions).
> 

-- 
Dmitry
