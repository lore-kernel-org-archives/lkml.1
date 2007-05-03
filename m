Return-Path: <linux-kernel-owner+w=401wt.eu-S2993266AbXECPag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993266AbXECPag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 11:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993282AbXECPag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 11:30:36 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4845 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1162129AbXECP35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 11:29:57 -0400
Date: Thu, 3 May 2007 15:10:47 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: nigel@nigel.suspend2.net, Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
Message-ID: <20070503151047.GB3866@ucw.cz>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <1177654110.4737.91.camel@nigel.suspend2.net> <Pine.LNX.4.64.0704270910190.18521@sbz-30.cs.Helsinki.FI> <200704272324.43359.rjw@sisk.pl> <alpine.LFD.0.98.0704271442160.9964@woody.linux-foundation.org> <1177711666.4737.176.camel@nigel.suspend2.net> <35EFC5BA-D16B-41BE-A641-AEA8CCC9E0BE@mac.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35EFC5BA-D16B-41BE-A641-AEA8CCC9E0BE@mac.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>It makes it harder to debug (wouldn't it be *nice* to 
> >>just ssh in,  and do
> >>	gdb -p <snapshotter>
> >
> >Make the machine being suspended a VM and you can 
> >already do that.
> 
> >>when something goes wrong?) but we also *depend* on 
> >>user space for  various things (the same way we depend 
> >>on kernel threads, and why  it has been such a total 
> >>disaster to try to freeze the kernel  threads too!). 
> >>For example, if you want to do graphical stuff,  just 
> >>using X would be quite nice,  wouldn't it?
> >
> >But in doing so you make the contents of the disk 
> >inconsistent with  the state you've just snapshotted, 
> >leading to filesystem  corruption. Even if you modify 
> >filesystems to do checkpointing  (which is what we're 
> >really talking about), you still also have the  problem 
> >that your snapshot has to be stored somewhere before 
> >you  write it to disk, so you also have to either [snip]
> 
> Actually, it's a lot simpler than that.  We can just 
> combine the  device-mapper snapshot with a VM+kernel 
> snapshot system call and be  almost done:
> 
>   sys_snapshot(dev_t snapblockdev, int __user 
>   *snapshotfd);
> 
> When sys_snapshot is run, the kernel does:
> 
> 1)  Sequentially freeze mounted filesystems using 
> blockdev freezing.   If it's an fs that doesn't support 
> freezing then either fail or force- remount-ro that fs 
> and downgrade all its filedescriptors to RO.   Doesn't 
> need extra locking since process which try to do IO 
> either  succeed before the freeze call returns for that 
> blockdev or sleep on  the unfreeze of that blockdev.  
> Filesystems are synchronized and made  clean.

How mature is freezing filesystems -- will it work on at least ext2/3
and vfat?

What happens if you try to boot and filesystems are frozen from
previous run?

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
