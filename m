Return-Path: <linux-kernel-owner+w=401wt.eu-S1754184AbYKTGNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbYKTGNe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 01:13:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752796AbYKTGN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 01:13:26 -0500
Received: from kroah.org ([198.145.64.141]:44610 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752672AbYKTGNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 01:13:25 -0500
Date: Wed, 19 Nov 2008 21:54:50 -0800
From: Greg KH <greg@kroah.com>
To: Tejun Heo <tj@kernel.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH RESEND] char_dev: add cdev->release() and convert
	cdev_alloc() to use it
Message-ID: <20081120055450.GA10821@kroah.com>
References: <20080828174807.GA18461@kroah.com> <48B6E69B.1090800@kernel.org> <20080828181720.GB23898@kroah.com> <491BEC4E.9030505@kernel.org> <492136F5.8010903@kernel.org> <20081117171717.GB31306@kroah.com> <49221CE8.1050402@kernel.org> <49221D23.8040904@kernel.org> <4922C6BB.5020203@panasas.com> <4922E622.50401@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4922E622.50401@kernel.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2008 at 12:58:26AM +0900, Tejun Heo wrote:
> Hello,
> 
> Boaz Harrosh wrote:
> > I just saw this thread for the first time and it left me confused.
> > What was the final verdict. Is this patch going in at the end?
> > Which incarnation of it? is there a public git tree I can try?
> 
> Yes it is and as posted and no there isn't no public git tree yet, I was
> planning on pushing it through Miklos' tree.
> 
> > The reason I ask is because I have just the same principal work in one of
> > my test trees. What I have is a Filesystem, osdfs, that is mounted
> > on an OSD scsi-device, which is a char-device. Now the osdfs when mounting
> > an OSD device does not use __open, like user mode it needs some kernel
> > reference counting to keep the char-device up. On the other hand
> > the actual teardown and unmap of the char-device is done from the scsi-ml
> > remove vector. So just like in sd, sr and other scsi ULDs I need to unmap
> > the device but keep the memory allocated and available until the last reference.
> > All this is usually done using the Release() of the block-device. But for me
> > I only have a char-device. Currently what I had to do is keep another kref
> > to govern the device's lifecycle and sync every thing together. A Release() at
> > the char-dev would let me reuse what's there and let me clean all that code up.
> > 
> > While Investigating the problem and compering what was done on the block-device
> > side, I've seen more then a few places that private reference counting could be
> > dropped completely, and the char-dev could be used. Off my head some of these places
> > are: 
> > 	- UBI used by UBIFS 
> > 	- sg.c which does not have a Kernel user but needs it's char device until
> > 	  scsi-Remove and/or __close()
> > 
> > and other places as well.
> 
> Hmmm... if you can use this change, I think you can push it through
> whatever tree you push patches through, things can be taken care of when
> merging or we can put it in Greg's tree and ask Miklos to pull from the
> tree first but Greg doesn't keep a stable tree.

I don't keep a stable tree?  What do you mean?  It's a quilt tree, and
it does get included in -next, so I think it does work :)

Send it to me again and I'll push it through my tree if no one else
objects.

thanks,

greg k-h
