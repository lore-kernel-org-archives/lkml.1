Return-Path: <linux-kernel-owner+w=401wt.eu-S1756290AbYAORBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290AbYAORBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 12:01:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755450AbYAORBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 12:01:19 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:60002 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755401AbYAORBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 12:01:18 -0500
Date: Tue, 15 Jan 2008 12:01:17 -0500
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Possibly silly Q?
Message-ID: <20080115170117.GP2310@csclub.uwaterloo.ca>
References: <200801141434.00934.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801141434.00934.gene.heskett@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 02:34:00PM -0500, Gene Heskett wrote:
> Do we have a utility that can force the kernel to re-read, and re-initialize 
> itself to a given drives partition tables without having to reboot if one is 
> working with a drive that is not part of the required kernel directory tree?
> 
> The reason I ask, is that I've just spent about 20 hours fighting with amanda 
> after repartitioning a drive for use by amanda as virtual tapes, 
> making /dev/sdc1 into a primary partition of nearly 400GB.  /dev/sdc1 started 
> out as a /boot2 labeled partition of 200mb, and because the kernels data was 
> stale, amanda upchucked all over itself when the kernel thought the original 
> 200Mb had been filled when it had been umounted from /mnt/bootf8 
> repartitioned, mke2fs'd, a journal added and a new label written and then 
> mounted to /amandatapes.
> 
> Something it seems to me, should have forced the re-init, but didn't.  So is 
> there a tool that can force that?

In my experience fdisk (whichever one you use) will ask the kernel to
reread the partition table on write.

The kernel refuses to reread the partition table on any disk where it
has anything mounted.  So if any part of the disk is in use then it
refuses to change anything about it's view of that disk.

So if you only have partitions mounted from sda and sdb then you can
repartition sdc and it will reload the partition table just fine.  If
any part of sdc is mounted or otherwise in use then you can't.

I have often wondered how hard it would be to change the kernel
behaviour so that it only refuses to reload the partition table if the
partitions that are in use on the disk are being changed, but let it
reload the partition table if only unused partitions are being changed.

For example:
sdc1 200MB mounted
sdc2 500MB not mounted
sdc3 300MB not mounted

Delete sdc2 and sdc3 and create a new sdc2 that is 800MB

Since sdc1 is not changed (no change in size or start and end locations
in partition table), then the kernel should let the partition table be
reloaded since there is no affect on the in use partition.

After all it seems the disk manager in windows is capable of this, so
perhaps linux ought to be as well.  It may not be relevant very often,
but it sure is annoying having to go through multiple reboots when doing
certain disk layout changes just because you are using and not changing
one partition on a disk.

--
Len Sorensen
