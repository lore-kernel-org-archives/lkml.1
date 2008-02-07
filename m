Return-Path: <linux-kernel-owner+w=401wt.eu-S933811AbYBGAmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933811AbYBGAmq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:42:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933697AbYBGA2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 19:28:37 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59906
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933686AbYBGA2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 19:28:35 -0500
Date: Wed, 06 Feb 2008 16:29:04 -0800 (PST)
Message-Id: <20080206.162904.187464710.davem@davemloft.net>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org
Subject: Re: partition sysfs OOPS in current GIT
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080207000959.GA16601@suse.de>
References: <20080206235902.GA15719@suse.de>
	<20080206.160231.45881964.davem@davemloft.net>
	<20080207000959.GA16601@suse.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@suse.de>
Date: Wed, 6 Feb 2008 16:09:59 -0800

> On Wed, Feb 06, 2008 at 04:02:31PM -0800, David Miller wrote:
> > From: Greg KH <gregkh@suse.de>
> > Date: Wed, 6 Feb 2008 15:59:02 -0800
> > 
> > > What block drivers are you using for sparc?  Scsi?  Or something else?
> > > What could make sparc64 different from x86 in regards to block device
> > > structure, odd...
> > 
> > Only Fusion SAS on this system, therefore scsi.
> 
> Can you send me the output of 'tree /sys/block/' on 2.6.24?
> 
> Are there a lot of partitions here?  Anything different you can think of
> from x86 that I can have a chance to try to narrow things down with?  :)

It's a pretty simple partitioning scheme.

[    0.307823]  sda: sda1 sda2 sda3 sda4

> I don't know if you can boot without udev, but if you could, can you
> send the 'tree' output of the offending kernel too?

It actually is able to continue booting after udevd gets
killed off by the OOPS.

I'm going to run a bisect again and get some other info
for you...

Here is the tree output with current GIT:

/sys/block/
|-- loop0 -> ../devices/virtual/block/loop0
|-- loop1 -> ../devices/virtual/block/loop1
|-- loop2 -> ../devices/virtual/block/loop2
|-- loop3 -> ../devices/virtual/block/loop3
|-- loop4 -> ../devices/virtual/block/loop4
|-- loop5 -> ../devices/virtual/block/loop5
|-- loop6 -> ../devices/virtual/block/loop6
|-- loop7 -> ../devices/virtual/block/loop7
|-- ram0 -> ../devices/virtual/block/ram0
|-- ram1 -> ../devices/virtual/block/ram1
|-- ram10 -> ../devices/virtual/block/ram10
|-- ram11 -> ../devices/virtual/block/ram11
|-- ram12 -> ../devices/virtual/block/ram12
|-- ram13 -> ../devices/virtual/block/ram13
|-- ram14 -> ../devices/virtual/block/ram14
|-- ram15 -> ../devices/virtual/block/ram15
|-- ram2 -> ../devices/virtual/block/ram2
|-- ram3 -> ../devices/virtual/block/ram3
|-- ram4 -> ../devices/virtual/block/ram4
|-- ram5 -> ../devices/virtual/block/ram5
|-- ram6 -> ../devices/virtual/block/ram6
|-- ram7 -> ../devices/virtual/block/ram7
|-- ram8 -> ../devices/virtual/block/ram8
|-- ram9 -> ../devices/virtual/block/ram9
|-- sda -> ../devices/pci0000:02/0000:02:00.0/0000:03:02.0/0000:0a:00.0/host0/port-0:0/end_device-0:0/target0:0:0/0:0:0:0/block/sda
`-- sr0 -> ../devices/pci0000:02/0000:02:00.0/0000:03:01.0/0000:04:00.0/0000:05:01.0/0000:06:00.0/0000:07:00.2/usb3/3-2/3-2:1.0/host1/target1:0:0/1:0:0:0/block/sr0

26 directories, 0 files
