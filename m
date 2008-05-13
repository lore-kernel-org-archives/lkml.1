Return-Path: <linux-kernel-owner+w=401wt.eu-S1757325AbYEMMHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325AbYEMMHf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 08:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754270AbYEMMHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 08:07:24 -0400
Received: from relay2.sgi.com ([192.48.171.30]:49242 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751747AbYEMMHX (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 08:07:23 -0400
Date: Tue, 13 May 2008 22:07:10 +1000
From: David Chinner <dgc@sgi.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       util-linux-ng@vger.kernel.org
Subject: Re: [BUG] remount ro on loopback mount leaves unmountable filesystem behind
Message-ID: <20080513120710.GA155679365@sgi.com>
References: <20080513085047.GY155679365@sgi.com> <20080513102340.GA15112@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080513102340.GA15112@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 06:23:40AM -0400, Christoph Hellwig wrote:
> On Tue, May 13, 2008 at 06:50:47PM +1000, David Chinner wrote:
> > Same thing, but remounting the loop filesystem readonly
> > before unmounting:
> > 
> > $ mount -t xfs /dev/sdb6 /mnt/scratch
> > $ mkdir /mnt/scratch/mnt
> > $ touch /mnt/scratch/img
> > $ mkfs.xfs -f -d file,name=/mnt/scratch/img,size=1g
> > $ mount -t xfs -o loop /mnt/scratch/img /mnt/scratch/mnt
> > $ mount -t xfs -o remount,ro /mnt/scratch/img /mnt/scratch/mnt
> > $ umount /mnt/scratch/mnt
> > $ umount /mnt/scratch
> > umount: /mnt/scratch: device is busy
> > umount: /mnt/scratch: device is busy
> 
> This is a problem in mount, no the kernel.  Before the remount the
> /etc mtab looks something like this:
> 
> /qemu/test.img /mnt xfs rw,loop=/dev/loop0 0 0
> 
> and after it looks something like this:
> 
> /qemu/test.img /mnt xfs ro 0 0
> 
> As a workaround do a losetup -d /dev/loop0 after unmounting the
> filesystem.

Hmmm - I even considered that and tried a '-o remount,ro,loop'
but that obviously doesn't work with dynamic loop device instantiation,
either.

/me didn't read all the way to the bottom of the extremely verbose
mount man page so didn't find the bit about losetup -d....

Anyway, I'll hard code loop device numbers into the script so
I can just forget about this problem. Thanks, Christoph.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
