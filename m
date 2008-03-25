Return-Path: <linux-kernel-owner+w=401wt.eu-S1757821AbYCYRbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757821AbYCYRbb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 13:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756047AbYCYRbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 13:31:20 -0400
Received: from rtr.ca ([76.10.145.34]:1485 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755670AbYCYRbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 13:31:19 -0400
Message-ID: <47E936E5.7090506@rtr.ca>
Date: Tue, 25 Mar 2008 13:31:17 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>,
       Tejun Heo <htejun@gmail.com>, Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
References: <47E875AD.1000901@rtr.ca>  <47E87942.2020409@rtr.ca> <1206458278.3273.5.camel@localhost.localdomain>
In-Reply-To: <1206458278.3273.5.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Tue, 2008-03-25 at 00:02 -0400, Mark Lord wrote:
>..
>> Practically all utilities that care about it,
>> use ioctl(fd, HDIO_GETGEO) to determine the starting
>> sector offset of a hard disk partition.
..
> Perhaps I've missed something, but surely geometry doesn't make sense on
> a >2TB drive does it?  The only reason we use it on modern disks (which
> usually make it up specially for us) is that the DOS partition scheme
> requires it.  Once we're over 2TB, isn't it impossible to use DOS
> partitions (well, OK, unless you increase the sector size, but that's
> only delaying the inevitable), so we can just go with a proper disk
> labelling scheme and use BLKGETSIZE64 all the time.
..

I haven't thought much about problems with the virtual geometry,
because, as you say, we really don't care about it for the most part.
We use LBA values from the partition tables rather than CHS.
I suppose those also likely to be 32-bit limited.

The "partition offset", or "starting sector" is the important
bit of information for most things.  And that's currently available
from HDIO_GETGEO, and from /sys/block/XXX/XXXn/start, if sysfs is mounted.

We just need an easy way to get it, given a dev_t from stat(2).
Currently there isn't an easy way, and HDIO_GETGEO returns
only 32-bits on a 32-bit system.

Cheers

