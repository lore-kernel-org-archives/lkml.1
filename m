Return-Path: <linux-kernel-owner+w=401wt.eu-S1761325AbYDPHtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761325AbYDPHtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 03:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751227AbYDPHtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 03:49:45 -0400
Received: from mr1.bfh.ch ([147.87.250.50]:55227 "EHLO mr1.bfh.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931AbYDPHto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 03:49:44 -0400
Message-ID: <4805AF93.90209@bfh.ch>
Date: Wed, 16 Apr 2008 09:49:39 +0200
From: Seewer Philippe <philippe.seewer@bfh.ch>
Organization: BFH
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Francis Moreau <francis.moro@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Disk geometry from /sys
References: <38b2ab8a0804091353h3725ce29s196e27e8b4f1ff56@mail.gmail.com>	 <480354C9.1050600@bfh.ch> <38b2ab8a0804150040i14840a9fudc3b95ba80d52ac1@mail.gmail.com>
In-Reply-To: <38b2ab8a0804150040i14840a9fudc3b95ba80d52ac1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Apr 2008 07:49:39.0947 (UTC) FILETIME=[6CCEEBB0:01C89F96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Francis Moreau wrote:
> Hi Seewer,
> 
> On Mon, Apr 14, 2008 at 2:57 PM, Seewer Philippe <philippe.seewer@bfh.ch> wrote:
>>  As you've problably seen from the other answers, disk geometry is (except
>> for a few older devices) unneeded inside the Linux kernel.
> 
> Yes but I'm doing userspace stuff and that's the reason I was asking for the
> sysfs thing.
> 
>> I'd say thats the
>> reason why there's no sysfs export and I'd further guess disk geometry is an
>> artifact most would like to get rid of (or pushed into userspace).
>>
> 
> Well, I looked at sfdisk(8) and parted(8) source code and they all need the
> geometry description. If I understood correctly the reason why is that it
> 'prefers' to align partition sizes/starts on a cylinder boundary because some
> bootloaders probably use CHS addressing, but I'm really not sure.
Yes indeed, mainly in the (w)intel world though.

> 
>>  Anyway, if you really need it, try the patch below. Should apply cleanly to
>> version 2.6.23.1 and gives you a geometry/ directory for each block device
>> providing the getgeo function. It adds a setgeo counterpart for some
>> subsystems as well, allowing 'echo something > ...' so please be careful.
>>
> 
> Thanks but I probably won't use it. Using sfdisk, for example, is a
> more portable
> way to get the geometry from a script.

Correct. Though be really careful which geometry you are requesting:

root@local:/# sfdisk -g /dev/sda
/dev/sda: 7296 cylinders, 255 heads, 63 sectors/track
root@local:/# sfdisk -G /dev/sda
/dev/sda: 116280 cylinders, 16 heads, 63 sectors/track

The first one is the kernels idea of a disks geometry which is probably 
as often correct as it's just plain wrong, versus the second one which 
tries to guess a disks geometry by looking at the current partition 
table. Which might be just as wrong since its only necessary for bios 
and/or bootloader. Really depends on what you need.

Cheers
Philippe

