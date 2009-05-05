Return-Path: <linux-kernel-owner+w=401wt.eu-S1755504AbZEEFq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504AbZEEFq0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 01:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbZEEFqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 01:46:17 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:65071 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680AbZEEFqQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 01:46:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NttJYY55uyA/ja8OCZm/CHVJjjED5Bn9QXOyb+bK/mQTW5MvFf4oSt5Z76ISCXBzdn
         aletQ7+4uKWRlTFNBUF56RLyI8QxCO1KqbkI/073VO+n80Y5Sm3KtYaUoBkrr8ziw62a
         tbrPleAFhzgg5s3519zbxPxsRf0j4mvGKQJho=
MIME-Version: 1.0
In-Reply-To: <b1bc6a000905042131t3656f14arc98dc4a518543a86@mail.gmail.com>
References: <egHshlwQQFE.A.8CD.mpE9JB@chimera>
	 <20090428172845R.fujita.tomonori@lab.ntt.co.jp>
	 <db2b43030904280218v61fded68rc585ce9c58ba1cce@mail.gmail.com>
	 <20090428184431Z.fujita.tomonori@lab.ntt.co.jp>
	 <db2b43030905032227u73a41ec3wa511efcef6a22169@mail.gmail.com>
	 <da824cf30905041858t2cbd0fa2x4075f387973e2700@mail.gmail.com>
	 <b1bc6a000905042131t3656f14arc98dc4a518543a86@mail.gmail.com>
Date: Tue, 5 May 2009 10:46:16 +0500
Message-ID: <db2b43030905042246j770578e0xeb8d8ce8c01853d6@mail.gmail.com>
Subject: Re: [Bug #13001] PCI-DMA: Out of IOMMU space
From: =?UTF-8?B?0JTQsNC90LjQu9CwINCW0YPQutC+0YbQutC40Lk=?= 
	<optimusgd@gmail.com>
To: adam radford <aradford@gmail.com>
Cc: Grant Grundler <grundler@google.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Full dmesg there: http://bugzilla.kernel.org/attachment.cgi?id=21222
Got this:
------------[ cut here ]------------
WARNING: at fs/namei.c:1251 lookup_one_len+0xe9/0x100()
Hardware name: HP xw9400 Workstation
Modules linked in: fuse nfs auth_rpcgss lockd sunrpc scsi_wait_scan
usbhid ohci_hcd usb_storage usb_libusual ehci_hcd usbcore
Pid: 2717, comm: mount Not tainted 2.6.30-rc4-git1 #1
Call Trace:
 [<ffffffff8023ceca>] ? warn_slowpath+0xea/0x160
 [<ffffffff80564d06>] ? printk+0x4e/0x58
 [<ffffffff8032daea>] ? prepare_error_buf+0x51a/0x610
 [<ffffffff802a0cfe>] ? new_slab+0x1ee/0x330
 [<ffffffff8032dcc1>] ? reiserfs_info+0x71/0xa0
 [<ffffffff802b3df9>] ? lookup_one_len+0xe9/0x100
 [<ffffffff8033eaed>] ? reiserfs_xattr_init+0x3d/0xb0
 [<ffffffff8032c4e3>] ? reiserfs_fill_super+0x663/0xb50
 [<ffffffff805678f2>] ? __down_write_nested+0xb2/0xc0
 [<ffffffff802a39e5>] ? kmem_cache_alloc+0x65/0xa0
 [<ffffffff802acb22>] ? sget+0x3c2/0x410
 [<ffffffff802ace94>] ? get_sb_bdev+0x174/0x1a0
 [<ffffffff8032be80>] ? reiserfs_fill_super+0x0/0xb50
 [<ffffffff802ab926>] ? vfs_kern_mount+0x56/0xd0
 [<ffffffff802aba03>] ? do_kern_mount+0x53/0x120
 [<ffffffff802c474a>] ? do_mount+0x2ba/0x8c0
 [<ffffffff805691c8>] ? bad_gs+0xc34/0x1e0c
 [<ffffffff802c4e1d>] ? sys_mount+0xcd/0x100
 [<ffffffff8020b4eb>] ? system_call_fastpath+0x16/0x1b
---[ end trace 93edef2de057a0ed ]---

and

------------[ cut here ]------------
WARNING: at lib/dma-debug.c:625 check_unmap+0x3b3/0x610()
Hardware name: HP xw9400 Workstation
forcedeth 0000:00:09.0: DMA-API: device driver frees DMA memory with
wrong function [device address=0x0000000023780c02] [size=42 bytes]
[mapped as single] [unmapped as page]
Modules linked in: nfsd exportfs iptable_filter iptable_mangle
ip_tables x_tables snd_seq snd_seq_device vboxnetflt vboxdrv
snd_hda_codec_realtek snd_hda_intel snd_hda_codec nvidia(P) snd_pcm
snd_timer snd firewire_ohci firewire_core soundcore snd_page_alloc
tpm_infineon tpm forcedeth floppy tpm_bios fuse nfs auth_rpcgss lockd
sunrpc scsi_wait_scan usbhid ohci_hcd usb_storage usb_libusual
ehci_hcd usbcore
Pid: 0, comm: swapper Tainted: P        W  2.6.30-rc4-git1 #1
Call Trace:
 <IRQ>  [<ffffffff8023ceca>] ? warn_slowpath+0xea/0x160
 [<ffffffff80231ad7>] ? task_rq_lock+0x47/0x90
 [<ffffffff8029b287>] ? dma_pool_alloc+0x1b7/0x2d0
 [<ffffffffa0059692>] ? ohci_urb_enqueue+0x1a2/0x980 [ohci_hcd]
 [<ffffffff80231a63>] ? __wake_up+0x43/0x70
 [<ffffffff802343f4>] ? find_busiest_group+0x244/0x920
 [<ffffffffa00073b7>] ? usb_hcd_submit_urb+0x117/0xa40 [usbcore]
 [<ffffffff803f0bb3>] ? check_unmap+0x3b3/0x610
 [<ffffffff803f0e58>] ? debug_dma_unmap_page+0x48/0x50
 [<ffffffffa014e639>] ? nv_tx_done_optimized+0xd9/0x2c0 [forcedeth]
 [<ffffffffa0151346>] ? nv_napi_poll+0x76/0x630 [forcedeth]
 [<ffffffff80256a1b>] ? hrtimer_get_next_event+0xdb/0xf0
 [<ffffffff804dcc47>] ? net_rx_action+0x87/0x130
 [<ffffffff802421fb>] ? __do_softirq+0x7b/0x110
 [<ffffffff8020c56c>] ? call_softirq+0x1c/0x30
 [<ffffffff8020e315>] ? do_softirq+0x35/0x80
 [<ffffffff80242055>] ? irq_exit+0x95/0xa0
 [<ffffffff8020db05>] ? do_IRQ+0x85/0xf0
 [<ffffffff8020be13>] ? ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80213182>] ? default_idle+0x42/0x50
 [<ffffffff802131c4>] ? c1e_idle+0x34/0x100
 [<ffffffff80258279>] ? __atomic_notifier_call_chain+0x19/0x50
 [<ffffffff8020a09a>] ? cpu_idle+0x5a/0xc0
