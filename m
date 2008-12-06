Return-Path: <linux-kernel-owner+w=401wt.eu-S1753138AbYLFRBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138AbYLFRBl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 12:01:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbYLFRBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 12:01:32 -0500
Received: from mail.vyatta.com ([76.74.103.46]:52628 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbYLFRB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 12:01:28 -0500
X-Spam-Flag: NO
X-Spam-Score: -0.939
Date: Sat, 6 Dec 2008 09:01:27 -0800 (PST)
From: Stephen Hemminger <stephen.hemminger@vyatta.com>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: kernel-testers@vger.kernel.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "David S. Miller" <davem@davemloft.net>
Message-ID: <2681028.65321228582887579.JavaMail.root@tahiti.vyatta.com>
In-Reply-To: <200812061455.37331.m.kozlowski@tuxland.pl>
Subject: Re: linux-next: Tree for December 4
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [96.225.207.155]
X-Mailer: Zimbra 5.0.8_GA_2463.RHEL4 (ZimbraWebClient - FF3.0 (Linux)/5.0.8_GA_2463.RHEL4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Which ethernet device driver?

----- Original Message -----
From: "Mariusz Kozlowski" <m.kozlowski@tuxland.pl>
To: "Stephen Rothwell" <sfr@canb.auug.org.au>, "Stephen Hemminger" <shemminger@vyatta.com>, "David S. Miller" <davem@davemloft.net>
Cc: kernel-testers@vger.kernel.org, linux-next@vger.kernel.org, "LKML" <linux-kernel@vger.kernel.org>
Sent: Saturday, December 6, 2008 5:55:37 AM GMT -08:00 US/Canada Pacific
Subject: Re: linux-next: Tree for December 4

Hi,

> 	I didn't run linux-next for some time. Today I gave it a shot and
> a few interesting things poped out:
> 
> Linux agpgart interface v0.103
> Serial: 8250/16550 driver4 ports, IRQ sharing enabled
> serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
> =============================================================================
> BUG kmalloc-4096: Invalid object pointer 0xffff88007fb20010
> -----------------------------------------------------------------------------

I'm told the serial one is already fixed.

> I also noticed my network wasn't reachable. That's probably not related to the kernel
> but to check if my link is ok I run mii-tool and the result is NULL pointer dereference:
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000138
> IP: [<ffffffff8042beff>] dev_ifsioc+0x1f/0x320
> PGD 736e3067 PUD 736ca067 PMD 0 
> Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:05:01.0/resource
> CPU 1 
> Modules linked in: nfsd lockd sunrpc exportfs snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss usbhid gspca_zc3xx gspca_main compat_ioctl32 videodev v4l1_compat snd_mixer_oss usb_storage libusual ehci_hcd uhci_hcd usbcore parport_pc snd_hda_codec_realtek thermal parport snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer i2c_i801 snd soundcore snd_page_alloc sr_mod pcspkr sg i2c_core intel_agp processor rtc button cdrom
> Pid: 4768, comm: mii-tool Not tainted 2.6.28-rc7-next-20081204 #1
> RIP: 0010:[<ffffffff8042beff>]  [<ffffffff8042beff>] dev_ifsioc+0x1f/0x320
> RSP: 0018:ffff88006e623da8  EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 0000000000008947 RCX: 00000000019369c2
> RDX: 0000000000000610 RSI: ffff88006e623e0c RDI: 00000000ffffffff
> RBP: ffff88006e623e08 R08: 00000000019369c2 R09: 0000000000000001
> R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
> R13: 0000000000000000 R14: ffffffff80d7da40 R15: 00007fff55e4ee88
> FS:  00007f944de2f6f0(0000) GS:ffff88007f8047d0(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000138 CR3: 000000006e4d9000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process mii-tool (pid: 4768, threadinfo ffff88006e622000, task ffff88006e45ba80)
> Stack:
>  0000000000008947 ffff88006e623e08 0000000000603400 ffffffff8042c4c7
>  ffffe2000003f428 0000000000603400 0000000001213025 ffffffff8028e3fd
>  ffff88007d4f5500 00007f944db51330 ffff880076fbb180 0000000000000096
> Call Trace:
>  [<ffffffff8042c4c7>] ? dev_ioctl+0x2c7/0x590
>  [<ffffffff8028e3fd>] ? __do_fault+0x1dd/0x4a0
>  [<ffffffff8041de92>] ? sock_ioctl+0x72/0x250
>  [<ffffffff802b971f>] ? vfs_ioctl+0x2f/0xa0
>  [<ffffffff802b980d>] ? do_vfs_ioctl+0x7d/0x4c0
>  [<ffffffff80492d1d>] ? lockdep_sys_exit_thunk+0x35/0x67
>  [<ffffffff802b9c99>] ? sys_ioctl+0x49/0x80
>  [<ffffffff8020b95b>] ? system_call_fastpath+0x16/0x1b
> Code: f8 bd f1 ff e9 52 fe ff ff 0f 1f 00 48 83 ec 18 48 89 1c 24 89 d3 48 89 6c 24 08 4c 89 64 24 10 48 89 f5 e8 f4 d4 ff ff 49 89 c4 <48> 8b 88 38 01 00 00 8d 83 ec 76 ff ff 83 f8 5d 77 0f 89 c0 ff 
> RIP  [<ffffffff8042beff>] dev_ifsioc+0x1f/0x320
>  RSP <ffff88006e623da8>
> CR2: 0000000000000138
> ---[ end trace 787e122ecd30f760 ]---

And this got bisected to:

commit d314774cf2cd5dfeb39a00d37deee65d4c627927
Author: Stephen Hemminger <shemminger@vyatta.com>
Date:   Wed Nov 19 21:32:24 2008 -0800

    netdev: network device operations infrastructure
    
    This patch changes the network device internal API to move adminstrative
    operations out of the network device structure and into a separate structure.
    
    This patch involves some hackery to maintain compatablity between the
    new and old model, so all 300+ drivers don't have to be changed at once.
    For drivers that aren't converted yet, the netdevice_ops virt function list
    still resides in the net_device structure. For old protocols, the new
    net_device_ops are copied out to the old net_device pointers.
    
    After the transistion is completed the nag message can be changed to
    an WARN_ON, and the compatiablity code can be made configurable.
    
    Some function pointers aren't moved:
    * destructor can't be in net_device_ops because
      it may need to be referenced after the module is unloaded.
    * neighbor setup is manipulated in a couple of places that need special
      consideration
    * hard_start_xmit is in the fast path for transmit.
    
    Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>


(gdb) l *dev_ifsioc+0x1f
0xffffffff8042309f is in dev_ifsioc (/home/mako/linux/lkt/sources/linux-next/net/core/dev.c:3553).
3548     *      Perform the SIOCxIFxxx calls, inside rtnl_lock()
3549     */
3550    static int dev_ifsioc(struct net *net, struct ifreq *ifr, unsigned int cmd)
3551    {
3552            int err;
3553            struct net_device *dev = __dev_get_by_name(net, ifr->ifr_name);
3554    
3555            if (!dev)
3556                    return -ENODEV;
3557


> 
> 
> Full dmesg and .config is attached.
> 
> 	Mariusz
> 
> 
> Right before this there was also a rather long lockdep info triggered by starting skype:
> 
> ======================================================
> [ INFO: soft-safe -> soft-unsafe lock order detected ]
> 2.6.28-rc7-next-20081204 #1
> ------------------------------------------------------
> skype/4695 [HC0[0]:SC0[1]:HE1:SE0] is trying to acquire:
>  (&fbc->lock){--..}, at: [<ffffffff8035adce>] __percpu_counter_add+0x5e/0xd0
> 
> and this task is already holding:
>  (slock-AF_INET){-+..}, at: [<ffffffff80453496>] tcp_close+0x166/0x4a0
> which would create a new lock dependency:
>  (slock-AF_INET){-+..} -> (&fbc->lock){--..}
> 
> but this new dependency connects a soft-irq-safe lock:
>  (slock-AF_INET){-+..}
> ... which became soft-irq-safe at:
>   [<ffffffffffffffff>] 0xffffffffffffffff
> 
> to a soft-irq-unsafe lock:
>  (&fbc->lock){--..}
> ... which became soft-irq-unsafe at:
> ...  [<ffffffff80265afd>] __lock_acquire+0x82d/0xa50
>   [<ffffffff80265d73>] lock_acquire+0x53/0x70
>   [<ffffffff8035adce>] __percpu_counter_add+0x5e/0xd0
>   [<ffffffff804930c3>] _spin_lock+0x33/0x40
>   [<ffffffff8035adce>] __percpu_counter_add+0x5e/0xd0
>   [<ffffffff802a6e21>] kmem_cache_alloc+0xd1/0xe0
>   [<ffffffff8035adce>] __percpu_counter_add+0x5e/0xd0
>   [<ffffffff802ad058>] get_empty_filp+0x68/0x140
>   [<ffffffff802b7e7b>] path_lookup_open+0x3b/0xd0
>   [<ffffffff802b07d4>] open_exec+0x24/0xd0
>   [<ffffffff802ac4fa>] vfs_read+0x12a/0x160
>   [<ffffffff802b0688>] kernel_read+0x38/0x50
>   [<ffffffff802ea559>] load_elf_binary+0x18b9/0x1d20
>   [<ffffffff8027f74f>] generic_file_aio_read+0x4ff/0x5e0
>   [<ffffffff80264530>] validate_chain+0x460/0x1200
>   [<ffffffff80264530>] validate_chain+0x460/0x1200
>   [<ffffffff80265717>] __lock_acquire+0x447/0xa50
>   [<ffffffff802ec040>] load_elf_binary+0x0/0x1e70
>   [<ffffffff802e8ca0>] load_elf_binary+0x0/0x1d20
>   [<ffffffff802b0360>] search_binary_handler+0xd0/0x2e0
>   [<ffffffff802e7640>] load_script+0x270/0x280
>   [<ffffffff802e8ca0>] load_elf_binary+0x0/0x1d20
>   [<ffffffff802e73d0>] load_script+0x0/0x280
>   [<ffffffff802b0360>] search_binary_handler+0xd0/0x2e0
>   [<ffffffff802b18de>] do_execve+0x22e/0x290
>   [<ffffffff80209b49>] sys_execve+0x49/0x80
>   [<ffffffff8020bdfa>] stub_execve+0x6a/0xc0
>   [<ffffffffffffffff>] 0xffffffffffffffff
> 
> other info that might help us debug this:
> 
> 1 lock held by skype/4695:
>  #0:  (slock-AF_INET){-+..}, at: [<ffffffff80453496>] tcp_close+0x166/0x4a0
> 
> the soft-irq-safe lock's dependencies:
> -> (slock-AF_INET){-+..} ops: 0 {
>    initial-use  at:
>                         [<ffffffff8026548d>] __lock_acquire+0x1bd/0xa50
>                         [<ffffffff80265d73>] lock_acquire+0x53/0x70
>                         [<ffffffff8041ed1e>] lock_sock_nested+0x1e/0x110
>                         [<ffffffff80493108>] _spin_lock_bh+0x38/0x50
>                         [<ffffffff8041ed1e>] lock_sock_nested+0x1e/0x110
>                         [<ffffffff8041ed1e>] lock_sock_nested+0x1e/0x110
>                         [<ffffffff80264530>] validate_chain+0x460/0x1200
>                         [<ffffffff80264530>] validate_chain+0x460/0x1200
>                         [<ffffffff804681bb>] udp_destroy_sock+0xb/0x20
>                         [<ffffffff8041f558>] sk_common_release+0x18/0x80
>                         [<ffffffff8046f7fe>] inet_release+0x3e/0x70
>                         [<ffffffff8041c9f9>] sock_release+0x19/0xb0
>                         [<ffffffff8041cfe2>] sock_close+0x12/0x40
>                         [<ffffffff802ace0b>] __fput+0xbb/0x200
>                         [<ffffffff802a9cc4>] filp_close+0x54/0x90
>                         [<ffffffff802a9d9f>] sys_close+0x9f/0x110
>                         [<ffffffff8020b95b>] system_call_fastpath+0x16/0x1b
>                         [<ffffffffffffffff>] 0xffffffffffffffff
>    in-softirq-W at:
>                         [<ffffffffffffffff>] 0xffffffffffffffff
>    hardirq-on-W at:
>                         [<ffffffff80265ad5>] __lock_acquire+0x805/0xa50
>                         [<ffffffff80265d73>] lock_acquire+0x53/0x70
>                         [<ffffffff8041ed1e>] lock_sock_nested+0x1e/0x110
>                         [<ffffffff80493108>] _spin_lock_bh+0x38/0x50
>                         [<ffffffff8041ed1e>] lock_sock_nested+0x1e/0x110
>                         [<ffffffff8041ed1e>] lock_sock_nested+0x1e/0x110
>                         [<ffffffff80264530>] validate_chain+0x460/0x1200
>                         [<ffffffff80264530>] validate_chain+0x460/0x1200
>                         [<ffffffff804681bb>] udp_destroy_sock+0xb/0x20
>                         [<ffffffff8041f558>] sk_common_release+0x18/0x80
>                         [<ffffffff8046f7fe>] inet_release+0x3e/0x70
>                         [<ffffffff8041c9f9>] sock_release+0x19/0xb0
>                         [<ffffffff8041cfe2>] sock_close+0x12/0x40
>                         [<ffffffff802ace0b>] __fput+0xbb/0x200
>                         [<ffffffff802a9cc4>] filp_close+0x54/0x90
>                         [<ffffffff802a9d9f>] sys_close+0x9f/0x110
>                         [<ffffffff8020b95b>] system_call_fastpath+0x16/0x1b
>                         [<ffffffffffffffff>] 0xffffffffffffffff
>  }
>  ... key      at: [<ffffffff80d7d650>] af_family_slock_keys+0x10/0x120
>  -> (&rt_hash_locks[i]){-+..} ops: 0 {
>     initial-use  at:
>                           [<ffffffffffffffff>] 0xffffffffffffffff
>     in-softirq-W at:
>                           [<ffffffffffffffff>] 0xffffffffffffffff
>     hardirq-on-W at:
>                           [<ffffffffffffffff>] 0xffffffffffffffff
>   }
>   ... key      at: [<ffffffff80d7e714>] __key.40927+0x0/0x8
>   -> (&zone->lock){.+..} ops: 0 {
>      initial-use  at:
>                             [<ffffffff8026548d>] __lock_acquire+0x1bd/0xa50
>                             [<ffffffff80265d73>] lock_acquire+0x53/0x70
>                             [<ffffffff802825e6>] free_pages_bulk+0x36/0x300
>                             [<ffffffff804930c3>] _spin_lock+0x33/0x40
>                             [<ffffffff802825e6>] free_pages_bulk+0x36/0x300
>                             [<ffffffff802825e6>] free_pages_bulk+0x36/0x300
>                             [<ffffffff802831d2>] free_hot_cold_page+0x262/0x2f0
>                             [<ffffffff80624c88>] free_all_bootmem_core+0xd8/0x240
>                             [<ffffffff80496d0d>] _etext+0x0/0x3
>                             [<ffffffff8062085c>] mem_init+0x3c/0x190
>                             [<ffffffff80611cff>] start_kernel+0x28f/0x440
>                             [<ffffffff8061136a>] x86_64_start_kernel+0xca/0xe0
>                             [<ffffffffffffffff>] 0xffffffffffffffff
>      in-softirq-W at:
>                             [<ffffffffffffffff>] 0xffffffffffffffff
>    }
>    ... key      at: [<ffffffff80d6ded0>] __key.29131+0x0/0x8
>   ... acquired at:
>    [<ffffffff802838a5>] get_page_from_freelist+0x525/0x5b0
>    [<ffffffff80264cd5>] validate_chain+0xc05/0x1200
>    [<ffffffff80265717>] __lock_acquire+0x447/0xa50
>    [<ffffffff80265d73>] lock_acquire+0x53/0x70
>    [<ffffffff802838a5>] get_page_from_freelist+0x525/0x5b0
>    [<ffffffff8049337e>] _spin_lock_irqsave+0x3e/0x60
>    [<ffffffff802838a5>] get_page_from_freelist+0x525/0x5b0
>    [<ffffffff802838a5>] get_page_from_freelist+0x525/0x5b0
>    [<ffffffff80283bfa>] __alloc_pages_internal+0xaa/0x450
>    [<ffffffff802a64da>] __slab_alloc+0x17a/0x670
>    [<ffffffff80431e54>] neigh_create+0x74/0x5b0
>    [<ffffffff80431e54>] neigh_create+0x74/0x5b0
>    [<ffffffff802a6e0f>] kmem_cache_alloc+0xbf/0xe0
>    [<ffffffff80431e54>] neigh_create+0x74/0x5b0
>    [<ffffffff80263821>] trace_hardirqs_on_caller+0x71/0x180
>    [<ffffffff80243561>] local_bh_enable_ip+0x81/0xf0
>    [<ffffffff8043135a>] neigh_lookup+0x10a/0x140
>    [<ffffffff80469911>] arp_bind_neighbour+0xa1/0xb0
>    [<ffffffff80441e98>] rt_intern_hash+0x208/0x4f0
>    [<ffffffff8027c2fd>] __rcu_read_unlock+0xcd/0xe0
>    [<ffffffff80442593>] __ip_route_output_key+0x413/0xa60
>    [<ffffffff804650a7>] ip4_datagram_connect+0x177/0x2a0
>    [<ffffffff80243561>] local_bh_enable_ip+0x81/0xf0
>    [<ffffffff8041bd76>] sys_connect+0x86/0xe0
>    [<ffffffff8020c3ad>] retint_swapgs+0xe/0x13
>    [<ffffffff802638ce>] trace_hardirqs_on_caller+0x11e/0x180
>    [<ffffffff80492ca7>] trace_hardirqs_on_thunk+0x3a/0x3f
>    [<ffffffff8020b95b>] system_call_fastpath+0x16/0x1b
>    [<ffffffffffffffff>] 0xffffffffffffffff
> 
>  ... acquired at:
>    [<ffffffffffffffff>] 0xffffffffffffffff
> 
>  -> (rt_peer_lock){-+..} ops: 0 {
>     initial-use  at:
>                           [<ffffffffffffffff>] 0xffffffffffffffff
>     in-softirq-W at:
>                           [<ffffffffffffffff>] 0xffffffffffffffff
>     hardirq-on-W at:
>                           [<ffffffffffffffff>] 0xffffffffffffffff
>   }
>   ... key      at: [<ffffffff805ea3b8>] rt_peer_lock.41771+0x18/0x40
>  ... acquired at:
>    [<ffffffffffffffff>] 0xffffffffffffffff
> 
>  -> (inet_peer_idlock){-+..} ops: 0 {
>     initial-use  at:
>                           [<ffffffffffffffff>] 0xffffffffffffffff
>     in-softirq-W at:
>                           [<ffffffffffffffff>] 0xffffffffffffffff
>     hardirq-on-W at:
>                           [<ffffffffffffffff>] 0xffffffffffffffff
>   }
>   ... key      at: [<ffffffff805ea958>] inet_peer_idlock+0x18/0x40
>  ... acquired at:
>    [<ffffffffffffffff>] 0xffffffffffffffff
> 
>  -> (&n->lock){-+-+} ops: 0 {
>     initial-use  at:
>                           [<ffffffff8026548d>] __lock_acquire+0x1bd/0xa50
>                           [<ffffffff80265d73>] lock_acquire+0x53/0x70
>                           [<ffffffff80430c0a>] __neigh_event_send+0x2a/0x200
>                           [<ffffffff80493198>] _write_lock_bh+0x38/0x50
>                           [<ffffffff80430c0a>] __neigh_event_send+0x2a/0x200
>                           [<ffffffff80430c0a>] __neigh_event_send+0x2a/0x200
>                           [<ffffffff804335b7>] neigh_resolve_output+0x147/0x2d0
>                           [<ffffffff8044a51d>] ip_generic_getfrag+0x4d/0x90
>                           [<ffffffff8044896c>] ip_push_pending_frames+0x27c/0x400
>                           [<ffffffff80467153>] udp_push_pending_frames+0x233/0x3c0
>                           [<ffffffff80468531>] udp_sendmsg+0x361/0x730
>                           [<ffffffff80243561>] local_bh_enable_ip+0x81/0xf0
>                           [<ffffffff80243561>] local_bh_enable_ip+0x81/0xf0
>                           [<ffffffff8043135a>] neigh_lookup+0x10a/0x140
>                           [<ffffffff8041c3fb>] sock_sendmsg+0xcb/0x100
>                           [<ffffffff802638ce>] trace_hardirqs_on_caller+0x11e/0x180
>                           [<ffffffff80265717>] __lock_acquire+0x447/0xa50
>                           [<ffffffff80254370>] autoremove_wake_function+0x0/0x30
>                           [<ffffffff8028e3fd>] __do_fault+0x1dd/0x4a0
>                           [<ffffffff80264530>] validate_chain+0x460/0x1200
>                           [<ffffffff8041bac1>] sockfd_lookup_light+0x41/0x80
>                           [<ffffffff8041c8a9>] sys_sendto+0x119/0x180
>                           [<ffffffff80265717>] __lock_acquire+0x447/0xa50
>                           [<ffffffff80468e40>] udp_poll+0x0/0x120
>                           [<ffffffff8020b95b>] system_call_fastpath+0x16/0x1b
>                           [<ffffffffffffffff>] 0xffffffffffffffff
>     in-softirq-W at:
>                           [<ffffffffffffffff>] 0xffffffffffffffff
>     hardirq-on-W at:
>                           [<ffffffff80265ad5>] __lock_acquire+0x805/0xa50
>                           [<ffffffff80265d73>] lock_acquire+0x53/0x70
>                           [<ffffffff80430c0a>] __neigh_event_send+0x2a/0x200
>                           [<ffffffff80493198>] _write_lock_bh+0x38/0x50
>                           [<ffffffff80430c0a>] __neigh_event_send+0x2a/0x200
>                           [<ffffffff80430c0a>] __neigh_event_send+0x2a/0x200
>                           [<ffffffff804335b7>] neigh_resolve_output+0x147/0x2d0
>                           [<ffffffff8044a51d>] ip_generic_getfrag+0x4d/0x90
>                           [<ffffffff8044896c>] ip_push_pending_frames+0x27c/0x400
>                           [<ffffffff80467153>] udp_push_pending_frames+0x233/0x3c0
>                           [<ffffffff80468531>] udp_sendmsg+0x361/0x730
>                           [<ffffffff80243561>] local_bh_enable_ip+0x81/0xf0
>                           [<ffffffff80243561>] local_bh_enable_ip+0x81/0xf0
>                           [<ffffffff8043135a>] neigh_lookup+0x10a/0x140
>                           [<ffffffff8041c3fb>] sock_sendmsg+0xcb/0x100
>                           [<ffffffff802638ce>] trace_hardirqs_on_caller+0x11e/0x180
>                           [<ffffffff80265717>] __lock_acquire+0x447/0xa50
>                           [<ffffffff80254370>] autoremove_wake_function+0x0/0x30
>                           [<ffffffff8028e3fd>] __do_fault+0x1dd/0x4a0
>                           [<ffffffff80264530>] validate_chain+0x460/0x1200
>                           [<ffffffff8041bac1>] sockfd_lookup_light+0x41/0x80
>                           [<ffffffff8041c8a9>] sys_sendto+0x119/0x180
>                           [<ffffffff80265717>] __lock_acquire+0x447/0xa50
>                           [<ffffffff80468e40>] udp_poll+0x0/0x120
>                           [<ffffffff8020b95b>] system_call_fastpath+0x16/0x1b
>                           [<ffffffffffffffff>] 0xffffffffffffffff
>     in-softirq-R at:
>                           [<ffffffffffffffff>] 0xffffffffffffffff
>     hardirq-on-R at:
>                           [<ffffffffffffffff>] 0xffffffffffffffff
>   }
>   ... key      at: [<ffffffff80d7e3a4>] __key.31965+0x0/0xc
>   -> (&base->lock){++..} ops: 0 {
>      initial-use  at:
>                             [<ffffffff8026548d>] __lock_acquire+0x1bd/0xa50
>                             [<ffffffff80265d73>] lock_acquire+0x53/0x70
>                             [<ffffffff80248c44>] lock_timer_base+0x34/0x70
>                             [<ffffffff8049337e>] _spin_lock_irqsave+0x3e/0x60
>                             [<ffffffff80248c44>] lock_timer_base+0x34/0x70
>                             [<ffffffff80248c44>] lock_timer_base+0x34/0x70
>                             [<ffffffff80493735>] _spin_unlock_irqrestore+0x65/0x80
>                             [<ffffffff80248d3a>] __mod_timer+0x2a/0xe0
>                             [<ffffffff80493710>] _spin_unlock_irqrestore+0x40/0x80
>                             [<ffffffff8062da24>] con_init+0x274/0x2a0
>                             [<ffffffff8062d00a>] console_init+0x1a/0x30
>                             [<ffffffff80611cd5>] start_kernel+0x265/0x440
>                             [<ffffffff8061136a>] x86_64_start_kernel+0xca/0xe0
>                             [<ffffffffffffffff>] 0xffffffffffffffff
>      in-hardirq-W at:
>                             [<ffffffffffffffff>] 0xffffffffffffffff
>      in-softirq-W at:
>                             [<ffffffffffffffff>] 0xffffffffffffffff
>    }
>    ... key      at: [<ffffffff8077f918>] __key.21559+0x0/0x8
>   ... acquired at:
>    [<ffffffff80248c44>] lock_timer_base+0x34/0x70
>    [<ffffffff80264cd5>] validate_chain+0xc05/0x1200
>    [<ffffffff80265717>] __lock_acquire+0x447/0xa50
>    [<ffffffff80265d73>] lock_acquire+0x53/0x70
>    [<ffffffff80248c44>] lock_timer_base+0x34/0x70
>    [<ffffffff8049337e>] _spin_lock_irqsave+0x3e/0x60
>    [<ffffffff80248c44>] lock_timer_base+0x34/0x70
>    [<ffffffff80248c44>] lock_timer_base+0x34/0x70
>    [<ffffffff80248d3a>] __mod_timer+0x2a/0xe0
>    [<ffffffff80430bb7>] neigh_add_timer+0x17/0x40
>    [<ffffffff80430cb3>] __neigh_event_send+0xd3/0x200
>    [<ffffffff804335b7>] neigh_resolve_output+0x147/0x2d0
>    [<ffffffff8044a51d>] ip_generic_getfrag+0x4d/0x90
>    [<ffffffff8044896c>] ip_push_pending_frames+0x27c/0x400
>    [<ffffffff80467153>] udp_push_pending_frames+0x233/0x3c0
>    [<ffffffff80468531>] udp_sendmsg+0x361/0x730
>    [<ffffffff80243561>] local_bh_enable_ip+0x81/0xf0
>    [<ffffffff80243561>] local_bh_enable_ip+0x81/0xf0
>    [<ffffffff8043135a>] neigh_lookup+0x10a/0x140
>    [<ffffffff8041c3fb>] sock_sendmsg+0xcb/0x100
>    [<ffffffff802638ce>] trace_hardirqs_on_caller+0x11e/0x180
>    [<ffffffff80265717>] __lock_acquire+0x447/0xa50
>    [<ffffffff80254370>] autoremove_wake_function+0x0/0x30
>    [<ffffffff8028e3fd>] __do_fault+0x1dd/0x4a0
>    [<ffffffff80264530>] validate_chain+0x460/0x1200
>    [<ffffffff8041bac1>] sockfd_lookup_light+0x41/0x80
>    [<ffffffff8041c8a9>] sys_sendto+0x119/0x180
>    [<ffffffff80265717>] __lock_acquire+0x447/0xa50
>    [<ffffffff80468e40>] udp_poll+0x0/0x120
>    [<ffffffff8020b95b>] system_call_fastpath+0x16/0x1b
>    [<ffffffffffffffff>] 0xffffffffffffffff
> 
>   -> (&list->lock#3){.+..} ops: 0 {
>      initial-use  at:
>                             [<ffffffffffffffff>] 0xffffffffffffffff
>      in-softirq-W at:
>                             [<ffffffffffffffff>] 0xffffffffffffffff
>    }
>    ... key      at: [<ffffffff80d7e394>] __key.17594+0x0/0x8
>   ... acquired at:
>    [<ffffffffffffffff>] 0xffffffffffffffff
> 
>  ... acquired at:
>    [<ffffffffffffffff>] 0xffffffffffffffff
> 
>  -> (&list->lock){-+..} ops: 0 {
>     initial-use  at:
>                           [<ffffffff8026548d>] __lock_acquire+0x1bd/0xa50
>                           [<ffffffff80265d73>] lock_acquire+0x53/0x70
>                           [<ffffffff80422d84>] skb_queue_tail+0x24/0x60
>                           [<ffffffff8049337e>] _spin_lock_irqsave+0x3e/0x60
>                           [<ffffffff80422d84>] skb_queue_tail+0x24/0x60
>                           [<ffffffff80422d84>] skb_queue_tail+0x24/0x60
>                           [<ffffffff8043d0ed>] netlink_broadcast+0x2cd/0x3c0
>                           [<ffffffff803449b6>] kobject_uevent_env+0x336/0x3f0
>                           [<ffffffff80344adf>] kobject_action_type+0x5f/0xb0
>                           [<ffffffff803c9139>] bus_uevent_store+0x39/0x50
>                           [<ffffffff80300aec>] sysfs_write_file+0xcc/0x150
>                           [<ffffffff802ac328>] vfs_write+0xc8/0x170
>                           [<ffffffff802ac903>] sys_write+0x53/0x90
>                           [<ffffffff8020b95b>] system_call_fastpath+0x16/0x1b
>                           [<ffffffffffffffff>] 0xffffffffffffffff
>     in-softirq-W at:
>                           [<ffffffffffffffff>] 0xffffffffffffffff
>     hardirq-on-W at:
>                           [<ffffffff80265ad5>] __lock_acquire+0x805/0xa50
>                           [<ffffffff80265d73>] lock_acquire+0x53/0x70
>                           [<ffffffff80468e94>] udp_poll+0x54/0x120
>                           [<ffffffff80493108>] _spin_lock_bh+0x38/0x50
>                           [<ffffffff80468e94>] udp_poll+0x54/0x120
>                           [<ffffffff80468e94>] udp_poll+0x54/0x120
>                           [<ffffffff802bab22>] do_sys_poll+0x1e2/0x3d0
>                           [<ffffffff802bb9f0>] __pollwait+0x0/0x130
>                           [<ffffffff80234f50>] default_wake_function+0x0/0x10
>                           [<ffffffff80234f50>] default_wake_function+0x0/0x10
>                           [<ffffffff80265717>] __lock_acquire+0x447/0xa50
>                           [<ffffffff802636b2>] mark_held_locks+0x42/0x90
>                           [<ffffffff80264530>] validate_chain+0x460/0x1200
>                           [<ffffffff8027c2fd>] __rcu_read_unlock+0xcd/0xe0
>                           [<ffffffff802638ce>] trace_hardirqs_on_caller+0x11e/0x180
>                           [<ffffffff80265717>] __lock_acquire+0x447/0xa50
>                           [<ffffffff8028e3fd>] __do_fault+0x1dd/0x4a0
>                           [<ffffffff80265717>] __lock_acquire+0x447/0xa50
>                           [<ffffffff8020c3ad>] retint_swapgs+0xe/0x13
>                           [<ffffffff802bad83>] sys_poll+0x73/0xf0
>                           [<ffffffff8020b95b>] system_call_fastpath+0x16/0x1b
>                           [<ffffffffffffffff>] 0xffffffffffffffff
>   }
>   ... key      at: [<ffffffff80d7d4d4>] __key.24456+0x0/0x8
>  ... acquired at:
>    [<ffffffffffffffff>] 0xffffffffffffffff
> 
>  -> (&q->lock){++..} ops: 0 {
>     initial-use  at:
>                           [<ffffffff8026548d>] __lock_acquire+0x1bd/0xa50
>                           [<ffffffff80265d73>] lock_acquire+0x53/0x70
>                           [<ffffffff8048ffc7>] wait_for_common+0x37/0x190
>                           [<ffffffff804932d9>] _spin_lock_irq+0x39/0x50
>                           [<ffffffff8048ffc7>] wait_for_common+0x37/0x190
>                           [<ffffffff802638ce>] trace_hardirqs_on_caller+0x11e/0x180
>                           [<ffffffff8048ffc7>] wait_for_common+0x37/0x190
>                           [<ffffffff80493710>] _spin_unlock_irqrestore+0x40/0x80
>                           [<ffffffff80234e67>] try_to_wake_up+0x107/0x1f0
>                           [<ffffffff802541ea>] kthread_create+0x9a/0x110
>                           [<ffffffff802389b0>] migration_thread+0x0/0x290
>                           [<ffffffff80264530>] validate_chain+0x460/0x1200
>                           [<ffffffff80265717>] __lock_acquire+0x447/0xa50
>                           [<ffffffff8021273f>] init_pit_timer+0x1f/0xc0
>                           [<ffffffff802636b2>] mark_held_locks+0x42/0x90
>                           [<ffffffff80493735>] _spin_unlock_irqrestore+0x65/0x80
>                           [<ffffffff80621a90>] migration_init+0x0/0x60
>                           [<ffffffff8048e204>] migration_call+0x244/0x580
>                           [<ffffffff80493710>] _spin_unlock_irqrestore+0x40/0x80
>                           [<ffffffff80621a90>] migration_init+0x0/0x60
>                           [<ffffffff80621ab1>] migration_init+0x21/0x60
>                           [<ffffffff80621a90>] migration_init+0x0/0x60
>                           [<ffffffff8020903b>] _stext+0x3b/0x170
>                           [<ffffffff80493609>] _spin_unlock+0x29/0x50
>                           [<ffffffff80223930>] get_apic_id+0x0/0x10
>                           [<ffffffff8061aaab>] native_smp_prepare_cpus+0x1ab/0x460
>                           [<ffffffff806118c0>] kernel_init+0x70/0x1f0
>                           [<ffffffff8020c9fa>] child_rip+0xa/0x20
>                           [<ffffffff8020c3c0>] restore_args+0x0/0x30
>                           [<ffffffff80611850>] kernel_init+0x0/0x1f0
>                           [<ffffffff8020c9f0>] child_rip+0x0/0x20
>                           [<ffffffffffffffff>] 0xffffffffffffffff
>     in-hardirq-W at:
>                           [<ffffffffffffffff>] 0xffffffffffffffff
>     in-softirq-W at:
>                           [<ffffffffffffffff>] 0xffffffffffffffff
>   }
>   ... key      at: [<ffffffff80780058>] __key.16756+0x0/0x8
>   -> (&rq->lock){++..} ops: 0 {
>      initial-use  at:
>                             [<ffffffff8026548d>] __lock_acquire+0x1bd/0xa50
>                             [<ffffffff80265d73>] lock_acquire+0x53/0x70
>                             [<ffffffff80234b93>] rq_attach_root+0x23/0xe0
>                             [<ffffffff8049337e>] _spin_lock_irqsave+0x3e/0x60
>                             [<ffffffff80234b93>] rq_attach_root+0x23/0xe0
>                             [<ffffffff80234b93>] rq_attach_root+0x23/0xe0
>                             [<ffffffff80622035>] sched_init+0x375/0x510
>                             [<ffffffff80611c04>] start_kernel+0x194/0x440
>                             [<ffffffff8061136a>] x86_64_start_kernel+0xca/0xe0
>                             [<ffffffffffffffff>] 0xffffffffffffffff
>      in-hardirq-W at:
>                             [<ffffffffffffffff>] 0xffffffffffffffff
>      in-softirq-W at:
>                             [<ffffffffffffffff>] 0xffffffffffffffff
>    }
>    ... key      at: [<ffffffff8067b0d8>] __key.42751+0x0/0x8
>    -> (&vec->lock){.+..} ops: 0 {
>       initial-use  at:
>                               [<ffffffff8026548d>] __lock_acquire+0x1bd/0xa50
>                               [<ffffffff80265d73>] lock_acquire+0x53/0x70
>                               [<ffffffff8027ceac>] cpupri_set+0x8c/0xe0
>                               [<ffffffff8049337e>] _spin_lock_irqsave+0x3e/0x60
>                               [<ffffffff8027ceac>] cpupri_set+0x8c/0xe0
>                               [<ffffffff8027ceac>] cpupri_set+0x8c/0xe0
>                               [<ffffffff802302b1>] set_rq_online+0x51/0x70
>                               [<ffffffff80234b93>] rq_attach_root+0x23/0xe0
>                               [<ffffffff80234bfd>] rq_attach_root+0x8d/0xe0
>                               [<ffffffff80622035>] sched_init+0x375/0x510
>                               [<ffffffff80611c04>] start_kernel+0x194/0x440
>                               [<ffffffff8061136a>] x86_64_start_kernel+0xca/0xe0
>                               [<ffffffffffffffff>] 0xffffffffffffffff
>       in-softirq-W at:
>                               [<ffffffffffffffff>] 0xffffffffffffffff
>     }
>     ... key      at: [<ffffffff80d6de50>] __key.13804+0x0/0x8
>    ... acquired at:
>    [<ffffffff8027ceac>] cpupri_set+0x8c/0xe0
>    [<ffffffff80264cd5>] validate_chain+0xc05/0x1200
>    [<ffffffff80260f57>] save_trace+0x37/0xa0
>    [<ffffffff80265717>] __lock_acquire+0x447/0xa50
>    [<ffffffff80265d73>] lock_acquire+0x53/0x70
>    [<ffffffff8027ceac>] cpupri_set+0x8c/0xe0
>    [<ffffffff8049337e>] _spin_lock_irqsave+0x3e/0x60
>    [<ffffffff8027ceac>] cpupri_set+0x8c/0xe0
>    [<ffffffff8027ceac>] cpupri_set+0x8c/0xe0
>    [<ffffffff802302b1>] set_rq_online+0x51/0x70
>    [<ffffffff80234b93>] rq_attach_root+0x23/0xe0
>    [<ffffffff80234bfd>] rq_attach_root+0x8d/0xe0
>    [<ffffffff80622035>] sched_init+0x375/0x510
>    [<ffffffff80611c04>] start_kernel+0x194/0x440
>    [<ffffffff8061136a>] x86_64_start_kernel+0xca/0xe0
>    [<ffffffffffffffff>] 0xffffffffffffffff
> 
>    -> (&rt_b->rt_runtime_lock){.+..} ops: 0 {
>       initial-use  at:
>                               [<ffffffff8026548d>] __lock_acquire+0x1bd/0xa50
>                               [<ffffffff80265d73>] lock_acquire+0x53/0x70
>                               [<ffffffff80233a0c>] __enqueue_rt_entity+0xdc/0x180
>                               [<ffffffff804930c3>] _spin_lock+0x33/0x40
>                               [<ffffffff80233a0c>] __enqueue_rt_entity+0xdc/0x180
>                               [<ffffffff80233a0c>] __enqueue_rt_entity+0xdc/0x180
>                               [<ffffffff80233aeb>] enqueue_task_rt+0x3b/0x80
>                               [<ffffffff8022f1ab>] enqueue_task+0xb/0x20
>                               [<ffffffff8022f23a>] activate_task+0x1a/0x30
>                               [<ffffffff80234f3d>] try_to_wake_up+0x1dd/0x1f0
>                               [<ffffffff802638ce>] trace_hardirqs_on_caller+0x11e/0x180
>                               [<ffffffff8048e024>] migration_call+0x64/0x580
>                               [<ffffffff80621ace>] migration_init+0x3e/0x60
>                               [<ffffffff80621a90>] migration_init+0x0/0x60
>                               [<ffffffff8020903b>] _stext+0x3b/0x170
>                               [<ffffffff80493609>] _spin_unlock+0x29/0x50
>                               [<ffffffff80223930>] get_apic_id+0x0/0x10
>                               [<ffffffff8061aaab>] native_smp_prepare_cpus+0x1ab/0x460
>                               [<ffffffff806118c0>] kernel_init+0x70/0x1f0
>                               [<ffffffff8020c9fa>] child_rip+0xa/0x20
>                               [<ffffffff8020c3c0>] restore_args+0x0/0x30
>                               [<ffffffff80611850>] kernel_init+0x0/0x1f0
>                               [<ffffffff8020c9f0>] child_rip+0x0/0x20
>                               [<ffffffffffffffff>] 0xffffffffffffffff
>       in-softirq-W at:
>                               [<ffffffffffffffff>] 0xffffffffffffffff
>     }
>     ... key      at: [<ffffffff8067b0e0>] __key.34599+0x0/0x8
>     -> (&cpu_base->lock){++..} ops: 0 {
>        initial-use  at:
>                                 [<ffffffffffffffff>] 0xffffffffffffffff
>        in-hardirq-W at:
>                                 [<ffffffffffffffff>] 0xffffffffffffffff
>        in-softirq-W at:
>                                 [<ffffffffffffffff>] 0xffffffffffffffff
>      }
>      ... key      at: [<ffffffff80780094>] __key.18863+0x0/0x8
>     ... acquired at:
>    [<ffffffff80257589>] lock_hrtimer_base+0x29/0x60
>    [<ffffffff80264cd5>] validate_chain+0xc05/0x1200
>    [<ffffffff80265717>] __lock_acquire+0x447/0xa50
>    [<ffffffff80265d73>] lock_acquire+0x53/0x70
>    [<ffffffff80257589>] lock_hrtimer_base+0x29/0x60
>    [<ffffffff8049337e>] _spin_lock_irqsave+0x3e/0x60
>    [<ffffffff80257589>] lock_hrtimer_base+0x29/0x60
>    [<ffffffff80257589>] lock_hrtimer_base+0x29/0x60
>    [<ffffffff80257722>] hrtimer_start_range_ns+0x42/0x200
>    [<ffffffff80257af5>] ktime_get_ts+0x25/0x60
>    [<ffffffff80233a55>] __enqueue_rt_entity+0x125/0x180
>    [<ffffffff80233aeb>] enqueue_task_rt+0x3b/0x80
>    [<ffffffff8022f1ab>] enqueue_task+0xb/0x20
>    [<ffffffff8022f23a>] activate_task+0x1a/0x30
>    [<ffffffff80234f3d>] try_to_wake_up+0x1dd/0x1f0
>    [<ffffffff802638ce>] trace_hardirqs_on_caller+0x11e/0x180
>    [<ffffffff8048e024>] migration_call+0x64/0x580
>    [<ffffffff80621ace>] migration_init+0x3e/0x60
>    [<ffffffff80621a90>] migration_init+0x0/0x60
>    [<ffffffff8020903b>] _stext+0x3b/0x170
>    [<ffffffff80493609>] _spin_unlock+0x29/0x50
>    [<ffffffff80223930>] get_apic_id+0x0/0x10
>    [<ffffffff8061aaab>] native_smp_prepare_cpus+0x1ab/0x460
>    [<ffffffff806118c0>] kernel_init+0x70/0x1f0
>    [<ffffffff8020c9fa>] child_rip+0xa/0x20
>    [<ffffffff8020c3c0>] restore_args+0x0/0x30
>    [<ffffffff80611850>] kernel_init+0x0/0x1f0
>    [<ffffffff8020c9f0>] child_rip+0x0/0x20
>    [<ffffffffffffffff>] 0xffffffffffffffff
> 
>     -> (&rt_rq->rt_runtime_lock){+...} ops: 0 {
>        initial-use  at:
>                                 [<ffffffff8026548d>] __lock_acquire+0x1bd/0xa50
>                                 [<ffffffff80265d73>] lock_acquire+0x53/0x70
>                                 [<ffffffff80237e50>] update_curr_rt+0x110/0x190
>                                 [<ffffffff804930c3>] _spin_lock+0x33/0x40
>                                 [<ffffffff80237e50>] update_curr_rt+0x110/0x190
>                                 [<ffffffff80237e50>] update_curr_rt+0x110/0x190
>                                 [<ffffffff80237fe9>] dequeue_task_rt+0x19/0x50
>                                 [<ffffffff8022f20f>] dequeue_task+0x4f/0x60
>                                 [<ffffffff8022f26a>] deactivate_task+0x1a/0x20
>                                 [<ffffffff80490507>] thread_return+0xe3/0x59c
>                                 [<ffffffff802389b0>] migration_thread+0x0/0x290
>                                 [<ffffffff80493774>] _spin_unlock_irq+0x24/0x50
>                                 [<ffffffff802389b0>] migration_thread+0x0/0x290
>                                 [<ffffffff802389b0>] migration_thread+0x0/0x290
>                                 [<ffffffff80238b2f>] migration_thread+0x17f/0x290
>                                 [<ffffffff802389b0>] migration_thread+0x0/0x290
>                                 [<ffffffff80253f6b>] kthread+0x4b/0x80
>                                 [<ffffffff8020c9fa>] child_rip+0xa/0x20
>                                 [<ffffffff8020c3c0>] restore_args+0x0/0x30
>                                 [<ffffffff80253f20>] kthread+0x0/0x80
>                                 [<ffffffff8020c9f0>] child_rip+0x0/0x20
>                                 [<ffffffffffffffff>] 0xffffffffffffffff
>        in-hardirq-W at:
>                                 [<ffffffffffffffff>] 0xffffffffffffffff
>      }
>      ... key      at: [<ffffffff8067b0e8>] __key.42703+0x0/0x8
>     ... acquired at:
>    [<ffffffff802321c2>] __enable_runtime+0x42/0xa0
>    [<ffffffff80264cd5>] validate_chain+0xc05/0x1200
>    [<ffffffff80265717>] __lock_acquire+0x447/0xa50
>    [<ffffffff80265d73>] lock_acquire+0x53/0x70
>    [<ffffffff802321c2>] __enable_runtime+0x42/0xa0
>    [<ffffffff804930c3>] _spin_lock+0x33/0x40
>    [<ffffffff802321c2>] __enable_runtime+0x42/0xa0
>    [<ffffffff802321c2>] __enable_runtime+0x42/0xa0
>    [<ffffffff802336e4>] rq_online_rt+0x24/0x70
>    [<ffffffff802302b1>] set_rq_online+0x51/0x70
>    [<ffffffff8048e03d>] migration_call+0x7d/0x580
>    [<ffffffff8048e065>] migration_call+0xa5/0x580
>    [<ffffffff80258c71>] notifier_call_chain+0x51/0x70
>    [<ffffffff8048e836>] _cpu_up+0xe6/0x140
>    [<ffffffff8048e8e9>] cpu_up+0x59/0x80
>    [<ffffffff80611944>] kernel_init+0xf4/0x1f0
>    [<ffffffff8020c9fa>] child_rip+0xa/0x20
>    [<ffffffff8020c3c0>] restore_args+0x0/0x30
>    [<ffffffff80611850>] kernel_init+0x0/0x1f0
>    [<ffffffff8020c9f0>] child_rip+0x0/0x20
>    [<ffffffffffffffff>] 0xffffffffffffffff
> 
>    ... acquired at:
>    [<ffffffff80233a0c>] __enqueue_rt_entity+0xdc/0x180
>    [<ffffffff80264cd5>] validate_chain+0xc05/0x1200
>    [<ffffffff80260f57>] save_trace+0x37/0xa0
>    [<ffffffff80265717>] __lock_acquire+0x447/0xa50
>    [<ffffffff80265d73>] lock_acquire+0x53/0x70
>    [<ffffffff80233a0c>] __enqueue_rt_entity+0xdc/0x180
>    [<ffffffff804930c3>] _spin_lock+0x33/0x40
>    [<ffffffff80233a0c>] __enqueue_rt_entity+0xdc/0x180
>    [<ffffffff80233a0c>] __enqueue_rt_entity+0xdc/0x180
>    [<ffffffff80233aeb>] enqueue_task_rt+0x3b/0x80
>    [<ffffffff8022f1ab>] enqueue_task+0xb/0x20
>    [<ffffffff8022f23a>] activate_task+0x1a/0x30
>    [<ffffffff80234f3d>] try_to_wake_up+0x1dd/0x1f0
>    [<ffffffff802638ce>] trace_hardirqs_on_caller+0x11e/0x180
>    [<ffffffff8048e024>] migration_call+0x64/0x580
>    [<ffffffff80621ace>] migration_init+0x3e/0x60
>    [<ffffffff80621a90>] migration_init+0x0/0x60
>    [<ffffffff8020903b>] _stext+0x3b/0x170
>    [<ffffffff80493609>] _spin_unlock+0x29/0x50
>    [<ffffffff80223930>] get_apic_id+0x0/0x10
>    [<ffffffff8061aaab>] native_smp_prepare_cpus+0x1ab/0x460
>    [<ffffffff806118c0>] kernel_init+0x70/0x1f0
>    [<ffffffff8020c9fa>] child_rip+0xa/0x20
>    [<ffffffff8020c3c0>] restore_args+0x0/0x30
>    [<ffffffff80611850>] kernel_init+0x0/0x1f0
>    [<ffffffff8020c9f0>] child_rip+0x0/0x20
>    [<ffffffffffffffff>] 0xffffffffffffffff
> 
>    ... acquired at:
>    [<ffffffff80237e50>] update_curr_rt+0x110/0x190
>    [<ffffffff80264cd5>] validate_chain+0xc05/0x1200
>    [<ffffffff80260f57>] save_trace+0x37/0xa0
>    [<ffffffff80265717>] __lock_acquire+0x447/0xa50
>    [<ffffffff80265d73>] lock_acquire+0x53/0x70
>    [<ffffffff80237e50>] update_curr_rt+0x110/0x190
>    [<ffffffff804930c3>] _spin_lock+0x33/0x40
>    [<ffffffff80237e50>] update_curr_rt+0x110/0x190
>    [<ffffffff80237e50>] update_curr_rt+0x110/0x190
>    [<ffffffff80237fe9>] dequeue_task_rt+0x19/0x50
>    [<ffffffff8022f20f>] dequeue_task+0x4f/0x60
>    [<ffffffff8022f26a>] deactivate_task+0x1a/0x20
>    [<ffffffff80490507>] thread_return+0xe3/0x59c
>    [<ffffffff802389b0>] migration_thread+0x0/0x290
>    [<ffffffff80493774>] _spin_unlock_irq+0x24/0x50
>    [<ffffffff802389b0>] migration_thread+0x0/0x290
>    [<ffffffff802389b0>] migration_thread+0x0/0x290
>    [<ffffffff80238b2f>] migration_thread+0x17f/0x290
>    [<ffffffff802389b0>] migration_thread+0x0/0x290
>    [<ffffffff80253f6b>] kthread+0x4b/0x80
>    [<ffffffff8020c9fa>] child_rip+0xa/0x20
>    [<ffffffff8020c3c0>] restore_args+0x0/0x30
>    [<ffffffff80253f20>] kthread+0x0/0x80
>    [<ffffffff8020c9f0>] child_rip+0x0/0x20
>    [<ffffffffffffffff>] 0xffffffffffffffff
> 
>    -> (&rq->lock/1){.+..} ops: 0 {
>       initial-use  at:
>                               [<ffffffffffffffff>] 0xffffffffffffffff
>       in-softirq-W at:
>                               [<ffffffffffffffff>] 0xffffffffffffffff
>     }
>     ... key      at: [<ffffffff8067b0d9>] __key.42751+0x1/0x8
>    ... acquired at:
>    [<ffffffffffffffff>] 0xffffffffffffffff
> 
>   ... acquired at:
>    [<ffffffff802308a3>] task_rq_lock+0x53/0xa0
>    [<ffffffff80264cd5>] validate_chain+0xc05/0x1200
>    [<ffffffff80264530>] validate_chain+0x460/0x1200
>    [<ffffffff80265717>] __lock_acquire+0x447/0xa50
>    [<ffffffff80265d73>] lock_acquire+0x53/0x70
>    [<ffffffff802308a3>] task_rq_lock+0x53/0xa0
>    [<ffffffff804930c3>] _spin_lock+0x33/0x40
>    [<ffffffff802308a3>] task_rq_lock+0x53/0xa0
>    [<ffffffff802308a3>] task_rq_lock+0x53/0xa0
>    [<ffffffff80234df3>] try_to_wake_up+0x93/0x1f0
>    [<ffffffff8022f58b>] __wake_up_common+0x5b/0x90
>    [<ffffffff8023066d>] complete+0x3d/0x60
>    [<ffffffff802540b9>] kthreadd+0x119/0x1b0
>    [<ffffffff8020c3c0>] restore_args+0x0/0x30
>    [<ffffffff8020c9fa>] child_rip+0xa/0x20
>    [<ffffffff8020c3c0>] restore_args+0x0/0x30
>    [<ffffffff80253fa0>] kthreadd+0x0/0x1b0
>    [<ffffffff8020c9f0>] child_rip+0x0/0x20
>    [<ffffffffffffffff>] 0xffffffffffffffff
> 
>  ... acquired at:
>    [<ffffffffffffffff>] 0xffffffffffffffff
> 
> 
> the soft-irq-unsafe lock's dependencies:
> -> (&fbc->lock){--..} ops: 0 {
>    initial-use  at:
>                         [<ffffffff8026548d>] __lock_acquire+0x1bd/0xa50
>                         [<ffffffff80265d73>] lock_acquire+0x53/0x70
>                         [<ffffffff8035adce>] __percpu_counter_add+0x5e/0xd0
>                         [<ffffffff804930c3>] _spin_lock+0x33/0x40
>                         [<ffffffff8035adce>] __percpu_counter_add+0x5e/0xd0
>                         [<ffffffff802a6e21>] kmem_cache_alloc+0xd1/0xe0
>                         [<ffffffff8035adce>] __percpu_counter_add+0x5e/0xd0
>                         [<ffffffff802ad058>] get_empty_filp+0x68/0x140
>                         [<ffffffff802b7e7b>] path_lookup_open+0x3b/0xd0
>                         [<ffffffff802b07d4>] open_exec+0x24/0xd0
>                         [<ffffffff802ac4fa>] vfs_read+0x12a/0x160
>                         [<ffffffff802b0688>] kernel_read+0x38/0x50
>                         [<ffffffff802ea559>] load_elf_binary+0x18b9/0x1d20
>                         [<ffffffff8027f74f>] generic_file_aio_read+0x4ff/0x5e0
>                         [<ffffffff80264530>] validate_chain+0x460/0x1200
>                         [<ffffffff80264530>] validate_chain+0x460/0x1200
>                         [<ffffffff80265717>] __lock_acquire+0x447/0xa50
>                         [<ffffffff802ec040>] load_elf_binary+0x0/0x1e70
>                         [<ffffffff802e8ca0>] load_elf_binary+0x0/0x1d20
>                         [<ffffffff802b0360>] search_binary_handler+0xd0/0x2e0
>                         [<ffffffff802e7640>] load_script+0x270/0x280
>                         [<ffffffff802e8ca0>] load_elf_binary+0x0/0x1d20
>                         [<ffffffff802e73d0>] load_script+0x0/0x280
>                         [<ffffffff802b0360>] search_binary_handler+0xd0/0x2e0
>                         [<ffffffff802b18de>] do_execve+0x22e/0x290
>                         [<ffffffff80209b49>] sys_execve+0x49/0x80
>                         [<ffffffff8020bdfa>] stub_execve+0x6a/0xc0
>                         [<ffffffffffffffff>] 0xffffffffffffffff
>    softirq-on-W at:
>                         [<ffffffff80265afd>] __lock_acquire+0x82d/0xa50
>                         [<ffffffff80265d73>] lock_acquire+0x53/0x70
>                         [<ffffffff8035adce>] __percpu_counter_add+0x5e/0xd0
>                         [<ffffffff804930c3>] _spin_lock+0x33/0x40
>                         [<ffffffff8035adce>] __percpu_counter_add+0x5e/0xd0
>                         [<ffffffff802a6e21>] kmem_cache_alloc+0xd1/0xe0
>                         [<ffffffff8035adce>] __percpu_counter_add+0x5e/0xd0
>                         [<ffffffff802ad058>] get_empty_filp+0x68/0x140
>                         [<ffffffff802b7e7b>] path_lookup_open+0x3b/0xd0
>                         [<ffffffff802b07d4>] open_exec+0x24/0xd0
>                         [<ffffffff802ac4fa>] vfs_read+0x12a/0x160
>                         [<ffffffff802b0688>] kernel_read+0x38/0x50
>                         [<ffffffff802ea559>] load_elf_binary+0x18b9/0x1d20
>                         [<ffffffff8027f74f>] generic_file_aio_read+0x4ff/0x5e0
>                         [<ffffffff80264530>] validate_chain+0x460/0x1200
>                         [<ffffffff80264530>] validate_chain+0x460/0x1200
>                         [<ffffffff80265717>] __lock_acquire+0x447/0xa50
>                         [<ffffffff802ec040>] load_elf_binary+0x0/0x1e70
>                         [<ffffffff802e8ca0>] load_elf_binary+0x0/0x1d20
>                         [<ffffffff802b0360>] search_binary_handler+0xd0/0x2e0
>                         [<ffffffff802e7640>] load_script+0x270/0x280
>                         [<ffffffff802e8ca0>] load_elf_binary+0x0/0x1d20
>                         [<ffffffff802e73d0>] load_script+0x0/0x280
>                         [<ffffffff802b0360>] search_binary_handler+0xd0/0x2e0
>                         [<ffffffff802b18de>] do_execve+0x22e/0x290
>                         [<ffffffff80209b49>] sys_execve+0x49/0x80
>                         [<ffffffff8020bdfa>] stub_execve+0x6a/0xc0
>                         [<ffffffffffffffff>] 0xffffffffffffffff
>    hardirq-on-W at:
>                         [<ffffffff80265ad5>] __lock_acquire+0x805/0xa50
>                         [<ffffffff80265d73>] lock_acquire+0x53/0x70
>                         [<ffffffff8035adce>] __percpu_counter_add+0x5e/0xd0
>                         [<ffffffff804930c3>] _spin_lock+0x33/0x40
>                         [<ffffffff8035adce>] __percpu_counter_add+0x5e/0xd0
>                         [<ffffffff802a6e21>] kmem_cache_alloc+0xd1/0xe0
>                         [<ffffffff8035adce>] __percpu_counter_add+0x5e/0xd0
>                         [<ffffffff802ad058>] get_empty_filp+0x68/0x140
>                         [<ffffffff802b7e7b>] path_lookup_open+0x3b/0xd0
>                         [<ffffffff802b07d4>] open_exec+0x24/0xd0
>                         [<ffffffff802ac4fa>] vfs_read+0x12a/0x160
>                         [<ffffffff802b0688>] kernel_read+0x38/0x50
>                         [<ffffffff802ea559>] load_elf_binary+0x18b9/0x1d20
>                         [<ffffffff8027f74f>] generic_file_aio_read+0x4ff/0x5e0
>                         [<ffffffff80264530>] validate_chain+0x460/0x1200
>                         [<ffffffff80264530>] validate_chain+0x460/0x1200
>                         [<ffffffff80265717>] __lock_acquire+0x447/0xa50
>                         [<ffffffff802ec040>] load_elf_binary+0x0/0x1e70
>                         [<ffffffff802e8ca0>] load_elf_binary+0x0/0x1d20
>                         [<ffffffff802b0360>] search_binary_handler+0xd0/0x2e0
>                         [<ffffffff802e7640>] load_script+0x270/0x280
>                         [<ffffffff802e8ca0>] load_elf_binary+0x0/0x1d20
>                         [<ffffffff802e73d0>] load_script+0x0/0x280
>                         [<ffffffff802b0360>] search_binary_handler+0xd0/0x2e0
>                         [<ffffffff802b18de>] do_execve+0x22e/0x290
>                         [<ffffffff80209b49>] sys_execve+0x49/0x80
>                         [<ffffffff8020bdfa>] stub_execve+0x6a/0xc0
>                         [<ffffffffffffffff>] 0xffffffffffffffff
>  }
>  ... key      at: [<ffffffff80d736d4>] __key.10917+0x0/0x8
> 
> stack backtrace:
> Pid: 4695, comm: skype Not tainted 2.6.28-rc7-next-20081204 #1
> Call Trace:
>  [<ffffffff80263ed2>] check_usage+0x362/0x480
>  [<ffffffff802649a0>] validate_chain+0x8d0/0x1200
>  [<ffffffff80265717>] __lock_acquire+0x447/0xa50
>  [<ffffffff80265d73>] lock_acquire+0x53/0x70
>  [<ffffffff8035adce>] __percpu_counter_add+0x5e/0xd0
>  [<ffffffff804930c3>] _spin_lock+0x33/0x40
>  [<ffffffff8035adce>] __percpu_counter_add+0x5e/0xd0
>  [<ffffffff8035adce>] __percpu_counter_add+0x5e/0xd0
>  [<ffffffff8044ee36>] inet_csk_destroy_sock+0x46/0xf0
>  [<ffffffff80453650>] tcp_close+0x320/0x4a0
>  [<ffffffff8046f7fe>] inet_release+0x3e/0x70
>  [<ffffffff8041c9f9>] sock_release+0x19/0xb0
>  [<ffffffff8041cfe2>] sock_close+0x12/0x40
>  [<ffffffff802ace0b>] __fput+0xbb/0x200
>  [<ffffffff802a9cc4>] filp_close+0x54/0x90
>  [<ffffffff802a9d9f>] sys_close+0x9f/0x110
>  [<ffffffff8022b9d4>] sysenter_dispatch+0x7/0x30
>  [<ffffffff80492ca7>] trace_hardirqs_on_thunk+0x3a/0x3f
> 


