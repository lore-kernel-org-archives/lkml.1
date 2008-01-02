Return-Path: <linux-kernel-owner+w=401wt.eu-S1755713AbYABFTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713AbYABFTt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 00:19:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbYABFTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 00:19:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:43758 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261AbYABFTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 00:19:39 -0500
Date: Tue, 1 Jan 2008 21:18:28 -0800
From: Greg KH <gregkh@suse.de>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Greg KH <greg@kroah.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 01/12] Use mutex instead of semaphore in driver core
Message-ID: <20080102051828.GA24431@suse.de>
References: <1198892544.6821.103.camel@twins> <a8e1da0712281752q68ec8a98kcc5f84928091a8d2@mail.gmail.com> <1198893445.6821.108.camel@twins> <a8e1da0712281803i11c04b37ic5e92a4c27c79b07@mail.gmail.com> <a8e1da0712281836t418881fbi5c8b924ba353bf90@mail.gmail.com> <20071229044200.GA16712@suse.de> <a8e1da0712282106j666988acndcc5eab302a5a284@mail.gmail.com> <a8e1da0712282307p3723857ex534d787f128db112@mail.gmail.com> <20071229170730.GA1351@kroah.com> <a8e1da0801011654j1427d466m3971f693f0439954@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0801011654j1427d466m3971f693f0439954@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2008 at 08:54:53AM +0800, Dave Young wrote:
> On Dec 30, 2007 1:07 AM, Greg KH <greg@kroah.com> wrote:
> >
> > On Sat, Dec 29, 2007 at 03:07:30PM +0800, Dave Young wrote:
> > > On Dec 29, 2007 1:06 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> > > >
> > > > On Dec 29, 2007 12:42 PM, Greg KH <gregkh@suse.de> wrote:
> > > > > On Sat, Dec 29, 2007 at 10:36:49AM +0800, Dave Young wrote:
> > > > > > >
> > > > > > The full boot dmesg with lockdep output is out, there's one warnings in it :
> > > > >
> > > > > Please fix that warning before the next repost of these patches (along
> > > > > with fixing the problem of them not being able to be applied and
> > > > > successfully built at every point in the series...)
> > > > >
> > > >
> > > > Ok, thanks, I will fix them and repost.
> > > >
> > >
> > > Hi,
> > > After digging the code, I feel hard to fix the lockdep warning due to
> > > some misterious relationship with usb.
> > >
> > > Could someone help on this? thanks.
> >
> > My question back to you is why are you doing this conversion?  Have you
> > found that it is needed for something?  Are there problems in the -rt
> > kernels that this conversion helps with?  Or is it just a janitorial
> > "convert semaphore to mutex" type thing.
> 
> Sorry for delay-reply because recently I have little free time.
> 
> Mutex is lightweighter than semaphore, the device/class is used
> heavily in kernel, so I think the convert would be worth.

But is the usage of this semaphore in the class code really a problem?
Has it been seen to cause issues anywhere?  Does it show up on any
benchmarks as being something that really needs to be replaced?

All of the places this is used should be on a "slow" code-path, and the
semaphores themselves should very rarely ever have to block anyone under
normal usages.

Without any real problems being reported for this, I wouldn't worry
about this, the effort involved is non-trivial as you are quickly
finding out :)

good luck,

greg k-h
