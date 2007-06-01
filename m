Return-Path: <linux-kernel-owner+w=401wt.eu-S1758117AbXFAGAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117AbXFAGAb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 02:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754831AbXFAGAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 02:00:21 -0400
Received: from ns1.suse.de ([195.135.220.2]:58556 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754608AbXFAGAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 02:00:19 -0400
From: Neil Brown <neilb@suse.de>
To: David Chinner <dgc@sgi.com>
Date: Fri, 1 Jun 2007 15:59:51 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18015.46551.209946.204238@notabene.brown>
Cc: Phillip Susi <psusi@cfl.rr.com>, Jens Axboe <jens.axboe@oracle.com>,
       david@lang.hm, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       linux-raid@vger.kernel.org, Stefan Bader <Stefan.Bader@de.ibm.com>,
       Andreas Dilger <adilger@clusterfs.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems, and dm/md.
In-Reply-To: message from David Chinner on Friday June 1
References: <20070528024559.GA85884050@sgi.com>
	<465C871F.708@cfl.rr.com>
	<20070529234832.GT85884050@sgi.com>
	<Pine.LNX.4.64.0705291653230.31474@asgard.lang.hm>
	<20070530061723.GY85884050@sgi.com>
	<Pine.LNX.4.64.0705300946220.8246@asgard.lang.hm>
	<20070531002011.GC85884050@sgi.com>
	<20070531062644.GI32105@kernel.dk>
	<20070531070307.GK85884050@sgi.com>
	<465F1479.70100@cfl.rr.com>
	<20070531233449.GT86004887@sgi.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday June 1, dgc@sgi.com wrote:
> On Thu, May 31, 2007 at 02:31:21PM -0400, Phillip Susi wrote:
> > David Chinner wrote:
> > >That sounds like a good idea - we can leave the existing
> > >WRITE_BARRIER behaviour unchanged and introduce a new WRITE_ORDERED
> > >behaviour that only guarantees ordering. The filesystem can then
> > >choose which to use where appropriate....
> > 
> > So what if you want a synchronous write, but DON'T care about the order? 
> 
> submit_bio(WRITE_SYNC, bio);
> 
> Already there, already used by XFS, JFS and direct I/O.

Are you sure?

You seem to be saying that WRITE_SYNC causes the write to be safe on
media before the request returns.  That isn't my understanding.
I think (from comments near the definition and a quick grep through
the code) that WRITE_SYNC expedites the delivery of the request
through the elevator, but doesn't do anything special about getting it
onto the media.
It essentially say "Submit this request now, don't wait for more
request to bundle with it for better bandwidth utilisation"

NeilBrown
