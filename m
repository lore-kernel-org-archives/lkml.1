Return-Path: <linux-kernel-owner+w=401wt.eu-S1756635AbYDCMqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbYDCMqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 08:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752664AbYDCMqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 08:46:17 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:40604 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbYDCMqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 08:46:16 -0400
Date: Thu, 3 Apr 2008 14:46:15 +0200
From: Jan Kara <jack@suse.cz>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, stable@kernel.org,
       npiggin@suse.de, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [BUG] 2.6.24.4 kernel bug while running ftest03
Message-ID: <20080403124615.GA4214@atrey.karlin.mff.cuni.cz>
References: <47F48DD3.8070103@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47F48DD3.8070103@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

> The kernel panic's, while running the LTP ftest03 on the 2.6.24.4 kernel
> compiled with the gcov patches from LTP.
> (http://ltp.cvs.sourceforge.net/ltp/utils/analysis/gcov-kernel/linux-2.6.24-gcov.patch?view=markup) 
  Are you able to reproduce the problem without this patch? The patch is
nontrivial...

> BUG: unable to handle kernel paging request at virtual address f8000004
  The address is a bit strange. Looks like we have advanced iov beyond
the area we have allocated. Can you send me disassembly of the function
iov_iter_advance() of your kernel? Thanks.

> printing eip: c01c2836 *pdpt = 0000000000004001 *pde = 0000000000000000 
> Oops: 0000 [#1] SMP 
> 
> Modules linked in: hidp rfcomm l2cap bluetooth dm_multipath nvram via686a hwmon i2c_viapro pcspkr mptsas scsi_transport_sas floppy tg3 parport_pc ac battery button dm_mirror dm_mod joydev sunrpc i2c_dev i2c_core autofs4 lp parport ipv6 md5 sg mptspi mptscsih mptbase scsi_transport_spi sd_mod scsi_mod ehci_hcd ohci_hcd uhci_hcdPid: 24160, comm: ftest03 Not tainted (2.6.24.4-gcov-autokern1 #1) 
> 
> EIP: 0060:[<c01c2836>] EFLAGS: 00010246 CPU: 1
> EIP is at iov_iter_advance+0xe9/0x155
> EAX: 00000000 EBX: f3457d98 ECX: 00000080 EDX: 00000000
> ESI: 00000000 EDI: f8000000 EBP: f33f6d30 ESP: f3457d24
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process ftest03 (pid: 24160, ti=f3457000 task=f6544590 task.ti=f3457000)
> Stack: 00000800 0006b800 00000000 c01c5e79 0006b800 00000000 00000800 00000800 
>        c7209030 c015cdea f3457e8c f7fb9180 f33f6d30 c07b1600 f33f6c68 00000000 
>        00000800 00000800 00000000 c07b1600 00000000 0000006b f3457da8 c02f11cd 
> Call Trace:
>  [<c01c5e79>] generic_file_buffered_write+0x29f/0xc05
>  [<c015cdea>] current_fs_time+0x4e/0x6f
>  [<c02f11cd>] ext3_readpages+0x0/0x35
>  [<c02f11cd>] ext3_readpages+0x0/0x35
>  [<c01d1da4>] __do_page_cache_readahead+0x268/0x386
>  [<c015cdea>] current_fs_time+0x4e/0x6f
>  [<c01c6f97>] __generic_file_aio_write_nolock+0x7b8/0x852
>  [<c01c70be>] generic_file_aio_write+0x8d/0x162
>  [<c01c7bfd>] generic_file_aio_read+0x292/0x31a
>  [<c02ecfc2>] ext3_file_write+0x32/0x17c
>  [<c020b830>] do_sync_readv_writev+0xcf/0x152
>  [<c01c5163>] wait_on_page_writeback_range+0x153/0x1e7
>  [<c017d0f7>] autoremove_wake_function+0x0/0x5f
>  [<c04f21b9>] copy_from_user+0xb1/0x135
>  [<c020b602>] rw_copy_check_uvector+0xd2/0x19f
>  [<c020c4f6>] do_readv_writev+0x152/0x328
>  [<c02ecf90>] ext3_file_write+0x0/0x17c
>  [<c079c11d>] _spin_unlock+0x13/0x22
>  [<c01b427e>] audit_syscall_entry+0x2eb/0x323
>  [<c020c758>] vfs_writev+0x8c/0x9e
>  [<c020cf6c>] sys_writev+0x8b/0x1a5
>  [<c0108a76>] syscall_call+0x7/0xb
>  =======================
> Code: c0 00 29 c8 01 ce 89 43 0c 39 77 04 75 13 83 c7 08 83 05 98 63 a6 c0 01 83 15 9c 63 a6 c0 00 31 f6 29 ca 85 d2 0f 85 78 ff ff ff <83> 7f 04 00 75 29 83 05 a0 63 a6 c0 01 83 15 a4 63 a6 c0 00 83 EIP: [<c01c2836>] iov_iter_advance+0xe9/0x155 SS:ESP 0068:f3457d24---[ end trace af3ae442124c3d18 ]---

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
