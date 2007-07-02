Return-Path: <linux-kernel-owner+w=401wt.eu-S1758716AbXGBMjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716AbXGBMjl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 08:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751173AbXGBMjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 08:39:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:45638 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754945AbXGBMjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 08:39:32 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Subject: Re: blink driver power saving
Date: Mon, 2 Jul 2007 14:39:27 +0200
User-Agent: KMail/1.9.6
Cc: "Indan Zupancic" <indan@nul.nu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, bwalle@suse.de
References: <51563.81.207.0.53.1183376603.squirrel@secure.samage.net> <200707021351.57965.ak@suse.de> <d120d5000707020531y43d41b6fl46e05c8343dbbeae@mail.gmail.com>
In-Reply-To: <d120d5000707020531y43d41b6fl46e05c8343dbbeae@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707021439.27357.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > Perhaps one of you geniuses who all hate it can find a better way to
> > solve the "video output dead after kexec; but need visual feedback to the user
> > while crash dumping" problem. I'm waiting for your patches.
> >
> 
> I don't don't like it ;) Unfortunately too many people end up enabling

Yes that's pretty weird. I admit I hadn't expected
that problem. blink is equivalent to "annoy me" and it
is a mystery why so many people should willingly ask their computer to 
annoy them.

Or perhaps they update their configs with yes | make oldconfig? 

User psychology can be mysterious.

I wonder if the kernel offered a CONFIG_FORMAT_FILESYSTEMS_AT_BOOT
how many people would enable that @) Might be an interesting experiment
for next April.

> it and having issues with their keyboards.

Forcing a suitable slow rate should fix that shouldn't it? We need
that anyways to stop the "setleds DOS". 

> Can we have it depend on 
> DEBUG_KERNEL? 

Yes that would be probably a good idea; even though it is technically
not correct: the debug kernel doesn't try to debug itself. But anyways,
it's probably the best place.

> And probably KEXEC as well? 

The kcrash kernel doesn't necessarily need to have kexec enabled by
itself.

> Another option would be for it not use panic_blink. Do your kexec
> kernels have atkbd support enabled? You could write an new "blink"
> input handler that would latch to keyboards supporting leds and blink
> by sending EV_LED events.

Yes that would be probably a better implementation. Also hook something
for USB keyboards. iirc Bernhard Walle (cc'ed) was looking at that.

-Andi
