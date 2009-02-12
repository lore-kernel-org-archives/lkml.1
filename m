Return-Path: <linux-kernel-owner+w=401wt.eu-S1760861AbZBLVXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760861AbZBLVXV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 16:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757201AbZBLVXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 16:23:10 -0500
Received: from mail.suse.de ([195.135.220.2]:40998 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbZBLVXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 16:23:09 -0500
Date: Thu, 12 Feb 2009 22:23:04 +0100
From: Jan Kara <jack@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>,
       Theodore Tso <tytso@MIT.EDU>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, fernando@kic.ac.jp,
       Ric Wheeler <rwheeler@redhat.com>
Subject: Re: vfs: Add MS_FLUSHONFSYNC mount flag
Message-ID: <20090212212304.GA7935@duck.suse.cz>
References: <1232114101.13775.63.camel@sebastian.kern.oss.ntt.co.jp> <20090116163039.GE10617@duck.suse.cz> <1232185639.4831.18.camel@sebastian.kern.oss.ntt.co.jp> <1232186449.4831.29.camel@sebastian.kern.oss.ntt.co.jp> <20090119120349.GA10193@duck.suse.cz> <1233135913.5399.57.camel@sebastian.kern.oss.ntt.co.jp> <20090128095518.GA16554@duck.suse.cz> <1234434811.15270.7.camel@sebastian.kern.oss.ntt.co.jp> <1234434970.15433.4.camel@sebastian.kern.oss.ntt.co.jp> <499458C1.90105@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <499458C1.90105@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 12-02-09 11:13:37, Eric Sandeen wrote:
> Fernando Luis Vázquez Cao wrote:
> > This mount flag will be used to determine whether the block device's write
> > cache should be flush or not on fsync()/fdatasync().
> > 
> > Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
> > ---
> 
> Again, apologies for chiming in late.
> 
> But wouldn't it be better to make this a block device property rather
> than a new filesystem mount option?
  Hum, that's an interesting idea. Yes, probably it makes even more sence
than a global mount option.

> That way the filesystem can always do "the right thing" and call the
> blkdev flush on fsync.
> 
> The block device *could* choose to ignore this in hardware if it knows
> it's built with a nonvolatile write cache or if it has no write cache.
> 
> Somewhere in the middle, if an administrator knows they have a UPS they
> trust and hardware that stays connected to it, they could tune the bdev
> to ignore these flush requests.
> 
> Also that way if you have 8 partitions on a battery-backed blockdev, you
> can tune it once, instead of needing to mount all 8 filesystems with the
> new option.
  Yes, but OTOH we should give sysadmin a possibility to enable / disable
it on just some partitions. I don't see a reasonable use for that but people
tend to do strange things ;) and here isn't probably a strong reason to not
allow them.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
