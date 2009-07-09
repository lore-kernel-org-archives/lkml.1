Return-Path: <linux-kernel-owner+w=401wt.eu-S1759010AbZGIBFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759010AbZGIBFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 21:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755908AbZGIBFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 21:05:13 -0400
Received: from mail.lang.hm ([64.81.33.126]:54005 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755088AbZGIBFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 21:05:12 -0400
Date: Wed, 8 Jul 2009 18:05:06 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard
To: linux-kernel <linux-kernel@vger.kernel.org>
cc: linux-raid@vger.kernel.org
Subject: Re: partition detection problem on 2.6.29.1 and 2.6.30
In-Reply-To: <alpine.DEB.1.10.0907081424140.9159@asgard>
Message-ID: <alpine.DEB.1.10.0907081759550.9159@asgard>
References: <alpine.DEB.1.10.0907081424140.9159@asgard>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; FORMAT=flowed; CHARSET=US-ASCII
Content-ID: <alpine.DEB.1.10.0907081759552.9159@asgard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I managed to track the problem down.

it turns out that at some point someone created a md array using the raw 
devices instead of the partitions. it looks like the kernel autodetection 
for raid kicked in prior to the partition detection and after it claimed 
the drives the partition detection was never given a chance to do so.

this is logical, but it makes the dmesg output that appears to be 
identifying the paritions _very_ misleading.

David Lang

On Wed, 8 Jul 2009, david@lang.hm wrote:

> Date: Wed, 8 Jul 2009 14:35:41 -0700 (PDT)
> From: david@lang.hm
> To: linux-kernel <linux-kernel@vger.kernel.org>
> Subject: partition detection problem on 2.6.29.1 and 2.6.30
> 
> I have a system that has a large number of drives in it (45), and it's had a 
> problem with banks of disks getting disconnected from it.
>
> however, when I started looking into it today (after another sysadmin worked 
> on it for a while), I found that the system is not able to access the 
> partitions on the drives.
>
> if I am reading dmesg correctly it is seeing the partitions during boot, and 
> if I do 'fdisk -l' it lists all the paritions correctly, but if I try to do a
>
> dd if=/dev/sdb1 of=/dev/null count=1
>
> I get the error "dd: opening `/dev/sdb1': No such device or address"
>
> #ls -l /dev/sdb1
> brw-rw---- 1 root disk 8, 17 Nov  7  2006 /dev/sdb1
>
> I removed udev and setup nodes manually to eliminate any possibility that it 
> was a problem there.
>
> the attachment partitions.missing.partitions is a cat of /proc/partitions
>
> sysfs shows all the drives but none of the partitions.
>
> if I run fdisk and do a write (which runs the ioctl to re-read the parition 
> table) the system detects the partition and is able to access it until the 
> next reboot.
>
> what is going on here?
>
> David Lang
