Return-Path: <linux-kernel-owner+w=401wt.eu-S1764227AbXGTSvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764227AbXGTSvc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 14:51:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757769AbXGTSvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 14:51:07 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:27479 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756182AbXGTSvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 14:51:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nr3aYdSUrBeSd2bkIq8eqsI2xNRnP8pwYhDnb4VsZ5SuHGkV+PgnVijoECRugrovCdsZ5sGUFGDZtjuoPwG3rFJxkRt6vakKT4xpaxiVa1Ne1NC1yAbB2qvE2dj4gSJVzxFZR0tRFd578yZPxZe3Z5GblHOHfat39pYb13SkR0w=
Message-ID: <d120d5000707201151q433f1f3eteb479109291a54bd@mail.gmail.com>
Date: Fri, 20 Jul 2007 14:51:02 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: [patch 1/3] m68k/mac: Make mac_hid_mouse_emulate_buttons() declaration visible
Cc: "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-input@atrey.karlin.mff.cuni.cz,
       linuxppc-dev@ozlabs.org
In-Reply-To: <20070720183503.GC3801@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070720164043.523003359@mail.of.borg>
	 <20070720164323.625963918@mail.of.borg>
	 <d120d5000707201047y2d22167co882a10176d79fce4@mail.gmail.com>
	 <20070720183503.GC3801@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/20/07, Adrian Bunk <bunk@stusta.de> wrote:
> On Fri, Jul 20, 2007 at 01:47:36PM -0400, Dmitry Torokhov wrote:
> > Hi Geert,
> >
> > On 7/20/07, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> >> From: Geert Uytterhoeven <geert@linux-m68k.org>
> >>
> >> m68k/mac: Make mac_hid_mouse_emulate_buttons() declaration visible
> >>
> >> drivers/char/keyboard.c: In function 'kbd_keycode':
> >> drivers/char/keyboard.c:1142: error: implicit declaration of function
> >> 'mac_hid_mouse_emulate_buttons'
> >>
> >> The forward declaration of mac_hid_mouse_emulate_buttons() is not visible
> >> on
> >> m68k because it's hidden in the middle of a big #ifdef block.
> >>
> >> Move it to <linux/hid.h>, correct the type of the second parameter, and
> >> include <linux/hid.h> where needed.
> >
> > linux/hid.h contains definitions needed for drivers speaking HID
> > protocol, I don't think we want to put quirks for legacy keyboard
> > driver there. I'd just move the #ifdef within drivers/char/keyboard.c
> > for now.
> >...
>
> If you only move it you will keep the bug of the wrong second parameter.
>
> But if you move it to any header file gcc is able to figure out such
> errors itself instead of them being nasty runtime errors.
>
> Such prototypes in C files are really bad since (like in this case) they
> prevent the finding of bugs. It doesn't matter which header file you put
> the prototype into (it can even be a new one), but it belongs into a
> header file.
>

I am OK with adding a new header file. I was just saying that placing
that declaration in linux/hid.h makes about the same sense as putting
it into linux/scsi.h

-- 
Dmitry
