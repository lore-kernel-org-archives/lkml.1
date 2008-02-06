Return-Path: <linux-kernel-owner+w=401wt.eu-S1761999AbYBFXdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761999AbYBFXdX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:33:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759869AbYBFXdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:33:09 -0500
Received: from cantor.suse.de ([195.135.220.2]:42843 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760421AbYBFXdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:33:07 -0500
Date: Wed, 6 Feb 2008 15:31:17 -0800
From: Greg KH <gregkh@suse.de>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org
Subject: Re: partition sysfs OOPS in current GIT
Message-ID: <20080206233117.GA28931@suse.de>
References: <20080206.152639.35541094.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080206.152639.35541094.davem@davemloft.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2008 at 03:26:39PM -0800, David Miller wrote:
> 
> I get the following OOPS from udevd during bootup on
> sparc64:
> 
> [    0.982046]               \|/ ____ \|/
> [    0.982054]               "@'/ .. \`@"
> [    0.982058]               /_| \__/ |_\
> [    0.982063]                  \__U_/
> [    0.982482] udevd(1305): Kernel illegal instruction [#1]
> [    0.982550] TSTATE: 0000004411001602 TPC: 00000000007ddb80 TNPC: 00000000007ddb84 Y: 00000000    Not tainted
> [    0.982647] TPC: <0x7ddb88>
> [    0.982684] g0: 0000000000000000 g1: 00000000007ddb80 g2: 0000000000000000 g3: 0000000000000000
> [    0.982760] g4: fffff803fb332a00 g5: fffff8000f8a6000 g6: fffff803fb3a8000 g7: fffff803fc893724
> [    0.982831] o0: fffff803fc8bc010 o1: 00000000007ddb58 o2: fffff803fbba0000 o3: fffff803fb3abd48
> [    0.982907] o4: 0000000000040001 o5: 0000000000000000 sp: fffff803fb3ab391 ret_pc: 00000000005b7524
> [    0.982984] RPC: <dev_attr_show+0x24/0x30>
> [    0.983016] l0: 0000000000000000 l1: 0000000000000000 l2: fffff803fc9a5308 l3: 000000000005a000
> [    0.983074] l4: 0000000000000004 l5: fffff803fb340b00 l6: 0000000000000168 l7: fffff803fbd32700
> [    0.983133] i0: fffffffffffffffb i1: 00000000007ddb58 i2: fffff803fbba0000 i3: 0000000000000000
> [    0.983197] i4: 00000000005002a4 i5: 0000000000000008 i6: fffff803fb3ab451 i7: 0000000000500620
> [    0.983269] I7: <sysfs_read_file+0x80/0x104>
> [    0.983299] Caller[0000000000500620]: sysfs_read_file+0x80/0x104
> [    0.983368] Caller[00000000004bedc0]: vfs_read+0x78/0x10c
> [    0.983556] Caller[00000000004bf114]: sys_read+0x34/0x60
> [    0.983622] Caller[0000000000406294]: linux_sparc_syscall32+0x3c/0x40
> [    0.983707] Caller[0000000000016d90]: 0x16d98
> [    0.983873] Instruction DUMP: 007ddb80  00000000  00000000 <00000000> 00000000  00000000  00000000  00000000  007ddb98 
> 
> This is dev_attr_show() calling attr->show() which points to
> 'part_attr_group' struct instead of a function. :-)

Ick, that's not good :)

How is it working for anyone else then?  sparc64 isn't doing anything
"odd" with it's block devices, is it?

> I'm pretty sure the following changeset is to blame:
> 
> commit edfaa7c36574f1bf09c65ad602412db9da5f96bf
> Author: Kay Sievers <kay.sievers@vrfy.org>
> Date:   Mon May 21 22:08:01 2007 +0200
> 
>     Driver core: convert block from raw kobjects to core devices
>     
>     This moves the block devices to /sys/class/block. It will create a
>     flat list of all block devices, with the disks and partitions in one
>     directory. For compatibility /sys/block is created and contains symlinks
>     to the disks.

So I'm guessing if you revert this it works?

Do you have CONFIG_SYSFS_DEPRECATED=Y or N?

thanks,

greg k-h
