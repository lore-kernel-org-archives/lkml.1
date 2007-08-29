Return-Path: <linux-kernel-owner+w=401wt.eu-S1759237AbXH2C6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759237AbXH2C6b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 22:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754431AbXH2C6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 22:58:22 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47787 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754420AbXH2C6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 22:58:21 -0400
Date: Tue, 28 Aug 2007 19:58:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
       SCSI Mailing List <linux-scsi@vger.kernel.org>
Subject: Re: oops at sr_block_release [Re: 2.6.23-rc3-mm1]
Message-Id: <20070828195813.02ab1d1c.akpm@linux-foundation.org>
In-Reply-To: <46D407E9.3070603@gmail.com>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	<46D407E9.3070603@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Aug 2007 13:32:57 +0200 Jiri Slaby <jirislaby@gmail.com> wrote:

> Andrew Morton napsal(a):
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc3/2.6.23-rc3-mm1/
> 
> I got this during gxine initialization of ocko.tv live stream without any cd in
> cdroms:
> 
> BUG: unable to handle kernel NULL pointer dereference at virtual address 0000005c
> printing eip: f88fbe7a *pde = 00000000
> Oops: 0000 [#1] SMP
> Modules linked in: ath5k arc4 ecb blkcipher cryptomgr crypto_algapi
> rc80211_simple mac80211 cfg80211 nls_cp437 vfat fat usb_storage tun ipv6 floppy
> parport_pc parport ohci1394 ieee1394 usbhid sr_mod ehci_hcd cdrom ff_memless
> 
> Pid: 2809, comm: hald-addon-stor Not tainted (2.6.23-rc3-mm1 #315)
> EIP: 0060:[<f88fbe7a>] EFLAGS: 00010246 CPU: 1
> EIP is at sr_block_release+0xb/0x2c [sr_mod]
> EAX: 00000000 EBX: 00000000 ECX: f88fbe6f EDX: 00000000
> ESI: c21c36c0 EDI: c289a780 EBP: c3729f18 ESP: c3729f10
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process hald-addon-stor (pid: 2809, ti=c3729000 task=c1c2be40 task.ti=c3729000)
> Stack: 00000000 c21c36c0 c3729f38 c018d7ad c21c36cc c1f9ff80 c21c3730 c21c36c0
>        c2a6ada0 dcbb3f80 c3729f40 c018d7dc c3729f4c c018e103 00000010 c3729f74
>        c016bc5f 00000000 00000000 c217fa80 c1f9ff80 c2a6ada0 dcbb3f80 c1cc6900
> Call Trace:
>  [<c0105022>] show_trace_log_lvl+0x1a/0x30
>  [<c01050dd>] show_stack_log_lvl+0xa5/0xca
>  [<c01051d2>] show_registers+0xd0/0x1c1
>  [<c01053cd>] die+0x10a/0x24d
>  [<c011afbe>] do_page_fault+0x496/0x608
>  [<c03768e2>] error_code+0x72/0x78
>  [<c018d7ad>] __blkdev_put+0x125/0x14a
>  [<c018d7dc>] blkdev_put+0xa/0xc
>  [<c018e103>] blkdev_close+0x29/0x2c
>  [<c016bc5f>] __fput+0xa6/0x161
>  [<c016bea4>] fput+0x22/0x3b
>  [<c016960b>] filp_close+0x41/0x67
>  [<c016a78c>] sys_close+0x60/0x9f
>  [<c01040ce>] syscall_call+0x7/0xb
>  =======================
> Code: 0c 81 c3 4c 01 00 00 89 5c 24 08 89 44 24 04 c7 04 24 88 cd 8f f8 e8 99 84
> 82 c7 e9 04 fe ff ff 55 89 e5 56 53 8b 80 04 01 00 00 <8b> 40 5c 8b 70 3c 8d 46
> 18 e8 cf f6 fe ff 89 c3 85 c0 75 07 89
> EIP: [<f88fbe7a>] sr_block_release+0xb/0x2c [sr_mod] SS:ESP 0068:c3729f10
> 

Possibly due to remove-bdput-from-do_open-in-fs-block_devc.patch.

That patch is "wrong" and I think the problem which it attempts to address
actually lies in the cdrom code.  viro was taking a look at it but appears
to have recoiled in horror.  I'll drop
remove-bdput-from-do_open-in-fs-block_devc.patch so let's just watch out
for any reoccurrence, thanks.

