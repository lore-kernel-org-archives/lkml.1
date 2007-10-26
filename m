Return-Path: <linux-kernel-owner+w=401wt.eu-S1758173AbXJZJRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173AbXJZJRp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 05:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756403AbXJZJRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 05:17:36 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:51514 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757523AbXJZJRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 05:17:33 -0400
Date: Fri, 26 Oct 2007 14:47:22 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Greg KH <greg@kroah.com>, Amit Shah <amitshah@gmx.net>,
       alsa-devel@alsa-project.org
Subject: Re: sysfs: WARNING: at fs/sysfs/dir.c:424 sysfs_add_one() - with ALSA
Message-ID: <20071026091722.GA21274@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <877aabc40710260014v220ab804o5de5dbc36b870bd1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877aabc40710260014v220ab804o5de5dbc36b870bd1@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007 at 12:44:38PM +0530, Amit Shah wrote:
> On 2.6.24-rc1, I get this for all my eth interfaces:
> 
> [  150.389821] sysfs: duplicate filename 'eth1_rename' can not be created
> [  150.389824] WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
> [  150.389826]
> [  150.389826] Call Trace:
> [  150.389840]  [<ffffffff802ee9cf>] sysfs_add_one+0xaf/0xf0
> [  150.389844]  [<ffffffff802ef9fe>] sysfs_create_link+0x9e/0x150
> [  150.389849]  [<ffffffff8038a418>] device_rename+0x1d8/0x230
> [  150.389854]  [<ffffffff803c2626>] dev_change_name+0xb6/0x230
> [  150.389857]  [<ffffffff803c2d5b>] dev_ioctl+0x2bb/0x5a0
> [  150.389862]  [<ffffffff80437436>] _spin_unlock_irqrestore+0x16/0x40
> [  150.389864]  [<ffffffff8043947a>] do_page_fault+0x24a/0x930
> [  150.389869]  [<ffffffff803b341d>] sock_ioctl+0x7d/0x250
> [  150.389872]  [<ffffffff802aafef>] do_ioctl+0x2f/0xa0
> [  150.389875]  [<ffffffff802ab0d4>] vfs_ioctl+0x74/0x2d0
> [  150.389878]  [<ffffffff802ab3c1>] sys_ioctl+0x91/0xb0
> [  150.389881]  [<ffffffff8020c32e>] system_call+0x7e/0x83
> [  150.389884]
> [  150.389886] net eth1_rename: device_rename: sysfs_create_symlink failed (-17)
> [  151.169923] sysfs: duplicate filename 'eth2' can not be created
> [  151.169927] WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
> [  151.169929]
> [  151.169930] Call Trace:
> [  151.169946]  [<ffffffff802ee9cf>] sysfs_add_one+0xaf/0xf0
> [  151.169949]  [<ffffffff802ef9fe>] sysfs_create_link+0x9e/0x150
> [  151.169955]  [<ffffffff8038a418>] device_rename+0x1d8/0x230
> [  151.169960]  [<ffffffff803c2626>] dev_change_name+0xb6/0x230
> [  151.169963]  [<ffffffff803c2d5b>] dev_ioctl+0x2bb/0x5a0
> [  151.169967]  [<ffffffff80437436>] _spin_unlock_irqrestore+0x16/0x40
> [  151.169970]  [<ffffffff8043947a>] do_page_fault+0x24a/0x930
> [  151.169974]  [<ffffffff803b341d>] sock_ioctl+0x7d/0x250
> [  151.169978]  [<ffffffff802aafef>] do_ioctl+0x2f/0xa0
> [  151.169980]  [<ffffffff802ab0d4>] vfs_ioctl+0x74/0x2d0
> [  151.169983]  [<ffffffff802ab3c1>] sys_ioctl+0x91/0xb0
> [  151.169987]  [<ffffffff8020c32e>] system_call+0x7e/0x83
> [  151.169990]
> [  151.169992] net eth2: device_rename: sysfs_create_symlink failed (-17)
> [  151.176762] e1000: eth2: e1000_watchdog: NIC Link is Up 100 Mbps
> Full Duplex, Flow Control: RX/TX
> [  151.209396] sysfs: duplicate filename 'eth0' can not be created
> 
Hi,

I get similar warning, while loading the alsa driver

