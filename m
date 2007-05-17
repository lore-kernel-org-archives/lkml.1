Return-Path: <linux-kernel-owner+w=401wt.eu-S1755932AbXEQIVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbXEQIVe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 04:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755205AbXEQIVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 04:21:19 -0400
Received: from barclay.balt.net ([195.14.162.78]:15114 "EHLO barclay.balt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754835AbXEQIVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 04:21:12 -0400
Subject: Re: Kernel NFS lockd freezes notebook on shutdown (Linux
	2.6.22-rc1 + CFS v12)
From: Zilvinas Valinskas <zilvinas@wilibox.com>
Reply-To: zilvinas@wilibox.com
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070516225543.GA337@tv-sign.ru>
References: <1179338441.4265.13.camel@zv.wilibox.com>
	 <20070516121538.7b108c10.akpm@linux-foundation.org>
	 <20070516225543.GA337@tv-sign.ru>
Content-Type: text/plain
Date: Thu, 17 May 2007 11:21:05 +0300
Message-Id: <1179390065.4760.5.camel@zv.wilibox.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Oleg, 

Patch seems to help and it seems kernel doesn't free anymore. I've
booted new kernel and did :

#1 $ sudo /etc/init.d/nfs-kernel-server stop
#2 $ sudo /etc/init.d/nfs-common stop

Previously it was enough to run '#1' to freeze the kernel. This time
with your patch applied #1 and #2 worked fine. So far so good. Don't
know why , but I've tried to run #1 & #2 several times  - as a result
OOPS (kernel is tainted). Opps from dmesg:

[  429.103734] usb 1-5.4: link qh8-0601/ffff81003ebac320 start 7 [1/2 us]
[  436.009276] nfsd: last server has exited
[  436.009410] nfsd: unexporting all filesystems
[  436.011395] RPC: failed to contact local rpcbind server (errno 5).
[  460.950495] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[  460.950659] NFSD: starting 90-second grace period
[  615.796112] nfsd: last server has exited
[  615.796121] nfsd: unexporting all filesystems
[  615.800976] RPC: failed to contact local rpcbind server (errno 5).
[  619.444368] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[  619.444403] NFSD: starting 90-second grace period
[  620.576730] nfsd: last server has exited
[  620.576739] nfsd: unexporting all filesystems
[  620.581036] RPC: failed to contact local rpcbind server (errno 5).
[  621.606324] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[  621.606359] NFSD: starting 90-second grace period
[  622.561989] nfsd: last server has exited
[  622.561999] nfsd: unexporting all filesystems
[  623.639396] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[  623.639430] NFSD: starting 90-second grace period
[  623.639487] Unable to handle kernel paging request at ffffffff00000000 RIP: 
[  623.639492]  [<ffffffff8041c47f>] __kfree_skb+0x9f/0x150
[  623.639504] PGD 203067 PUD 0 
[  623.639510] Oops: 0002 [1] PREEMPT SMP 
[  623.639515] CPU 0 
[  623.639519] Modules linked in: fglrx(P) nfs nfsd exportfs lockd nfs_acl sunrpc ppdev lp autofs4 ipw3945 ieee80211 ieee80211_crypt ipv6 deflate zlib_deflate twofish twofish_common camellia serpent blowfish des cbc ecb blkcipher aes xcbc sha256 sha1 crypto_null af_key piix ide_core dm_crypt dm_snapshot dm_mirror dm_mod sbp2 loop coretemp cpufreq_conservative cpufreq_stats acpi_cpufreq freq_table usbhid pl2303 ohci1394 ieee1394 usbserial pcmcia firmware_class snd_hda_intel snd_pcm_oss snd_mixer_oss sdhci snd_pcm joydev iTCO_wdt fw_ohci fw_core mmc_core snd_timer tg3 sg snd yenta_socket rsrc_nonstatic pcmcia_core crc_itu_t iTCO_vendor_support tifm_7xx1 tsdev parport_pc parport intel_agp tpm_infineon tpm tpm_bios uhci_hcd sr_mod tifm_core ehci_hcd psmouse soundcore snd_page_alloc pcspkr serio_raw evdev cdrom
[  623.639616] Pid: 616, comm: udevd Tainted: P       2.6.22-rc1-cfs-v12 #2
[  623.639622] RIP: 0010:[<ffffffff8041c47f>]  [<ffffffff8041c47f>] __kfree_skb+0x9f/0x150
[  623.639631] RSP: 0018:ffff81003ed87be8  EFLAGS: 00010286
[  623.639635] RAX: ffff81003f2144a0 RBX: 0000000000000000 RCX: 0000000000000000
[  623.639641] RDX: 0000000000000130 RSI: ffff8100285eb400 RDI: ffffffff00000000
[  623.639646] RBP: ffff8100285eb400 R08: 000000000050eaf0 R09: 0000000000000000
[  623.639651] R10: 0000000000000000 R11: 0000000000000246 R12: ffff81003f214400
[  623.639656] R13: ffff81003ed87ee8 R14: ffff8100285eb440 R15: 0000000000000000
[  623.639662] FS:  00002b0370c18e00(0000) GS:ffffffff80603000(0000) knlGS:0000000000000000
[  623.639667] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  623.639672] CR2: ffffffff00000000 CR3: 000000003ed6c000 CR4: 00000000000006e0
[  623.639678] Process udevd (pid: 616, threadinfo ffff81003ed86000, task ffff81003ecd0000)
[  623.639682] Stack:  ffff81003ed87ee8 ffff81003ed87e68 ffff8100285eb400 ffffffff8043b6a6
[  623.639694]  0000000100000000 ffff810001ff7b80 0000000000000050 ffff81003ed87db8
[  623.639702]  0000000000000000 0000000000000000 0000000000000000 0000000000000000
[  623.639709] Call Trace:
[  623.639719]  [<ffffffff8043b6a6>] netlink_recvmsg+0x176/0x3a0
[  623.639739]  [<ffffffff80415b80>] sock_recvmsg+0x150/0x170
[  623.639754]  [<ffffffff8024e760>] autoremove_wake_function+0x0/0x30
[  623.639768]  [<ffffffff802a531e>] core_sys_select+0x26e/0x350
[  623.639785]  [<ffffffff802a9f05>] __d_lookup+0x165/0x180
[  623.639797]  [<ffffffff80416f8e>] sys_recvfrom+0xfe/0x190
[  623.639807]  [<ffffffff8024e969>] remove_wait_queue+0x19/0x60
[  623.639823]  [<ffffffff802a5874>] sys_select+0x44/0x1c0
[  623.639836]  [<ffffffff8020a2ae>] system_call+0x7e/0x83
[  623.639849] 
[  623.639851] 
[  623.639852] Code: f0 ff 0f 0f 94 c0 84 c0 75 27 66 c7 85 a8 00 00 00 00 00 66 
[  623.639871] RIP  [<ffffffff8041c47f>] __kfree_skb+0x9f/0x150
[  623.639878]  RSP <ffff81003ed87be8>
[  623.639881] CR2: ffffffff00000000

