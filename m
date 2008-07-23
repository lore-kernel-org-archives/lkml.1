Return-Path: <linux-kernel-owner+w=401wt.eu-S1754531AbYGWMyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbYGWMyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 08:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751104AbYGWMyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 08:54:32 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:43015 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbYGWMyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 08:54:31 -0400
Date: Wed, 23 Jul 2008 14:54:26 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Brice Goglin <brice@myri.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Regression: myri10ge driver in 2.6.26
Message-ID: <20080723125426.GN4359@ics.muni.cz>
References: <20080722150438.GK4359@ics.muni.cz> <48865B04.6030707@myri.com> <488664A0.3040407@myri.com> <20080723080638.GL4359@ics.muni.cz> <4886E932.1010206@myri.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4886E932.1010206@myri.com>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Muni-Spam-TestIP: 147.251.3.109
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Wed, 23 Jul 2008 14:54:25 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jul 23, 2008 at 10:17:54AM +0200, Brice Goglin wrote:
> Thanks for testing, I just sent the patch to stable@

it seems, I got another problem with the driver from 2.6.26:

modprobe myri10ge; ifconfig eth2 ip netmask mask up 
produces:
[  232.446645] myri10ge: Version 1.3.99-1.347
[  232.446645] ACPI: PCI Interrupt 0000:07:00.0[A] -> GSI 18 (level, low) -> IRQ 18
[  232.446645] PCI: Setting latency timer of device 0000:07:00.0 to 64
[  232.446645] firmware: requesting myri10ge_eth_z8e.dat
[  232.473332] myri10ge 0000:07:00.0: Unable to load myri10ge_eth_z8e.dat firmware image via hotplug
[  232.473332] myri10ge 0000:07:00.0: hotplug firmware loading failed
[  232.479988] myri10ge 0000:07:00.0: Successfully adopted running firmware
[  232.479988] myri10ge 0000:07:00.0: Using firmware currently running on NIC.  For optimal
[  232.479988] myri10ge 0000:07:00.0: performance consider loading optimized firmware
[  232.479988] myri10ge 0000:07:00.0: via hotplug
[  232.532326] firmware: requesting adopted
[  232.533331] myri10ge 0000:07:00.0: Unable to load adopted firmware image via hotplug
[  232.533331] myri10ge 0000:07:00.0: hotplug firmware loading failed
[  232.533331] myri10ge 0000:07:00.0: Successfully adopted running firmware
[  232.640929] myri10ge 0000:07:00.0: MSI IRQ 499, tx bndry 2048, fw adopted, WC Enabled
[  266.273295] myri10ge: Version 1.3.99-1.347
[  266.273295] PCI: Setting latency timer of device 0000:07:00.0 to 64
[  266.273295] firmware: requesting myri10ge_eth_z8e.dat
[  266.406642] firmware: requesting myri10ge_eth_z8e.dat
[  266.590610] myri10ge 0000:07:00.0: MSI IRQ 499, tx bndry 4096, fw myri10ge_eth_z8e.dat, WC Enabled
[  271.500645] BUG: unable to handle kernel NULL pointer dereference at 0000000000000598
[  271.500826] IP: [<ffffffffa0093308>] :myri10ge:myri10ge_open+0x1c8/0x880
[  271.500957] PGD 43a88a067 PUD 43c636067 PMD 0 
[  271.501152] Oops: 0000 [1] SMP 
[  271.501301] CPU 1 
[  271.501405] Modules linked in: myri10ge ipv6 ac raid0 evdev usbhid loop serio_raw ehci_hcd i2c_i801 psmouse uhci_hcd i2c_core [last unloaded: myri10ge]
[  271.502150] Pid: 2099, comm: ifconfig Not tainted 2.6.26 #1
[  271.502217] RIP: 0010:[<ffffffffa0093308>]  [<ffffffffa0093308>] :myri10ge:myri10ge_open+0x1c8/0x880
[  271.502349] RSP: 0018:ffff81043a859d68  EFLAGS: 00010246
[  271.502416] RAX: 0000000000000000 RBX: ffff81043a859d78 RCX: 0000000000000000
[  271.502486] RDX: ffff81043a859d78 RSI: 000000000000000b RDI: 0000000000000000
[  271.502556] RBP: ffff81043bb826c0 R08: ffff81043a858000 R09: ffffffff80730280
[  271.502626] R10: ffff810080914000 R11: 0000000000000000 R12: 0000000000001043
[  271.502696] R13: 0000000000001000 R14: ffff81043bb82000 R15: ffff81043bbedc10
[  271.502766] FS:  00007f752d3686d0(0000) GS:ffff81043e42e480(0000) knlGS:0000000000000000
[  271.502851] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  271.502919] CR2: 0000000000000598 CR3: 000000043b87a000 CR4: 00000000000006e0
[  271.502988] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  271.503058] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  271.503128] Process ifconfig (pid: 2099, threadinfo ffff81043a858000, task ffff81043c5ebff0)
[  271.503214] Stack:  0000000000000001 0000000000000000 0000000000000296 ffffffff803b2fc1
[  271.503516]  ffffffff000a0000 0000000000000000 0000000000000296 ffff81043bb82000
[  271.503597]  0000000000000001 0000000000001043 0000000000001002 0000000000000000
[  271.503597] Call Trace:
[  271.503597]  [<ffffffff803b2fc1>] ? __up_read+0x21/0xb0
[  271.503597]  [<ffffffff804cea79>] ? dev_open+0x59/0xb0
[  271.503597]  [<ffffffff804cd36f>] ? dev_change_flags+0x9f/0x1d0
[  271.503597]  [<ffffffff80510d74>] ? devinet_ioctl+0x594/0x730
[  271.503597]  [<ffffffff804bf4e4>] ? sock_ioctl+0x54/0x240
[  271.503597]  [<ffffffff802af57f>] ? vfs_ioctl+0x2f/0xa0
[  271.503597]  [<ffffffff802af664>] ? do_vfs_ioctl+0x74/0x2d0
[  271.503597]  [<ffffffff802af951>] ? sys_ioctl+0x91/0xb0
[  271.503597]  [<ffffffff8020c15b>] ? system_call_after_swapgs+0x7b/0x80
[  271.503597] 
[  271.503597] 
[  271.503597] Code: 42 ff 48 85 d0 75 ec 8d 41 14 89 85 90 05 00 00 48 8b 85 f0 04 00 00 48 8d 5c 24 10 31 c9 be 0b 00 00 00 48 89 da 48 89 44 24 08 <48> 8b 80 98 05 00 00 48 8b 7c 24 08 48 89 04 24 e8 f3 ef ff ff 
[  271.503597] RIP  [<ffffffffa0093308>] :myri10ge:myri10ge_open+0x1c8/0x880
[  271.503597]  RSP <ffff81043a859d68>
[  271.503597] CR2: 0000000000000598
[  271.507626] ---[ end trace d24e8d9a8e3ce862 ]---


-- 
Luká¹ Hejtmánek