[  191.933548] Advanced Linux Sound Architecture Driver Version 1.0.15
(Tue Oct 23 06:09:18 2007 UTC).
[  191.996323] ALSA sound/core/seq/oss/seq_oss.c:232: can't register
device seq
[  192.046004] sysfs: duplicate filename 'audio' can not be created
[  192.086048] WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
[  192.122882] 
[  192.122883] Call Trace:
[  192.154111]  [<ffffffff802fbe74>] sysfs_add_one+0x5c/0xc9
[  192.190144]  [<ffffffff802fc498>] create_dir+0x58/0x93
[  192.224571]  [<ffffffff802fc50b>] sysfs_create_dir+0x38/0x4f
[  192.262068]  [<ffffffff813a622b>] _spin_unlock+0x26/0x2a
[  192.297448]  [<ffffffff8048eb92>] kobject_add+0x13e/0x1f9
[  192.333292]  [<ffffffff8065c746>] device_add+0xac/0x610
[  192.367959]  [<ffffffff8065ccc3>] device_register+0x19/0x1d
[  192.404621]  [<ffffffff8065cda6>] device_create+0xdf/0x110
[  192.440760]  [<ffffffff8049301c>] sprintf+0x68/0x6a
[  192.473288]  [<ffffffff80ff9b4a>] sound_insert_unit+0xcf/0x172
[  192.511443]  [<ffffffff80ff9ba4>] sound_insert_unit+0x129/0x172
[  192.549996]  [<ffffffff80ff9deb>]
register_sound_special_device+0x14a/0x159
[  192.594734]  [<ffffffff8101ed06>] snd_register_oss_device+0x11d/0x18f
[  192.636281]  [<ffffffff81034470>] register_oss_dsp+0x54/0x8a
[  192.673031]  [<ffffffff802604e6>] mark_held_locks+0x4a/0x6a
[  192.709275]  [<ffffffff813a50f1>] mutex_lock_nested+0x2a8/0x2c3
[  192.747533]  [<ffffffff802604e6>] mark_held_locks+0x4a/0x6a
[  192.783587]  [<ffffffff813a4e32>] __mutex_unlock_slowpath+0x12e/0x13a
[  192.824764]  [<ffffffff802606d0>] trace_hardirqs_on+0x11c/0x147
[  192.862739]  [<ffffffff810378d4>]
snd_pcm_oss_register_minor+0x35/0x16b
[  192.904816]  [<ffffffff813a4e47>] mutex_unlock+0x9/0xb
[  192.938016]  [<ffffffff810208de>] snd_timer_dev_register+0x125/0x12c
[  192.978469]  [<ffffffff8101e27c>] snd_device_register+0x73/0xe0
[  193.016307]  [<ffffffff8102e03d>] snd_pcm_timer_init+0xba/0xf5
[  193.053660]  [<ffffffff810245bd>] snd_pcm_dev_register+0x1d7/0x211
[  193.093096]  [<ffffffff8101e1e1>] snd_device_register_all+0x5d/0x85
[  193.133041]  [<ffffffff810197ac>] snd_card_register+0x4e/0x2ea
[  193.170427]  [<ffffffff8104f66d>] snd_dummy_probe+0x201/0x21a
[  193.207240]  [<ffffffff806601b5>] platform_drv_probe+0x12/0x14
[  193.244615]  [<ffffffff8065ea16>] driver_probe_device+0x132/0x1d2
[  193.283580]  [<ffffffff8065eab6>] __device_attach+0x0/0xb
[  193.318382]  [<ffffffff8065eabf>] __device_attach+0x9/0xb
[  193.353173]  [<ffffffff8065df69>] bus_for_each_drv+0x47/0x7d
[  193.389534]  [<ffffffff8065eb5a>] device_attach+0x75/0x8d
[  193.424319]  [<ffffffff8065dd78>] bus_attach_device+0x2d/0x79
[  193.461202]  [<ffffffff8065ca2d>] device_add+0x393/0x610
[  193.495910]  [<ffffffff806605a5>] platform_device_add+0x133/0x16a
[  193.534870]  [<ffffffff806607a8>]
platform_device_register_simple+0x46/0x64
[  193.579013]  [<ffffffff8208d029>] alsa_card_dummy_init+0x38/0x7e
[  193.617437]  [<ffffffff82028678>] kernel_init+0x176/0x2ed
[  193.652173]  [<ffffffff813a5d27>] trace_hardirqs_on_thunk+0x35/0x3a
[  193.692147]  [<ffffffff802606d0>] trace_hardirqs_on+0x11c/0x147
[  193.730030]  [<ffffffff8020cef8>] child_rip+0xa/0x12
[  193.762145]  [<ffffffff8020c60f>] restore_args+0x0/0x30
[  193.795821]  [<ffffffff8023fc7f>] release_console_sem+0x4d/0x1f5
[  193.834171]  [<ffffffff82028502>] kernel_init+0x0/0x2ed
[  193.867870]  [<ffffffff8020ceee>] child_rip+0x0/0x12
[  193.899987] 
[  193.911270] kobject_add failed for audio with -EEXIST, don't try to
register things with the same name in the same directory.
[  193.983989] 
[  193.983990] Call Trace:
[  194.012668]  [<ffffffff8048e440>] kobject_put+0x19/0x1b
[  194.046571]  [<ffffffff8048ec17>] kobject_add+0x1c3/0x1f9
[  194.081445]  [<ffffffff8065c746>] device_add+0xac/0x610
[  194.115311]  [<ffffffff8065ccc3>] device_register+0x19/0x1d
[  194.151267]  [<ffffffff8065cda6>] device_create+0xdf/0x110
[  194.186663]  [<ffffffff8049301c>] sprintf+0x68/0x6a
[  194.218463]  [<ffffffff80ff9b4a>] sound_insert_unit+0xcf/0x172
[  194.255953]  [<ffffffff80ff9ba4>] sound_insert_unit+0x129/0x172
[  194.293932]  [<ffffffff80ff9deb>]
register_sound_special_device+0x14a/0x159
[  194.338208]  [<ffffffff8101ed06>] snd_register_oss_device+0x11d/0x18f
[  194.379363]  [<ffffffff81034470>] register_oss_dsp+0x54/0x8a
[  194.415853]  [<ffffffff802604e6>] mark_held_locks+0x4a/0x6a
[  194.451820]  [<ffffffff813a50f1>] mutex_lock_nested+0x2a8/0x2c3
[  194.489889]  [<ffffffff802604e6>] mark_held_locks+0x4a/0x6a
[  194.525880]  [<ffffffff813a4e32>] __mutex_unlock_slowpath+0x12e/0x13a
[  194.567098]  [<ffffffff802606d0>] trace_hardirqs_on+0x11c/0x147
[  194.605551]  [<ffffffff810378d4>]
snd_pcm_oss_register_minor+0x35/0x16b
[  194.647848]  [<ffffffff813a4e47>] mutex_unlock+0x9/0xb
[  194.681271]  [<ffffffff810208de>] snd_timer_dev_register+0x125/0x12c
[  194.721968]  [<ffffffff8101e27c>] snd_device_register+0x73/0xe0
[  194.760041]  [<ffffffff8102e03d>] snd_pcm_timer_init+0xba/0xf5
[  194.797490]  [<ffffffff810245bd>] snd_pcm_dev_register+0x1d7/0x211
[  194.836921]  [<ffffffff8101e1e1>] snd_device_register_all+0x5d/0x85
[  194.876879]  [<ffffffff810197ac>] snd_card_register+0x4e/0x2ea
[  194.914262]  [<ffffffff8104f66d>] snd_dummy_probe+0x201/0x21a
[  194.951096]  [<ffffffff806601b5>] platform_drv_probe+0x12/0x14
[  194.988480]  [<ffffffff8065ea16>] driver_probe_device+0x132/0x1d2
[  195.027449]  [<ffffffff8065eab6>] __device_attach+0x0/0xb
[  195.062267]  [<ffffffff8065eabf>] __device_attach+0x9/0xb
[  195.097053]  [<ffffffff8065df69>] bus_for_each_drv+0x47/0x7d
[  195.133408]  [<ffffffff8065eb5a>] device_attach+0x75/0x8d
[  195.168203]  [<ffffffff8065dd78>] bus_attach_device+0x2d/0x79
[  195.205133]  [<ffffffff8065ca2d>] device_add+0x393/0x610
[  195.239455]  [<ffffffff806605a5>] platform_device_add+0x133/0x16a
[  195.278432]  [<ffffffff806607a8>]
platform_device_register_simple+0x46/0x64
[  195.322586]  [<ffffffff8208d029>] alsa_card_dummy_init+0x38/0x7e
[  195.361032]  [<ffffffff82028678>] kernel_init+0x176/0x2ed
[  195.395798]  [<ffffffff813a5d27>] trace_hardirqs_on_thunk+0x35/0x3a
[  195.435764]  [<ffffffff802606d0>] trace_hardirqs_on+0x11c/0x147
[  195.473657]  [<ffffffff8020cef8>] child_rip+0xa/0x12
[  195.505771]  [<ffffffff8020c60f>] restore_args+0x0/0x30
[  195.539459]  [<ffffffff8023fc7f>] release_console_sem+0x4d/0x1f5
[  195.577825]  [<ffffffff82028502>] kernel_init+0x0/0x2ed
[  195.611533]  [<ffffffff8020ceee>] child_rip+0x0/0x12
[  195.643690] 
[  195.659326] ALSA sound/core/rawmidi.c:1542: unable to register OSS
rawmidi device 1:0
[  195.712879] no UART detected at 0x1
[  195.739880] Motu MidiTimePiece on parallel port irq: 7 ioport: 0x378
[  195.804370] usbcore: registered new interface driver snd-usb-audio
[  195.844370] usbcore: registered new interface driver snd-usb-usx2y
[  195.884286] usbcore: registered new interface driver snd-usb-caiaq
[  195.924293] ASoC version 0.13.1
[  195.946107] ALSA device list:
[  195.966550]   #0: Dummy 1
[  195.984913]   #1: Virtual MIDI Card 1
[  196.009489]   #2: MTPAV on parallel port at 0x378

--
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
