Return-Path: <linux-kernel-owner+w=401wt.eu-S1755121AbZFESfD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121AbZFESfD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 14:35:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbZFESex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 14:34:53 -0400
Received: from mail.fieldses.org ([141.211.133.115]:58685 "EHLO
	pickle.fieldses.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbZFESex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 14:34:53 -0400
Date: Fri, 5 Jun 2009 14:34:55 -0400
To: Sergey Lapin <slapin@ossfans.org>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: nfsd loads 90% CPU, client hangs
Message-ID: <20090605183455.GC14043@fieldses.org>
References: <20090605042754.GB576@build.ossfans.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090605042754.GB576@build.ossfans.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05, 2009 at 08:27:54AM +0400, Sergey Lapin wrote:
> Hi, all!
> 
> With recent kernels I see a problem with using NFS. It was broken
> somewhere after 2.6.27.

In other words, it worked in 2.6.27?  So the regression is somewhere
between 2.6.27 and 2.6.30-rc8?

Can you figure out what the running nfsd threads are doing?

--b.

> 
> I have ARM board with several hard drives connected over USB 1.1
> dongles (USB->IDE, USB->SATA). And I have lvm2 over them.
> They produce 2 logical volumes with data, which are exported
> over NFS to PC host. ARM box runs vanilla kernel 2.6.30-rc8,
> and PC host runs Debian kernel 2.6.24. After some bigger file writes
> (when large amounts of data are written to disks) I experience the
> following error in logs on ARM nfsd server host. I use kernel nfsd here,
> to be clear. I use NFSv3.
> 
> INFO: task nfsd:1933 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
> message.
> nfsd          D c02e29e8     0  1933      2
> [<c02e29e8>] (__schedule+0x2d8/0x348) from [<c02e374c>]
> (__mutex_lock_slowpath+0x8c/0xfc)
> [<c02e374c>] (__mutex_lock_slowpath+0x8c/0xfc) from [<c006d670>]
> (generic_file_aio_write+0x58/0xe8)
> [<c006d670>] (generic_file_aio_write+0x58/0xe8) from [<c00dc1ec>]
> (ext3_file_write+0x20/0xa0)
> [<c00dc1ec>] (ext3_file_write+0x20/0xa0) from [<c0093cc8>]
> (do_sync_readv_writev+0xac/0x100)
> [<c0093cc8>] (do_sync_readv_writev+0xac/0x100) from [<c00943e4>]
> (do_readv_writev+0xac/0x1b0)
> [<c00943e4>] (do_readv_writev+0xac/0x1b0) from [<c009454c>]
> (vfs_writev+0x64/0x74)
> [<c009454c>] (vfs_writev+0x64/0x74) from [<c0124c88>]
> (nfsd_vfs_write+0x10c/0x350)
> [<c0124c88>] (nfsd_vfs_write+0x10c/0x350) from [<c01257b4>]
> (nfsd_write+0xc0/0xd8)
> [<c01257b4>] (nfsd_write+0xc0/0xd8) from [<c012c354>]
> (nfsd3_proc_write+0xe8/0x114)
> [<c012c354>] (nfsd3_proc_write+0xe8/0x114) from [<c0120f90>]
> (nfsd_dispatch+0xcc/0x1e4)
> [<c0120f90>] (nfsd_dispatch+0xcc/0x1e4) from [<c02d3f34>]
> (svc_process+0x42c/0x7a8)
> [<c02d3f34>] (svc_process+0x42c/0x7a8) from [<c0121640>]
> (nfsd+0xe4/0x148)
> [<c0121640>] (nfsd+0xe4/0x148) from [<c0056720>] (kthread+0x58/0x90)
> [<c0056720>] (kthread+0x58/0x90) from [<c0044e90>] (do_exit+0x0/0x620)
> [<c0044e90>] (do_exit+0x0/0x620) from [<ffffffff>] (0xffffffff)
> 
> And then NFS doesn't work at all with nfsd consuming all of CPU it can.
> I see no hardware problems here, because files are perfectly accessible
> locally or over HTTP, and no USB or disk error messages.
> 
> If I reboot ARM box without unmounting NFS shares on PC, the same
> situation occurs as soon as ARM box boots (excessively loaded CPU with
> nfsd at top, and NFS doesn't work and doesn't recover). If I unmount
> them, box boots fine, but fails again as soon as I repeat file
> operation.
> So, the question is - what causes it and if it is possible to fix this
> problem or work it around?
> 
> Thanks a lot,
> S.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
