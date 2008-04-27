Return-Path: <linux-kernel-owner+w=401wt.eu-S1761900AbYD0BIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761900AbYD0BIy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 21:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753503AbYD0BIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 21:08:46 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:61773 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbYD0BIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 21:08:45 -0400
X-IronPort-AV: E=Sophos;i="4.25,712,1199682000"; 
   d="scan'208";a="67200682"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 1/1] Input/Joystick Driver: add support AD7142 joystickdriver (v2)
Date: Sat, 26 Apr 2008 21:09:09 -0400
User-Agent: KMail/1.9.5
Cc: "Bryan Wu" <cooloney@kernel.org>, khali@linux-fr.org,
       andre@bitwigglers.org, linux-input@vger.kernel.org, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org, vapier.adi@gmail.com,
       "Michael Hennerich" <michael.hennerich@analog.com>
References: <1206643110-8789-1-git-send-email-cooloney@kernel.org> <386072610804250309j5f2222cfj2f58b3b92d091a3a@mail.gmail.com> <20080425113501.ZZRA012@mailhub.coreip.homeip.net>
In-Reply-To: <20080425113501.ZZRA012@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804262109.09596.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 27 Apr 2008 01:08:39.0745 (UTC) FILETIME=[3A5AB310:01C8A803]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 25 Apr 2008 11:39, Dmitry Torokhov pondered:
> On Fri, Apr 25, 2008 at 06:09:52PM +0800, Bryan Wu wrote:
> > On Sat, Apr 19, 2008 at 1:15 AM, Dmitry Torokhov
> > <dmitry.torokhov@gmail.com> wrote:
> > > Hi Bryan,
> > >
> > >  Why don't you use REL_X/REL_Y to report directional movement? Using
> > >  buttons for that is pretty unusual.
> > >
> > 
> > In our development board, it includes UP/DOWN/LEFT/RIGHT 4 buttons. So
> > this driver matches this.
> > Please found some information about the hardware as below:
> >
> http://docs.blackfin.uclinux.org/doku.php?id=capacitance_touch_sensors&s
> []=ad7142
> 
> What is the expected behaviur when a person touches one of these
> buttons?

It depends on the design of the button on the target hardware. They can be 
pretty much any number of different shapes and sizes. Buttons, wheels, 
scroll-bar, joypad, and touchpad shapes can be laid out as traces on the 
sensor PCB. While we tested/wrote something for what we had hardware to 
verify, it is not restricted to this.

As Bryan indicated - have a look at:
http://docs.blackfin.uclinux.org/doku.php?id=capacitance_touch_sensors#overview

for a variety of options.

> Is it generatig a left/rigth mouse button clocks or moving a 
> pointer in some direction? Judging by the category of the devices you
> are placing it in (joystick) it seems that latter is what you want,
> therefore it should generate REL_X and REL_Y events. Otherwise it
> should probably be called a button driver and live either in
> drivers/input/keyboard or driver/input/misc. Do you agree?

If someone makes a joypad, it is a joypad. If someone makes a button, it is a 
button. The specific ad7142_work function will need to be modified to match 
the hardware design.

So, I am not sure where it should live - maybe driver/input/misc since it can 
be so many different things. The issue (in my mind) is how it gets exposed to 
userspace. If someone makes a joypad - they want it to show up as a joystick, 
so they don't have to modify any standard userspace applications to use it.

-Robin
