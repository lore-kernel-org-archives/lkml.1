Return-Path: <linux-kernel-owner+w=401wt.eu-S1753536AbXFNPSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbXFNPSA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 11:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141AbXFNPRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 11:17:53 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:50356 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbXFNPRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 11:17:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eMvmbyicnY34qPhsZzaYpHiVjaDgiv3O2N0W+p1iaD71kfxBjOksTG+fSgWcv6ADgfKKkz0V/FqTxu0hHD4A/i0ud+evA77dMeSmu/Bfz/i6SUa2k52ORqIdQ0mQ1h27FoTGGnKEuZA2ABiGoXx0rQLqAV1b7wbDwkmCH/Jyg6o=
Message-ID: <d120d5000706140817o5ee1a047nb90c9f787811a832@mail.gmail.com>
Date: Thu, 14 Jun 2007 11:17:51 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH -mm 4/7] PM: Remove suspend and resume support from struct device_type
Cc: "Kay Sievers" <kay.sievers@vrfy.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Alan Stern" <stern@rowland.harvard.edu>, "Greg KH" <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>, "Pavel Machek" <pavel@ucw.cz>
In-Reply-To: <200706140803.18603.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706131551.51336.rjw@sisk.pl>
	 <200706140719.28829.david-b@pacbell.net>
	 <d120d5000706140744w13f3ed50xc923f11bda7cb8e6@mail.gmail.com>
	 <200706140803.18603.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/14/07, David Brownell <david-b@pacbell.net> wrote:
> On Thursday 14 June 2007, Dmitry Torokhov wrote:
> > On 6/14/07, David Brownell <david-b@pacbell.net> wrote:
> > > On Wednesday 13 June 2007, Dmitry Torokhov wrote:
> > > > On Wednesday 13 June 2007 18:20, Kay Sievers wrote:
> > > > > Dmitry, you added this recently, is this used in any code you plan to
> > > > > merge soon?
> > > > >
> > > >
> > > > Yes, I will need it to implement input device resume (mainly to restore LED
> > > > state and repeat rate for keyboards).
> > >
> > > Why wouldn't that use the class device suspend/resume mechanism?
> > >
> >
> > Because they are not class devices anymore.
>
> Perhaps you mis-understood me:  the class level device suspend/resume
> hooks don't rely on class_device.  I observe that /sys/class/input
> still exists (2.6.22-rc4-git), so if all you mean is that it's no
> longer using class_device, that's good.

Yes, I did misunderstood you.

The reason I can't use class-wide resume support is that since we
can't have class hierarchy we have mess of different objects dumped
into single pool (input_dev, evdev. mousedev, joydev, tsdev all relate
to /sys/class/input). And so instead of having class define standard
interface for all objects in it we have to rely on something else
(struct device_type - not visible fom userspace) to separate them and
add tweaks to interface. Can you see that I am not a fan of the
design? ;)

As far as input concerned - I need to resume input_dev but not evdev,
mousedev, tsdev, etc. as they are all just different representations
of the same object.

> One part of the reason to
> stop using class_device is specifically to let framework code (like
> input, network, or rtc) receive class level suspend/resume calls.

It could be done within the class_device infrastructure as well.

> ISTR the RTC framework was the first to do that, but there's some
> work afoot to teach the network stack to use that mechanism too.
>
> Or are you referring to some input patches which I've not yet seen,
> which cause /sys/class/input to vanish?
>

No, it will stay.

-- 
Dmitry
