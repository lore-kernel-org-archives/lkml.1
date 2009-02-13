Return-Path: <linux-kernel-owner+w=401wt.eu-S1760210AbZBMBOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760210AbZBMBOw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 20:14:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753737AbZBMBOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 20:14:41 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:45947 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbZBMBOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 20:14:40 -0500
Subject: Re: vfs: Add MS_FLUSHONFSYNC mount flag
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Theodore Tso <tytso@MIT.EDU>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, fernando@kic.ac.jp,
       Ric Wheeler <rwheeler@redhat.com>
In-Reply-To: <499458C1.90105@redhat.com>
References: <20090114165952.GH6222@mit.edu>
	 <1232021211.14626.19.camel@sebastian.kern.oss.ntt.co.jp>
	 <20090115234544.GA7579@duck.suse.cz>
	 <1232109069.13775.35.camel@sebastian.kern.oss.ntt.co.jp>
	 <1232114101.13775.63.camel@sebastian.kern.oss.ntt.co.jp>
	 <20090116163039.GE10617@duck.suse.cz>
	 <1232185639.4831.18.camel@sebastian.kern.oss.ntt.co.jp>
	 <1232186449.4831.29.camel@sebastian.kern.oss.ntt.co.jp>
	 <20090119120349.GA10193@duck.suse.cz>
	 <1233135913.5399.57.camel@sebastian.kern.oss.ntt.co.jp>
	 <20090128095518.GA16554@duck.suse.cz>
	 <1234434811.15270.7.camel@sebastian.kern.oss.ntt.co.jp>
	 <1234434970.15433.4.camel@sebastian.kern.oss.ntt.co.jp>
	 <499458C1.90105@redhat.com>
Content-Type: text/plain; charset=UTF-8
Organization: NTT Open Source Software Center
Date: Fri, 13 Feb 2009 10:14:39 +0900
Message-Id: <1234487679.3795.15.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-12 at 11:13 -0600, Eric Sandeen wrote:
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
> 
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

The main reason I decided to go for the mount option approach is to be
consistent with what we do when it comes to write barriers. Treating one
as a mount option and the other as a (possibly) sysfs tunable property
seems a bit confusing to me.

Do you suggest using sysfs tunables instead?

- Fernando

