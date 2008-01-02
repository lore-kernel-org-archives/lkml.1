Return-Path: <linux-kernel-owner+w=401wt.eu-S1758596AbYABAzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596AbYABAzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 19:55:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755994AbYABAy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 19:54:57 -0500
Received: from hs-out-0708.google.com ([64.233.178.246]:62626 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755841AbYABAy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 19:54:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jEcPVOvHolkLLNcszzYCMMh3hnqzxuLCT2VLvwej0JHrWBn6mckag2f66H7C1EbEKEvQsTAgeAaCl4B7nUZGuMZLAfuYI68Ik0yY06Z8dNp0wCAnBzI9z9lyS0AiAhBfJPvLookm/bhUe+4oGJbh1a3q4nEOfCYqc+1HUVhY+LA=
Message-ID: <a8e1da0801011654j1427d466m3971f693f0439954@mail.gmail.com>
Date: Wed, 2 Jan 2008 08:54:53 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [PATCH 01/12] Use mutex instead of semaphore in driver core
Cc: "Greg KH" <gregkh@suse.de>, "Peter Zijlstra" <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
In-Reply-To: <20071229170730.GA1351@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1198891742.6821.98.camel@twins> <1198892544.6821.103.camel@twins>
	 <a8e1da0712281752q68ec8a98kcc5f84928091a8d2@mail.gmail.com>
	 <1198893445.6821.108.camel@twins>
	 <a8e1da0712281803i11c04b37ic5e92a4c27c79b07@mail.gmail.com>
	 <a8e1da0712281836t418881fbi5c8b924ba353bf90@mail.gmail.com>
	 <20071229044200.GA16712@suse.de>
	 <a8e1da0712282106j666988acndcc5eab302a5a284@mail.gmail.com>
	 <a8e1da0712282307p3723857ex534d787f128db112@mail.gmail.com>
	 <20071229170730.GA1351@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 30, 2007 1:07 AM, Greg KH <greg@kroah.com> wrote:
>
> On Sat, Dec 29, 2007 at 03:07:30PM +0800, Dave Young wrote:
> > On Dec 29, 2007 1:06 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> > >
> > > On Dec 29, 2007 12:42 PM, Greg KH <gregkh@suse.de> wrote:
> > > > On Sat, Dec 29, 2007 at 10:36:49AM +0800, Dave Young wrote:
> > > > > >
> > > > > The full boot dmesg with lockdep output is out, there's one warnings in it :
> > > >
> > > > Please fix that warning before the next repost of these patches (along
> > > > with fixing the problem of them not being able to be applied and
> > > > successfully built at every point in the series...)
> > > >
> > >
> > > Ok, thanks, I will fix them and repost.
> > >
> >
> > Hi,
> > After digging the code, I feel hard to fix the lockdep warning due to
> > some misterious relationship with usb.
> >
> > Could someone help on this? thanks.
>
> My question back to you is why are you doing this conversion?  Have you
> found that it is needed for something?  Are there problems in the -rt
> kernels that this conversion helps with?  Or is it just a janitorial
> "convert semaphore to mutex" type thing.

Sorry for delay-reply because recently I have little free time.

Mutex is lightweighter than semaphore, the device/class is used
heavily in kernel, so I think the convert would be worth.

>
> If the latter, I would suggest dropping it, as this area is quite
> complex and I think the locking chain too deep at times for a simple
> conversion.

I admit that I did not realize the complex in the lockdep fixing when
writing the patches.

> good luck,
>
> greg k-h
>
