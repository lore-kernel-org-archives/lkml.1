Return-Path: <linux-kernel-owner+w=401wt.eu-S1753333AbYLFR3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbYLFR3Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 12:29:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbYLFR3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 12:29:15 -0500
Received: from orion.ambsoft.pl ([212.109.144.130]:53659 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbYLFR3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 12:29:14 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Stephen Hemminger <stephen.hemminger@vyatta.com>
Subject: Re: linux-next: Tree for December 4
Date: Sat, 6 Dec 2008 18:30:00 +0100
User-Agent: KMail/1.9.9
Cc: kernel-testers@vger.kernel.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "David S. Miller" <davem@davemloft.net>
References: <2681028.65321228582887579.JavaMail.root@tahiti.vyatta.com>
In-Reply-To: <2681028.65321228582887579.JavaMail.root@tahiti.vyatta.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812061830.00454.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Which ethernet device driver?

That would be realtek 8169 gigabit ethernet - aka r8169.

Btw. In original thread you have dmesg and .config attached.

	Mariusz


> ----- Original Message -----
> From: "Mariusz Kozlowski" <m.kozlowski@tuxland.pl>
> To: "Stephen Rothwell" <sfr@canb.auug.org.au>, "Stephen Hemminger" <shemminger@vyatta.com>, "David S. Miller" <davem@davemloft.net>
> Cc: kernel-testers@vger.kernel.org, linux-next@vger.kernel.org, "LKML" <linux-kernel@vger.kernel.org>
> Sent: Saturday, December 6, 2008 5:55:37 AM GMT -08:00 US/Canada Pacific
> Subject: Re: linux-next: Tree for December 4
> 
> Hi,
> 
> > 	I didn't run linux-next for some time. Today I gave it a shot and
> > a few interesting things poped out:
> > 
> > Linux agpgart interface v0.103
> > Serial: 8250/16550 driver4 ports, IRQ sharing enabled
> > serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> > serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
> > =============================================================================
> > BUG kmalloc-4096: Invalid object pointer 0xffff88007fb20010
> > -----------------------------------------------------------------------------
> 
> I'm told the serial one is already fixed.
> 
> > I also noticed my network wasn't reachable. That's probably not related to the kernel
> > but to check if my link is ok I run mii-tool and the result is NULL pointer dereference:
> > 
> > BUG: unable to handle kernel NULL pointer dereference at 0000000000000138
> > IP: [<ffffffff8042beff>] dev_ifsioc+0x1f/0x320
> > PGD 736e3067 PUD 736ca067 PMD 0 
> > Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> > last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:05:01.0/resource
> > CPU 1 
> > Modules linked in: nfsd lockd sunrpc exportfs snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss usbhid gspca_zc3xx gspca_main compat_ioctl32 videodev v4l1_compat snd_mixer_oss usb_storage libusual ehci_hcd uhci_hcd usbcore parport_pc snd_hda_codec_realtek thermal parport snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer i2c_i801 snd soundcore snd_page_alloc sr_mod pcspkr sg i2c_core intel_agp processor rtc button cdrom
> > Pid: 4768, comm: mii-tool Not tainted 2.6.28-rc7-next-20081204 #1
> > RIP: 0010:[<ffffffff8042beff>]  [<ffffffff8042beff>] dev_ifsioc+0x1f/0x320
> > RSP: 0018:ffff88006e623da8  EFLAGS: 00010246
> > RAX: 0000000000000000 RBX: 0000000000008947 RCX: 00000000019369c2
> > RDX: 0000000000000610 RSI: ffff88006e623e0c RDI: 00000000ffffffff
> > RBP: ffff88006e623e08 R08: 00000000019369c2 R09: 0000000000000001
> > R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
> > R13: 0000000000000000 R14: ffffffff80d7da40 R15: 00007fff55e4ee88
> > FS:  00007f944de2f6f0(0000) GS:ffff88007f8047d0(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > CR2: 0000000000000138 CR3: 000000006e4d9000 CR4: 00000000000006e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > Process mii-tool (pid: 4768, threadinfo ffff88006e622000, task ffff88006e45ba80)
> > Stack:
> >  0000000000008947 ffff88006e623e08 0000000000603400 ffffffff8042c4c7
> >  ffffe2000003f428 0000000000603400 0000000001213025 ffffffff8028e3fd
> >  ffff88007d4f5500 00007f944db51330 ffff880076fbb180 0000000000000096
> > Call Trace:
> >  [<ffffffff8042c4c7>] ? dev_ioctl+0x2c7/0x590
> >  [<ffffffff8028e3fd>] ? __do_fault+0x1dd/0x4a0
> >  [<ffffffff8041de92>] ? sock_ioctl+0x72/0x250
> >  [<ffffffff802b971f>] ? vfs_ioctl+0x2f/0xa0
> >  [<ffffffff802b980d>] ? do_vfs_ioctl+0x7d/0x4c0
> >  [<ffffffff80492d1d>] ? lockdep_sys_exit_thunk+0x35/0x67
> >  [<ffffffff802b9c99>] ? sys_ioctl+0x49/0x80
> >  [<ffffffff8020b95b>] ? system_call_fastpath+0x16/0x1b
> > Code: f8 bd f1 ff e9 52 fe ff ff 0f 1f 00 48 83 ec 18 48 89 1c 24 89 d3 48 89 6c 24 08 4c 89 64 24 10 48 89 f5 e8 f4 d4 ff ff 49 89 c4 <48> 8b 88 38 01 00 00 8d 83 ec 76 ff ff 83 f8 5d 77 0f 89 c0 ff 
> > RIP  [<ffffffff8042beff>] dev_ifsioc+0x1f/0x320
> >  RSP <ffff88006e623da8>
> > CR2: 0000000000000138
> > ---[ end trace 787e122ecd30f760 ]---
> 
> And this got bisected to:
> 
> commit d314774cf2cd5dfeb39a00d37deee65d4c627927
> Author: Stephen Hemminger <shemminger@vyatta.com>
> Date:   Wed Nov 19 21:32:24 2008 -0800
> 
>     netdev: network device operations infrastructure
>     
>     This patch changes the network device internal API to move adminstrative
>     operations out of the network device structure and into a separate structure.
>     
>     This patch involves some hackery to maintain compatablity between the
>     new and old model, so all 300+ drivers don't have to be changed at once.
>     For drivers that aren't converted yet, the netdevice_ops virt function list
>     still resides in the net_device structure. For old protocols, the new
>     net_device_ops are copied out to the old net_device pointers.
>     
>     After the transistion is completed the nag message can be changed to
>     an WARN_ON, and the compatiablity code can be made configurable.
>     
>     Some function pointers aren't moved:
>     * destructor can't be in net_device_ops because
>       it may need to be referenced after the module is unloaded.
>     * neighbor setup is manipulated in a couple of places that need special
>       consideration
>     * hard_start_xmit is in the fast path for transmit.
>     
>     Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> 
> (gdb) l *dev_ifsioc+0x1f
> 0xffffffff8042309f is in dev_ifsioc (/home/mako/linux/lkt/sources/linux-next/net/core/dev.c:3553).
> 3548     *      Perform the SIOCxIFxxx calls, inside rtnl_lock()
> 3549     */
> 3550    static int dev_ifsioc(struct net *net, struct ifreq *ifr, unsigned int cmd)
> 3551    {
> 3552            int err;
> 3553            struct net_device *dev = __dev_get_by_name(net, ifr->ifr_name);
> 3554    
> 3555            if (!dev)
> 3556                    return -ENODEV;
> 3557
