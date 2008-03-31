Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbYCaWrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbYCaWrW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 18:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbYCaWrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 18:47:14 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:10928 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbYCaWrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 18:47:13 -0400
Date: Mon, 31 Mar 2008 16:47:10 -0600
From: Alex Chiang <achiang@hp.com>
To: David Miller <davem@davemloft.net>
Cc: chris.mason@oracle.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, btrfs-devel@oss.oracle.com
Subject: Re: [ANNOUNCE] Btrfs v0.13
Message-ID: <20080331224710.GC2362@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	David Miller <davem@davemloft.net>, chris.mason@oracle.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	btrfs-devel@oss.oracle.com
References: <200802211609.50563.chris.mason@oracle.com> <20080331202633.GA341@ldl.fc.hp.com> <20080331.134510.126138884.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080331.134510.126138884.davem@davemloft.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Miller <davem@davemloft.net>:
> From: Alex Chiang <achiang@hp.com>
> Date: Mon, 31 Mar 2008 14:26:33 -0600
> 
> > I've gotten as far as successfully creating a btrfs filesystem
> > (at least that's what btrfsck tells me), but haven't been able to
> > mount it yet, probably because of the sector size issue.
> 
> You should be able to make a filesystem with a sector
> size >= PAGE_SIZE and it should work just fine.  Please
> give it a try.

So, using the patch from my last mail, I created a btrfs, but was
unable to mount it...

[root@canola btrfs]# getconf PAGESIZE
16384

[root@canola btrfs]# mkfs.btrfs -E sectorsize=16384 /dev/cciss/c2d1
found device 1 on /dev/cciss/c2d1
lowest devid now 1
found Btrfs on /dev/cciss/c2d1 with 1 devices
opening /dev/cciss/c2d1 devid 1 fd 5
alloc chunk size 8388608 from dev 1
alloc chunk size 8388608 from dev 1
fs created on /dev/cciss/c2d1 nodesize 16384 leafsize 16384
sectorsize 16384 bytes 73372631040

[root@canola btrfs]# mount -t btrfs /dev/cciss/c2d1 /mnt/btrfs
mount: /dev/cciss/c2d1: can't read superblock

And from /var/log/messages:

Mar 31 16:50:23 canola kernel: btrfs: cciss/c2d1 checksum verify
failed on 16384 wanted A76CDD59 found 4A0E371 from_this_trans 0
Mar 31 16:50:23 canola kernel: btrfs: valid FS not found on cciss/c2d1
Mar 31 16:50:23 canola kernel: btrfs: open_ctree failed

Any hints?

/ac

