Return-Path: <linux-kernel-owner+w=401wt.eu-S1757389AbXIOJkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389AbXIOJkY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 05:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbXIOJkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 05:40:12 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46909 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751220AbXIOJkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 05:40:10 -0400
Date: Sat, 15 Sep 2007 02:39:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Maurice Volaski <mvolaski@aecom.yu.edu>
Cc: linux-lvm@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: Can LVM block I/O and hang a system?
Message-Id: <20070915023953.d364349d.akpm@linux-foundation.org>
In-Reply-To: <a06240411c30cd5dee72c@[129.98.90.227]>
References: <a06240411c30cd5dee72c@[129.98.90.227]>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2007 03:09:14 -0400 Maurice Volaski <mvolaski@aecom.yu.edu> wrote:

> A working system begins hanging and it seems to be stuck on I/O 
> processes that use ext3 partitions that are running on top of LVM. 
> The system is AMD 64-bit running Gentoo. Kernel is Gentoo 2.6.22-r3 
> and LVM lvm2-2.02.27. Here is the disk setup:
> 
> Boot disk, attached to motherboard via SATA
> 1) some partitions accessed via ext3 -> hardware partition.
> 2) some partitions accessed via ext3 -> drbd, which is version 8.0.5, 
> -> hardware partition.
> 
> External SATA-SCSI RAID, attached to via an LSI Logic card,
> 3) one partition accessed via ext3 -> drbd -> hardware partition.
> 4) some partitions accessed via ext3 -> LVM -> drbd -> hardware partition.
> 
> On repeated reboots, #1) boots fine, and I can fsck #2) no problem. I 
> can also fsck #3, but the fsck processes on #4, which all are trying 
> to recover the journals, just seem to not do anything. There is no 
> evidence of I/O and there are no errors reported anywhere. The frozen 
> fsck processes cannot even be killed and the system ignores the 
> shutdown command.
> 
> That the hanging fsck processes are all occurring on just the LVM 
> partitions seems to imply that LVM is responsible.
> 
> drbd had been unattached to its peer during this time, and when I 
> reattached it, it had no trouble syncing to the peer. That system, 
> which should basically be identical, however, has no trouble running 
> running fsck everywhere. I'm not sure, though, if that lets LVM off 
> the hook.

Next time it hangs, please do

dmesg -c
echo t > /proc/sysrq-trigger
dmesg -s 1000000 > foo

and send foo.
