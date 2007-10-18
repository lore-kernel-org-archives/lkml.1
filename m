Return-Path: <linux-kernel-owner+w=401wt.eu-S1764379AbXJRMxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764379AbXJRMxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 08:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761957AbXJRMxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 08:53:23 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:52660 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761692AbXJRMxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 08:53:22 -0400
Date: Thu, 18 Oct 2007 14:53:16 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Nevine AbouGhazaleh <nevine@cs.pitt.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: suspend-to-disk using a SAS drive
Message-ID: <20071018125316.GA22228@elf.ucw.cz>
References: <46B67B03.1050008@cs.pitt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B67B03.1050008@cs.pitt.edu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2007-08-05 18:36:03, Nevine AbouGhazaleh wrote:
> I am trying to suspend-to-disk using the Suspend2 modules. I am using an 
> SSD drive connected through a SAS bus interface. The SSD acts as a boot 
> disk.
> All read and write transactions to the drive works well during normal 
> operation.  when I hibernate (suspend-to-disk).
>
> I get the following errors:
> ------------------
> mptbase: ioc0: ERROR ? Invalid IOC facts reply, msgLength=0 offset=6
> pnp: Failed to activate device 00:09.
> pnp: Failed to activate device 00:0a.
> ------------
>
> Immediately after these messages, Linux hangs as soon as it starts writing 
> the image to the drive. showing the following output.
> ------------------
> Writing Kernel and process data ...
> 20%...
> ------------------
>
>
> When using KDB to trace the problem after the kernel hung.
>
> <ps> shows a running process: Ks2io
>
> when doing Back Trace for Ks2io wheen the kernel hangs, I get the following 
> trace
> --------------------
> _spin_unlock_irq+0xb
> thread_return+0x64
> _raw_spin_lock+ox90
> __mutex_up_process+0x10
> wake_up_process+0x10
> suspend_bio_write_page
> mutex_lock+0x2a
> flush_workqueue+0x51
> kblockd_flush+0x10
> do_bio_wait+0x1b
> suspend_bio_write_page
> suepend_bio_write_page+0x41
> suspend_compress_write_page+0x137
> worker_rw_loop
> worker_rw_loop+0x133
> worker_rw_loop
> kthread+0xf5
> schedule_tail_0x45
> child_rip+0x45
> worker_thread
> kthread
> child_rip --------------------
>
> It seems that the problem is when suspend2 tries to write to the SSD drive.
> I am not sure whether the problem is with the suspend2 module or the mpt 
> driver? I am using kernel 2.6.21.1 x86_64 with fedora core 5 x86_64. MPT 
> driver 3.04
> Any insights/recommendations will be greatly appreciated.  

Try latest kernel without suspend2 patch... ... if it hangs at 20% you
may have a chance that driver already has some suspend/resume support.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
