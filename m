Return-Path: <linux-kernel-owner+w=401wt.eu-S1757248AbYLFMDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248AbYLFMDq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 07:03:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754853AbYLFMDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 07:03:37 -0500
Received: from orion.ambsoft.pl ([212.109.144.130]:58797 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbYLFMDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 07:03:30 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>, kernel-testers@vger.kernel.org
Subject: Re: linux-next: Tree for December 4
Date: Sat, 6 Dec 2008 13:04:12 +0100
User-Agent: KMail/1.9.9
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20081204200745.eff0ac87.sfr@canb.auug.org.au>
In-Reply-To: <20081204200745.eff0ac87.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_8omOJh8gxsVLPqn"
Message-Id: <200812061304.12216.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_8omOJh8gxsVLPqn
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello Stephen,

	I didn't run linux-next for some time. Today I gave it a shot and
a few interesting things poped out:

Linux agpgart interface v0.103
Serial: 8250/16550 driver4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
=============================================================================
BUG kmalloc-4096: Invalid object pointer 0xffff88007fb20010
-----------------------------------------------------------------------------

INFO: Slab 0xffffe20001beef00 objects=7 used=1 fp=0xffff88007fb21048 flags=0x40000000000020c3
Pid: 1, comm: swapper Not tainted 2.6.28-rc7-next-20081204 #1
Call Trace:
 [<ffffffff802a4edd>] slab_err+0x9d/0xc0
 [<ffffffff80218992>] save_stack_trace+0x22/0x40
 [<ffffffff80260f57>] save_trace+0x37/0xa0
 [<ffffffff80261027>] add_lock_to_list+0x67/0xf0
 [<ffffffff80244c42>] __release_region+0x22/0xc0
 [<ffffffff80264dac>] validate_chain+0xcdc/0x1200
 [<ffffffff802a558b>] check_bytes_and_report+0x4b/0x100
 [<ffffffff802a53f7>] slab_pad_check+0xe7/0x170
 [<ffffffff803bf590>] uart_remove_one_port+0xf0/0x120
 [<ffffffff802a6c28>] __slab_free+0x258/0x380
 [<ffffffff803bf590>] uart_remove_one_port+0xf0/0x120
 [<ffffffff802a6ee2>] kfree+0xb2/0x150
 [<ffffffff803bf590>] uart_remove_one_port+0xf0/0x120
 [<ffffffff803c4f18>] serial8250_register_port+0x88/0x1f0
 [<ffffffff804851d0>] serial_pnp_probe+0x1a0/0x220
 [<ffffffff8039bfef>] match_device+0x2f/0x50
 [<ffffffff8039c0a4>] pnp_device_probe+0x64/0xe0
 [<ffffffff803ca4d6>] driver_probe_device+0x96/0x1b0
 [<ffffffff803ca68c>] __driver_attach+0x9c/0xa0
 [<ffffffff803ca5f0>] __driver_attach+0x0/0xa0
 [<ffffffff803c98f3>] bus_for_each_dev+0x53/0x80
 [<ffffffff803ca08b>] bus_add_driver+0x1cb/0x230
 [<ffffffff803ca855>] driver_register+0x55/0x140
 [<ffffffff8062e200>] serial8250_pnp_init+0x0/0x10
 [<ffffffff8020903b>] _stext+0x3b/0x170
 [<ffffffff8027b181>] register_irq_proc+0xc1/0xe0
 [<ffffffff806119ad>] kernel_init+0x15d/0x1f0
 [<ffffffff8020c9fa>] child_rip+0xa/0x20
 [<ffffffff8020c3c0>] restore_args+0x0/0x30
 [<ffffffff80611850>] kernel_init+0x0/0x1f0
 [<ffffffff8020c9f0>] child_rip+0x0/0x20
FIX kmalloc-4096: Object at 0xffff88007fb20010 not freed
00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
=============================================================================
BUG kmalloc-4096: Invalid object pointer 0xffff88007fb20278
-----------------------------------------------------------------------------

INFO: Slab 0xffffe20001beef00 objects=7 used=1 fp=0xffff88007fb21048 flags=0x40000000000020c3
Pid: 1, comm: swapper Not tainted 2.6.28-rc7-next-20081204 #1
Call Trace:
 [<ffffffff802a4edd>] slab_err+0x9d/0xc0
 [<ffffffff80264530>] validate_chain+0x460/0x1200
 [<ffffffff80264530>] validate_chain+0x460/0x1200
 [<ffffffff802a558b>] check_bytes_and_report+0x4b/0x100
 [<ffffffff802a53f7>] slab_pad_check+0xe7/0x170
 [<ffffffff803bf590>] uart_remove_one_port+0xf0/0x120
 [<ffffffff802a6c28>] __slab_free+0x258/0x380
 [<ffffffff803bf590>] uart_remove_one_port+0xf0/0x120
 [<ffffffff802a6ee2>] kfree+0xb2/0x150
 [<ffffffff803bf590>] uart_remove_one_port+0xf0/0x120
 [<ffffffff803c4f18>] serial8250_register_port+0x88/0x1f0
 [<ffffffff804851d0>] serial_pnp_probe+0x1a0/0x220
 [<ffffffff8039bfef>] match_device+0x2f/0x50
 [<ffffffff8039c0a4>] pnp_device_probe+0x64/0xe0
 [<ffffffff803ca4d6>] driver_probe_device+0x96/0x1b0
 [<ffffffff803ca68c>] __driver_attach+0x9c/0xa0
 [<ffffffff803ca5f0>] __driver_attach+0x0/0xa0
 [<ffffffff803c98f3>] bus_for_each_dev+0x53/0x80
 [<ffffffff803ca08b>] bus_add_driver+0x1cb/0x230
 [<ffffffff803ca855>] driver_register+0x55/0x140
 [<ffffffff8062e200>] serial8250_pnp_init+0x0/0x10
 [<ffffffff8020903b>] _stext+0x3b/0x170
 [<ffffffff8027b181>] register_irq_proc+0xc1/0xe0
 [<ffffffff806119ad>] kernel_init+0x15d/0x1f0
 [<ffffffff8020c9fa>] child_rip+0xa/0x20
 [<ffffffff8020c3c0>] restore_args+0x0/0x30
 [<ffffffff80611850>] kernel_init+0x0/0x1f0
 [<ffffffff8020c9f0>] child_rip+0x0/0x20
FIX kmalloc-4096: Object at 0xffff88007fb20278 not freed
00:07: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A


I also noticed my network wasn't reachable. That's probably not related to the kernel
but to check if my link is ok I run mii-tool and the result is NULL pointer dereference:


BUG: unable to handle kernel NULL pointer dereference at 0000000000000138
IP: [<ffffffff8042beff>] dev_ifsioc+0x1f/0x320
PGD 736e3067 PUD 736ca067 PMD 0 
Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:05:01.0/resource
CPU 1 
Modules linked in: nfsd lockd sunrpc exportfs snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss usbhid gspca_zc3xx gspca_main compat_ioctl32 videodev v4l1_compat snd_mixer_oss usb_storage libusual ehci_hcd uhci_hcd usbcore parport_pc snd_hda_codec_realtek thermal parport snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer i2c_i801 snd soundcore snd_page_alloc sr_mod pcspkr sg i2c_core intel_agp processor rtc button cdrom
Pid: 4768, comm: mii-tool Not tainted 2.6.28-rc7-next-20081204 #1
RIP: 0010:[<ffffffff8042beff>]  [<ffffffff8042beff>] dev_ifsioc+0x1f/0x320
RSP: 0018:ffff88006e623da8  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000008947 RCX: 00000000019369c2
RDX: 0000000000000610 RSI: ffff88006e623e0c RDI: 00000000ffffffff
RBP: ffff88006e623e08 R08: 00000000019369c2 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
R13: 0000000000000000 R14: ffffffff80d7da40 R15: 00007fff55e4ee88
FS:  00007f944de2f6f0(0000) GS:ffff88007f8047d0(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000138 CR3: 000000006e4d9000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process mii-tool (pid: 4768, threadinfo ffff88006e622000, task ffff88006e45ba80)
Stack:
 0000000000008947 ffff88006e623e08 0000000000603400 ffffffff8042c4c7
 ffffe2000003f428 0000000000603400 0000000001213025 ffffffff8028e3fd
 ffff88007d4f5500 00007f944db51330 ffff880076fbb180 0000000000000096
Call Trace:
 [<ffffffff8042c4c7>] ? dev_ioctl+0x2c7/0x590
 [<ffffffff8028e3fd>] ? __do_fault+0x1dd/0x4a0
 [<ffffffff8041de92>] ? sock_ioctl+0x72/0x250
 [<ffffffff802b971f>] ? vfs_ioctl+0x2f/0xa0
 [<ffffffff802b980d>] ? do_vfs_ioctl+0x7d/0x4c0
 [<ffffffff80492d1d>] ? lockdep_sys_exit_thunk+0x35/0x67
 [<ffffffff802b9c99>] ? sys_ioctl+0x49/0x80
 [<ffffffff8020b95b>] ? system_call_fastpath+0x16/0x1b
Code: f8 bd f1 ff e9 52 fe ff ff 0f 1f 00 48 83 ec 18 48 89 1c 24 89 d3 48 89 6c 24 08 4c 89 64 24 10 48 89 f5 e8 f4 d4 ff ff 49 89 c4 <48> 8b 88 38 01 00 00 8d 83 ec 76 ff ff 83 f8 5d 77 0f 89 c0 ff 
RIP  [<ffffffff8042beff>] dev_ifsioc+0x1f/0x320
 RSP <ffff88006e623da8>
CR2: 0000000000000138
---[ end trace 787e122ecd30f760 ]---


Full dmesg and .config is attached.

	Mariusz


Right before this there was also a rather long lockdep info triggered by starting skype:

======================================================
[ INFO: soft-safe -> soft-unsafe lock order detected ]
2.6.28-rc7-next-20081204 #1
------------------------------------------------------
skype/4695 [HC0[0]:SC0[1]:HE1:SE0] is trying to acquire:
 (&fbc->lock){--..}, at: [<ffffffff8035adce>] __percpu_counter_add+0x5e/0xd0

and this task is already holding:
 (slock-AF_INET){-+..}, at: [<ffffffff80453496>] tcp_close+0x166/0x4a0
which would create a new lock dependency:
 (slock-AF_INET){-+..} -> (&fbc->lock){--..}

but this new dependency connects a soft-irq-safe lock:
 (slock-AF_INET){-+..}
... which became soft-irq-safe at:
  [<ffffffffffffffff>] 0xffffffffffffffff

to a soft-irq-unsafe lock:
 (&fbc->lock){--..}
... which became soft-irq-unsafe at:
...  [<ffffffff80265afd>] __lock_acquire+0x82d/0xa50
  [<ffffffff80265d73>] lock_acquire+0x53/0x70
  [<ffffffff8035adce>] __percpu_counter_add+0x5e/0xd0
  [<ffffffff804930c3>] _spin_lock+0x33/0x40
  [<ffffffff8035adce>] __percpu_counter_add+0x5e/0xd0
  [<ffffffff802a6e21>] kmem_cache_alloc+0xd1/0xe0
  [<ffffffff8035adce>] __percpu_counter_add+0x5e/0xd0
  [<ffffffff802ad058>] get_empty_filp+0x68/0x140
  [<ffffffff802b7e7b>] path_lookup_open+0x3b/0xd0
  [<ffffffff802b07d4>] open_exec+0x24/0xd0
  [<ffffffff802ac4fa>] vfs_read+0x12a/0x160
  [<ffffffff802b0688>] kernel_read+0x38/0x50
  [<ffffffff802ea559>] load_elf_binary+0x18b9/0x1d20
  [<ffffffff8027f74f>] generic_file_aio_read+0x4ff/0x5e0
  [<ffffffff80264530>] validate_chain+0x460/0x1200
  [<ffffffff80264530>] validate_chain+0x460/0x1200
  [<ffffffff80265717>] __lock_acquire+0x447/0xa50
  [<ffffffff802ec040>] load_elf_binary+0x0/0x1e70
  [<ffffffff802e8ca0>] load_elf_binary+0x0/0x1d20
  [<ffffffff802b0360>] search_binary_handler+0xd0/0x2e0
  [<ffffffff802e7640>] load_script+0x270/0x280
  [<ffffffff802e8ca0>] load_elf_binary+0x0/0x1d20
  [<ffffffff802e73d0>] load_script+0x0/0x280
  [<ffffffff802b0360>] search_binary_handler+0xd0/0x2e0
  [<ffffffff802b18de>] do_execve+0x22e/0x290
  [<ffffffff80209b49>] sys_execve+0x49/0x80
  [<ffffffff8020bdfa>] stub_execve+0x6a/0xc0
  [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

1 lock held by skype/4695:
 #0:  (slock-AF_INET){-+..}, at: [<ffffffff80453496>] tcp_close+0x166/0x4a0

the soft-irq-safe lock's dependencies:
-> (slock-AF_INET){-+..} ops: 0 {
   initial-use  at:
                        [<ffffffff8026548d>] __lock_acquire+0x1bd/0xa50
                        [<ffffffff80265d73>] lock_acquire+0x53/0x70
                        [<ffffffff8041ed1e>] lock_sock_nested+0x1e/0x110
                        [<ffffffff80493108>] _spin_lock_bh+0x38/0x50
                        [<ffffffff8041ed1e>] lock_sock_nested+0x1e/0x110
                        [<ffffffff8041ed1e>] lock_sock_nested+0x1e/0x110
                        [<ffffffff80264530>] validate_chain+0x460/0x1200
                        [<ffffffff80264530>] validate_chain+0x460/0x1200
                        [<ffffffff804681bb>] udp_destroy_sock+0xb/0x20
                        [<ffffffff8041f558>] sk_common_release+0x18/0x80
                        [<ffffffff8046f7fe>] inet_release+0x3e/0x70
                        [<ffffffff8041c9f9>] sock_release+0x19/0xb0
                        [<ffffffff8041cfe2>] sock_close+0x12/0x40
                        [<ffffffff802ace0b>] __fput+0xbb/0x200
                        [<ffffffff802a9cc4>] filp_close+0x54/0x90
                        [<ffffffff802a9d9f>] sys_close+0x9f/0x110
                        [<ffffffff8020b95b>] system_call_fastpath+0x16/0x1b
                        [<ffffffffffffffff>] 0xffffffffffffffff
   in-softirq-W at:
                        [<ffffffffffffffff>] 0xffffffffffffffff
   hardirq-on-W at:
                        [<ffffffff80265ad5>] __lock_acquire+0x805/0xa50
                        [<ffffffff80265d73>] lock_acquire+0x53/0x70
                        [<ffffffff8041ed1e>] lock_sock_nested+0x1e/0x110
                        [<ffffffff80493108>] _spin_lock_bh+0x38/0x50
                        [<ffffffff8041ed1e>] lock_sock_nested+0x1e/0x110
                        [<ffffffff8041ed1e>] lock_sock_nested+0x1e/0x110
                        [<ffffffff80264530>] validate_chain+0x460/0x1200
                        [<ffffffff80264530>] validate_chain+0x460/0x1200
                        [<ffffffff804681bb>] udp_destroy_sock+0xb/0x20
                        [<ffffffff8041f558>] sk_common_release+0x18/0x80
                        [<ffffffff8046f7fe>] inet_release+0x3e/0x70
                        [<ffffffff8041c9f9>] sock_release+0x19/0xb0
                        [<ffffffff8041cfe2>] sock_close+0x12/0x40
                        [<ffffffff802ace0b>] __fput+0xbb/0x200
                        [<ffffffff802a9cc4>] filp_close+0x54/0x90
                        [<ffffffff802a9d9f>] sys_close+0x9f/0x110
                        [<ffffffff8020b95b>] system_call_fastpath+0x16/0x1b
                        [<ffffffffffffffff>] 0xffffffffffffffff
 }
 ... key      at: [<ffffffff80d7d650>] af_family_slock_keys+0x10/0x120
 -> (&rt_hash_locks[i]){-+..} ops: 0 {
    initial-use  at:
                          [<ffffffffffffffff>] 0xffffffffffffffff
    in-softirq-W at:
                          [<ffffffffffffffff>] 0xffffffffffffffff
    hardirq-on-W at:
                          [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffff80d7e714>] __key.40927+0x0/0x8
  -> (&zone->lock){.+..} ops: 0 {
     initial-use  at:
                            [<ffffffff8026548d>] __lock_acquire+0x1bd/0xa50
                            [<ffffffff80265d73>] lock_acquire+0x53/0x70
                            [<ffffffff802825e6>] free_pages_bulk+0x36/0x300
                            [<ffffffff804930c3>] _spin_lock+0x33/0x40
                            [<ffffffff802825e6>] free_pages_bulk+0x36/0x300
                            [<ffffffff802825e6>] free_pages_bulk+0x36/0x300
                            [<ffffffff802831d2>] free_hot_cold_page+0x262/0x2f0
                            [<ffffffff80624c88>] free_all_bootmem_core+0xd8/0x240
                            [<ffffffff80496d0d>] _etext+0x0/0x3
                            [<ffffffff8062085c>] mem_init+0x3c/0x190
                            [<ffffffff80611cff>] start_kernel+0x28f/0x440
                            [<ffffffff8061136a>] x86_64_start_kernel+0xca/0xe0
                            [<ffffffffffffffff>] 0xffffffffffffffff
     in-softirq-W at:
                            [<ffffffffffffffff>] 0xffffffffffffffff
   }
   ... key      at: [<ffffffff80d6ded0>] __key.29131+0x0/0x8
  ... acquired at:
   [<ffffffff802838a5>] get_page_from_freelist+0x525/0x5b0
   [<ffffffff80264cd5>] validate_chain+0xc05/0x1200
   [<ffffffff80265717>] __lock_acquire+0x447/0xa50
   [<ffffffff80265d73>] lock_acquire+0x53/0x70
   [<ffffffff802838a5>] get_page_from_freelist+0x525/0x5b0
   [<ffffffff8049337e>] _spin_lock_irqsave+0x3e/0x60
   [<ffffffff802838a5>] get_page_from_freelist+0x525/0x5b0
   [<ffffffff802838a5>] get_page_from_freelist+0x525/0x5b0
   [<ffffffff80283bfa>] __alloc_pages_internal+0xaa/0x450
   [<ffffffff802a64da>] __slab_alloc+0x17a/0x670
   [<ffffffff80431e54>] neigh_create+0x74/0x5b0
   [<ffffffff80431e54>] neigh_create+0x74/0x5b0
   [<ffffffff802a6e0f>] kmem_cache_alloc+0xbf/0xe0
   [<ffffffff80431e54>] neigh_create+0x74/0x5b0
   [<ffffffff80263821>] trace_hardirqs_on_caller+0x71/0x180
   [<ffffffff80243561>] local_bh_enable_ip+0x81/0xf0
   [<ffffffff8043135a>] neigh_lookup+0x10a/0x140
   [<ffffffff80469911>] arp_bind_neighbour+0xa1/0xb0
   [<ffffffff80441e98>] rt_intern_hash+0x208/0x4f0
   [<ffffffff8027c2fd>] __rcu_read_unlock+0xcd/0xe0
   [<ffffffff80442593>] __ip_route_output_key+0x413/0xa60
   [<ffffffff804650a7>] ip4_datagram_connect+0x177/0x2a0
   [<ffffffff80243561>] local_bh_enable_ip+0x81/0xf0
   [<ffffffff8041bd76>] sys_connect+0x86/0xe0
   [<ffffffff8020c3ad>] retint_swapgs+0xe/0x13
   [<ffffffff802638ce>] trace_hardirqs_on_caller+0x11e/0x180
   [<ffffffff80492ca7>] trace_hardirqs_on_thunk+0x3a/0x3f
   [<ffffffff8020b95b>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

 ... acquired at:
   [<ffffffffffffffff>] 0xffffffffffffffff

 -> (rt_peer_lock){-+..} ops: 0 {
    initial-use  at:
                          [<ffffffffffffffff>] 0xffffffffffffffff
    in-softirq-W at:
                          [<ffffffffffffffff>] 0xffffffffffffffff
    hardirq-on-W at:
                          [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffff805ea3b8>] rt_peer_lock.41771+0x18/0x40
 ... acquired at:
   [<ffffffffffffffff>] 0xffffffffffffffff

 -> (inet_peer_idlock){-+..} ops: 0 {
    initial-use  at:
                          [<ffffffffffffffff>] 0xffffffffffffffff
    in-softirq-W at:
                          [<ffffffffffffffff>] 0xffffffffffffffff
    hardirq-on-W at:
                          [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffff805ea958>] inet_peer_idlock+0x18/0x40
 ... acquired at:
   [<ffffffffffffffff>] 0xffffffffffffffff

 -> (&n->lock){-+-+} ops: 0 {
    initial-use  at:
                          [<ffffffff8026548d>] __lock_acquire+0x1bd/0xa50
                          [<ffffffff80265d73>] lock_acquire+0x53/0x70
                          [<ffffffff80430c0a>] __neigh_event_send+0x2a/0x200
                          [<ffffffff80493198>] _write_lock_bh+0x38/0x50
                          [<ffffffff80430c0a>] __neigh_event_send+0x2a/0x200
                          [<ffffffff80430c0a>] __neigh_event_send+0x2a/0x200
                          [<ffffffff804335b7>] neigh_resolve_output+0x147/0x2d0
                          [<ffffffff8044a51d>] ip_generic_getfrag+0x4d/0x90
                          [<ffffffff8044896c>] ip_push_pending_frames+0x27c/0x400
                          [<ffffffff80467153>] udp_push_pending_frames+0x233/0x3c0
                          [<ffffffff80468531>] udp_sendmsg+0x361/0x730
                          [<ffffffff80243561>] local_bh_enable_ip+0x81/0xf0
                          [<ffffffff80243561>] local_bh_enable_ip+0x81/0xf0
                          [<ffffffff8043135a>] neigh_lookup+0x10a/0x140
                          [<ffffffff8041c3fb>] sock_sendmsg+0xcb/0x100
                          [<ffffffff802638ce>] trace_hardirqs_on_caller+0x11e/0x180
                          [<ffffffff80265717>] __lock_acquire+0x447/0xa50
                          [<ffffffff80254370>] autoremove_wake_function+0x0/0x30
                          [<ffffffff8028e3fd>] __do_fault+0x1dd/0x4a0
                          [<ffffffff80264530>] validate_chain+0x460/0x1200
                          [<ffffffff8041bac1>] sockfd_lookup_light+0x41/0x80
                          [<ffffffff8041c8a9>] sys_sendto+0x119/0x180
                          [<ffffffff80265717>] __lock_acquire+0x447/0xa50
                          [<ffffffff80468e40>] udp_poll+0x0/0x120
                          [<ffffffff8020b95b>] system_call_fastpath+0x16/0x1b
                          [<ffffffffffffffff>] 0xffffffffffffffff
    in-softirq-W at:
                          [<ffffffffffffffff>] 0xffffffffffffffff
    hardirq-on-W at:
                          [<ffffffff80265ad5>] __lock_acquire+0x805/0xa50
                          [<ffffffff80265d73>] lock_acquire+0x53/0x70
                          [<ffffffff80430c0a>] __neigh_event_send+0x2a/0x200
                          [<ffffffff80493198>] _write_lock_bh+0x38/0x50
                          [<ffffffff80430c0a>] __neigh_event_send+0x2a/0x200
                          [<ffffffff80430c0a>] __neigh_event_send+0x2a/0x200
                          [<ffffffff804335b7>] neigh_resolve_output+0x147/0x2d0
                          [<ffffffff8044a51d>] ip_generic_getfrag+0x4d/0x90
                          [<ffffffff8044896c>] ip_push_pending_frames+0x27c/0x400
                          [<ffffffff80467153>] udp_push_pending_frames+0x233/0x3c0
                          [<ffffffff80468531>] udp_sendmsg+0x361/0x730
                          [<ffffffff80243561>] local_bh_enable_ip+0x81/0xf0
                          [<ffffffff80243561>] local_bh_enable_ip+0x81/0xf0
                          [<ffffffff8043135a>] neigh_lookup+0x10a/0x140
                          [<ffffffff8041c3fb>] sock_sendmsg+0xcb/0x100
                          [<ffffffff802638ce>] trace_hardirqs_on_caller+0x11e/0x180
                          [<ffffffff80265717>] __lock_acquire+0x447/0xa50
                          [<ffffffff80254370>] autoremove_wake_function+0x0/0x30
                          [<ffffffff8028e3fd>] __do_fault+0x1dd/0x4a0
                          [<ffffffff80264530>] validate_chain+0x460/0x1200
                          [<ffffffff8041bac1>] sockfd_lookup_light+0x41/0x80
                          [<ffffffff8041c8a9>] sys_sendto+0x119/0x180
                          [<ffffffff80265717>] __lock_acquire+0x447/0xa50
                          [<ffffffff80468e40>] udp_poll+0x0/0x120
                          [<ffffffff8020b95b>] system_call_fastpath+0x16/0x1b
                          [<ffffffffffffffff>] 0xffffffffffffffff
    in-softirq-R at:
                          [<ffffffffffffffff>] 0xffffffffffffffff
    hardirq-on-R at:
                          [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffff80d7e3a4>] __key.31965+0x0/0xc
  -> (&base->lock){++..} ops: 0 {
     initial-use  at:
                            [<ffffffff8026548d>] __lock_acquire+0x1bd/0xa50
                            [<ffffffff80265d73>] lock_acquire+0x53/0x70
                            [<ffffffff80248c44>] lock_timer_base+0x34/0x70
                            [<ffffffff8049337e>] _spin_lock_irqsave+0x3e/0x60
                            [<ffffffff80248c44>] lock_timer_base+0x34/0x70
                            [<ffffffff80248c44>] lock_timer_base+0x34/0x70
                            [<ffffffff80493735>] _spin_unlock_irqrestore+0x65/0x80
                            [<ffffffff80248d3a>] __mod_timer+0x2a/0xe0
                            [<ffffffff80493710>] _spin_unlock_irqrestore+0x40/0x80
                            [<ffffffff8062da24>] con_init+0x274/0x2a0
                            [<ffffffff8062d00a>] console_init+0x1a/0x30
                            [<ffffffff80611cd5>] start_kernel+0x265/0x440
                            [<ffffffff8061136a>] x86_64_start_kernel+0xca/0xe0
                            [<ffffffffffffffff>] 0xffffffffffffffff
     in-hardirq-W at:
                            [<ffffffffffffffff>] 0xffffffffffffffff
     in-softirq-W at:
                            [<ffffffffffffffff>] 0xffffffffffffffff
   }
   ... key      at: [<ffffffff8077f918>] __key.21559+0x0/0x8
  ... acquired at:
   [<ffffffff80248c44>] lock_timer_base+0x34/0x70
   [<ffffffff80264cd5>] validate_chain+0xc05/0x1200
   [<ffffffff80265717>] __lock_acquire+0x447/0xa50
   [<ffffffff80265d73>] lock_acquire+0x53/0x70
   [<ffffffff80248c44>] lock_timer_base+0x34/0x70
   [<ffffffff8049337e>] _spin_lock_irqsave+0x3e/0x60
   [<ffffffff80248c44>] lock_timer_base+0x34/0x70
   [<ffffffff80248c44>] lock_timer_base+0x34/0x70
   [<ffffffff80248d3a>] __mod_timer+0x2a/0xe0
   [<ffffffff80430bb7>] neigh_add_timer+0x17/0x40
   [<ffffffff80430cb3>] __neigh_event_send+0xd3/0x200
   [<ffffffff804335b7>] neigh_resolve_output+0x147/0x2d0
   [<ffffffff8044a51d>] ip_generic_getfrag+0x4d/0x90
   [<ffffffff8044896c>] ip_push_pending_frames+0x27c/0x400
   [<ffffffff80467153>] udp_push_pending_frames+0x233/0x3c0
   [<ffffffff80468531>] udp_sendmsg+0x361/0x730
   [<ffffffff80243561>] local_bh_enable_ip+0x81/0xf0
   [<ffffffff80243561>] local_bh_enable_ip+0x81/0xf0
   [<ffffffff8043135a>] neigh_lookup+0x10a/0x140
   [<ffffffff8041c3fb>] sock_sendmsg+0xcb/0x100
   [<ffffffff802638ce>] trace_hardirqs_on_caller+0x11e/0x180
   [<ffffffff80265717>] __lock_acquire+0x447/0xa50
   [<ffffffff80254370>] autoremove_wake_function+0x0/0x30
   [<ffffffff8028e3fd>] __do_fault+0x1dd/0x4a0
   [<ffffffff80264530>] validate_chain+0x460/0x1200
   [<ffffffff8041bac1>] sockfd_lookup_light+0x41/0x80
   [<ffffffff8041c8a9>] sys_sendto+0x119/0x180
   [<ffffffff80265717>] __lock_acquire+0x447/0xa50
   [<ffffffff80468e40>] udp_poll+0x0/0x120
   [<ffffffff8020b95b>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

  -> (&list->lock#3){.+..} ops: 0 {
     initial-use  at:
                            [<ffffffffffffffff>] 0xffffffffffffffff
     in-softirq-W at:
                            [<ffffffffffffffff>] 0xffffffffffffffff
   }
   ... key      at: [<ffffffff80d7e394>] __key.17594+0x0/0x8
  ... acquired at:
   [<ffffffffffffffff>] 0xffffffffffffffff

 ... acquired at:
   [<ffffffffffffffff>] 0xffffffffffffffff

 -> (&list->lock){-+..} ops: 0 {
    initial-use  at:
                          [<ffffffff8026548d>] __lock_acquire+0x1bd/0xa50
                          [<ffffffff80265d73>] lock_acquire+0x53/0x70
                          [<ffffffff80422d84>] skb_queue_tail+0x24/0x60
                          [<ffffffff8049337e>] _spin_lock_irqsave+0x3e/0x60
                          [<ffffffff80422d84>] skb_queue_tail+0x24/0x60
                          [<ffffffff80422d84>] skb_queue_tail+0x24/0x60
                          [<ffffffff8043d0ed>] netlink_broadcast+0x2cd/0x3c0
                          [<ffffffff803449b6>] kobject_uevent_env+0x336/0x3f0
                          [<ffffffff80344adf>] kobject_action_type+0x5f/0xb0
                          [<ffffffff803c9139>] bus_uevent_store+0x39/0x50
                          [<ffffffff80300aec>] sysfs_write_file+0xcc/0x150
                          [<ffffffff802ac328>] vfs_write+0xc8/0x170
                          [<ffffffff802ac903>] sys_write+0x53/0x90
                          [<ffffffff8020b95b>] system_call_fastpath+0x16/0x1b
                          [<ffffffffffffffff>] 0xffffffffffffffff
    in-softirq-W at:
                          [<ffffffffffffffff>] 0xffffffffffffffff
    hardirq-on-W at:
                          [<ffffffff80265ad5>] __lock_acquire+0x805/0xa50
                          [<ffffffff80265d73>] lock_acquire+0x53/0x70
                          [<ffffffff80468e94>] udp_poll+0x54/0x120
                          [<ffffffff80493108>] _spin_lock_bh+0x38/0x50
                          [<ffffffff80468e94>] udp_poll+0x54/0x120
                          [<ffffffff80468e94>] udp_poll+0x54/0x120
                          [<ffffffff802bab22>] do_sys_poll+0x1e2/0x3d0
                          [<ffffffff802bb9f0>] __pollwait+0x0/0x130
                          [<ffffffff80234f50>] default_wake_function+0x0/0x10
                          [<ffffffff80234f50>] default_wake_function+0x0/0x10
                          [<ffffffff80265717>] __lock_acquire+0x447/0xa50
                          [<ffffffff802636b2>] mark_held_locks+0x42/0x90
                          [<ffffffff80264530>] validate_chain+0x460/0x1200
                          [<ffffffff8027c2fd>] __rcu_read_unlock+0xcd/0xe0
                          [<ffffffff802638ce>] trace_hardirqs_on_caller+0x11e/0x180
                          [<ffffffff80265717>] __lock_acquire+0x447/0xa50
                          [<ffffffff8028e3fd>] __do_fault+0x1dd/0x4a0
                          [<ffffffff80265717>] __lock_acquire+0x447/0xa50
                          [<ffffffff8020c3ad>] retint_swapgs+0xe/0x13
                          [<ffffffff802bad83>] sys_poll+0x73/0xf0
                          [<ffffffff8020b95b>] system_call_fastpath+0x16/0x1b
                          [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffff80d7d4d4>] __key.24456+0x0/0x8
 ... acquired at:
   [<ffffffffffffffff>] 0xffffffffffffffff

 -> (&q->lock){++..} ops: 0 {
    initial-use  at:
                          [<ffffffff8026548d>] __lock_acquire+0x1bd/0xa50
                          [<ffffffff80265d73>] lock_acquire+0x53/0x70
                          [<ffffffff8048ffc7>] wait_for_common+0x37/0x190
                          [<ffffffff804932d9>] _spin_lock_irq+0x39/0x50
                          [<ffffffff8048ffc7>] wait_for_common+0x37/0x190
                          [<ffffffff802638ce>] trace_hardirqs_on_caller+0x11e/0x180
                          [<ffffffff8048ffc7>] wait_for_common+0x37/0x190
                          [<ffffffff80493710>] _spin_unlock_irqrestore+0x40/0x80
                          [<ffffffff80234e67>] try_to_wake_up+0x107/0x1f0
                          [<ffffffff802541ea>] kthread_create+0x9a/0x110
                          [<ffffffff802389b0>] migration_thread+0x0/0x290
                          [<ffffffff80264530>] validate_chain+0x460/0x1200
                          [<ffffffff80265717>] __lock_acquire+0x447/0xa50
                          [<ffffffff8021273f>] init_pit_timer+0x1f/0xc0
                          [<ffffffff802636b2>] mark_held_locks+0x42/0x90
                          [<ffffffff80493735>] _spin_unlock_irqrestore+0x65/0x80
                          [<ffffffff80621a90>] migration_init+0x0/0x60
                          [<ffffffff8048e204>] migration_call+0x244/0x580
                          [<ffffffff80493710>] _spin_unlock_irqrestore+0x40/0x80
                          [<ffffffff80621a90>] migration_init+0x0/0x60
                          [<ffffffff80621ab1>] migration_init+0x21/0x60
                          [<ffffffff80621a90>] migration_init+0x0/0x60
                          [<ffffffff8020903b>] _stext+0x3b/0x170
                          [<ffffffff80493609>] _spin_unlock+0x29/0x50
                          [<ffffffff80223930>] get_apic_id+0x0/0x10
                          [<ffffffff8061aaab>] native_smp_prepare_cpus+0x1ab/0x460
                          [<ffffffff806118c0>] kernel_init+0x70/0x1f0
                          [<ffffffff8020c9fa>] child_rip+0xa/0x20
                          [<ffffffff8020c3c0>] restore_args+0x0/0x30
                          [<ffffffff80611850>] kernel_init+0x0/0x1f0
                          [<ffffffff8020c9f0>] child_rip+0x0/0x20
                          [<ffffffffffffffff>] 0xffffffffffffffff
    in-hardirq-W at:
                          [<ffffffffffffffff>] 0xffffffffffffffff
    in-softirq-W at:
                          [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffff80780058>] __key.16756+0x0/0x8
  -> (&rq->lock){++..} ops: 0 {
     initial-use  at:
                            [<ffffffff8026548d>] __lock_acquire+0x1bd/0xa50
                            [<ffffffff80265d73>] lock_acquire+0x53/0x70
                            [<ffffffff80234b93>] rq_attach_root+0x23/0xe0
                            [<ffffffff8049337e>] _spin_lock_irqsave+0x3e/0x60
                            [<ffffffff80234b93>] rq_attach_root+0x23/0xe0
                            [<ffffffff80234b93>] rq_attach_root+0x23/0xe0
                            [<ffffffff80622035>] sched_init+0x375/0x510
                            [<ffffffff80611c04>] start_kernel+0x194/0x440
                            [<ffffffff8061136a>] x86_64_start_kernel+0xca/0xe0
                            [<ffffffffffffffff>] 0xffffffffffffffff
     in-hardirq-W at:
                            [<ffffffffffffffff>] 0xffffffffffffffff
     in-softirq-W at:
                            [<ffffffffffffffff>] 0xffffffffffffffff
   }
   ... key      at: [<ffffffff8067b0d8>] __key.42751+0x0/0x8
   -> (&vec->lock){.+..} ops: 0 {
      initial-use  at:
                              [<ffffffff8026548d>] __lock_acquire+0x1bd/0xa50
                              [<ffffffff80265d73>] lock_acquire+0x53/0x70
                              [<ffffffff8027ceac>] cpupri_set+0x8c/0xe0
                              [<ffffffff8049337e>] _spin_lock_irqsave+0x3e/0x60
                              [<ffffffff8027ceac>] cpupri_set+0x8c/0xe0
                              [<ffffffff8027ceac>] cpupri_set+0x8c/0xe0
                              [<ffffffff802302b1>] set_rq_online+0x51/0x70
                              [<ffffffff80234b93>] rq_attach_root+0x23/0xe0
                              [<ffffffff80234bfd>] rq_attach_root+0x8d/0xe0
                              [<ffffffff80622035>] sched_init+0x375/0x510
                              [<ffffffff80611c04>] start_kernel+0x194/0x440
                              [<ffffffff8061136a>] x86_64_start_kernel+0xca/0xe0
                              [<ffffffffffffffff>] 0xffffffffffffffff
      in-softirq-W at:
                              [<ffffffffffffffff>] 0xffffffffffffffff
    }
    ... key      at: [<ffffffff80d6de50>] __key.13804+0x0/0x8
   ... acquired at:
   [<ffffffff8027ceac>] cpupri_set+0x8c/0xe0
   [<ffffffff80264cd5>] validate_chain+0xc05/0x1200
   [<ffffffff80260f57>] save_trace+0x37/0xa0
   [<ffffffff80265717>] __lock_acquire+0x447/0xa50
   [<ffffffff80265d73>] lock_acquire+0x53/0x70
   [<ffffffff8027ceac>] cpupri_set+0x8c/0xe0
   [<ffffffff8049337e>] _spin_lock_irqsave+0x3e/0x60
   [<ffffffff8027ceac>] cpupri_set+0x8c/0xe0
   [<ffffffff8027ceac>] cpupri_set+0x8c/0xe0
   [<ffffffff802302b1>] set_rq_online+0x51/0x70
   [<ffffffff80234b93>] rq_attach_root+0x23/0xe0
   [<ffffffff80234bfd>] rq_attach_root+0x8d/0xe0
   [<ffffffff80622035>] sched_init+0x375/0x510
   [<ffffffff80611c04>] start_kernel+0x194/0x440
   [<ffffffff8061136a>] x86_64_start_kernel+0xca/0xe0
   [<ffffffffffffffff>] 0xffffffffffffffff

   -> (&rt_b->rt_runtime_lock){.+..} ops: 0 {
      initial-use  at:
                              [<ffffffff8026548d>] __lock_acquire+0x1bd/0xa50
                              [<ffffffff80265d73>] lock_acquire+0x53/0x70
                              [<ffffffff80233a0c>] __enqueue_rt_entity+0xdc/0x180
                              [<ffffffff804930c3>] _spin_lock+0x33/0x40
                              [<ffffffff80233a0c>] __enqueue_rt_entity+0xdc/0x180
                              [<ffffffff80233a0c>] __enqueue_rt_entity+0xdc/0x180
                              [<ffffffff80233aeb>] enqueue_task_rt+0x3b/0x80
                              [<ffffffff8022f1ab>] enqueue_task+0xb/0x20
                              [<ffffffff8022f23a>] activate_task+0x1a/0x30
                              [<ffffffff80234f3d>] try_to_wake_up+0x1dd/0x1f0
                              [<ffffffff802638ce>] trace_hardirqs_on_caller+0x11e/0x180
                              [<ffffffff8048e024>] migration_call+0x64/0x580
                              [<ffffffff80621ace>] migration_init+0x3e/0x60
                              [<ffffffff80621a90>] migration_init+0x0/0x60
                              [<ffffffff8020903b>] _stext+0x3b/0x170
                              [<ffffffff80493609>] _spin_unlock+0x29/0x50
                              [<ffffffff80223930>] get_apic_id+0x0/0x10
                              [<ffffffff8061aaab>] native_smp_prepare_cpus+0x1ab/0x460
                              [<ffffffff806118c0>] kernel_init+0x70/0x1f0
                              [<ffffffff8020c9fa>] child_rip+0xa/0x20
                              [<ffffffff8020c3c0>] restore_args+0x0/0x30
                              [<ffffffff80611850>] kernel_init+0x0/0x1f0
                              [<ffffffff8020c9f0>] child_rip+0x0/0x20
                              [<ffffffffffffffff>] 0xffffffffffffffff
      in-softirq-W at:
                              [<ffffffffffffffff>] 0xffffffffffffffff
    }
    ... key      at: [<ffffffff8067b0e0>] __key.34599+0x0/0x8
    -> (&cpu_base->lock){++..} ops: 0 {
       initial-use  at:
                                [<ffffffffffffffff>] 0xffffffffffffffff
       in-hardirq-W at:
                                [<ffffffffffffffff>] 0xffffffffffffffff
       in-softirq-W at:
                                [<ffffffffffffffff>] 0xffffffffffffffff
     }
     ... key      at: [<ffffffff80780094>] __key.18863+0x0/0x8
    ... acquired at:
   [<ffffffff80257589>] lock_hrtimer_base+0x29/0x60
   [<ffffffff80264cd5>] validate_chain+0xc05/0x1200
   [<ffffffff80265717>] __lock_acquire+0x447/0xa50
   [<ffffffff80265d73>] lock_acquire+0x53/0x70
   [<ffffffff80257589>] lock_hrtimer_base+0x29/0x60
   [<ffffffff8049337e>] _spin_lock_irqsave+0x3e/0x60
   [<ffffffff80257589>] lock_hrtimer_base+0x29/0x60
   [<ffffffff80257589>] lock_hrtimer_base+0x29/0x60
   [<ffffffff80257722>] hrtimer_start_range_ns+0x42/0x200
   [<ffffffff80257af5>] ktime_get_ts+0x25/0x60
   [<ffffffff80233a55>] __enqueue_rt_entity+0x125/0x180
   [<ffffffff80233aeb>] enqueue_task_rt+0x3b/0x80
   [<ffffffff8022f1ab>] enqueue_task+0xb/0x20
   [<ffffffff8022f23a>] activate_task+0x1a/0x30
   [<ffffffff80234f3d>] try_to_wake_up+0x1dd/0x1f0
   [<ffffffff802638ce>] trace_hardirqs_on_caller+0x11e/0x180
   [<ffffffff8048e024>] migration_call+0x64/0x580
   [<ffffffff80621ace>] migration_init+0x3e/0x60
   [<ffffffff80621a90>] migration_init+0x0/0x60
   [<ffffffff8020903b>] _stext+0x3b/0x170
   [<ffffffff80493609>] _spin_unlock+0x29/0x50
   [<ffffffff80223930>] get_apic_id+0x0/0x10
   [<ffffffff8061aaab>] native_smp_prepare_cpus+0x1ab/0x460
   [<ffffffff806118c0>] kernel_init+0x70/0x1f0
   [<ffffffff8020c9fa>] child_rip+0xa/0x20
   [<ffffffff8020c3c0>] restore_args+0x0/0x30
   [<ffffffff80611850>] kernel_init+0x0/0x1f0
   [<ffffffff8020c9f0>] child_rip+0x0/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

    -> (&rt_rq->rt_runtime_lock){+...} ops: 0 {
       initial-use  at:
                                [<ffffffff8026548d>] __lock_acquire+0x1bd/0xa50
                                [<ffffffff80265d73>] lock_acquire+0x53/0x70
                                [<ffffffff80237e50>] update_curr_rt+0x110/0x190
                                [<ffffffff804930c3>] _spin_lock+0x33/0x40
                                [<ffffffff80237e50>] update_curr_rt+0x110/0x190
                                [<ffffffff80237e50>] update_curr_rt+0x110/0x190
                                [<ffffffff80237fe9>] dequeue_task_rt+0x19/0x50
                                [<ffffffff8022f20f>] dequeue_task+0x4f/0x60
                                [<ffffffff8022f26a>] deactivate_task+0x1a/0x20
                                [<ffffffff80490507>] thread_return+0xe3/0x59c
                                [<ffffffff802389b0>] migration_thread+0x0/0x290
                                [<ffffffff80493774>] _spin_unlock_irq+0x24/0x50
                                [<ffffffff802389b0>] migration_thread+0x0/0x290
                                [<ffffffff802389b0>] migration_thread+0x0/0x290
                                [<ffffffff80238b2f>] migration_thread+0x17f/0x290
                                [<ffffffff802389b0>] migration_thread+0x0/0x290
                                [<ffffffff80253f6b>] kthread+0x4b/0x80
                                [<ffffffff8020c9fa>] child_rip+0xa/0x20
                                [<ffffffff8020c3c0>] restore_args+0x0/0x30
                                [<ffffffff80253f20>] kthread+0x0/0x80
                                [<ffffffff8020c9f0>] child_rip+0x0/0x20
                                [<ffffffffffffffff>] 0xffffffffffffffff
       in-hardirq-W at:
                                [<ffffffffffffffff>] 0xffffffffffffffff
     }
     ... key      at: [<ffffffff8067b0e8>] __key.42703+0x0/0x8
    ... acquired at:
   [<ffffffff802321c2>] __enable_runtime+0x42/0xa0
   [<ffffffff80264cd5>] validate_chain+0xc05/0x1200
   [<ffffffff80265717>] __lock_acquire+0x447/0xa50
   [<ffffffff80265d73>] lock_acquire+0x53/0x70
   [<ffffffff802321c2>] __enable_runtime+0x42/0xa0
   [<ffffffff804930c3>] _spin_lock+0x33/0x40
   [<ffffffff802321c2>] __enable_runtime+0x42/0xa0
   [<ffffffff802321c2>] __enable_runtime+0x42/0xa0
   [<ffffffff802336e4>] rq_online_rt+0x24/0x70
   [<ffffffff802302b1>] set_rq_online+0x51/0x70
   [<ffffffff8048e03d>] migration_call+0x7d/0x580
   [<ffffffff8048e065>] migration_call+0xa5/0x580
   [<ffffffff80258c71>] notifier_call_chain+0x51/0x70
   [<ffffffff8048e836>] _cpu_up+0xe6/0x140
   [<ffffffff8048e8e9>] cpu_up+0x59/0x80
   [<ffffffff80611944>] kernel_init+0xf4/0x1f0
   [<ffffffff8020c9fa>] child_rip+0xa/0x20
   [<ffffffff8020c3c0>] restore_args+0x0/0x30
   [<ffffffff80611850>] kernel_init+0x0/0x1f0
   [<ffffffff8020c9f0>] child_rip+0x0/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

   ... acquired at:
   [<ffffffff80233a0c>] __enqueue_rt_entity+0xdc/0x180
   [<ffffffff80264cd5>] validate_chain+0xc05/0x1200
   [<ffffffff80260f57>] save_trace+0x37/0xa0
   [<ffffffff80265717>] __lock_acquire+0x447/0xa50
   [<ffffffff80265d73>] lock_acquire+0x53/0x70
   [<ffffffff80233a0c>] __enqueue_rt_entity+0xdc/0x180
   [<ffffffff804930c3>] _spin_lock+0x33/0x40
   [<ffffffff80233a0c>] __enqueue_rt_entity+0xdc/0x180
   [<ffffffff80233a0c>] __enqueue_rt_entity+0xdc/0x180
   [<ffffffff80233aeb>] enqueue_task_rt+0x3b/0x80
   [<ffffffff8022f1ab>] enqueue_task+0xb/0x20
   [<ffffffff8022f23a>] activate_task+0x1a/0x30
   [<ffffffff80234f3d>] try_to_wake_up+0x1dd/0x1f0
   [<ffffffff802638ce>] trace_hardirqs_on_caller+0x11e/0x180
   [<ffffffff8048e024>] migration_call+0x64/0x580
   [<ffffffff80621ace>] migration_init+0x3e/0x60
   [<ffffffff80621a90>] migration_init+0x0/0x60
   [<ffffffff8020903b>] _stext+0x3b/0x170
   [<ffffffff80493609>] _spin_unlock+0x29/0x50
   [<ffffffff80223930>] get_apic_id+0x0/0x10
   [<ffffffff8061aaab>] native_smp_prepare_cpus+0x1ab/0x460
   [<ffffffff806118c0>] kernel_init+0x70/0x1f0
   [<ffffffff8020c9fa>] child_rip+0xa/0x20
   [<ffffffff8020c3c0>] restore_args+0x0/0x30
   [<ffffffff80611850>] kernel_init+0x0/0x1f0
   [<ffffffff8020c9f0>] child_rip+0x0/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

   ... acquired at:
   [<ffffffff80237e50>] update_curr_rt+0x110/0x190
   [<ffffffff80264cd5>] validate_chain+0xc05/0x1200
   [<ffffffff80260f57>] save_trace+0x37/0xa0
   [<ffffffff80265717>] __lock_acquire+0x447/0xa50
   [<ffffffff80265d73>] lock_acquire+0x53/0x70
   [<ffffffff80237e50>] update_curr_rt+0x110/0x190
   [<ffffffff804930c3>] _spin_lock+0x33/0x40
   [<ffffffff80237e50>] update_curr_rt+0x110/0x190
   [<ffffffff80237e50>] update_curr_rt+0x110/0x190
   [<ffffffff80237fe9>] dequeue_task_rt+0x19/0x50
   [<ffffffff8022f20f>] dequeue_task+0x4f/0x60
   [<ffffffff8022f26a>] deactivate_task+0x1a/0x20
   [<ffffffff80490507>] thread_return+0xe3/0x59c
   [<ffffffff802389b0>] migration_thread+0x0/0x290
   [<ffffffff80493774>] _spin_unlock_irq+0x24/0x50
   [<ffffffff802389b0>] migration_thread+0x0/0x290
   [<ffffffff802389b0>] migration_thread+0x0/0x290
   [<ffffffff80238b2f>] migration_thread+0x17f/0x290
   [<ffffffff802389b0>] migration_thread+0x0/0x290
   [<ffffffff80253f6b>] kthread+0x4b/0x80
   [<ffffffff8020c9fa>] child_rip+0xa/0x20
   [<ffffffff8020c3c0>] restore_args+0x0/0x30
   [<ffffffff80253f20>] kthread+0x0/0x80
   [<ffffffff8020c9f0>] child_rip+0x0/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

   -> (&rq->lock/1){.+..} ops: 0 {
      initial-use  at:
                              [<ffffffffffffffff>] 0xffffffffffffffff
      in-softirq-W at:
                              [<ffffffffffffffff>] 0xffffffffffffffff
    }
    ... key      at: [<ffffffff8067b0d9>] __key.42751+0x1/0x8
   ... acquired at:
   [<ffffffffffffffff>] 0xffffffffffffffff

  ... acquired at:
   [<ffffffff802308a3>] task_rq_lock+0x53/0xa0
   [<ffffffff80264cd5>] validate_chain+0xc05/0x1200
   [<ffffffff80264530>] validate_chain+0x460/0x1200
   [<ffffffff80265717>] __lock_acquire+0x447/0xa50
   [<ffffffff80265d73>] lock_acquire+0x53/0x70
   [<ffffffff802308a3>] task_rq_lock+0x53/0xa0
   [<ffffffff804930c3>] _spin_lock+0x33/0x40
   [<ffffffff802308a3>] task_rq_lock+0x53/0xa0
   [<ffffffff802308a3>] task_rq_lock+0x53/0xa0
   [<ffffffff80234df3>] try_to_wake_up+0x93/0x1f0
   [<ffffffff8022f58b>] __wake_up_common+0x5b/0x90
   [<ffffffff8023066d>] complete+0x3d/0x60
   [<ffffffff802540b9>] kthreadd+0x119/0x1b0
   [<ffffffff8020c3c0>] restore_args+0x0/0x30
   [<ffffffff8020c9fa>] child_rip+0xa/0x20
   [<ffffffff8020c3c0>] restore_args+0x0/0x30
   [<ffffffff80253fa0>] kthreadd+0x0/0x1b0
   [<ffffffff8020c9f0>] child_rip+0x0/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

 ... acquired at:
   [<ffffffffffffffff>] 0xffffffffffffffff


the soft-irq-unsafe lock's dependencies:
-> (&fbc->lock){--..} ops: 0 {
   initial-use  at:
                        [<ffffffff8026548d>] __lock_acquire+0x1bd/0xa50
                        [<ffffffff80265d73>] lock_acquire+0x53/0x70
                        [<ffffffff8035adce>] __percpu_counter_add+0x5e/0xd0
                        [<ffffffff804930c3>] _spin_lock+0x33/0x40
                        [<ffffffff8035adce>] __percpu_counter_add+0x5e/0xd0
                        [<ffffffff802a6e21>] kmem_cache_alloc+0xd1/0xe0
                        [<ffffffff8035adce>] __percpu_counter_add+0x5e/0xd0
                        [<ffffffff802ad058>] get_empty_filp+0x68/0x140
                        [<ffffffff802b7e7b>] path_lookup_open+0x3b/0xd0
                        [<ffffffff802b07d4>] open_exec+0x24/0xd0
                        [<ffffffff802ac4fa>] vfs_read+0x12a/0x160
                        [<ffffffff802b0688>] kernel_read+0x38/0x50
                        [<ffffffff802ea559>] load_elf_binary+0x18b9/0x1d20
                        [<ffffffff8027f74f>] generic_file_aio_read+0x4ff/0x5e0
                        [<ffffffff80264530>] validate_chain+0x460/0x1200
                        [<ffffffff80264530>] validate_chain+0x460/0x1200
                        [<ffffffff80265717>] __lock_acquire+0x447/0xa50
                        [<ffffffff802ec040>] load_elf_binary+0x0/0x1e70
                        [<ffffffff802e8ca0>] load_elf_binary+0x0/0x1d20
                        [<ffffffff802b0360>] search_binary_handler+0xd0/0x2e0
                        [<ffffffff802e7640>] load_script+0x270/0x280
                        [<ffffffff802e8ca0>] load_elf_binary+0x0/0x1d20
                        [<ffffffff802e73d0>] load_script+0x0/0x280
                        [<ffffffff802b0360>] search_binary_handler+0xd0/0x2e0
                        [<ffffffff802b18de>] do_execve+0x22e/0x290
                        [<ffffffff80209b49>] sys_execve+0x49/0x80
                        [<ffffffff8020bdfa>] stub_execve+0x6a/0xc0
                        [<ffffffffffffffff>] 0xffffffffffffffff
   softirq-on-W at:
                        [<ffffffff80265afd>] __lock_acquire+0x82d/0xa50
                        [<ffffffff80265d73>] lock_acquire+0x53/0x70
                        [<ffffffff8035adce>] __percpu_counter_add+0x5e/0xd0
                        [<ffffffff804930c3>] _spin_lock+0x33/0x40
                        [<ffffffff8035adce>] __percpu_counter_add+0x5e/0xd0
                        [<ffffffff802a6e21>] kmem_cache_alloc+0xd1/0xe0
                        [<ffffffff8035adce>] __percpu_counter_add+0x5e/0xd0
                        [<ffffffff802ad058>] get_empty_filp+0x68/0x140
                        [<ffffffff802b7e7b>] path_lookup_open+0x3b/0xd0
                        [<ffffffff802b07d4>] open_exec+0x24/0xd0
                        [<ffffffff802ac4fa>] vfs_read+0x12a/0x160
                        [<ffffffff802b0688>] kernel_read+0x38/0x50
                        [<ffffffff802ea559>] load_elf_binary+0x18b9/0x1d20
                        [<ffffffff8027f74f>] generic_file_aio_read+0x4ff/0x5e0
                        [<ffffffff80264530>] validate_chain+0x460/0x1200
                        [<ffffffff80264530>] validate_chain+0x460/0x1200
                        [<ffffffff80265717>] __lock_acquire+0x447/0xa50
                        [<ffffffff802ec040>] load_elf_binary+0x0/0x1e70
                        [<ffffffff802e8ca0>] load_elf_binary+0x0/0x1d20
                        [<ffffffff802b0360>] search_binary_handler+0xd0/0x2e0
                        [<ffffffff802e7640>] load_script+0x270/0x280
                        [<ffffffff802e8ca0>] load_elf_binary+0x0/0x1d20
                        [<ffffffff802e73d0>] load_script+0x0/0x280
                        [<ffffffff802b0360>] search_binary_handler+0xd0/0x2e0
                        [<ffffffff802b18de>] do_execve+0x22e/0x290
                        [<ffffffff80209b49>] sys_execve+0x49/0x80
                        [<ffffffff8020bdfa>] stub_execve+0x6a/0xc0
                        [<ffffffffffffffff>] 0xffffffffffffffff
   hardirq-on-W at:
                        [<ffffffff80265ad5>] __lock_acquire+0x805/0xa50
                        [<ffffffff80265d73>] lock_acquire+0x53/0x70
                        [<ffffffff8035adce>] __percpu_counter_add+0x5e/0xd0
                        [<ffffffff804930c3>] _spin_lock+0x33/0x40
                        [<ffffffff8035adce>] __percpu_counter_add+0x5e/0xd0
                        [<ffffffff802a6e21>] kmem_cache_alloc+0xd1/0xe0
                        [<ffffffff8035adce>] __percpu_counter_add+0x5e/0xd0
                        [<ffffffff802ad058>] get_empty_filp+0x68/0x140
                        [<ffffffff802b7e7b>] path_lookup_open+0x3b/0xd0
                        [<ffffffff802b07d4>] open_exec+0x24/0xd0
                        [<ffffffff802ac4fa>] vfs_read+0x12a/0x160
                        [<ffffffff802b0688>] kernel_read+0x38/0x50
                        [<ffffffff802ea559>] load_elf_binary+0x18b9/0x1d20
                        [<ffffffff8027f74f>] generic_file_aio_read+0x4ff/0x5e0
                        [<ffffffff80264530>] validate_chain+0x460/0x1200
                        [<ffffffff80264530>] validate_chain+0x460/0x1200
                        [<ffffffff80265717>] __lock_acquire+0x447/0xa50
                        [<ffffffff802ec040>] load_elf_binary+0x0/0x1e70
                        [<ffffffff802e8ca0>] load_elf_binary+0x0/0x1d20
                        [<ffffffff802b0360>] search_binary_handler+0xd0/0x2e0
                        [<ffffffff802e7640>] load_script+0x270/0x280
                        [<ffffffff802e8ca0>] load_elf_binary+0x0/0x1d20
                        [<ffffffff802e73d0>] load_script+0x0/0x280
                        [<ffffffff802b0360>] search_binary_handler+0xd0/0x2e0
                        [<ffffffff802b18de>] do_execve+0x22e/0x290
                        [<ffffffff80209b49>] sys_execve+0x49/0x80
                        [<ffffffff8020bdfa>] stub_execve+0x6a/0xc0
                        [<ffffffffffffffff>] 0xffffffffffffffff
 }
 ... key      at: [<ffffffff80d736d4>] __key.10917+0x0/0x8

stack backtrace:
Pid: 4695, comm: skype Not tainted 2.6.28-rc7-next-20081204 #1
Call Trace:
 [<ffffffff80263ed2>] check_usage+0x362/0x480
 [<ffffffff802649a0>] validate_chain+0x8d0/0x1200
 [<ffffffff80265717>] __lock_acquire+0x447/0xa50
 [<ffffffff80265d73>] lock_acquire+0x53/0x70
 [<ffffffff8035adce>] __percpu_counter_add+0x5e/0xd0
 [<ffffffff804930c3>] _spin_lock+0x33/0x40
 [<ffffffff8035adce>] __percpu_counter_add+0x5e/0xd0
 [<ffffffff8035adce>] __percpu_counter_add+0x5e/0xd0
 [<ffffffff8044ee36>] inet_csk_destroy_sock+0x46/0xf0
 [<ffffffff80453650>] tcp_close+0x320/0x4a0
 [<ffffffff8046f7fe>] inet_release+0x3e/0x70
 [<ffffffff8041c9f9>] sock_release+0x19/0xb0
 [<ffffffff8041cfe2>] sock_close+0x12/0x40
 [<ffffffff802ace0b>] __fput+0xbb/0x200
 [<ffffffff802a9cc4>] filp_close+0x54/0x90
 [<ffffffff802a9d9f>] sys_close+0x9f/0x110
 [<ffffffff8022b9d4>] sysenter_dispatch+0x7/0x30
 [<ffffffff80492ca7>] trace_hardirqs_on_thunk+0x3a/0x3f

--Boundary-00=_8omOJh8gxsVLPqn
Content-Type: application/x-tgz;
  name="dmesg-and-config.tar.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="dmesg-and-config.tar.gz"

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

--Boundary-00=_8omOJh8gxsVLPqn--
