Return-Path: <linux-kernel-owner+w=401wt.eu-S1761493AbYA2DWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761493AbYA2DWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 22:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757749AbYA2DVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 22:21:54 -0500
Received: from rtr.ca ([76.10.145.34]:3805 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757422AbYA2DVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 22:21:53 -0500
Message-ID: <479E9BD0.3040900@rtr.ca>
Date: Mon, 28 Jan 2008 22:21:52 -0500
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Robert Hancock <hancockr@shaw.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Problem with ata layer in 2.6.24
References: <fa.YoSRdik0niRWE1jgfb9yTQPim5A@ifi.uio.no> <479E81FE.2090604@shaw.ca> <200801282051.13680.gene.heskett@gmail.com> <200801282120.33442.gene.heskett@gmail.com>
In-Reply-To: <200801282120.33442.gene.heskett@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
> On Monday 28 January 2008, Gene Heskett wrote:
>> On Monday 28 January 2008, Robert Hancock wrote:
>> [...]
>>
>>> Check the /etc/modprobe.conf file, a lot of distributions use this to
>>> generate the initrd. If there's references to pata_amd it'll try and
>>> include it.
>> Bingo!  Thanks Robert, I'll try it again with that line commented.  I wasn't
>> aware of that connection at all.  Yup, it worked, I feel a reboot coming
>> on. :)
> 
> But it didn't work, apparently commenting that line out needs to be balanced 
> by adding another line telling it amd74xx is the 'hostadapter', not 
> necessarily scsi.
> 
> Can this be made more universal so I don't have to edit /etc/modprobe.conf?
>..

You could really do it like Linus (and me), and not bother with modules
for critical services like hard disks.

Just build them *into* the core kernel (select "y" or "checkmark" rather
than "m" or "dot" for modules).  This eliminates a ton of crap that can fail,
and may also make your kernel a micro-MIP faster (core memory is often mapped
without page table entries, whereas loaded modules use page tables.. slower, slightly).

Linus just edits the /boot/grub/menu.lst, and clones an existing boot entry
for the new kernel, editing the "kernel" line to match the name of the file
that got installed in /boot by "make install" (from the kernel directory).
He just leaves the ramdisk/initrd line as-was --> wrong version, but that's okay.

I totally get rid of them here, but that requires hardcoding the root=/dev/xxxx
part on the "kernel" line.  No big deal, it works just fine that way.

Cheers
