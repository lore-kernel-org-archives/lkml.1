Return-Path: <linux-kernel-owner+w=401wt.eu-S1752966AbXLALTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbXLALTh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 06:19:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751465AbXLALTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 06:19:16 -0500
Received: from lucidpixels.com ([75.144.35.66]:57945 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbXLALTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 06:19:15 -0500
Date: Sat, 1 Dec 2007 06:19:14 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
cc: apiszcz@solarrain.com
Subject: Kernel 2.6.23.9 + mdadm 2.6.2-2 + Auto rebuild RAID1?
Message-ID: <Pine.LNX.4.64.0712010614070.25643@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quick question,

Setup a new machine last night with two raptor 150 disks.  Setup RAID1 as 
I do everywhere else, 0.90.03 superblocks (in order to be compatible with 
LILO, if you use 1.x superblocks with LILO you can't boot), and then:

/dev/sda1+sdb1 <-> /dev/md0 <-> swap
/dev/sda2+sdb2 <-> /dev/md1 <-> /boot (ext3)
/dev/sda3+sdb3 <-> /dev/md2 <-> / (xfs)

All works fine, no issues...

Quick question though, I turned off the machine, disconnected /dev/sda 
from the machine, boot from /dev/sdb, no problems, shows as degraded 
RAID1.  Turn the machine off.  Re-attach the first drive.  When I boot my 
first partition either re-synced by itself or it was not degraded, was is 
this?

So two questions:

1) If it rebuilt by itself, how come it only rebuilt /dev/md0?
2) If it did not rebuild, is it because the kernel knows it does not need 
to re-calculate parity etc for swap?

I had to:

mdadm /dev/md1 -a /dev/sda2
and
mdadm /dev/md2 -a /dev/sda3

To rebuild the /boot and /, which worked fine, I am just curious though 
why it works like this, I figured it would be all or nothing.

More info:

Not using ANY initramfs/initrd images, everything is compiled into 1 
kernel image (makes things MUCH simpler and the expected device layout etc 
is always the same, unlike initrd/etc).

Justin.
