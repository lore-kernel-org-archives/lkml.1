Return-Path: <linux-kernel-owner+w=401wt.eu-S1162896AbYCSXHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162896AbYCSXHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932654AbYCSVcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:32:41 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:46325 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932717AbYCSVci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:32:38 -0400
Date: Wed, 19 Mar 2008 22:33:10 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: marcel@holtmann.org, maxk@qualcomm.com, bluez-devel@lists.sourceforge.net,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: bluetooth still corrupts memory in 2.6.25-rc6
Message-ID: <20080319213310.GE1811@elf.ucw.cz>
References: <20080319082115.GA14543@elf.ucw.cz> <200803192228.09834.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803192228.09834.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > sd 0:0:0:0: [sda] 117210240 512-byte hardware sectors (60012 MB)
> > sd 0:0:0:0: [sda] Write Protect is off
> > sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> > sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> > sd 0:0:0:0: [sda] 117210240 512-byte hardware sectors (60012 MB)
> > sd 0:0:0:0: [sda] Write Protect is off
> > sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> > sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> > PM: Finishing wakeup.
> > Restarting tasks ... <6>usb 5-1: USB disconnect, address 5
> > slab error in verify_redzone_free(): cache `size-1024': memory outside object was overwritten
> > Pid: 264, comm: khubd Not tainted 2.6.25-rc6 #186
> >  [<c0270baf>] cache_free_debugcheck+0x18f/0x220
> >  [<c07252bc>] __mutex_lock_slowpath+0x10c/0x1c0
> >  [<c0562603>] hci_usb_close+0xd3/0x120
> >  [<c0270d96>] kfree+0x56/0xc0
> >  [<c0562603>] hci_usb_close+0xd3/0x120
> >  [<c056311d>] hci_usb_disconnect+0x2d/0x90
> >  [<c0506328>] usb_disable_interface+0x28/0x40
> >  [<c0509040>] usb_unbind_interface+0x50/0xa0
> >  [<c0411ef1>] __device_release_driver+0x51/0x90
> >  [<c041231e>] device_release_driver+0x1e/0x40
> >  [<c04117f0>] bus_remove_device+0x60/0x90
> >  [<c040fb93>] device_del+0xe3/0x150
> >  [<c050629e>] usb_disable_device+0x7e/0xe0
> >  [<c0501b06>] usb_disconnect+0x96/0x120
> >  [<c0502f2e>] hub_thread+0x33e/0xd20
> >  [<c072445c>] schedule+0x32c/0x830
> >  [<c021ec25>] try_to_wake_up+0x55/0x1d0
> >  [<c0239190>] autoremove_wake_function+0x0/0x50
> >  [<c0502bf0>] hub_thread+0x0/0xd20
> >  [<c0238ea2>] kthread+0x42/0x70
> >  [<c0238e60>] kthread+0x0/0x70
> >  [<c0204867>] kernel_thread_helper+0x7/0x10
> >  =======================
> > e3505734: redzone 1:0x5a5a5a5ad84156c5, redzone 2:0xffffffffd84156c5.
> > ------------[ cut here ]------------
> > kernel BUG at /data/l/linux/mm/slab.c:2906!
> > invalid opcode: 0000 [#1] SMP 
> > Modules linked in:
> > 
> > Pid: 264, comm: khubd Not tainted (2.6.25-rc6 #186)
> > EIP: 0060:[<c0270c38>] EFLAGS: 00010002 CPU: 0
> > EIP is at cache_free_debugcheck+0x218/0x220
> > EAX: e3505730 EBX: f7c01800 ECX: e35042b8 EDX: 00000005
> > ESI: e3505734 EDI: d84156c5 EBP: 5a5a5a5a ESP: f7d91e28
> >  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> > Process khubd (pid: 264, ti=f7d90000 task=f7d8b980 task.ti=f7d90000)
> > Stack: c07fce50 e3505734 d84156c5 5a5a5a5a d84156c5 ffffffff c0562603 e3504280 
> >        d84156c5 ffffffff f7c01800 f7c06388 e350573c 00000282 c0270d96 e34dca24 
> >        e34dca10 00000000 f76ac578 c0562603 f76ac548 0000000c f70631e0 f76ac4c0 
> > Call Trace:
> >  [<c0562603>] hci_usb_close+0xd3/0x120
> >  [<c0270d96>] kfree+0x56/0xc0
> >  [<c0562603>] hci_usb_close+0xd3/0x120
> >  [<c056311d>] hci_usb_disconnect+0x2d/0x90
> >  [<c0506328>] usb_disable_interface+0x28/0x40
> >  [<c0509040>] usb_unbind_interface+0x50/0xa0
> >  [<c0411ef1>] __device_release_driver+0x51/0x90
> >  [<c041231e>] device_release_driver+0x1e/0x40
> >  [<c04117f0>] bus_remove_device+0x60/0x90
> >  [<c040fb93>] device_del+0xe3/0x150
> >  [<c050629e>] usb_disable_device+0x7e/0xe0
> >  [<c0501b06>] usb_disconnect+0x96/0x120
> >  [<c0502f2e>] hub_thread+0x33e/0xd20
> >  [<c072445c>] schedule+0x32c/0x830
> >  [<c021ec25>] try_to_wake_up+0x55/0x1d0
> >  [<c0239190>] autoremove_wake_function+0x0/0x50
> >  [<c0502bf0>] hub_thread+0x0/0xd20
> >  [<c0238ea2>] kthread+0x42/0x70
> >  [<c0238e60>] kthread+0x0/0x70
> >  [<c0204867>] kernel_thread_helper+0x7/0x10
> >  =======================
> > Code: 3d 00 40 02 00 0f 85 3b fe ff ff 8b 52 0c e9 33 fe ff ff 0f 0b eb fe 8b 52 0c e9 6d fe ff ff 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe <0f> 0b eb fe 8d 74 26 00 55 57 56 53 83 ec 10 89 44 24 08 89 54 
> > EIP: [<c0270c38>] cache_free_debugcheck+0x218/0x220 SS:ESP 0068:f7d91e28
> > ---[ end trace 4ee36c05f33330e1 ]---
> > done.
> > slab error in verify_redzone_free(): cache `size-1024': memory outside object was overwritten
> > Pid: 4, comm: ksoftirqd/0 Tainted: G      D  2.6.25-rc6 #186
> >  [<c0270baf>] cache_free_debugcheck+0x18f/0x220
> >  [<c0270af1>] cache_free_debugcheck+0xd1/0x220
> >  [<c02890cc>] free_fdtable_rcu+0x4c/0x70
> >  [<c0270d96>] kfree+0x56/0xc0
> >  [<c02890cc>] free_fdtable_rcu+0x4c/0x70
> >  [<c0252783>] __rcu_process_callbacks+0x63/0x180
> >  [<c02528b7>] rcu_process_callbacks+0x17/0x30
> >  [<c022b5a2>] __do_softirq+0x72/0xf0
> >  [<c022b710>] ksoftirqd+0x0/0xd0
> >  [<c022b657>] do_softirq+0x37/0x40
> >  [<c022b764>] ksoftirqd+0x54/0xd0
> >  [<c0238ea2>] kthread+0x42/0x70
> >  [<c0238e60>] kthread+0x0/0x70
> >  [<c0204867>] kernel_thread_helper+0x7/0x10
> >  =======================
> > e3505b48: redzone 1:0xd84156c5c0562603, redzone 2:0xd84156c5635688c0.
> 
> For how long has it been doing that?

Pretty much forever. Not a 2.6.24 regression.
									Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
