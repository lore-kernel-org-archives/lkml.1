Return-Path: <linux-kernel-owner+w=401wt.eu-S1752584AbZBNPhD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbZBNPhD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 10:37:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750761AbZBNPgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 10:36:52 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:37501 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbZBNPgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 10:36:52 -0500
Date: Sat, 14 Feb 2009 10:36:26 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Eric Sandeen <sandeen@redhat.com>,
       Fernando Luis V?zquez Cao <fernando@oss.ntt.co.jp>,
       Jan Kara <jack@suse.cz>, Theodore Tso <tytso@MIT.EDU>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, fernando@kic.ac.jp,
       Ric Wheeler <rwheeler@redhat.com>
Subject: Re: vfs: Add MS_FLUSHONFSYNC mount flag
Message-ID: <20090214153626.GA3973@infradead.org>
References: <20090116163039.GE10617@duck.suse.cz> <1232185639.4831.18.camel@sebastian.kern.oss.ntt.co.jp> <1232186449.4831.29.camel@sebastian.kern.oss.ntt.co.jp> <20090119120349.GA10193@duck.suse.cz> <1233135913.5399.57.camel@sebastian.kern.oss.ntt.co.jp> <20090128095518.GA16554@duck.suse.cz> <1234434811.15270.7.camel@sebastian.kern.oss.ntt.co.jp> <1234434970.15433.4.camel@sebastian.kern.oss.ntt.co.jp> <499458C1.90105@redhat.com> <49945C90.3010104@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49945C90.3010104@garzik.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 12, 2009 at 12:29:52PM -0500, Jeff Garzik wrote:
>> The block device *could* choose to ignore this in hardware if it knows
>> it's built with a nonvolatile write cache or if it has no write cache.
>
> That would certainly be my preference -- turn this ON by default, and  
> them if a layer NEEDS to ignore it, it can.

Yeah, and we should integrate this with the barriers settings.

I think the right setup is:

 - each gendisk has a variable to indicate if we have a write-back
   cache, which is filled from scsi inquiry data (or whatever the
   equivalent in the storage protocol is), but we allow an override
   from userspace if the admin knows better (if he really does or
   wants to play fast and lose is the admin's business)
 - filesystems do the right things by using barriers and cache flushes
   if they see the underlying device needs it.