Hmm, I've got something different now :( - 


On Thu, 2007-05-17 at 02:55 +0400, Oleg Nesterov wrote:
> On Wed, 16 May 2007 21:00:41 +0300
> Zilvinas Valinskas <zilvinas@wilibox.com> wrote:
> > 
> > In short, on shutdown my laptop is always freezing now. I was able to
> > capture the 'sysrq-P' (hit that several times), sysrq-T outputs. Please
> > see .config and log messages at http://barclay.balt.net/~zilvinas/oops/ 
> > 
> > Kernel version I had built according git is :
> > 
> > zilvinas@zv:/projects/linux-amd64.git$ git describe HEAD
> > v2.6.22-rc1-29-gfaa8b6c
> > 
> > On top of that I have CFS v12 applied (no other changes otherwise).
> > Please note that there is ''fglrx.ko'' loaded and kernel is tainted
> > because of that (feel free to ignore the report ...).
> > 
> > Anyway, 'sysrq-P' always show that PC is stuck at (NFS lockd?) and it is
> > always the same backtrace is shown. 'sysrq-t' output is in
> > 'kernel-nfs-freeze.log' file (did not want to post it here).
> > 
> >  Pid: 3652, comm: lockd Tainted: P       2.6.22-rc1-cfs-v12 #1
> > 
> > [<ffffffff8024a5a0>] wq_barrier_func+0x0/0x10
> > [<ffffffff8024a7e5>] destroy_workqueue+0x75/0xa0
> > [<ffffffff8833cd34>] :sunrpc:rpciod_down+0xf4/0x170
> > [<ffffffff8836dd74>] :lockd:lockd+0x244/0x300
> > [<ffffffff80233e1f>] schedule_tail+0x3f/0xb0
> > [<ffffffff8020b0f8>] child_rip+0xa/0x12
> > [<ffffffff8836db30>] :lockd:lockd+0x0/0x300
> > [<ffffffff8836db30>] :lockd:lockd+0x0/0x300
> > [<ffffffff8020b0ee>] child_rip+0x0/0x12
> > 
> > Hope this helps. Thanks in advance for any advice how to solve problem !
> > For now I am back to '2.6.21.1-cfs-v10'.
> > 
> 
> Nice, thanks.
> 
> Zilvinas, could you try the patch below?
> 
> It is a shot in the dark. I hope I'll suggest somethimg better tomorrow.
> 
> Oleg.
> 
> --- OLD/kernel/workqueue.c~	2007-05-17 00:15:37.000000000 +0400
> +++ OLD/kernel/workqueue.c	2007-05-17 02:51:15.000000000 +0400
> @@ -752,16 +752,25 @@ static void cleanup_workqueue_thread(str
>  	spin_unlock_irq(&cwq->lock);
>  
>  	if (alive) {
> +		int n;
> +
>  		wait_for_completion(&barr.done);
>  
> -		while (unlikely(cwq->thread != NULL))
> -			cpu_relax();
> -		/*
> -		 * Wait until cwq->thread unlocks cwq->lock,
> -		 * it won't touch *cwq after that.
> -		 */
> -		smp_rmb();
> -		spin_unlock_wait(&cwq->lock);
> +		for (n = 0;; ++n) {
> +			spin_lock_irq(&cwq->lock);
> +			alive = (cwq->thread != NULL);
> +			spin_unlock_irq(&cwq->lock);
> +
> +			if (!alive)
> +				break;
> +
> +			if (n > 1000) {
> +				printk(KERN_CRIT "ERR!! wq: %s\n", cwq->wq->name);
> +				break;
> +			}
> +
> +			yield();
> +		}
>  	}
>  }
>  
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

