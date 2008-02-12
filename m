Return-Path: <linux-kernel-owner+w=401wt.eu-S1764686AbYBLQqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764686AbYBLQqf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 11:46:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763425AbYBLQou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 11:44:50 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42346 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764121AbYBLQos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 11:44:48 -0500
Date: Tue, 12 Feb 2008 08:42:32 -0800
From: Greg KH <greg@kroah.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: multiple drivers, single device (was Re: Announce: Linux-next
	(Or Andrew's dream  :-)))
Message-ID: <20080212164232.GA326@kroah.com>
References: <20080212120208.f7168a91.sfr@canb.auug.org.au> <20080212042133.GA4625@kroah.com> <47B1C829.8020800@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B1C829.8020800@garzik.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 11:24:09AM -0500, Jeff Garzik wrote:
> Greg KH wrote:
>> [1] Hopefully the "multiple drivers for a single device" feature people
>> have been asking for for years will be landing soon, of course the
>> number of odd places in the kernel that made the assumption that we
>> could only have one driver per device is causing lots of fun...
>
>
> Color me a bit skeptical...  we've always had this capability really: for 
> multi-function devices, just register as many subsystems as you need.  If 
> your device is a network _and_ SCSI device, you can do that with today's 
> APIs.

Yes, but that's not the type of devices this is for.

> I just went through a long thread (e1000/e1000e) explaining how much pain 
> multiple drivers for the same PCI ID cause on the distro side of things...  
> its a mess.  In each case you must write special case code to resolve the 
> ambiguity.  You never know which is the best driver to choose, or proper 
> module load order -- which may vary depending on machine, not just static 
> information captured from a kernel Makefile.

Oh, I agree, multiple drivers for the same functionality is not a nice
thing from a distro standpoint.

The work I'm doing here is for stupid PCI firmware engineers, who have
created devices that are different things, all bound up under the same
PCI device.  I'm thinking of watchdog timers and random number
generator and i2c controller on the same PCI device, or even the more
basic, frame buffer and DRM access to the same PCI video device.

The OLPC is a good example of hardware that needs this kind of
functionality.

In order to take advantage of the "multiple drivers per device" all
drivers need to guarantee to play nice with others, as they need to be
aware that other drivers will be sharing the hardware.

I'll write up more details later this week, if I get this stuff to work
properly :)

thanks,

greg k-h
