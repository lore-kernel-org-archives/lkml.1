Return-Path: <linux-kernel-owner+w=401wt.eu-S1752712AbYLYWx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbYLYWx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 17:53:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752067AbYLYWxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 17:53:49 -0500
Received: from lucidpixels.com ([75.144.35.66]:46664 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066AbYLYWxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 17:53:48 -0500
Date: Thu, 25 Dec 2008 17:53:46 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
cc: linux-raid@vger.kernel.org, bug-parted@gnu.org, ataraid-list@redhat.com,
       xfs@oss.sgi.com
Subject: Re: How do I tell if my partition is aligned for a 64k/RAID-6?
In-Reply-To: <alpine.DEB.1.10.0812250821360.31386@p34.internal.lan>
Message-ID: <alpine.DEB.1.10.0812251753140.29925@p34.internal.lan>
References: <alpine.DEB.1.10.0812250821360.31386@p34.internal.lan>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Dec 2008, Justin Piszcz wrote:

> Output:
>
> ===============================================================================
>
> p34:~# parted /dev/sda print unit s print unit chs print
> Model: AMCC 9650SE-16M DISK (scsi)
> Disk /dev/sda: 13.0TB
> Sector size (logical/physical): 512B/512B
> Partition Table: gpt
>
> Number  Start   End     Size    File system  Name  Flags
> 1      17.4kB  13.0TB  13.0TB  xfs
>
> Model: AMCC 9650SE-16M DISK (scsi)
> Disk /dev/sda: 25390350336s
> Sector size (logical/physical): 512B/512B
> Partition Table: gpt
>
> Number  Start  End           Size          File system  Name  Flags
> 1      34s    25390350302s  25390350269s  xfs
>
> Model: AMCC 9650SE-16M DISK (scsi)
> Disk /dev/sda: 1580476,53,56
> Sector size (logical/physical): 512B/512B
> BIOS cylinder,head,sector geometry: 1580476,255,63.  Each cylinder is 8225kB.
> Partition Table: gpt
>
> Number  Start   End            File system  Name  Flags
> 1      0,0,34  1580476,53,23  xfs
>
> p34:~#
>
> ===============================================================================
>
> I created a partition from 0Gb to 13T on the following LUN, but how do I 
> verify this is aligned to the (hardware) 64KiB raid-6 array?
>
> Unit  UnitType  Status         %RCmpl  %V/I/M  Stripe  Size(GB)  Cache  AVrfy
> ------------------------------------------------------------------------------
> u0    RAID-6    OK             -       -       64K     12107.1   ON     ON
>
> ===============================================================================
>
> p34:~# xfs_info /dev/sda1
> meta-data=/dev/sda1              isize=256    agcount=12, agsize=268435455 
> blks
>         =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=3173793783, imaxpct=5
>         =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096
> log      =internal               bsize=4096   blocks=32768, version=2
>         =                       sectsz=512   sunit=0 blks, lazy-count=0
> realtime =none                   extsz=4096   blocks=0, rtextents=0
>
> ===============================================================================
>
> I am not worried about the filesystem as the defaults usually get it right 
> but with parted, this is the first time I had to use it for home use and with 
> RAID-6 I am noticing slower performance with 15 disks (1 is a spare) in 
> RAID-6 (albeit slower 7200 ones, RE3s) than I was getting with 10 raptor150s 
> in RAID-6 (but I had used fdisk there).
>
> Justin.
>
>

Problem was barriers were enabled, that is why everything was slow but I 
would still like to know about the alignment.

Justin.
