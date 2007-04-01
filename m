Return-Path: <linux-kernel-owner+w=401wt.eu-S933700AbXDARue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933700AbXDARue (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 13:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933721AbXDARue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 13:50:34 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:53673 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933700AbXDARud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 13:50:33 -0400
Date: Sun, 1 Apr 2007 19:50:20 +0200
From: Pavel Machek <pavel@ucw.cz>
To: David Zeuthen <davidz@redhat.com>
Cc: Maxim <maximlevitsky@gmail.com>, Pete Zaitcev <zaitcev@redhat.com>,
       Alan Stern <stern@rowland.harvard.edu>, gregkh@suse.de,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: USB: on suspend to ram/disk all usb devices are replugged
Message-ID: <20070401175020.GE11146@elf.ucw.cz>
References: <200703271824.46804.maximlevitsky@gmail.com> <Pine.LNX.4.44L0.0703271306230.2558-100000@iolanthe.rowland.org> <20070327110524.975e7113.zaitcev@redhat.com> <200703280129.10197.maximlevitsky@gmail.com> <20070401152957.GA5068@ucw.cz> <1175449366.3008.120.camel@zelda.fubar.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175449366.3008.120.camel@zelda.fubar.dk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > The GNOME hath spoken?
> > 
> > > 	I also thought about that,
> > > 	
> > > 	I think that the best solution is still to hide connect/disconnect of usb devices from userspace (now it also causes corruption)
> > > 	But to refuse suspend with any usb mass storage device connected with mounted systems (and add a module param override
> > > 	 for users who know what they are doing)
> > > 
> > > 	What do you think ?
> > 
> > Agreed... and notice how easy is to do that in userspace :-))).
> 
> The problem with refusing to suspend with usb mass storage devices
> mounted is just not going to work; the way we want desktop power

Problem is that suspending _with_ removable mass storage devices
attached just will not work. User will unplug them, then complain
about corruption. Advanced user will unplug them, work with them
somewhere else, replug them, then loose filesystem.

Feel free to send patch to teach filesystems to handle this.

> management to work is that the system automatically does s2ram or s2disk
> when
> 
>  - the system is idle
>  - the user closes the laptop lid
>    (all this is of course configurable but these are the defaults
>     in many distributions of Linux.)
> 
> and the kernel refusing to suspend in these cases may result in e.g. the
> laptop melting because the lid is closed. For example, in

Check your facts. Laptops do not melt. I know, I put them into my bed,
covered with pillow, and let them complain (evo 560c). ACPI thermals
can handle that.

> gnome-power-manager we play a loud "boohoo" sound if suspend fails when
> closing the lid. It's all we can do really, the user have closed the lid
> and if we didn't alert her _in some way_ the result would be a melted
> laptop. You have to realize that people use their system in such a
> way.

You have to realize what is possible and what is not.

> Suspending when idle is really important too, since at some point there
> will be legislation (akin to accessibility, e.g. the US's section

Yep? Create the filesystem patch, then.

> And there's this: suggesting to just provide an option for people to
> override this is not useful; any sane desktop distro will use that
> override because users _expect_ that their laptop suspends when they
> close the lid and they don't really or know care whether some drive is
> connected via USB.

If you don't care or care about your data, feel free to (patch your
kernel to) suspend with removable disks mounted.

> I hate to play this card, but you may want to look at other desktop

You are indeed should know better than speaking like this on lkml.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
