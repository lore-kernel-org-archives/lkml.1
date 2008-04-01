Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176AbYDAAlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbYDAAlU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 20:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753441AbYDAAlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 20:41:00 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:1838 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424AbYDAAk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 20:40:58 -0400
Date: Mon, 31 Mar 2008 18:40:53 -0600
From: Alex Chiang <achiang@hp.com>
To: David Miller <davem@davemloft.net>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       btrfs-devel@oss.oracle.com
Subject: Re: [ANNOUNCE] Btrfs v0.13
Message-ID: <20080401004053.GF2362@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	David Miller <davem@davemloft.net>, chris.mason@oracle.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	btrfs-devel@oss.oracle.com
References: <200802211609.50563.chris.mason@oracle.com> <20080331202633.GA341@ldl.fc.hp.com> <20080331.134510.126138884.davem@davemloft.net> <20080331224710.GC2362@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080331224710.GC2362@ldl.fc.hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alex Chiang <achiang@hp.com>:
> * David Miller <davem@davemloft.net>:
> > From: Alex Chiang <achiang@hp.com>
> > Date: Mon, 31 Mar 2008 14:26:33 -0600
> > 
> > > I've gotten as far as successfully creating a btrfs filesystem
> > > (at least that's what btrfsck tells me), but haven't been able to
> > > mount it yet, probably because of the sector size issue.
> > 
> > You should be able to make a filesystem with a sector
> > size >= PAGE_SIZE and it should work just fine.  Please
> > give it a try.
> 
> So, using the patch from my last mail, I created a btrfs, but was
> unable to mount it...

It turns out I am an idiot.

At some point, I got confused which btrfs trees I was working in,
and gotten switched up to where I had insmod'ed btrfs v0.13, but
was trying to mount a filesystem created with
btrfs-progs-unstable. Of course, I got a version mismatch when it
went to check for BTRFS_MAGIC and mount failed.

Moving to btrfs-unstable allowed me to mount the filesystem.

[root@canola btrfs-unstable]# mount -t btrfs /dev/cciss/c2d1
/mnt/btrfs
scan one opens /dev/cciss/c2d1
found device 1 on /dev/cciss/c2d1
lowest devid now 1
scan one closes bdev /dev/cciss/c2d1
opening /dev/cciss/c2d1 devid 1
lowest bdev /dev/cciss/c2d1

Sorry for the noise.

/ac

