Return-Path: <linux-kernel-owner+w=401wt.eu-S1756694AbYEPFAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694AbYEPFAy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 01:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbYEPFAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 01:00:44 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51887 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbYEPFAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 01:00:44 -0400
Date: Thu, 15 May 2008 21:59:36 -0700
From: Greg KH <greg@kroah.com>
To: Arthur Jones <ajones@riverbed.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>,
       Arthur Jones <Arthur.Jones@riverbed.com>,
       "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
       "mszeredi@suse.cz" <mszeredi@suse.cz>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "kay.sievers@vrfy.org" <kay.sievers@vrfy.org>,
       "trond.myklebust@fys.uio.no" <trond.myklebust@fys.uio.no>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] mm: bdi: export BDI attributes in sysfs
Message-ID: <20080516045936.GA22374@kroah.com>
References: <20080513190435.GG23649@ajones-laptop.nbttech.com> <20080514144030.GD6458@ajones-laptop.nbttech.com> <E1JwiZa-0007UA-Tm@pomaz-ex.szeredi.hu> <alpine.LFD.1.10.0805151213430.3019@woody.linux-foundation.org> <E1Jwj7G-0007Zs-GB@pomaz-ex.szeredi.hu> <alpine.LFD.1.10.0805151247010.3019@woody.linux-foundation.org> <20080515210254.GA23684@kroah.com> <20080515220510.GY23649@ajones-laptop.nbttech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080515220510.GY23649@ajones-laptop.nbttech.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 03:05:10PM -0700, Arthur Jones wrote:
> Hi Greg, ...
> 
> On Thu, May 15, 2008 at 02:02:54PM -0700, Greg KH wrote:
> > On Thu, May 15, 2008 at 12:54:57PM -0700, Linus Torvalds wrote:
> > >
> > >
> > > On Thu, 15 May 2008, Miklos Szeredi wrote:
> > > >
> > > > Actually nothing should need protection.  The only problem AFAICS is
> > > > that the device_create()/dev_set_drvdata() interface is racy: somebody
> > > > can come in after the device has been created but before drvdata has
> > > > been set, and then we are in trouble.
> > >
> > > Well, I'm not sure that the locking should be at that level. Maybe the
> > > locking *should* be in the driver that does this. It may need to do other
> > > setup too, after all.
> > >
> > > Of course, doing a device_create_drvdata() thing might be the right
> > > solution, at least part of the time. Greg?
> > 
> > Here's a patch that is build tested only.
> > 
> > Can someone who can reproduce this let me know if it solves the problem?
> 
> Yes, this patch survives many power cycles
> without hitting the BUG...

Thanks again.

I've audited the whole tree and only found one other place with this
problem, the display driver class.  I've build up patches for this and
added it to my tree.  I'll let them take a spin in -next to verify I
didn't do anything stupid before sending them tomorrow to Linus.

thanks,

greg k-h
