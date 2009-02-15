Return-Path: <linux-kernel-owner+w=401wt.eu-S1752628AbZBOHXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbZBOHXh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 02:23:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751260AbZBOHX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 02:23:28 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:55744 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbZBOHX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 02:23:28 -0500
Subject: Re: vfs: Add MS_FLUSHONFSYNC mount flag
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeff Garzik <jeff@garzik.org>, Eric Sandeen <sandeen@redhat.com>,
       Jan Kara <jack@suse.cz>, Theodore Tso <tytso@MIT.EDU>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, fernando@kic.ac.jp,
       Ric Wheeler <rwheeler@redhat.com>
In-Reply-To: <20090214153626.GA3973@infradead.org>
References: <20090116163039.GE10617@duck.suse.cz>
	 <1232185639.4831.18.camel@sebastian.kern.oss.ntt.co.jp>
	 <1232186449.4831.29.camel@sebastian.kern.oss.ntt.co.jp>
	 <20090119120349.GA10193@duck.suse.cz>
	 <1233135913.5399.57.camel@sebastian.kern.oss.ntt.co.jp>
	 <20090128095518.GA16554@duck.suse.cz>
	 <1234434811.15270.7.camel@sebastian.kern.oss.ntt.co.jp>
	 <1234434970.15433.4.camel@sebastian.kern.oss.ntt.co.jp>
	 <499458C1.90105@redhat.com> <49945C90.3010104@garzik.org>
	 <20090214153626.GA3973@infradead.org>
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Sun, 15 Feb 2009 16:23:26 +0900
Message-Id: <1234682606.19783.222.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-02-14 at 10:36 -0500, Christoph Hellwig wrote:
> On Thu, Feb 12, 2009 at 12:29:52PM -0500, Jeff Garzik wrote:
> >> The block device *could* choose to ignore this in hardware if it knows
> >> it's built with a nonvolatile write cache or if it has no write cache.
> >
> > That would certainly be my preference -- turn this ON by default, and  
> > them if a layer NEEDS to ignore it, it can.
> 
> Yeah, and we should integrate this with the barriers settings.
> 
> I think the right setup is:
> 
>  - each gendisk has a variable to indicate if we have a write-back
>    cache, which is filled from scsi inquiry data (or whatever the
>    equivalent in the storage protocol is), but we allow an override
>    from userspace if the admin knows better (if he really does or
>    wants to play fast and lose is the admin's business)
>  - filesystems do the right things by using barriers and cache flushes
>    if they see the underlying device needs it.

That makes sense, but the contentious issue seems to be whether the
override from userspace you mention should take the form of mount option
or per-block device sysfs tunable instead. Making this override
(flushonfsync in my patches) be a mount option would be consistent with
what filesystems such as ext3/4 and xfs do when it comes to barriers,
but, if there is consensus, I would not mind turning it into a
per-device tunable instead.

You mentioned "we should integrate this with the barrier settings". Do
you imply we should make it a per-device tunable too? Should we keep the
barrier-related mount options some filesystems provide?

 - Fernando

