Return-Path: <linux-kernel-owner+w=401wt.eu-S1758383AbXGBMb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758383AbXGBMb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 08:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754379AbXGBMbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 08:31:19 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:31064 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379AbXGBMbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 08:31:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uBScNPH+NuYjPigA5afXoTnfwi9pzNM46LEKbnGQgWznMSCbxCjVfPz0tHH/8J8CTu40Wb+Wq8Q4/oSFwnb5jjY3TVtkSzlLgkepw4OCG2icfk9qU4JXGkCRDmu9FCBBmNXA2cXbiUmhUTFizqMeAzkPYdEMmXHZPSlX2w8ohJE=
Message-ID: <d120d5000707020531y43d41b6fl46e05c8343dbbeae@mail.gmail.com>
Date: Mon, 2 Jul 2007 08:31:17 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: blink driver power saving
Cc: "Indan Zupancic" <indan@nul.nu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200707021351.57965.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <51563.81.207.0.53.1183376603.squirrel@secure.samage.net>
	 <200707021351.57965.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/2/07, Andi Kleen <ak@suse.de> wrote:
> On Monday 02 July 2007 13:43:23 Indan Zupancic wrote:
> > On Mon, July 2, 2007 01:59, Andi Kleen wrote:
> > > Well only those that could be already hung from user space
> > > with setleds (that was also confirmed).  Actually I thought
> > > they didn't hang completely, but just stopped reacting to
> > > the keyboard (which is actually pretty bad for every user
> > > to be able to trigger)
> >
> > Pavel's lost key events, mine stopped reacting altogether.
>
> Did you try if the network was still alive? Perhaps it was
> just a locked up keyboard.
>
> >
> > > I guess the better way to handle those would be to find out the
> > > minimum frequency of blinking that is still ok and rate limit it to that in
> > > the keyboard driver.
> >
> > Dmitry already has a patch for that. He limited it to one event each 50 ms.
>
> Great.
>
> >
> > > Anyways, Stephen's patch just doesn't make sense:
> > > he clearly didn't understand the code at all. Before you
> > > apply it and cripple it better drop the driver completely.
> >
> > CC'ing Dmitry, as I think he doesn't like the blink driver much either. ;-)
>
> Perhaps one of you geniuses who all hate it can find a better way to
> solve the "video output dead after kexec; but need visual feedback to the user
> while crash dumping" problem. I'm waiting for your patches.
>

I don't don't like it ;) Unfortunately too many people end up enabling
it and having issues with their keyboards. Can we have it depend on
DEBUG_KERNEL? And probably KEXEC as well?

Another option would be for it not use panic_blink. Do your kexec
kernels have atkbd support enabled? You could write an new "blink"
input handler that would latch to keyboards supporting leds and blink
by sending EV_LED events.

-- 
Dmitry
