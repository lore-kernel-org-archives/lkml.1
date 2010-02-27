Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030872Ab0B0VBK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 16:01:10 -0500
Received: from cantor.suse.de ([195.135.220.2]:33219 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030850Ab0B0VBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 16:01:09 -0500
Date: Sun, 28 Feb 2010 08:01:00 +1100
From: Neil Brown <neilb@suse.de>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       linux-ext4@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
Subject: Re: mdadm software raid + ext4, capped at ~350MiB/s limitation/bug?
Message-ID: <20100228080100.092c24c2@notabene.brown>
In-Reply-To: <alpine.DEB.2.00.1002270840410.27192@p34.internal.lan>
References: <alpine.DEB.2.00.1002270840410.27192@p34.internal.lan>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Feb 2010 08:47:48 -0500 (EST)
Justin Piszcz <jpiszcz@lucidpixels.com> wrote:

> Hello,
> 
> I have two separate systems and with ext4 I cannot get speeds greater than 
> ~350MiB/s when using ext4 as the filesystem on top of a raid5 or raid0. 
> It appears to be a bug with ext4 (or its just that ext4 is slower for this
> test)?
> 
> Each system runs 2.6.33 x86_64.

Could be related to the recent implementation of IO barriers in md.
Can you try mounting your filesystem with
   -o barrier=0

and see how that changes the result.

NeilBrown


> 
> Can someone please confirm?
> 
> Here is ext4:
> 
> # dd if=/dev/zero of=bigfile bs=1M count=10240
> 10240+0 records in
> 10240+0 records out
> 10737418240 bytes (11 GB) copied, 29.8556 s, 360 MB/s
> 
> The result is the same regardless of the RAID type (RAID-5 or RAID-0)
> 
> Note, this is not a bandwidth problem:
> 
> # dd if=/dev/zero of=/dev/md0 bs=1M count=10240
> 10240+0 records in
> 10240+0 records out
> 10737418240 bytes (11 GB) copied, 17.6871 s, 607 MB/s
> 
> With XFS:
> 
> p63:~# mkfs.xfs -f /dev/md0
> p63:~# mount /dev/md0 /r1
> p63:~# cd /r1
> 10240+0 records in
> 10240+0 records out
> 10737418240 bytes (11 GB) copied, 17.6078 s, 610 MB/s
> 
> NOTE: With a HW raid controller (OR using XFS), I can get > 500 MiB/s, 
> this problem only occurs with SW raid (Linux/mdadm).
> 
> Example (3ware 9650SE-16PML RAID-6, 15 drives (using EXT4)
> $ dd if=/dev/zero of=bigfile bs=1M count=10240
> 10240+0 records in
> 10240+0 records out
> 10737418240 bytes (11 GB) copied, 21.1729 s, 507 MB/s
> 
> Justin.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

