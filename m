Return-Path: <linux-kernel-owner+w=401wt.eu-S1754994AbYEWOPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994AbYEWOPO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 10:15:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753720AbYEWOOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 10:14:31 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:45412 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbYEWOO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 10:14:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=f2HIaYBqt6O3X7shzJg27XHOSEAoo+p3FVpXJxwygJeUPZnQOAyL5PRqAmRQAchMSC13m/IVN3D/1qUVH9Js3bOw18woJbnG0aTYWArTMFiFjlyryijFE81/6lRRUgE3wppAq+rKgMp7gF5e9hcMjPgJfWLFejwc7epaReIdElA=
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 14/15] rfkill: do not allow userspace to override ALL RADIOS OFF
Date: Fri, 23 May 2008 16:15:33 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       Dmitry Torokhov <dtor@mail.ru>
References: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br> <200805201209.06902.IvDoorn@gmail.com> <20080522205153.GA18483@khazad-dum.debian.net>
In-Reply-To: <20080522205153.GA18483@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805231615.33414.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 May 2008, Henrique de Moraes Holschuh wrote:
> On Tue, 20 May 2008, Ivo van Doorn wrote:
> > On Sunday 18 May 2008, Henrique de Moraes Holschuh wrote:
> > > SW_RFKILL_ALL is the "emergency power-off all radios" input event.  It must
> > > be handled, and must always do the same thing as far as the rfkill system
> > > is concerned: all transmitters are to go *immediately* offline.
> > 
> > I don't quite agree here. The SW_RFKILL_ALL key is the one send by thinkpad-acpi,
> > what makes that key so special that is has to be handled differently then a key
> > that only controls a single radio type?
> 
> Well, first there is no KEY involved, it is a SWITCH :-)  But that's not
> the reason it is special.
> 
> What makes SW_RFKILL_ALL special, is that it is the kernel view of *The*
> RFKill Switch.  SW_RFKILL_ALL is the event you get when the user
> manipulates the very *thing* that created the "rfkill switch" term.

So do keys that are pressed that only send the KEY_WLAN, KEY_BLUETOOTH or
KEY_UWB signals. They all indicate the key has been pressed and the radios
should be turned on/off.

> You get that event when someone moves that slider switch in the side/top
> of a laptop which has to kill all RF output in hardware as far as safety
> regulations go.  Therefore, it refers to the only rfkill switch that has
> guidelines that say that it must always work, and that it must not be
> possible to override it in software.

That is a valid point, and rfkill is supposed to do that, but making
a difference between RFKILL_ALL and the individual types is wrong
because that won't result in a clearly defined expected behavior for all
rfkill keys.

> Too bad that doesn't apply to "removable" radio transmitters, like
> PCMCIA and ExpressCard WLAN cards, USB RF transmitters, and so on...
> probably, the user is expected to yank them off when he moves the switch
> to the "no radios working here!" position.  Well, we can do better.  We
> can make it apply to these other radio transmitters, too.

Through the write-only rfkill class right? ;)

> So yes, it *is* special when it is doing its "power DOWN the
> transmitters" function.  It is not special at all when it is in the
> "allow radios to function if they want to" position, which is why I
> special-cased only the "OFF" state.
> 
> IMHO, that makes it special enough to implement it in a different way
> that is not subject to, e.g., brain damage in userspace.
> 
> As for thinkpad-acpi being the only in-tree code issuing that event so
> far, well... I have seen laptops from many vendors with that switch, and
> it is likely that the firmware of at least some of these laptops let you
> know the state of the switch (like the thinkpad firmware does), so I'd
> expect more users of SW_RFKILL_ALL to show up soon.  I am just paving
> the way.
> 
> That, and as an user, I'd really like to be able to implement a
> KEY_RFKILL_ALL keycode to use when I don't have a proper SW_RFKILL_ALL
> in my laptop.  But one thing at a time.  Small steps.
> 
> > All keys should have the same rules when it is pressed, so either all keys should
> > force the change, or none of them should.
> 
> IMO, "kill ALL radios" events are is the only kind of rfkill input event
> that have to *always work*, even if something in userspace tried to
> configure it not to.

Well the definition of "ALL radios" is the part that is the question, when the KEY_WLAN is
pressed it would be "ALL WLAN radios" and should still have the same rules for allowing
or disallowing userspace to overwrite the status.

Ivo
