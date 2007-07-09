Return-Path: <linux-kernel-owner+w=401wt.eu-S1753415AbXGIGNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbXGIGNX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 02:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751067AbXGIGNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 02:13:16 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:56124 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbXGIGNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 02:13:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kpqP1tETYYuTeoVZA7pY6kzwQ4g2TjlVLjXb2YLrxmqhuWmzUzbbmBrJudko0L3kkQ6jcO2mugq4RK+yO7hj61ROCeRJLeI1e7QtnwGPoGIl8q+INQ7kkRf0orLRBjvQjEtPGPC6HDBRtzOacOg/T94XE9MSfqEjCTwLjzTKGWE=
Message-ID: <41840b750707082306n6509ee6ds3a0ccd16b6387353@mail.gmail.com>
Date: Mon, 9 Jul 2007 02:06:27 -0400
From: "Shem Multinymous" <multinymous@gmail.com>
To: "Dmitry Torokhov" <dtor@insightbb.com>
Subject: Re: [Hdaps-devel] [PATCH] hdaps - switch to using input-polldev
Cc: hdaps-devel@lists.sourceforge.net, rlove@rlove.org,
       "Linux Kernel ML" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>, "Michael Riepe" <michael@mr511.de>,
       "Henrique de Moraes Holschuh" <hmh@debian.org>
In-Reply-To: <200707090144.45557.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705252354.43730.dtor@insightbb.com>
	 <200707090053.03228.dtor@insightbb.com>
	 <41840b750707082229k7672ef8bma050289d3cde93ee@mail.gmail.com>
	 <200707090144.45557.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 7/9/07, Dmitry Torokhov <dtor@insightbb.com> wrote:
> On Monday 09 July 2007 01:29, Shem Multinymous wrote:
> > > Every input event carries a timestamp so even if there are irregularities
> > > in taking the samples you should be able to account for it.
> >
> > The issue is how good are the input event timestamps. The way it works
> > is that the EC samples the analog sensor at some fixed rate and makes
> > them available over the LPC bus. If the hdaps driver consumes these
> > samples at the same rate then the timestamps will be accurate up to a
> > small phase difference, which is mostly inconsequential. But if the
> > hdaps driver gets scheduled irregularly, its timestamps will be offset
> > by varying amounts, which will completely throw off computation (e.g.,
> > think of estimating the angular velocity).
>
> Timers do not guarantee you that they will be fired at the exact time.
> If system is under load and there are hard IRQs they will also be
> delayed.

I understand there's no guaranteed scheduling with either timers or
workqueues, but that doesn't mean we should ignore the quantitative
difference when it's so relevant.

Are there any hard numbers on this?


> > A delay of 20ms in invoking the userspace daemon is negligible, but a
> > timing variance of 20ms in the driver's measurements is devastating.
>
> Even if you know that there is such variance?

Yes, because you'll now need 4-5 samples to reasonably estimate
something like angular velocity, and 100ms are no longer negligible.


> > > Have 2nd input device's ->open() method call input_open_device() for
> > > the first one.
> >
> > Won't that create an overhead by the redundant, unused notifications?
>
> They won't leave input core so nothing really noticeable.

Sounds good, then. It's a bit of a hack, but the benefits are well
worth it (if we can resolve the scheduling issue).

  Shem