---[ end trace 93edef2de057a0ee ]---



2009/5/5 adam radford <aradford@gmail.com>:
> 2009/5/4 Grant Grundler <grundler@google.com>:
>> 2009/5/3 Данила Жукоцкий <optimusgd@gmail.com>:
>> ...
>>> WARNING: at lib/dma-debug.c:607 check_unmap+0x542/0x610()
>>> Hardware name: HP xw9400 Workstation
>>> 3w-9xxx 0001:45:00.0: DMA-API: device driver tries to free DMA memory
>>> it has not allocated [device address=0x0000000000000000] [size=36
>>> bytes]
>>
>> This is definitely a driver bug. Just follow the stack trace back to
>> the device driver.
>>
>
> I think this is a regression from the scsi_dma_map()/unmap() changes a while
> back.
>
> Can you try this patch?
>
> Thanks,
>
> -Adam
>
> diff -Naur linux-2.6.30-rc4/drivers/scsi/3w-9xxx.c
> linux-2.6.30-rc4.new/drivers/scsi/3w-9xxx.c
> --- linux-2.6.30-rc4/drivers/scsi/3w-9xxx.c     2009-05-04 21:19:49.000000000 -0700
> +++ linux-2.6.30-rc4.new/drivers/scsi/3w-9xxx.c 2009-05-04
> 21:23:59.000000000 -0700
> @@ -1978,7 +1978,8 @@
>  {
>        struct scsi_cmnd *cmd = tw_dev->srb[request_id];
>
> -       scsi_dma_unmap(cmd);
> +       if (cmd->SCp.phase == TW_PHASE_SGLIST)
> +               scsi_dma_unmap(cmd);
>  } /* End twa_unmap_scsi_data() */
>
>  /* scsi_host_template initializer */
>



-- 
С уважением Данила Жукоцкий, системный администратор ЗАО "Роснефтегазмаш"
