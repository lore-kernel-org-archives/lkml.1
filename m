Return-Path: <linux-kernel-owner+w=401wt.eu-S933563AbZLGHvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933563AbZLGHvA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 02:51:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758880AbZLGHu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 02:50:59 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:40076 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202AbZLGHu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 02:50:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=F6uF5ofJCUEEfIYkIx/65Dm0lcbxfwpotKR9LoqUoMzFCBYL5rUXwXSiSDYn3jPxXV
         2vXXVWadOf71z5FibMe1xVWdubGK/vkxKXhT0j8srIppgH9S4ejo/z8SNFgcUNkp7Y8r
         GRydRAnlJ0XVEmAW0TjUK0ahOnriTcImGzQas=
Date: Sun, 6 Dec 2009 23:51:00 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Christoph Bartelmus <lirc@bartelmus.de>
Cc: awalls@radix.net, j@jannau.net, jarod@redhat.com, jarod@wilsonet.com,
       jonsmirl@gmail.com, khc@pm.waw.pl, kraxel@redhat.com,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org, mchehab@redhat.com, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
	IR  system?
Message-ID: <20091207075100.GB24958@core.coreip.homeip.net>
References: <20091204231527.GA3682@core.coreip.homeip.net> <BENgwLGXqgB@lirc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BENgwLGXqgB@lirc>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 06, 2009 at 12:58:00PM +0100, Christoph Bartelmus wrote:
> Hi Dmitry,
> 
> on 04 Dec 09 at 15:15, Dmitry Torokhov wrote:
> [...]
> >>>>>> http://lirc.sourceforge.net/remotes/lg/6711A20015N
> >>>>>>
> >>>>>> This is an air-conditioner remote.
> >>>>>> The entries that you see in this config file are not really separate
> >>>>>> buttons. Instead the remote just sends the current settings for e.g.
> >>>>>> temperature encoded in the protocol when you press some up/down key.
> >>>>>> You really don't want to map all possible temperature settings to KEY_*
> >>>>>> events. For such cases it would be nice to have access at the raw scan
> >>>>>> codes from user space to do interpretation of the data.
> >>>>>> The default would still be to pass the data to the input layer, but it
> >>>>>> won't hurt to have the possibility to access the raw data somehow.
> >>>>
> >>>>> Interesting. IMHO, the better would be to add an evdev ioctl to return
> >>>>> the scancode for such cases, instead of returning the keycode.
> >>>>
> >>>> That means you would have to set up a pseudo keymap, so that you can get
> >>>> the key event which you could than react on with a ioctl. Or are you
> >>>> generating KEY_UNKNOWN for every scancode that is not mapped?
> >>>> What if different scan codes are mapped to the same key event? How do you
> >>>> retrieve the scan code for the key event?
> >>>> I don't think it can work this way.
> >>>>
> >>
> >>> EV_MSC/MSC_SCAN.
> >>
> >> How would I get the 64 bit scan codes that the iMON devices generate?
> >> How would I know that the scan code is 64 bit?
> >> input_event.value is __s32.
> >>
> 
> > I suppose we could add MSC_SCAN_END event so that we can transmit
> > "scancodes" of arbitrary length. You'd get several MSC_SCAN followed by
> > MSC_SCAN_END marker. If you don't get MSC_SCAN_END assume the code is 32
> > bit.
> 
> And I set a timeout to know that no MSC_SCAN_END will arrive? This is  
> broken design IMHO.
> 

EV_SYN signals the end of state transmission.

> Furthermore lircd needs to know the length of the scan code in bits, not  
> as a multiple of 32.

I really do not think that LIRCD is the type of application that should
be using evdev interface, but rather other way around.

> 
> > FWIW there is MSC_RAW as well.
> 
> It took me some time to convice people that this is not the right way to  
> handle raw timing data.
> 
> Christoph

-- 
Dmitry
