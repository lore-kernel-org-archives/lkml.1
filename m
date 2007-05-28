Return-Path: <linux-kernel-owner+w=401wt.eu-S1760635AbXE1C61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760635AbXE1C61 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 22:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbXE1C6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 22:58:16 -0400
Received: from ns1.suse.de ([195.135.220.2]:38283 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104AbXE1C6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 22:58:14 -0400
From: Neil Brown <neilb@suse.de>
To: David Chinner <dgc@sgi.com>
Date: Mon, 28 May 2007 12:57:53 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18010.17713.76863.245176@notabene.brown>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com, linux-raid@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, Phillip Susi <psusi@cfl.rr.com>,
       Stefan Bader <Stefan.Bader@de.ibm.com>,
       Andreas Dilger <adilger@clusterfs.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems, and dm/md.
In-Reply-To: message from David Chinner on Monday May 28
References: <18006.38689.818186.221707@notabene.brown>
	<18010.12472.209452.148229@notabene.brown>
	<20070528024559.GA85884050@sgi.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday May 28, dgc@sgi.com wrote:
> On Mon, May 28, 2007 at 11:30:32AM +1000, Neil Brown wrote:
> > 
> > Thanks everyone for your input.  There was some very valuable
> > observations in the various emails.
> > I will try to pull most of it together and bring out what seem to be
> > the important points.
> > 
> > 
> > 1/ A BIO_RW_BARRIER request should never fail with -EOPNOTSUP.
> 
> Sounds good to me, but how do we test to see if the underlying
> device supports barriers? Do we just assume that they do and
> only change behaviour if -o nobarrier is specified in the mount
> options?
> 

What exactly do you want to know, and why do you care?

The idea is that every "struct block_device" supports barriers.  If the
underlying hardware doesn't support them directly, then they get
simulated by draining the queue and issuing a flush.
Theoretically there could be devices which have a write-back cache
that cannot be flushed, and you couldn't implement barriers on such a
device.  So throw it out and buy another?

As far as I can tell, the only thing XFS does differently with devices
that don't support barriers is that it prints a warning message to the
kernel logs.  If the underlying device printed the message when it
detected that barriers couldn't be supported, XFS wouldn't need to
care at all.

NeilBrown
