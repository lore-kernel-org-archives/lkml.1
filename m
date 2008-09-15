Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbYIOFbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbYIOFbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 01:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750915AbYIOFbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 01:31:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43941 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbYIOFbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 01:31:12 -0400
Date: Mon, 15 Sep 2008 06:30:48 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Osterlund <petero2@telia.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Cox <alan@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: 2.6.27-rc4-git1: Reported regressions from 2.6.26
Message-ID: <20080915053048.GE28946@ZenIV.linux.org.uk>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <alpine.LFD.1.10.0808241120460.3363@nehalem.linux-foundation.org> <m3k5e2qkk2.fsf@telia.com> <alpine.LFD.1.10.0808271335260.3363@nehalem.linux-foundation.org> <20080828135245.GA12410@infradead.org> <20080902072642.GX20055@kernel.dk> <20080903020629.GS28946@ZenIV.linux.org.uk> <20080904101326.GD20055@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080904101326.GD20055@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2008 at 12:13:27PM +0200, Jens Axboe wrote:
> On Wed, Sep 03 2008, Al Viro wrote:
> > On Tue, Sep 02, 2008 at 09:26:43AM +0200, Jens Axboe wrote:
> > > > Actually both interfaces are a fscking disaster.  The right things to
> > > > pass is neither and inode nor a file but a struct block_device.  Al had
> > > > all this work done a while and it just needs rebasing to a current tree:
> > > > 
> > > > 	http://git.kernel.org/?p=linux/kernel/git/viro/bdev.git;a=summary
> > > 
> > > Completely agreed. Al, I remember talking to you about this at the
> > > storage summit back in february. What are your current plans wrt moving
> > > this forward?
> > 
> > Rebased, with nfs parts of fmode_t patch taken out (irrelevant for
> > bdev anyway and really better off in intent-killing queue).  Other
> > than that, it's a straight port...  Same place, same branch.
> 
> So what's your plan with this - 2.6.28?

Yes.  The only nastiness is around drivers/ide - there it gets a bunch of
annoying conflicts from the ide-{disk,floppy}_ioctl.c splitoff.  Other than
that, it's trivially ported on top of current linux-next.  Merge order is
going to be interesting - depending on whether block merge happens before
or after ide one.

I'm going to put linux-next-based series on kernel.org tonight, before
going to Portland...
