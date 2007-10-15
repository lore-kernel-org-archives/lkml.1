Return-Path: <linux-kernel-owner+w=401wt.eu-S1756319AbXJOVaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319AbXJOVaS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 17:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbXJOVaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 17:30:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41744 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296AbXJOVaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 17:30:04 -0400
Subject: Re: [PATCH] Map volume and brightness events on thinkpads
From: Jeremy Katz <katzj@redhat.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>
In-Reply-To: <20071015210737.GA15293@khazad-dum.debian.net>
References: <1192481110-9299-1-git-send-email-katzj@redhat.com>
	 <20071015210737.GA15293@khazad-dum.debian.net>
Content-Type: text/plain
Date: Mon, 15 Oct 2007 17:27:07 -0400
Message-Id: <1192483627.25568.60.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-8.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-15 at 19:07 -0200, Henrique de Moraes Holschuh wrote:
> On Mon, 15 Oct 2007, Jeremy Katz wrote:
> > There are standard keycodes for brightness and volume; map the events to
> > emit them so that things work properly
> 
> NAK.  It is the completely wrong thing to do for IBM thinkpads which process
> volume and brightness completely in firmware.
> 
> And the input subsystem maintainer has made it extremely clear in various
> threads that the input devices are *not* to be used as a notification
> service for on-screen-display or other such stuff.  If you send volume and
> brightness *key* events to userspace, it is supposed to act on them and
> raise/lower brightness/volume, which is the wrong thing to do on thinkpads.
> Never mind that HAL is ignoring the input maintainer's directions and
> violating this.

It seemed to be doing the right thing here on an X31 (had to give it
back to its owner; will retrieve and test again tomorrow to make sure
everything is matching up).

> We should fix the backlight class to be more useful and support poll() or
> somesuch, for userspace to track the backlight level in a resource-friendly
> way for OSD (the only sane thing to do on an IBM thinkpad with such events).
> And an ALSA mixer to provide a proper path to the thinkpad-acpi volume
> functionality is also in my schedule for 2.6.25.

I don't know that having another mixer is really the right answer.  You
want to have the buttons/hardware volume matching (and showing)
on-screen changes to the system volume.  Otherwise, things are just
confusing to a user.

> As for Lenovo thinkpads, brightness control is to be processed by the ACPI
> video module, so brightness hot keys are not to be reported by default there
> either.  

Brightness events are being reported as is with the X60t I've got...

> I am not so sure about the volume keys, but your patch touches the
> IBM keymap *and* you provide no testing information for the various Lenovo
> models, so I have to NAK it as well until more information is available.

Having the volume keys reported makes it so that we get the on-screen
display of the volume changing and /proc/acpi/ibm/volume matches what
the displayed volume shows.

As far as other Lenovos, if you want it tested out on more of them,
that's easy enough to do as they're very common in the office here.  But
the couple of people that I've given the patched module to haven't had
problems (various T60s)

Jeremy

