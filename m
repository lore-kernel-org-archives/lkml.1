Return-Path: <linux-kernel-owner+w=401wt.eu-S932929AbXBLCDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932929AbXBLCDm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 21:03:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932931AbXBLCDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 21:03:41 -0500
Received: from 87-194-2-4.bethere.co.uk ([87.194.2.4]:59915 "EHLO
	mail.arasphere.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932929AbXBLCDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 21:03:41 -0500
X-Greylist: delayed 1563 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Feb 2007 21:03:41 EST
Message-ID: <45CFC4DE.9010504@arasphere.net>
Date: Mon, 12 Feb 2007 01:37:34 +0000
From: Matthew Hodgson <matthew@arasphere.net>
User-Agent: Thunderbird 1.5.0.9 (Macintosh/20061207)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: BUG: at fs/nfs/pagelist.c:339 nfs_scan_dirty()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just upgraded from 2.6.13.4 to 2.6.20 on a Pentium M, and on booting 
off an NFS root encountered the following bug somewhere after loading 
the w83627hf module and before ohci1394:

BUG: at fs/nfs/pagelist.c:339 nfs_scan_dirty()
  [<c01da1b6>] nfs_scan_dirty+0x168/0x17d
  [<c01dd54a>] nfs_wait_on_requests_locked+0x9c/0xac
  [<c01dda9b>] nfs_sync_mapping_wait+0xad/0x256
  [<c01de35a>] nfs_sync_mapping_range+0x83/0x9e
  [<c01d8037>] nfs_getattr+0x37/0x98
  [<c01d8000>] nfs_getattr+0x0/0x98
  [<c014be19>] vfs_getattr+0x21/0x30
  [<c014c203>] vfs_stat_fd+0x2e/0x40
  [<c0224ec4>] __copy_to_user_ll+0xc9/0xd4
  [<c014c2a2>] sys_stat64+0xf/0x23
  [<c010f5bb>] do_page_fault+0x277/0x528
  [<c0149c61>] vfs_read+0xfa/0x134
  [<c010f344>] do_page_fault+0x0/0x528
  [<c0102c98>] syscall_call+0x7/0xb
  =======================

So far the machine appears stable other than this - but after having had 
a year or so of perfect uptime on the box under 2.6.13.4 with no such 
kernel errors, I thought you might like to know in case this indicates 
something more serious.

The kernel options given to boot off NFS were...

root=/dev/nfs rw 
nfsroot=192.168.0.x:/home/stb,v3,hard,intr,nolock,retrans=6,rsize=16384,wsize=16384 
ip=dhcp

...and the full dmesg, kernel config, lspci and lsmod output may be 
found at http://www.arasphere.net/linux/nfs-bug.  The NFS server is 
running the default NFS v3 options on 2.6.20 on Core 2 Duo.  No patches 
have been applied to either kernel.

Any advice on whether I should be worried by this, whether it indicates 
that something significant is wrong, and how I might help debug it would 
be appreciated.

thanks.

Matthew.
