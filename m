Return-Path: <linux-kernel-owner+w=401wt.eu-S1760081AbYFJWJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760081AbYFJWJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 18:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753793AbYFJWJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 18:09:33 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:64703 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759976AbYFJWJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 18:09:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=d+m1k+FfHAe6f6MhBKXmoahay05pv5xGCUJEPpOVnCU3zBHH2Gvqodtbj658/18Jr1
         Ghqz8wZ0vZzxD36NzLh6zN7EbFE0q/hdhnf9xQ9pV02n2R95hGTIVZQB5v7tg9lJpIbD
         5Wiw3ROHWjSke3dzTiV3EukNy1yQvYYrkSm48=
Message-ID: <a44ae5cd0806101509x5e2d5c19y10101ea0e72f8cba@mail.gmail.com>
Date: Tue, 10 Jun 2008 18:09:27 -0400
From: "Miles Lane" <miles.lane@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: BUG: NULL pointer dereference at 00000000 -- IP: [<f8e783d5>] :b43:b43_dma_mapping_error+0x16/0x155
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <200806101650.27180.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a44ae5cd0806100709rf4602f2x587631852502c0b5@mail.gmail.com>
	 <200806101637.11473.mb@bu3sch.de>
	 <19f34abd0806100742v176f50e8se463d2e70df44332@mail.gmail.com>
	 <200806101650.27180.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got a slightly different BUG with this patch applied:

BUG: unable to handle kernel NULL pointer dereference at 00000000
IP: [<f89e3d41>] :b43:b43_dma_mapping_error+0x16/0x97
*pde = 00000000
Oops: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
last sysfs file:
/sys/devices/pci0000:00/0000:00:08.0/0000:01:06.0/ssb0:0/firmware/ssb0:0/loading
Modules linked in: sbs sbshc wmi battery iptable_filter ip_tables
x_tables ac sbp2 rtc arc4 ecb crypto_blkcipher cryptomgr crypto_algapi
b43 mac80211 cfg80211 led_class snd_intel8x0 snd_ac97_codec ac97_bus
snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss
snd_seq_midi_event snd_seq snd_timer snd_seq_device snd soundcore
snd_page_alloc i2c_nforce2 i2c_core button ohci1394 3c59x ieee1394
forcedeth ehci_hcd ohci_hcd usbcore thermal processor fan thermal_sys

