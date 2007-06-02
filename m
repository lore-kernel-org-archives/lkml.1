Return-Path: <linux-kernel-owner+w=401wt.eu-S1760710AbXFBOgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760710AbXFBOgQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 10:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758915AbXFBOgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 10:36:05 -0400
Received: from brick.kernel.dk ([80.160.20.94]:17457 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757243AbXFBOgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 10:36:04 -0400
Date: Sat, 2 Jun 2007 16:34:39 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <htejun@gmail.com>
Cc: David Chinner <dgc@sgi.com>, david@lang.hm,
       Phillip Susi <psusi@cfl.rr.com>, Neil Brown <neilb@suse.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com, linux-raid@vger.kernel.org,
       Stefan Bader <Stefan.Bader@de.ibm.com>,
       Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems,   and dm/md.
Message-ID: <20070602143438.GB32105@kernel.dk>
References: <Pine.LNX.4.64.0705291653230.31474@asgard.lang.hm> <20070530061723.GY85884050@sgi.com> <Pine.LNX.4.64.0705300946220.8246@asgard.lang.hm> <20070531002011.GC85884050@sgi.com> <20070531062644.GI32105@kernel.dk> <20070531070307.GK85884050@sgi.com> <20070531070656.GK32105@kernel.dk> <465F8F71.20302@gmail.com> <20070601082140.GP32105@kernel.dk> <46613666.7010800@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46613666.7010800@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 02 2007, Tejun Heo wrote:
> Hello,
> 
> Jens Axboe wrote:
> >> Would that be very different from issuing barrier and not waiting for
> >> its completion?  For ATA and SCSI, we'll have to flush write back cache
> >> anyway, so I don't see how we can get performance advantage by
> >> implementing separate WRITE_ORDERED.  I think zero-length barrier
> >> (haven't looked at the code yet, still recovering from jet lag :-) can
> >> serve as genuine barrier without the extra write tho.
> > 
> > As always, it depends :-)
> > 
> > If you are doing pure flush barriers, then there's no difference. Unless
> > you only guarantee ordering wrt previously submitted requests, in which
> > case you can eliminate the post flush.
> > 
> > If you are doing ordered tags, then just setting the ordered bit is
> > enough. That is different from the barrier in that we don't need a flush
> > of FUA bit set.
> 
> Hmmm... I'm feeling dense.  Zero-length barrier also requires only one
> flush to separate requests before and after it (haven't looked at the
> code yet, will soon).  Can you enlighten me?

Yeah, that's what the zero-length barrier implementation I posted does.
Not sure if you have a question beyond that, if so fire away :-)

-- 
Jens Axboe

