Return-Path: <linux-kernel-owner+w=401wt.eu-S1754035AbZDYEnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbZDYEnc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 00:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbZDYEnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 00:43:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46686 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750898AbZDYEnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 00:43:23 -0400
Date: Fri, 24 Apr 2009 21:41:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: mmotm 2009-04-24-18-14 uploaded - pulseaudio causes BUG
Message-Id: <20090424214135.a6126934.akpm@linux-foundation.org>
In-Reply-To: <4730.1240631533@turing-police.cc.vt.edu>
References: <200904250133.n3P1XBJn006790@imap1.linux-foundation.org>
	<4730.1240631533@turing-police.cc.vt.edu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Apr 2009 23:52:13 -0400 Valdis.Kletnieks@vt.edu wrote:

> On Fri, 24 Apr 2009 18:14:22 PDT, akpm@linux-foundation.org said:
> > The mm-of-the-moment snapshot 2009-04-24-18-14 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> 
> Seeing this consistently and repeatably when trying to start pulseaudio:
> 
> [   70.686993] BUG: unable to handle kernel NULL pointer dereference at 00000000000000c8
> [   70.687012] IP: [<ffffffff80294d0a>] balance_dirty_pages_ratelimited_nr+0x20/0x2e3
> [   70.687012] PGD 7db07067 PUD 7a1c2067 PMD 0
> [   70.687012] Oops: 0000 [#1] PREEMPT SMP
> [   70.687012] last sysfs file: /sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/sda1/start
> [   70.687012] CPU 0
> [   70.687012] Modules linked in: [last unloaded: scsi_wait_scan]
> [   70.687012] Pid: 2109, comm: pulseaudio Not tainted 2.6.30-rc3-mmotm0424 #2 Latitude D820
> [   70.687012] RIP: 0010:[<ffffffff80294d0a>]  [<ffffffff80294d0a>] balance_dirty_pages_ratelimited_nr+0x20/0x2e3
> [   70.687012] RSP: 0000:ffff88007ebcdd28  EFLAGS: 00010296
> [   70.687012] RAX: ffff8800010ca100 RBX: 0000000000000000 RCX: 0000000000000035
> [   70.687012] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
> [   70.687012] RBP: ffff88007ebcddd8 R08: 5900000000000000 R09: 0000000000000000
> [   70.687012] R10: ffffffff80ab9f30 R11: ffff88007ebcdd58 R12: 0000000000000008
> [   70.687012] R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
> [   70.687012] FS:  00007fb7f4a017e0(0000) GS:ffff8800010d8000(0000) knlGS:0000000000000000
> [   70.687012] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   70.687012] CR2: 00000000000000c8 CR3: 000000007ea1f000 CR4: 00000000000006e0
> [   70.687012] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   70.687012] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   70.687012] Process pulseaudio (pid: 2109, threadinfo ffff88007ebcc000, task ffff88007e85e140)
> [   70.687012] Stack:
> [   70.687012]  0000000000000000 0000000000000001 ffff88007ebcdd58 ffffffff8065244d
> [   70.687012]  ffff88007ebcdd58 ffff88007d913d80 ffff88007ebcdd88 ffffffff802cbe06
> [   70.687012]  ffff88007e8e86d8 ffff88007e8e86d8 ffff88007e22f440 0000000000000000
> [   70.687012] Call Trace:
> [   70.687012]  [<ffffffff8065244d>] ? sub_preempt_count+0x35/0x48
> [   70.687012]  [<ffffffff802cbe06>] ? mnt_drop_write+0x108/0x128
> [   70.687012]  [<ffffffff802c735c>] ? file_update_time+0xbd/0xf4
> [   70.687012]  [<ffffffff802a4244>] __do_fault+0x2d2/0x315
> [   70.687012]  [<ffffffff802a44ec>] handle_mm_fault+0x265/0x598
> [   70.687012]  [<ffffffff80250090>] ? down_read_trylock+0x3f/0x4b
> [   70.687012]  [<ffffffff806522f7>] ? do_page_fault+0x107/0x228
> [   70.687012]  [<ffffffff80652403>] do_page_fault+0x213/0x228
> [   70.687012]  [<ffffffff8065037f>] page_fault+0x1f/0x30
> [   70.687012] Code: 5e 5f 5b 41 5c 41 5d 41 5e c9 c3 55 48 89 e5 41 57 41 56 41 55 49 89 f5 41 54 41 bc 08 00 00 00 53 48 89 fb 48 81 ec
>  88 00 00 00 <48> 8b 87 c8 00 00 00 bf 01 00 00 00 83 b8 68 01 00 00 00 4c 0f
> [   70.687012] RIP  [<ffffffff80294d0a>] balance_dirty_pages_ratelimited_nr+0x20/0x2e3
> [   70.687012]  RSP <ffff88007ebcdd28>
> [   70.687012] CR2: 00000000000000c8
> [   71.492293] ---[ end trace 3270cbac9ba6a165 ]---
> 
> The tail end of 'strace pulseaudio -vvvv':
> 
> open("/dev/snd/pcmC0D0p", O_RDWR|O_NONBLOCK) = 15
> close(14)                               = 0
> ioctl(15, AGPIOC_ACQUIRE or APM_IOC_STANDBY, 0x7fffb11a9c00) = 0
> fcntl(15, F_GETFL)                      = 0x8802 (flags O_RDWR|O_NONBLOCK|O_LARGEFILE)
> ioctl(15, AGPIOC_INFO, 0x7fffb11a9bfc)  = 0
> ioctl(15, AGPIOC_SETUP, 0x7fffb11a9bf8) = 0
> mmap(NULL, 4096, PROT_READ, MAP_SHARED, 15, 0x80000000) = 0x7f3ea91a2000
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_SHARED, 15, 0x81000000) = 0x7f3ea91a1000
> fcntl(15, F_GETFL)                      = 0x8802 (flags O_RDWR|O_NONBLOCK|O_LARGEFILE)
> fcntl(15, F_SETFL, O_RDWR|O_LARGEFILE)  = 0
> open("/dev/snd/controlC0", O_RDONLY)    = 14
> close(14)                               = 0
> stat("/usr/share/alsa/alsa.conf", {st_mode=S_IFREG|0644, st_size=8940, ...}) = 0
> open("/dev/snd/controlC0", O_RDONLY)    = 14
> close(14)                               = 0
> open("/dev/snd/controlC0", O_RDWR)      = 14
> ioctl(14, USBDEVFS_CONTROL, 0x7fffb11a9eec) = 0
> ioctl(14, USBDEVFS_CONNECTINFO, 0x7fffb11a9f90) = 0
> ioctl(14, 0xffffffffc008551a, 0x77a640) = 0
> ioctl(15, 0xc2604110, 0x7fffb11aa040)   = 0
> ioctl(15, 0xc2604110, 0x7fffb11aa040)   = 0
> ioctl(15, 0xc2604110, 0x7fffb11aa040)   = 0
> ioctl(15, 0xc2604110, 0x7fffb11a9d90)   = 0
> ioctl(15, 0xc2604110, 0x7fffb11a9d30)   = 0
> ioctl(15, 0xc2604110, 0x7fffb11a9d30)   = 0
> ioctl(15, 0xc2604110, 0x7fffb11a9ad0)   = 0
> ioctl(15, 0xc2604110, 0x7fffb11a9ad0)   = 0
> ioctl(2, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo ...}) = 0
> write(2, "D: alsa-util.c: Maximum hw buffer"..., 49D: alsa-util.c: Maximum hw buffer size is 371 ms
> ) = 49
> ioctl(15, 0xc2604110, 0x7fffb11a9ad0)   = 0
> ioctl(15, 0xc2604110, 0x7fffb11a9ab0)   = 0
> ioctl(15, 0xc2604110, 0x7fffb11a9ab0)   = 0
> ioctl(15, 0xc2604110, 0x7fffb11a9f80)   = 0
> ioctl(15, 0xc2604110, 0x7fffb11a9f50)   = 0
> ioctl(15, 0xc2604110, 0x7fffb11a9f50)   = 0
> ioctl(15, 0xc2604110, 0x7fffb11a9f80)   = 0
> ioctl(15, 0xc2604111, 0x7fffb11a9f80)   = 0
> ioctl(15, 0xc0884113, 0x7fffb11a9ed0)   = 0
> +++ killed by SIGKILL +++
> 
> Not sure what pulseaudio is doing with its page faults that causes it.
> I won't have a chance to bisect this until tomorrow....

Sound drivers install their own vm_operations.fault() handlers.  I
assume that mm-close-page_mkwrite-races-try-3.patch is causing core MM
to call calling balance_dirty_pages() due to a fault against a sounds
device, which is somewhat wrong.

This might plug things up, but I didn't put a lot of thought into it.

--- a/mm/memory.c~mm-close-page_mkwrite-races-try-3-fix
+++ a/mm/memory.c
@@ -2129,7 +2129,8 @@ unlock:
 			set_page_dirty(dirty_page);
 			unlock_page(dirty_page);
 			page_cache_release(dirty_page);
-			balance_dirty_pages_ratelimited(mapping);
+			if (mapping)
+				balance_dirty_pages_ratelimited(mapping);
 		}
 	}
 	return ret;
@@ -2769,7 +2770,7 @@ out:
 			page_mkwrite = 1;
 		unlock_page(dirty_page);
 		put_page(dirty_page);
-		if (page_mkwrite)
+		if (page_mkwrite && mapping)
 			balance_dirty_pages_ratelimited(mapping);
 	} else {
 		unlock_page(vmf.page);
_

