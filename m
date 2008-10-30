Return-Path: <linux-kernel-owner+w=401wt.eu-S1758730AbYJ3San@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758730AbYJ3San (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 14:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758409AbYJ3Sa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 14:30:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35034 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758318AbYJ3Sa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 14:30:27 -0400
Message-ID: <4909FD3E.8070104@redhat.com>
Date: Thu, 30 Oct 2008 19:30:22 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Wesley Leggette <wleggette@kaylix.net>
CC: linux-kernel@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Kernel panic in kcryptd
References: <C56C1A70-4E26-4D12-A1BC-4E744BCD51C5@kaylix.net>
In-Reply-To: <C56C1A70-4E26-4D12-A1BC-4E744BCD51C5@kaylix.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Wesley Leggette wrote:
> When performing large IO, seemingly only when over the network, I  
> receive a kernel panic that seems to be happening in the kcryptd module.
> 
> Here's two scenarios I've encountered this:
> 
> ietd -> kcryptd -> mdadm raid6

iscsi over dm crypt over mdadm?
And I see snapshots in the log too, isn't there snapshot under
the crypt mapping?

Is it reproducible without snapshots involved?

Maybe it is related to recently fixed problem there...
I think these patches solves the snapshot crashes (cc Mikulas)

http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/2.6.27/dm-snapshot-fix-primary_pe-race.patch
http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-snapshot-wait-for-chunks-in-destructor.patch

Milan

> Linux version 2.6.26-bpo.1-686-bigmem (Debian 2.6.26-4~bpo40+1) (nobse@debian.org 
> ) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #1 SMP  
> Tue Sep 2 18:42:50 UTC 2008
> 
> 
> 
> Oct 29 04:55:15 fargo kernel: [4285317.219492] ------------[ cut  
> here ]------------
> Oct 29 04:55:15 fargo kernel: [4285317.219492] kernel BUG at mm/slab.c: 
> 3008!
> Oct 29 04:55:15 fargo kernel: [4285317.219492] invalid opcode: 0000  
> [#1] SMP
> Oct 29 04:55:15 fargo kernel: [4285317.219492] Modules linked in:  
> usb_storage iscsi_trgt crc32c libcrc32c ipv6 ib_iser
>   rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi  
> scsi_transport_iscsi ac battery xt_tcpudp nf_conn
> track_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables  
> ext3 jbd mbcache loop snd_hda_intel i2c_i801 i2c_co
> re snd_pcm snd_timer snd soundcore iTCO_wdt intel_agp agpgart button  
> snd_page_alloc parport_pc parport evdev pcspkr fl
> oppy reiserfs sha256_generic aes_i586 aes_generic cbc dm_crypt  
> crypto_blkcipher dm_mirror dm_log dm_snapshot dm_mod ra
> id456 async_xor async_memcpy async_tx xor raid1 md_mod ide_generic  
> jmicron ide_core sd_mod sata_promise ata_generic ah
> ci r8169 libata scsi_mod uhci_hcd dock ehci_hcd usbcore thermal  
> processor fan thermal_sys [last unloaded: libcrc32c]
> Oct 29 04:55:15 fargo kernel: [4285317.219492]
> Oct 29 04:55:15 fargo kernel: [4285317.219492] Pid: 4191, comm:  
> kcryptd Not tainted (2.6.26-bpo.1-686-bigmem #1)
> Oct 29 04:55:15 fargo kernel: [4285317.219492] EIP: 0060:[<c017b8e8>]  
> EFLAGS: 00010046 CPU: 0
> Oct 29 04:55:15 fargo kernel: [4285317.219492] EIP is at  
> cache_alloc_refill+0xeb/0x48b
> Oct 29 04:55:15 fargo kernel: [4285317.219492] EAX: 0000003b EBX:  
> 00000012 ECX: f6d4d1c0 EDX: df32c000
> Oct 29 04:55:15 fargo kernel: [4285317.219492] ESI: c0878000 EDI:  
> 00000012 EBP: f540cac0 ESP: e70b5d78
> Oct 29 04:55:15 fargo kernel: [4285317.219492]  DS: 007b ES: 007b FS:  
> 00d8 GS: 0000 SS: 0068
> Oct 29 04:55:15 fargo kernel: [4285317.219492] Process kcryptd (pid:  
> 4191, ti=e70b4000 task=f696ba00 task.ti=e70b4000)
> Oct 29 04:55:15 fargo kernel: [4285317.219492] Stack: 00000000  
> 0000003b 00011200 f6d4d1c0 f5443e00 00000000 c0136139 f
> 51011ec
> Oct 29 04:55:15 fargo kernel: [4285317.219492]        e70b5de8  
> 00000202 c0136194 00000000 f6d4d1c0 00000206 00011200 c
> 017b7b6
> Oct 29 04:55:15 fargo kernel: [4285317.219492]        00000000  
> f540ca80 00000000 00011210 c015f909 f8935be2 df32c4c8 f
> 6430e40
> Oct 29 04:55:15 fargo kernel: [4285317.219492] Call Trace:
> Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<c0136139>]  
> __queue_work+0x1c/0x28
> Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<c0136194>] queue_work 
> +0x33/0x3c
> Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<c017b7b6>]  
> kmem_cache_alloc+0x47/0x8e
> Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<c015f909>]  
> mempool_alloc+0x1c/0xba
> Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<f8935be2>]  
> copy_callback+0x0/0x2c [dm_snapshot]
> Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<f893533e>]  
> __find_pending_exception+0x62/0x122 [dm_snapshot]
> Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<f89355c1>] origin_map 
> +0x105/0x23f [dm_snapshot]
> Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<f89064e2>] __map_bio 
> +0x4d/0x12a [dm_mod]
> Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<f8906309>] clone_bio 
> +0x3f/0x6f [dm_mod]
> Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<f8906ff1>]  
> __split_bio+0x156/0x3f7 [dm_mod]
> Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<f896e33f>]  
> crypto_cbc_encrypt+0x12b/0x13f [cbc]
> Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<f894d6d8>]  
> aes_encrypt+0x0/0xc [aes_i586]
> Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<f89076ff>] dm_request 
> +0xd3/0xf2 [dm_mod]
> Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<c01dc365>]  
> generic_make_request+0x34d/0x37b
> Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<f89488a9>]  
> crypt_convert+0x20f/0x240 [dm_crypt]
> Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<f8948a98>]  
> kcryptd_crypt+0x1be/0x267 [dm_crypt]
> Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<f89488da>]  
> kcryptd_crypt+0x0/0x267 [dm_crypt]
> Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<c0135d32>]  
> run_workqueue+0x74/0xf2
> Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<c013640d>]  
> worker_thread+0x0/0xbd
> Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<c01364c0>]  
> worker_thread+0xb3/0xbd
> Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<c01386ac>]  
> autoremove_wake_function+0x0/0x2d
> Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<c01385eb>] kthread 
> +0x38/0x5d
> Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<c01385b3>] kthread 
> +0x0/0x5d
> Oct 29 04:55:15 fargo kernel: [4285317.219492]  [<c01094ff>]  
> kernel_thread_helper+0x7/0x10
> Oct 29 04:55:15 fargo kernel: [4285317.219492]  =======================
> Oct 29 04:55:15 fargo kernel: [4285317.219492] Code: 8b 75 00 39 ee 75  
> 15 8b 75 10 8d 45 10 c7 45 34 01 00 00 00 39 c6
>   0f 84 a5 00 00 00 8b 4c 24 0c 8b 81 98 00 00 00 39 46 10 72 37 <0f>  
> 0b eb fe 8b 44 24 10 8b 5e 14 8b 08 8b 44 24 0c 8
> b 90 8c 00
> Oct 29 04:55:15 fargo kernel: [4285317.219492] EIP: [<c017b8e8>]  
> cache_alloc_refill+0xeb/0x48b SS:ESP 0068:e70b5d78
> Oct 29 04:55:15 fargo kernel: [4285317.219492] ---[ end trace  
> 0bb16d783d7c2616 ]---
