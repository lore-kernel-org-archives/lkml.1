Return-Path: <linux-kernel-owner+w=401wt.eu-S1767939AbXEEBgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767939AbXEEBgm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 21:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767937AbXEEBgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 21:36:42 -0400
Received: from ns1.q-leap.de ([153.94.51.193]:54389 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767939AbXEEBgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 21:36:42 -0400
Date: Sat, 5 May 2007 03:36:37 +0200
From: Bernd Schubert <bs@q-leap.de>
To: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: mkfs.ext2 triggerd RAM corruption
Message-ID: <20070505013637.GA23803@lanczos.q-leap.de>
References: <200705041659.51675.bs@q-leap.de> <20070504184943.GC25339@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070504184943.GC25339@thunk.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:

> On Fri, May 04, 2007 at 04:59:51PM +0200, Bernd Schubert wrote:
>> 
>> I'm presently rather puzzled, if this is really a kernel bug, its a
>> big
>> bug.
>> 
>> Summary: The system ramdisk (initrd) gets corrupted while running
>> mkfs.ext2 on a local sata disk partition.
> 
> What distribution are you using?  What's the hardware configuration,

distribution: modified debian sarge, in which aspect is the distribution
important for this problem? mkfs2.ext2 is supposed to write to /dev/sdaX
and not /dev/rd/0. Stracing it and grepping for open calls shows that
only /dev/sdaX is opened in read-write mode.

hardware:
beo-05 and beo-06: cpu: xeon, acpi shows S3000PTH board, memory 2GB
(board too new for EDAC), piix sata controller

beo-106: Dual Core AMD Opteron, no idea what kind of board, 4GB memory
(k8_edac monitored), nforce sata controller

beo-01: Presently can't connect to it, afaik another intel system

(all system are running in x86_64 mode)


> including amount of memory?  What is the partition table look
> like for /dev/sda?  What filesystems are mounted?  If you have any

I already tested several partition types, e.g. something like this for a
test on sda3

beo-05:~# sfdisk -d /dev/sda
# partition table of /dev/sda
unit: sectors

/dev/sda1 : start=       63, size=  4208967, Id=83
/dev/sda2 : start=  4209030, size=  4209030, Id=83
/dev/sda3 : start=  8418060, size=313251435, Id=83
/dev/sda4 : start=        0, size=        0, Id= 0


For the tests nothing was mounted. 


> soft RAID partitions, are any of them using part of /dev/sda?  What

No raid during the tests on sda, of course. 
When sdaX was part of a raid testing the raid device, the corruption did
NOT happen.

> swap partitions are you using?  And do any of the swap partitions

Swap already entirely disabled.

> overlap with /dev/sda?  :-)

Suspected this first too, but the tested partition was never used as
swap partition (first always tested on sda4 and sda2 was used for swap),
later I entirely disabled the swap.

Thanks,
Bernd


PS: I took me about 10 hours of testing, before I wrote the first mail.
Took me that time to believe that its really a kernel bug.
