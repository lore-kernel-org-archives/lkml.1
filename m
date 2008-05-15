Return-Path: <linux-kernel-owner+w=401wt.eu-S1760180AbYEOOUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760180AbYEOOUB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 10:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754469AbYEOOTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 10:19:54 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36952 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283AbYEOOTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 10:19:53 -0400
Date: Thu, 15 May 2008 16:27:29 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: [announce] "kill the Big Kernel Lock (BKL)" tree
Message-ID: <20080515142729.GA30216@one.firstfloor.org>
References: <20080514174955.GA515@elte.hu> <87fxsk7n7e.fsf@basil.nowhere.org> <20080514220034.51eae9e0@core> <482B5614.3060203@firstfloor.org> <20080514221957.6edb2d60@core> <alpine.LFD.1.10.0805141435540.3019@woody.linux-foundation.org> <482B61C2.9070106@firstfloor.org> <20080515143430.6a94508d@core>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080515143430.6a94508d@core>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 02:34:30PM +0100, Alan Cox wrote:
> > >  - superblock read/write.
> > > 
> > - fasync
> > 
> > [had some patches for "fasync_locked", not sure if it's worth it]
> > 
> > - character device open
> 
> file structures - as well

How so?

> 
> > I tried to recruit kernel janitors some time ago to just do all the
> > ioctl -> ioctl_unlocked/explicit lock_kernel changes. There were a few
> > patches generated but the effort died down then.
> 
> Start at the other end - you can't fix the ioctls until you fix what the
> ioctls interact with. That ends up at the basic data structure and once
> you fix those the rest just starts to fall into place.

In my experience there's usually not too much interaction with other
kernel structures at the random driver ioctl level. I'm sure tty is
different, but it's probably not typical.

-Andi
> 
