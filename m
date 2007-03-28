Return-Path: <linux-kernel-owner+w=401wt.eu-S933191AbXC1RCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933191AbXC1RCQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 13:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933200AbXC1RCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 13:02:16 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:37799 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933191AbXC1RCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 13:02:15 -0400
Date: Wed, 28 Mar 2007 19:02:14 +0200
From: Andreas Mohr <andi@rhlx01.fht-esslingen.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Con Kolivas <kernel@kolivas.org>, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc5-mm2
Message-ID: <20070328170214.GA13044@rhlx01.hs-esslingen.de>
References: <20070326211627.c681af3b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070326211627.c681af3b.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-Priority: none
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Mar 26, 2007 at 09:16:27PM -0800, Andrew Morton wrote:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm2/
> 
> 
> - This is the same as 2.6.12-rc5-mm1, except the staircase deadline CPU
>   scheduler has been added.

OOPS (hand-pasted), happens on roughly 85% of bootups, didn't seem to
occur during my several previous 2.6.21-rc4-mm1 bootups:

-----
...
Setting up ICE socket directory /tmp/.ICE-unix...done.
BUG: unable to handle kernel NULL pointer dereference at virtual address 00000024
!!!!! ======> last sysfs file: block/loop7/removable <=======
Process init
trace:
show_trace_log_lvl+0x1a
show_stack_log_lvl+0x9d
show_registers+0x1c0
die+0xe5
do_page_fault+0x432
error_code+0x71
sysfs_drop_dentry+0x30
sysfs_hash_and_remove+0x8e
sysfs_remove_file+0xd
device_remove_file+0x1c
device_del+0x1ed
device_unregister+0x26
device_destroy+0x8a
vcs_remove_sysfs+0x1a
con_close+0x4c
release_dev+0x1f0
tty_release+0xa
__fput+0xb8
fput+0x31
filp_close+0x54
put_files_struct+0x7c
do_exit+0x1e3
sys_exit_group+0x0
sys_exit_group+0xf
syscall_call+0x7
EIP: __iget+0x6
Fixing recursive fault but reboot is needed!
-----

Any hints? Possibly existing bug surfaced due to RSDL scheduling timing
differences? I did NOT test -mm1 to check this.

P3/700 UP i815 IDE ext3, Debian unstable.

Further .config available on request.

Note that something killed my /bin/run-parts (Debian) and S10portmap files
(and possibly some others are corrupted??), so it might be something fishy
(but this fishiness could also have uncovered this OOPS, so...).
Restoring those files didn't change the status quo.

CC'd relevant maintainers/recent submitters.

Andreas Mohr
