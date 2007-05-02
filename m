Return-Path: <linux-kernel-owner+w=401wt.eu-S1751696AbXEBHgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696AbXEBHgw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 03:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754891AbXEBHgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 03:36:52 -0400
Received: from mail.gmx.net ([213.165.64.20]:36087 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751696AbXEBHgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 03:36:51 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19EtXtHZJVEJVBZ95h4AKcAALbK+P62C8CzsHp1tH
	Bke+sqsH4DrCjR
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when
	FS is under heavy write load (massive starvation)
From: Mike Galbraith <efault@gmx.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070502065355.GB15878@kernel.dk>
References: <1177660767.6567.41.camel@Homer.simpson.net>
	 <alpine.LFD.0.98.0704270806230.9964@woody.linux-foundation.org>
	 <20070502065355.GB15878@kernel.dk>
Content-Type: text/plain
Date: Wed, 02 May 2007 09:36:47 +0200
Message-Id: <1178091407.8926.24.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-02 at 08:53 +0200, Jens Axboe wrote:
> On Fri, Apr 27 2007, Linus Torvalds wrote:
> > So I do believe that we could probably do something about the IO 
> > scheduling _too_:
> > 
> >  - break up large write requests (yeah, it will make for worse IO 
> >    throughput, but if make it configurable, and especially with 
> >    controllers that don't have insane overheads per command, the 
> >    difference between 128kB requests and 16MB requests is probably not 
> >    really even noticeable - SCSI things with large per-command overheads 
> >    are just stupid)
> > 
> >    Generating huge requests will automatically mean that they are 
> >    "unbreakable" from an IO scheduler perspective, so it's bad for latency 
> >    for other reqeusts once they've started.
> 
> Overlooked this one initially... We actually don't generate huge
> requests, exactly because of that. Even if the device can do large
> requests (most SATA disks today can do 32meg), we default to 512kB as
> the largest one that we will build due to file system requests. It's
> trivial to reduce that limit, see /sys/block/<dev>/queue/max_sectors_kb.
> That controls the maximum per-request size.

For the record, I haven't been able to stall KDE for ages with
data=writeback.

	-Mike

