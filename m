Return-Path: <linux-kernel-owner+w=401wt.eu-S1759624AbXFAGMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759624AbXFAGMq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 02:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756264AbXFAGMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 02:12:17 -0400
Received: from brick.kernel.dk ([80.160.20.94]:9918 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758866AbXFAGMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 02:12:15 -0400
Date: Fri, 1 Jun 2007 08:11:06 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Neil Brown <neilb@suse.de>
Cc: David Chinner <dgc@sgi.com>, Phillip Susi <psusi@cfl.rr.com>,
       david@lang.hm, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       linux-raid@vger.kernel.org, Stefan Bader <Stefan.Bader@de.ibm.com>,
       Andreas Dilger <adilger@clusterfs.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems, and dm/md.
Message-ID: <20070601061105.GK32105@kernel.dk>
References: <20070529234832.GT85884050@sgi.com> <Pine.LNX.4.64.0705291653230.31474@asgard.lang.hm> <20070530061723.GY85884050@sgi.com> <Pine.LNX.4.64.0705300946220.8246@asgard.lang.hm> <20070531002011.GC85884050@sgi.com> <20070531062644.GI32105@kernel.dk> <20070531070307.GK85884050@sgi.com> <465F1479.70100@cfl.rr.com> <20070531233449.GT86004887@sgi.com> <18015.46551.209946.204238@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18015.46551.209946.204238@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01 2007, Neil Brown wrote:
> On Friday June 1, dgc@sgi.com wrote:
> > On Thu, May 31, 2007 at 02:31:21PM -0400, Phillip Susi wrote:
> > > David Chinner wrote:
> > > >That sounds like a good idea - we can leave the existing
> > > >WRITE_BARRIER behaviour unchanged and introduce a new WRITE_ORDERED
> > > >behaviour that only guarantees ordering. The filesystem can then
> > > >choose which to use where appropriate....
> > > 
> > > So what if you want a synchronous write, but DON'T care about the order? 
> > 
> > submit_bio(WRITE_SYNC, bio);
> > 
> > Already there, already used by XFS, JFS and direct I/O.
> 
> Are you sure?
> 
> You seem to be saying that WRITE_SYNC causes the write to be safe on
> media before the request returns.  That isn't my understanding.
> I think (from comments near the definition and a quick grep through
> the code) that WRITE_SYNC expedites the delivery of the request
> through the elevator, but doesn't do anything special about getting it
> onto the media.
> It essentially say "Submit this request now, don't wait for more
> request to bundle with it for better bandwidth utilisation"

That is exactly right. WRITE_SYNC doesn't give any integrity guarentees,
it's just makes sure it goes straight through the io scheduler.

-- 
Jens Axboe