Pid: 4259, comm: NetworkManager Not tainted (2.6.26-rc5-mm2 #9)
EIP: 0060:[<f89e3d41>] EFLAGS: 00010296 CPU: 0
EIP is at b43_dma_mapping_error+0x16/0x97 [b43]
EAX: f6f205a0 EBX: c0416790 ECX: 0000006e EDX: 00000000
ESI: 0000006e EDI: 36060000 EBP: f6259b10 ESP: f6259afc
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process NetworkManager (pid: 4259, ti=f6259000 task=f78e8000 task.ti=f6259000)
Stack: 01107455 0000006e c0416790 f6f205a0 f6dfc9b0 f6259b64 f89e41d5 00000001
       f78e8000 c013506c f6dfc9b0 f6259b38 c0135026 01ffffff 00000001 00000000
       00000080 36060000 00000000 f6259b5c c01063c4 f7962940 00000000 3fffffff
Call Trace:
 [<f89e41d5>] ? b43_setup_dmaring+0xf2/0x51e [b43]
 [<c013506c>] ? trace_hardirqs_on+0xb/0xd
 [<c0135026>] ? trace_hardirqs_on_caller+0xe5/0x120
 [<c01063c4>] ? dma_set_mask+0x1a/0x37
 [<f89e4cc1>] ? b43_dma_init+0x21d/0x23b [b43]
 [<f89d6d2f>] ? b43_wireless_core_init+0x4a5/0x6d9 [b43]
 [<f89d7528>] ? b43_op_start+0xab/0xea [b43]
 [<f89b2ca9>] ? ieee80211_open+0x1e5/0x448 [mac80211]
 [<c013506c>] ? trace_hardirqs_on+0xb/0xd
 [<c02ccf41>] ? dev_open+0x66/0x99
 [<c02cbcf6>] ? dev_change_flags+0x9c/0x14a
 [<c02d3361>] ? do_setlink+0x227/0x2d7
 [<c031fca4>] ? _read_unlock+0x27/0x3c
 [<c02d4318>] ? rtnl_setlink+0xa4/0xbb
 [<c0135026>] ? trace_hardirqs_on_caller+0xe5/0x120
 [<c02d4274>] ? rtnl_setlink+0x0/0xbb
 [<c02d3f4e>] ? rtnetlink_rcv_msg+0x192/0x1ac
 [<c02d3dbc>] ? rtnetlink_rcv_msg+0x0/0x1ac
 [<c02d92e7>] ? netlink_rcv_skb+0x30/0x75
 [<c02d3db4>] ? rtnetlink_rcv+0x17/0x1f
 [<c02d90ce>] ? netlink_unicast+0x1c9/0x242
 [<c02d9bf9>] ? netlink_sendmsg+0x21b/0x228
 [<c02c22e2>] ? sock_sendmsg+0xc9/0xe0
 [<c012a6f9>] ? autoremove_wake_function+0x0/0x30
 [<c012a6f9>] ? autoremove_wake_function+0x0/0x30
 [<c0135f43>] ? __lock_acquire+0xb2e/0xb4a
 [<c013506c>] ? trace_hardirqs_on+0xb/0xd
 [<c0135026>] ? trace_hardirqs_on_caller+0xe5/0x120
 [<c01efe08>] ? copy_from_user+0x3b/0x5e
 [<c02c8930>] ? verify_iovec+0x40/0x70
 [<c02c2446>] ? sys_sendmsg+0x14d/0x1a8
 [<c02c2d34>] ? sys_recvmsg+0x172/0x17f
 [<c0135f43>] ? __lock_acquire+0xb2e/0xb4a
 [<c0156352>] ? handle_mm_fault+0x220/0x600
 [<c02c32d2>] ? sys_socketcall+0x13e/0x171
 [<c01ef9f8>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c0102c95>] ? sysenter_past_esp+0x6a/0xa5
 =======================
Code: c8 74 0d 41 75 05 42 b3 40 74 05 bb 1e 00 00 00 89 d8 5b c9 c3
55 89 e5 57 89 d7 56 89 ce 53 83 ec 08 8a 55 08 88 55 ef 8b 50 58 <8b>
12 8b 52 08 89 55 f0 8b 40 34 83 f8 1e 74 07 83 f8 20 75 5b
EIP: [<f89e3d41>] b43_dma_mapping_error+0x16/0x97 [b43] SS:ESP 0068:f6259afc
---[ end trace 7a51b359a273191c ]---


On Tue, Jun 10, 2008 at 10:50 AM, Michael Buesch <mb@bu3sch.de> wrote:
> On Tuesday 10 June 2008 16:42:41 Vegard Nossum wrote:
>> This change comes from
>>
>> commit 353c409463ecba63c3a41a992d3f5fba935eada9
>> Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>> Date:   Fri May 23 19:02:30 2008 +0000
>
>
> Ok, FUJITA Tomonori, please make sure a patch like the following goes
> into the same trees that you submitted commit 353c409 to.
> Also make sure to check b43legacy. I _guess_ you might have added
> the same bug there.
>
> Index: wireless-testing/drivers/net/wireless/b43/dma.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/b43/dma.c        2008-06-10 13:58:22.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/b43/dma.c     2008-06-10 16:48:53.000000000 +0200
> @@ -802,6 +802,7 @@ struct b43_dmaring *b43_setup_dmaring(st
>        if (!ring)
>                goto out;
>        ring->type = type;
> +       ring->dev = dev;
>
>        nr_slots = B43_RXRING_SLOTS;
>        if (for_tx)
> @@ -853,7 +854,6 @@ struct b43_dmaring *b43_setup_dmaring(st
>                                 DMA_TO_DEVICE);
>        }
>
> -       ring->dev = dev;
>        ring->nr_slots = nr_slots;
>        ring->mmio_base = b43_dmacontroller_base(type, controller_index);
>        ring->index = controller_index;
>
>
>>     dma-mapping-add-the-device-argument-to-dma_mapping_error
>>
>>     Add per-device dma_mapping_ops support for CONFIG_X86_64 as POWER
>>     architecture does:
>>
>>     This enables us to cleanly fix the Calgary IOMMU issue that some devices
>>     are not behind the IOMMU (http://lkml.org/lkml/2008/5/8/423).
>>
>>     I think that per-device dma_mapping_ops support would be also helpful for
>>     KVM people to support PCI passthrough but Andi thinks that this makes it
>>     difficult to support the PCI passthrough (see the above thread).  So I
>>     CC'ed this to KVM camp.  Comments are appreciated.
>>
>>     A pointer to dma_mapping_ops to struct dev_archdata is added.  If the
>>     pointer is non NULL, DMA operations in asm/dma-mapping.h use it.  If it's
>>     NULL, the system-wide dma_ops pointer is used as before.
>>
>>     If it's useful for KVM people, I plan to implement a mechanism to register
>>     a hook called when a new pci (or dma capable) device is created (it works
>>     with hot plugging).  It enables IOMMUs to set up an appropriate
>>     dma_mapping_ops per device.
>>
>>     The major obstacle is that dma_mapping_error doesn't take a pointer to the
>>     device unlike other DMA operations.  So x86 can't have dma_mapping_ops per
>>     device.  Note all the POWER IOMMUs use the same dma_mapping_error function
>>     so this is not a problem for POWER but x86 IOMMUs use different
>>     dma_mapping_error functions.
>>
>>     The first patch adds the device argument to dma_mapping_error.  The patch
>>     is trivial but large since it touches lots of drivers and dma-mapping.h in
>>     all the architecture.
>>
>> (Added to Cc.)
>>
>>
>> Vegard
>>
>
>
>
> --
> Greetings Michael.
>
