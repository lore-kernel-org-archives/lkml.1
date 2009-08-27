Return-Path: <linux-kernel-owner+w=401wt.eu-S1752635AbZH0NC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbZH0NC6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 09:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbZH0NC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 09:02:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43987 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525AbZH0NC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 09:02:57 -0400
Date: Thu, 27 Aug 2009 15:02:52 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       chris.mason@oracle.com, jack@suse.cz, tytso@mit.edu, adilger@sun.com,
       swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, mfasheh@suse.com,
       joel.becker@oracle.com
Subject: Re: [PATCH] notes on volatile write caches vs fdatasync
Message-ID: <20090827130252.GC14240@duck.novell.com>
References: <20090827011624.GA10405@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090827011624.GA10405@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

On Thu 27-08-09 03:16:24, Christoph Hellwig wrote:
> There are two related issues when dealing with volatile write caches,
> the popular and beaten to death one are write barriers to guarantee
> write ordering and stable storage for log writes.  For this post
> I assume naively this works perfectly for all filesystems supporting it.
> 
> The second issue are plain cache flush.  Yes, they happen to be the
> base for the barrier implementation on all common disks in Linux, but
> there are cases where we need to issue them even without a log barrier.
> 
> Think about a plain write into a file that is already fully allocated.
> Or the O_DIRECT version of them same.  If we do an fdatasync after these
> we really do expect the write to really be on disk, not just in the disk
> cache, right?  The same is true for O_SYNC, but I ignore it for this
> write out as with Jan's patch series O_SYNC writes will be implemented
> by a range-fdatasync after the actual write, so after that this sync
> section covers it, too.
  I've noticed this as well when we were tracking some problems Pavel
Machek found with his USB stick. I even wrote a patch at the time
  http://osdir.com/ml/linux-ext4/2009-01/msg00015.html
but it somehow died out. Now, the situation should be simpler with
fsync paths cleaned up... BTW: People wanted this to be configurable per
block device which probably makes sence...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
