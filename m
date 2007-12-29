Return-Path: <linux-kernel-owner+w=401wt.eu-S1756309AbXL2RIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309AbXL2RIT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 12:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbXL2RIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 12:08:09 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33953 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbXL2RII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 12:08:08 -0500
Date: Sat, 29 Dec 2007 09:07:30 -0800
From: Greg KH <greg@kroah.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Greg KH <gregkh@suse.de>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 01/12] Use mutex instead of semaphore in driver core
Message-ID: <20071229170730.GA1351@kroah.com>
References: <1198891742.6821.98.camel@twins> <a8e1da0712281736p6dcc3f05vdb3b8ed9618e0147@mail.gmail.com> <1198892544.6821.103.camel@twins> <a8e1da0712281752q68ec8a98kcc5f84928091a8d2@mail.gmail.com> <1198893445.6821.108.camel@twins> <a8e1da0712281803i11c04b37ic5e92a4c27c79b07@mail.gmail.com> <a8e1da0712281836t418881fbi5c8b924ba353bf90@mail.gmail.com> <20071229044200.GA16712@suse.de> <a8e1da0712282106j666988acndcc5eab302a5a284@mail.gmail.com> <a8e1da0712282307p3723857ex534d787f128db112@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0712282307p3723857ex534d787f128db112@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 29, 2007 at 03:07:30PM +0800, Dave Young wrote:
> On Dec 29, 2007 1:06 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> >
> > On Dec 29, 2007 12:42 PM, Greg KH <gregkh@suse.de> wrote:
> > > On Sat, Dec 29, 2007 at 10:36:49AM +0800, Dave Young wrote:
> > > > >
> > > > The full boot dmesg with lockdep output is out, there's one warnings in it :
> > >
> > > Please fix that warning before the next repost of these patches (along
> > > with fixing the problem of them not being able to be applied and
> > > successfully built at every point in the series...)
> > >
> >
> > Ok, thanks, I will fix them and repost.
> >
> 
> Hi,
> After digging the code, I feel hard to fix the lockdep warning due to
> some misterious relationship with usb.
> 
> Could someone help on this? thanks.

My question back to you is why are you doing this conversion?  Have you
found that it is needed for something?  Are there problems in the -rt
kernels that this conversion helps with?  Or is it just a janitorial
"convert semaphore to mutex" type thing.

If the latter, I would suggest dropping it, as this area is quite
complex and I think the locking chain too deep at times for a simple
conversion.

good luck,

greg k-h
