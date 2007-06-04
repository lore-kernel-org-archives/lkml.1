Return-Path: <linux-kernel-owner+w=401wt.eu-S1758989AbXFDQkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758989AbXFDQkV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 12:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757392AbXFDQkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 12:40:08 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:24318 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756255AbXFDQkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 12:40:07 -0400
Message-ID: <46644061.7020508@msgid.tls.msk.ru>
Date: Mon, 04 Jun 2007 20:40:01 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Andi Kleen <ak@suse.de>,
       Jiri Kosina <jikos@jikos.cz>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: thinkpad testers wanted (was Re: 2.6.22-rc[23]: blinking capslock
 led, stuck keys?)
References: <20070604112426.GA2707@elf.ucw.cz> <20070604130903.GC1971@elf.ucw.cz> <Pine.LNX.4.64.0706041511010.29896@twin.jikos.cz> <200706041543.49071.ak@suse.de> <20070604135427.GA19466@elf.ucw.cz> <d120d5000706040702q3b5251e8oc5e9f3c198f060bd@mail.gmail.com> <20070604141345.GB2059@elf.ucw.cz>
In-Reply-To: <20070604141345.GB2059@elf.ucw.cz>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
[]
>>> pavel@amd:~$ while true; do setleds +num; setleds -num; done
>>> Hm,m so thiis  iis  a teest of fkeyboarad behaviour  under lloadd.
>>>
>>> ...but I'm not quite sure it is a buggy keyboard. It happens _way_ too
>>> often. Launch the line above and try to do some typing...
>> This used to work fine on my box last time I tried it (the switch
>> itself is offloaded to a keventd and shoud not get in the way) but
>> then they push all kind of ACPI/SMM crap together with KBC so who
>> knows... I should try it again when I get home.
> 
> Hmm, this needs to be ran from console (not X). Can someone with
> thinkpad try this?

I don't have a thinkpad, but I tried it - just for fun - with my desktop
PC here.  And it also shows some.. strangeness.  Namely, after several
secounds, it starts spewing:

drivers/usb/input/hid-core.c: control queue full
drivers/usb/input/hid-core.c: control queue full
drivers/usb/input/hid-core.c: control queue full

messages on the screen on every setleds (above) invocation.  Even if I
stop the loop and execute single setleds manually, it also shows this
same message.  And the led isn't working anymore too - even if I press
NumLock key, NumLock mode activates/deactivates correctly, but not the
led -- ditto for other leds (CapsLock & ScrollLock).  And it doesn't
restore when I switch to X and back.

(My keyboard is USB-connected).

I think it's something about count of setleds/etc operations.  Rebooting
and counting from 0...

(2.6.21.3 here)

/mjt
