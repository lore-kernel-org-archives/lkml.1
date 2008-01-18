Return-Path: <linux-kernel-owner+w=401wt.eu-S1758148AbYARGVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148AbYARGVe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 01:21:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750946AbYARGVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 01:21:24 -0500
Received: from ns.suse.de ([195.135.220.2]:36475 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843AbYARGVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 01:21:23 -0500
Date: Thu, 17 Jan 2008 22:25:00 -0800
From: Greg KH <gregkh@suse.de>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Dave Young <hidave.darkstar@gmail.com>,
       Jarek Poplawski <jarkao2@gmail.com>,
       Alan Stern <stern@rowland.harvard.edu>, stefanr@s5r6.in-berlin.de,
       David Brownell <david-b@pacbell.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] driver-core : convert semaphore to mutex in struct
	class
Message-ID: <20080118062500.GA23840@suse.de>
References: <20080117194728.GA2598@ami.dom.local> <Pine.LNX.4.44L0.0801171448590.5731-100000@iolanthe.rowland.org> <20080117203155.GA2791@ami.dom.local> <20080117232626.GC2905@ami.dom.local> <a8e1da0801171742o5520c3d9v577979f527f1a977@mail.gmail.com> <3ae72650801171755k85c4245i3b4c46a84ae8f52d@mail.gmail.com> <a8e1da0801171828n26b37be0oa8b1c3cbec5f83cb@mail.gmail.com> <1200626323.5640.21.camel@lov.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200626323.5640.21.camel@lov.site>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 04:18:43AM +0100, Kay Sievers wrote:
> On Fri, 2008-01-18 at 10:28 +0800, Dave Young wrote:
> > Then what's your opinon about the lockdep warning fix? I wonder
> > whether the "soon" means we should do mutex convert after the
> > class_device going away?
> 
> Yeah, might be better to wait until class_device is gone, otherwise you
> may need to fix stuff that is just going to be removed. Your change to
> have iterators for the class devices look like a nice preparation for
> future changes though.
> 
> Our rough plan is:
>  2.6.25:
>   - get the ~100 patches in Greg's tree (in -mm) merged :)
>  2.6.26:
> ???  - remove the 20 char limit in "struct device"
>   - get rid of "struct class_device"
>  2.6.27
>   - merge most of "struct class" and "struct bus_type" and have
>     only one type of list and iterator for all devices of all subsystems
>  2.6.27+
>   - allow multiple "drivers" to bind a single device (now that the
>     difference between class and bus devices is gone)

I'm hoping that we might be able to get this last one by 2.6.26 or .27,
depending on how much time I get to work on it...

Other than that, I agree with this timeline.

thanks,

greg k-h
