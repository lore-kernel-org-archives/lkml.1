Return-Path: <linux-kernel-owner+w=401wt.eu-S1765086AbYEOUmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765086AbYEOUmh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 16:42:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757057AbYEOUlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 16:41:50 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57850 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756526AbYEOUlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 16:41:50 -0400
Date: Thu, 15 May 2008 13:40:59 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, ajones@riverbed.com,
       a.p.zijlstra@chello.nl, mszeredi@suse.cz, akpm@linux-foundation.org,
       kay.sievers@vrfy.org, trond.myklebust@fys.uio.no,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] mm: bdi: export BDI attributes in sysfs
Message-ID: <20080515204059.GA19417@kroah.com>
References: <20080513190435.GG23649@ajones-laptop.nbttech.com> <20080514144030.GD6458@ajones-laptop.nbttech.com> <E1JwiZa-0007UA-Tm@pomaz-ex.szeredi.hu> <alpine.LFD.1.10.0805151213430.3019@woody.linux-foundation.org> <E1Jwj7G-0007Zs-GB@pomaz-ex.szeredi.hu> <alpine.LFD.1.10.0805151247010.3019@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805151247010.3019@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 12:54:57PM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 15 May 2008, Miklos Szeredi wrote:
> > 
> > Actually nothing should need protection.  The only problem AFAICS is
> > that the device_create()/dev_set_drvdata() interface is racy: somebody
> > can come in after the device has been created but before drvdata has
> > been set, and then we are in trouble.
> 
> Well, I'm not sure that the locking should be at that level. Maybe the 
> locking *should* be in the driver that does this. It may need to do other 
> setup too, after all.
> 
> Of course, doing a device_create_drvdata() thing might be the right 
> solution, at least part of the time. Greg?

Yes, you are right, let me go knock that together...

thanks,

greg k-h
