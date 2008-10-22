Return-Path: <linux-kernel-owner+w=401wt.eu-S1756632AbYJVRSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632AbYJVRSU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752328AbYJVRSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:18:11 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:57476 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142AbYJVRSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:18:10 -0400
Date: Wed, 22 Oct 2008 19:17:12 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Miquel van Smoorenburg <mikevs@xs4all.net>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: disk statistics issue in 2.6.27
Message-ID: <20081022171712.GO22217@kernel.dk>
References: <20081019113102.GA18440@xs4all.net> <20081020171248.GE19428@kernel.dk> <1224686272.25437.14.camel@n2o.xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224686272.25437.14.camel@n2o.xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22 2008, Miquel van Smoorenburg wrote:
> On Mon, 2008-10-20 at 19:12 +0200, Jens Axboe wrote:
> > On Sun, Oct 19 2008, Miquel van Smoorenburg wrote:
> > > I just upgraded one of our servers in the nntp cluster to 2.6.27.1 -
> > > most of the others are running 2.6.26.something.
> > > 
> > > I noticed that the "iostat -k -x 2" output does't make any sense.
> > > The number of reads/sec and number of writes/sec are about what I
> > > would expect, and so are the other fields, but rkB/sec and wkB/sec
> > > are  completely off-scale: gigabytes read/written per second.
> >
> > Weird, I cannot reproduce this at all, iostat works fine for me in .26,
> > .27 and current -git as well. So it's just a plain SCSI drive from
> > linux, no software raid or dm?
> 
> It's a 3-disk hardware RAID5 array, Adaptec 2005S, dpt_i2o driver.
> 
> > Are the reported values in iostat any sort of multiple of the real
> > throughtput, or is is just insanely large?
> 
> It looks like it's a multiple, but it appears to vary between 128 and
> 512, and is different for reads and writes, so I do not know what to
> make of it.
> 
> I tried to reproduce it on different systems - on another box with a
> 2010S controller I'm seeing the same thing. But on a different box with
> SATA drives I cannot reproduce the problem.
> 
> Thanks for looking at this. I guess I'll have to start putting debug
> statements in block/gendisk.c to find out what's wrong. I might not have
> time for it until after next week though, but I won't give up :)

It's all really weird, especially if you see it on drivers both using
the SCSI layer. And it's a multiple of the transfer size, then it can't
be something like requeues skewing the count. But do look into it, I'll
do some testing on various drivers tomorrow as well.

-- 
Jens Axboe

