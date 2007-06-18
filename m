Return-Path: <linux-kernel-owner+w=401wt.eu-S1764872AbXFRSHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764872AbXFRSHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 14:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762800AbXFRSHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 14:07:20 -0400
Received: from mail-relay-02.mailcluster.net ([85.249.135.243]:45822 "EHLO
	mail-relay-02.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762126AbXFRSHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 14:07:18 -0400
X-Greylist: delayed 1776 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Jun 2007 14:07:18 EDT
Message-ID: <4676C2D6.8030708@vlnb.net>
Date: Mon, 18 Jun 2007 21:37:26 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060501 Fedora/1.7.13-1.1.fc5
X-Accept-Language: en-us, ru, en
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [ANNOUNCE] Btrfs: a copy on write, snapshotting FS
References: <20070612161029.GB28279@think.oraclecorp.com>
In-Reply-To: <20070612161029.GB28279@think.oraclecorp.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Mason wrote:
> Hello everyone,
> 
> After the last FS summit, I started working on a new filesystem that
> maintains checksums of all file data and metadata.  Many thanks to Zach
> Brown for his ideas, and to Dave Chinner for his help on 
> benchmarking analysis.
> 
> The basic list of features looks like this:
> 
> 	* Extent based file storage (2^64 max file size)
> 	* Space efficient packing of small files
> 	* Space efficient indexed directories
> 	* Dynamic inode allocation
> 	* Writable snapshots
> 	* Subvolumes (separate internal filesystem roots)
> 	- Object level mirroring and striping
> 	* Checksums on data and metadata (multiple algorithms available)
> 	- Strong integration with device mapper for multiple device support
> 	- Online filesystem check
> 	* Very fast offline filesystem check
> 	- Efficient incremental backup and FS mirroring

I would also suggest one more feature: support for block level 
de-duplication. I mean:

1. Ability for Btrfs to have blocks in several files to point to the 
same block on disk

2. Support for new syscall or IOCTL to de-duplicate as a single 
transaction two or more blocks on disk, i.e. link them to one of them 
and free others

3. De-de-duplicate blocks on disk, i.e. copy them on write

I suppose that de-duplication itself would be done by some user space 
process that would scan files, determine blocks with the same data and 
then de-duplicate them by using syscall or IOCTL (2).

That would be very usable feature, which in most cases would allow to 
shrink occupied disk space on 50-90%.

Vlad
