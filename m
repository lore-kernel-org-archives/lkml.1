Return-Path: <linux-kernel-owner+w=401wt.eu-S1753851AbYE2HGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbYE2HGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 03:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751443AbYE2HGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 03:06:33 -0400
Received: from dwdmx4.dwd.de ([141.38.3.230]:38801 "EHLO dwdmx4.dwd.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbYE2HGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 03:06:32 -0400
X-Greylist: delayed 1332 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 May 2008 03:06:31 EDT
Date: Thu, 29 May 2008 06:44:13 +0000 (GMT)
From: Holger Kiehl <Holger.Kiehl@dwd.de>
X-X-Sender: kiehl@diagnostix.dwd.de
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Performance Characteristics of All Linux RAIDs (mdadm/bonnie++)
In-Reply-To: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan>
Message-ID: <Pine.LNX.4.64.0805290636020.20192@diagnostix.dwd.de>
References: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2008, Justin Piszcz wrote:

> Hardware:
>
> 1. Utilized (6) 400 gigabyte sata hard drives.
> 2. Everything is on PCI-e (965 chipset & a 2port sata card)
>
> Used the following 'optimizations' for all tests.
>
> # Set read-ahead.
> echo "Setting read-ahead to 64 MiB for /dev/md3"
> blockdev --setra 65536 /dev/md3
>
> # Set stripe-cache_size for RAID5.
> echo "Setting stripe_cache_size to 16 MiB for /dev/md3"
> echo 16384 > /sys/block/md3/md/stripe_cache_size
>
> # Disable NCQ on all disks.
> echo "Disabling NCQ on all disks..."
> for i in $DISKS
> do
>  echo "Disabling NCQ on $i"
>  echo 1 > /sys/block/"$i"/device/queue_depth
> done
>
> Software:
>
> Kernel: 2.6.23.1 x86_64
> Filesystem: XFS
> Mount options: defaults,noatime
>
> Results:
>
> http://home.comcast.net/~jpiszcz/raid/20080528/raid-levels.html
> http://home.comcast.net/~jpiszcz/raid/20080528/raid-levels.txt
>
Why is the Sequential Output (Block) for raid6 165719 and for raid5 only
86797? I would have thought that raid6 was always a bit slower in writting
due to having to write double amount of parity data.

Holger

