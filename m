Return-Path: <linux-kernel-owner+w=401wt.eu-S1759278AbZANOpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759278AbZANOpZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 09:45:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752358AbZANOpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 09:45:07 -0500
Received: from brick.kernel.dk ([93.163.65.50]:16996 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253AbZANOpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 09:45:06 -0500
Date: Wed, 14 Jan 2009 15:43:46 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Theodore Tso <tytso@MIT.EDU>
Cc: Jan Kara <jack@suse.cz>,
       Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>, sandeen@redhat.com
Subject: Re: ext2 + -osync: not as easy as it seems
Message-ID: <20090114144345.GD30821@kernel.dk>
References: <20090113131418.GD30352@atrey.karlin.mff.cuni.cz> <20090113134503.41318144@lxorguk.ukuu.org.uk> <20090113140347.GD17664@mit.edu> <20090113143011.GB10064@duck.suse.cz> <1231904239.11640.38.camel@sebastian.kern.oss.ntt.co.jp> <20090114103532.GA18834@duck.suse.cz> <20090114132146.GC6222@mit.edu> <20090114140532.GC19950@duck.suse.cz> <20090114140802.GC30821@kernel.dk> <20090114143455.GE6222@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114143455.GE6222@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14 2009, Theodore Tso wrote:
> On Wed, Jan 14, 2009 at 03:08:04PM +0100, Jens Axboe wrote:
> > 
> > It also guarentees that when you get a completion for that barrier
> > write, it's on safe storage. Think of it as a flush-write-flush
> > operation, in the presence of write back caching.
> > 
> 
> Is that true even if the barrier isn't attached to a write operation,
> i.e., when using
> 
>       blkdev_issue_flush(sb, NULL);
> 
> ?

No, since there's no specific write to protect in that case. The above
will flush existing writes to platter, but has no bearing on writes
submitted later (other than the obvious effect that they will be on disk
later then previously submitted writes). So for blkdev_issue_flush(),
when that returns with good status, then the writes are safe. In the
absence of the barrier flag on a write, completion of that write may
just mean that the disk drive is aware of it, not that it is in any way
safe.

The hardware may even treat the flush as a noop and do absolutely
nothing, which is perfectly valid if it guarantees us that it will never
lose a submitted write.

-- 
Jens Axboe

