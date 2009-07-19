Return-Path: <linux-kernel-owner+w=401wt.eu-S1754584AbZGSPB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbZGSPB0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 11:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518AbZGSPBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 11:01:25 -0400
Received: from ishtar.tlinx.org ([64.81.245.74]:36926 "EHLO Ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754313AbZGSPBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 11:01:24 -0400
Message-ID: <4A633542.8030502@tlinx.org>
Date: Sun, 19 Jul 2009 08:01:22 -0700
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: disk Partition label changes and reflecting them in /dev/disks-by-label/
X-Stationery: 0.4.9
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

If I have a disk with no mounted partitions and I change the partition 
order,
the OS will re-read the new partition and life goes on.

However, if I create or change a new disk label, it seems label programs
(and users) should have an option to reread the labels after the 
modification.

Ideally any prog that changes a Label or UUID would trigger an update
of what's in /dev/disks to reflect the new 'reality'.

Currently, I go through through a seemingly bizarre ritual of invoking
unmounting all other partitions on the same disk, then becoming root,
running fdisk on the disk, then just exiting with "w".  This triggers
a reread of not only the partition table, but also the new labels. 

However, I find this far less than ideal.  Is there a better way, or could
there be a better way to update new Labels and UUID's that are actually
on a disk -- perhaps even as an ordinary user command (since it would be
a read-only operation on the disk that simply updates /dev/disk to reflect
what's really there -- Especially being able to change only the label (or
UUID), only on one partition w/o having to actually unmount other file 
systems
on the disk....?

Already implemented?  Or doable?  Or bad idea?

Thanks,
-linda

