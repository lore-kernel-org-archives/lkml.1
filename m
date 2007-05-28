Return-Path: <linux-kernel-owner+w=401wt.eu-S1759202AbXE1EaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759202AbXE1EaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 00:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753605AbXE1EaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 00:30:05 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50429 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753189AbXE1EaB (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 00:30:01 -0400
Date: Mon, 28 May 2007 14:29:26 +1000
From: David Chinner <dgc@sgi.com>
To: Neil Brown <neilb@suse.de>
Cc: David Chinner <dgc@sgi.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Phillip Susi <psusi@cfl.rr.com>, Stefan Bader <Stefan.Bader@de.ibm.com>,
       Andreas Dilger <adilger@clusterfs.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems, and dm/md.
Message-ID: <20070528042926.GC85884050@sgi.com>
References: <18006.38689.818186.221707@notabene.brown> <18010.12472.209452.148229@notabene.brown> <20070528024559.GA85884050@sgi.com> <18010.17713.76863.245176@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18010.17713.76863.245176@notabene.brown>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2007 at 12:57:53PM +1000, Neil Brown wrote:
> On Monday May 28, dgc@sgi.com wrote:
> > On Mon, May 28, 2007 at 11:30:32AM +1000, Neil Brown wrote:
> > > Thanks everyone for your input.  There was some very valuable
> > > observations in the various emails.
> > > I will try to pull most of it together and bring out what seem to be
> > > the important points.
> > > 
> > > 1/ A BIO_RW_BARRIER request should never fail with -EOPNOTSUP.
> > 
> > Sounds good to me, but how do we test to see if the underlying
> > device supports barriers? Do we just assume that they do and
> > only change behaviour if -o nobarrier is specified in the mount
> > options?
> 
> What exactly do you want to know, and why do you care?

If someone explicitly mounts "-o barrier" and the underlying device
cannot do it, then we want to issue a warning or reject the
mount.

> The idea is that every "struct block_device" supports barriers.  If the
> underlying hardware doesn't support them directly, then they get
> simulated by draining the queue and issuing a flush.

Ok. But you also seem to be implying that there will be devices that
cannot support barriers.

Even if all devices do eventually support barriers, it may take some
time before we reach that goal.  Why not start by making it easy to
determine what the capabilities of each device are. This can then be
removed once we reach the holy grail....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
