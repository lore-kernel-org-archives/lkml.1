Return-Path: <linux-kernel-owner+w=401wt.eu-S1762887AbXGRK25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762887AbXGRK25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 06:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756324AbXGRK2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 06:28:48 -0400
Received: from lucidpixels.com ([75.144.35.66]:42034 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753915AbXGRK2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 06:28:47 -0400
Date: Wed, 18 Jul 2007 06:28:46 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Rui Santos <rsantos@grupopie.com>
cc: Linux RAID <linux-raid@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Neil Brown <neilb@suse.de>
Subject: Re: Slow Soft-RAID 5 performance
In-Reply-To: <469DE3BB.9070604@grupopie.com>
Message-ID: <Pine.LNX.4.64.0707180626481.7659@p34.internal.lan>
References: <469DE3BB.9070604@grupopie.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 18 Jul 2007, Rui Santos wrote:

> Hi,
>
> I'm getting a strange slow performance behavior on a recently installed
> Server. Here are the details:
>
> Server: Asus AS-TS500-E4A
> Board: Asus DSBV-D (
> http://uk.asus.com/products.aspx?l1=9&l2=39&l3=299&l4=0&model=1210&modelmenu=2
> )
> Hard Drives: 3x Seagate ST3400620AS (
> http://www.seagate.com/ww/v/index.jsp?vgnextoid=8eff99f4fa74c010VgnVCM100000dd04090aRCRD&locale=en-US
> )
> I'm using the AHCI driver, although with ata_piix, the behavior is the
> same. Here's some info about the AHCI controler:
>

With three disks, if everything was perfect yeah 120MB/s writes.  When I 
had started out with 4 raptors I was getting 164MB/s read and write.  By 
default with no optimizations you will not get good speed.

With no optimizations with 10 raptors I get 180-200MB/s, with 
optimizations, 464MB/s write and 622MB/s read.

1. Use XFS if you wan't speed.
2. Use 128k, 256k or 1MiB chunk size.
3. Use 8192k, 16384k stripe_cache_size.
4. Use 65536 readahead size.

These are only some of the optimizations I use.

Justin.

