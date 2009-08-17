Return-Path: <linux-kernel-owner+w=401wt.eu-S1756658AbZHQD5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658AbZHQD5F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 23:57:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754369AbZHQD5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 23:57:04 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:63794 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbZHQD5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 23:57:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=u0RxE6d4KQGkOj7OHQiQ9q+nIB08Gn0jY4MFrFG9v7E9rYUGt2qgif8oPvR9BHF32P
         TSbe16166tXbQ0M8UqN/ojWjuGrIvtntjyOjFn53gBUDxZpLTkDNOBU4zIblIxpgDDpk
         85bzgQ/Nzxuf9jYJ9XZ95zmZ2geWV9wleKW04=
Subject: Re: [patch 0/2] Winbond IR Driver - v2
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       jbarnes@virtuousgeek.org, akpm@linux-foundation.org,
       dmitry.torokhov@gmail.com
In-Reply-To: <20090816184350.GA28497@hardeman.nu>
References: <20090809095645.198777507@hardeman.nu>
	 <1250305347.18122.4.camel@maxim-laptop>
	 <20090815201019.GB27484@hardeman.nu>
	 <1250374211.1928.27.camel@maxim-laptop>
	 <20090816184350.GA28497@hardeman.nu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Aug 2009 06:56:57 +0300
Message-Id: <1250481417.3549.23.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-08-16 at 20:43 +0200, David Härdeman wrote:
> On Sun, Aug 16, 2009 at 01:10:11AM +0300, Maxim Levitsky wrote:
> >On Sat, 2009-08-15 at 22:10 +0200, David Härdeman wrote:
> >> On Sat, Aug 15, 2009 at 06:02:27AM +0300, Maxim Levitsky wrote:
> >>>
> >>> Then why not to implement lirc driver?
> >>
> >> That's a fair question, but I'm afraid you're putting the cart before
> >> the horse.
> >
> >No, I just want to write the driver that fully exposes the hardware. I
> >don't care if it has to be outside or not.
> 
> That's not a very user-friendly sentiment. The entire idea is to extend 
> the input subsystem so that it fully exposes the hardware *and* gives 
> users the benefit of in-kernel drivers.
> 
> >> The question is not why anyone would want to write an in-kernel driver
> >> but rather why anyone would want to write an out-of-kernel driver.
It doesn't matter that much. I have written a driver. It works.
Eventually some IR subsystem will make into kernel, I then port my
driver to that system.

Currently, there is no such system. attempting to write a driver that
decode just one remote, in my opinion aren't that great.
IR_RAW of course, it nice, and will solve all problems, so go ahead with
that.

As long as there is a normal (not debug or so) access to raw data, its
fine with me.

I do think however that in kernel ir decoders are redundant, except
maybe some embedded systems.


> >>
> >> There have been repeated attempts to get LIRC merged with the kernel,
> >> and the feedback has been pretty consistent - make it part of the input
> >> subsystem.
> >>
> >> I have written the driver for theo input system and it limits the driver
> >> somewhat. I am working on extending the input system to accomodate IR
> >> drivers (see the discussion of EV_IR on the linux-input list).
> >
> >The EV_IR thing is that he attempts to put all IR decoding in kernel,
> >and on top of that create a configfs config system.
> 
> I never proposed a configfs system. I only proposed a part of Jon 
> Smirl's EV_IR functionality. I think the configfs system as well as the 
> in-kernel protocol _en_coders are overengineering.
and decoders?


> 
> >I first thought it would be nice, but then realized that this is really
> >bad idea.
> >Currently LIRC has very oiled system for decoding pretty much every
> >remote that exist. It can cope with all kind of troubles, including not
> >very accurate receivers.
> 
> I think you've misunderstood my EV_IR suggestion on the linux-input 
> list. Part of that proposal is to allow drivers to generate IR_RAW 
> timing events (if asked to do so via an ioctl), then you could continue 
> to use lirc with some minimal changes to the lirc daemon while still 
> getting the benefits of in-kernel drivers. I have a hard time seeing 
> what would be wrong with that? Whether the input subsystem *also* 
> includes (optional) IR decoding or not should not matter to lirc fans as 
> long as it includes some kind of IR_RAW support (which it does both in 
> Jon's proposal and in mine).
Thats of course is different.
I am not yet a lirc fan :-), but I can assure you that there are many
protocols. much more that we think.

The way lirc works, ensures that it can adapt to any remote.

> 
> >On top of that there are pure userspace devices, like a IR diode
> >connected to soundcard. It would be nice to do all the raw signal
> >decoding in one place. Once signal is decoded, lirc forwards the input
> >signal to the kernel via uinput, so it is a part of input system.
> 
> That's a red herring, there is always going to be esoteric DIY hardware, 
> and no matter which API is used in the kernel, that hardware can always 
> use user-space drivers.
The point is that doing it all in userspace helps ensure that settings
are kept in one place.
I have a lirc.conf. It will work with any receiver, homebrew or not.

> 
> >The way kernel hands in the raw IR data to lirc doesn't matter much. It
> >is really just a queue of numbers. It can be forced into input system,
> >but there is really no need for that.
I personally don't care. If you want to send IR raw data via input
layer, it is very fine with me. I am sure that lirc devs won't mind that
ether.



> 
> There really is a need if you want in-kernel drivers.
> 
> >> Feel free to help me out in implementing that API, and porting LIRC
> >> drivers, and all the benefits of in-kernel drivers will flow from that
> >> work.
> >
> >This isn't a bad idea.
> 
> Good, we agree on this point, which is the most important one. IR_RAW 
> should be enough for the lirc daemon, right? So let's make sure 
> something like that gets added to the input subsystem and we can take it 
> from there...
This indeed will be great.


> 
> >>>This driver as I understand is a driver for single remote shipped with
> >>>the notebook.
> >>
> >> It's a driver for a winbond chipset shipped with many Intel desktop
> >> "media" motherboards (DP35DP, DG33TL, DX388T, DX488T2, DP455G, DG45ID
> >> and DG45FC are the ones I'm aware of).
> >
> >But it won't work with my JVC remote?....
> 
> Not sure what you JVC remote has to do with the Intel mainboards that 
> include the WPCD376I chipset.
Lets see. I have a remote from a VCR I no longer use, I now use it with
my computer....
It isn't a NEC protocol, it actually has its own protocol (JVC)
But all these protocols are very similar.


> 
> Anyway, based on past experience of JVC remotes I'm guessing that your 
> remote uses some version of the NEC protocol, in that case it will be 
> supported...and IR_RAW (or something similar) will be supported if it is 
> accepted by the input subsystem maintainers so you will additionally be 
> able to use that air conditioning remote which implements a completely 
> wonky IR protocol together with lirc - if you want to...
Indeed. Not with lirc, as it doesn't implement support for decoding such
remotes... but it is trivial to add such support, or write my own app
for that.


So I do agree with you mostly. I don't care how the raw timings will be
given to lirc.


Best regards,
	Maxim Levitsky



> 
> Regards,
> David Härdeman
> 
> (trimmed some people of the CC list which are unlikely to be interested 
> in this discussion, I hope Dmitry will speak up soon).
> 

