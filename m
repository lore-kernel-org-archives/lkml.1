Return-Path: <linux-kernel-owner+w=401wt.eu-S1761532AbXFIVCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761532AbXFIVCU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 17:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755173AbXFIVCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 17:02:12 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:43372 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165AbXFIVCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 17:02:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=PFx0qk8p4nHpG6EnLsqv+WQ7EynGdxiAhN3kLUNvgFMQz75XQ2+C5HgjC89y1nF2+IrqNJRN6OdvmNckuiUg1jwEgjLx6XOz/vdM4msdsDqPYd0ChRQg5rH6YCSN17/mZJVvSbOUdWU8K5c6blTmWoVkHO0lf80R9uSo40Jxnt4=
Message-ID: <466B4D86.1020808@gmail.com>
Date: Sun, 10 Jun 2007 03:01:58 +0200
From: Robert de Rooy <robert.de.rooy@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: Mark Lord <mlord@pobox.com>, Tejun Heo <htejun@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, bzolnier@gmail.com,
       linux-pcmcia@lists.infradead.org,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: libata and legacy ide pcmcia failure
References: <464A0321.3080201@gmail.com>	<464C1575.8070005@gmail.com> <464CB7C9.2080807@gmail.com>	<46503192.1040300@gmail.com> <4650B9E3.7070409@gmail.com>	<46518798.2020808@gmail.com> <4651B66E.6030505@gmail.com>	<4651B834.3060702@gmail.com> <4651C4A1.6000101@gmail.com>	<4651C74B.7020108@gmail.com> <46520B36.90409@garzik.org> <20070523150229.00a0c3c4@the-village.bc.nu> <466718B6.4080105@gmail.com> <4667B39D.209@gmail.com> <46685AE5.4010908@gmail.com> <466900F3.7040801@gmail.com> <46694FB2.6040007@pobox.com> <4669D2D8.3020806@gmail.com> <4669D3F5.7040300@rtr.ca>
In-Reply-To: <4669D3F5.7040300@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Oh crap.  I did test it a couple of months ago, but my boot/root drive
> is libata not IDE -- so no panic on boot with it.  After booting, it 
> worked
> just fine talking to PC-CARD CF devices using the polling.
>
> =ml

Ok, no problem. I recompiled the kernel with libata (but without the 
libata pcmcia support), and made legacy ide (only ide-core and ide-cs) 
modular.
This allowed me to boot my PATA HDD with libata, and when I plugged in 
the PCMCIA card it picked it up automatically with the legacy ide drivers.

Jun 10 02:40:06 localhost kernel: pccard: PCMCIA card inserted into slot 0
Jun 10 02:40:07 localhost kernel: cs: memory probe 
0xe8000000-0xefffffff: excluding 0xe8000000-0xefffffff
Jun 10 02:40:07 localhost kernel: cs: memory probe 
0xc0200000-0xcfffffff: excluding 0xc0200000-0xc11fffff 
0xc1a00000-0xc21fffff 0xc2a00000-0xc31fffff 0xc3a00000-0xcc1fffff 
0xcca00000-0xcd1fffff 0xcda00000-0xce1fffff 0xcea00000-0xcf1fffff 
0xcfa00000-0xd01fffff
Jun 10 02:40:07 localhost kernel: pcmcia: registering new device pcmcia0.0
Jun 10 02:40:07 localhost kernel: Uniform Multi-Platform E-IDE driver 
Revision: 7.00alpha2
Jun 10 02:40:07 localhost kernel: ide: Assuming 33MHz system bus speed 
for PIO modes; override with idebus=xx
Jun 10 02:40:07 localhost kernel: hda: Memory Card Adapter, CFA DISK drive
Jun 10 02:40:08 localhost kernel: ide0 at 0x4100-0x4107,0x410e on irq 3
Jun 10 02:40:08 localhost kernel: ide-cs: hda: Vpp = 0.0
Jun 10 02:40:08 localhost udevd-event[2630]: udev_rules_apply_format: 
unknown format variable '$modalias'

At this point I noticed no /dev/hda* devices existed, so I created them 
manually with mknod. But regardless I was not able to actually mount a 
filesystem, getting an error from mount that the device did not exist.

When pulling the card I also got the following..

Jun 10 02:41:53 localhost kernel: pccard: card ejected from slot 0
Jun 10 02:41:53 localhost kernel:
Jun 10 02:41:53 localhost kernel: 
======================================================
Jun 10 02:41:53 localhost kernel: [ INFO: soft-safe -> soft-unsafe lock 
order detected ]
Jun 10 02:41:53 localhost kernel: 2.6.22-rc4 #5
Jun 10 02:41:53 localhost kernel: 
------------------------------------------------------
Jun 10 02:41:53 localhost kernel: pccardd/355 [HC0[0]:SC0[0]:HE0:SE1] is 
trying to acquire:
Jun 10 02:41:53 localhost kernel:  (resource_lock){--..}, at: 
[<c042dcb2>] __release_region+0x2f/0xdd
Jun 10 02:41:53 localhost kernel:
Jun 10 02:41:53 localhost kernel: and this task is already holding:
Jun 10 02:41:53 localhost kernel:  (ide_lock){.+..}, at: [<f8e0269d>] 
ide_unregister+0x11d/0x56e [ide_core]
Jun 10 02:41:53 localhost kernel: which would create a new lock dependency:
Jun 10 02:41:53 localhost kernel:  (ide_lock){.+..} -> (resource_lock){--..}
Jun 10 02:41:53 localhost kernel:
Jun 10 02:41:53 localhost kernel: but this new dependency connects a 
soft-irq-safe lock:
Jun 10 02:41:53 localhost kernel:  (ide_lock){.+..}
Jun 10 02:41:53 localhost kernel: ... which became soft-irq-safe at:
Jun 10 02:41:53 localhost kernel:   [<c0444171>] __lock_acquire+0x3ad/0xb12
Jun 10 02:41:53 localhost kernel:   [<c0444c97>] lock_acquire+0x56/0x6f
Jun 10 02:41:53 localhost kernel:   [<c061711f>] 
_spin_lock_irqsave+0x34/0x44
Jun 10 02:41:53 localhost kernel:   [<f8e04679>] ide_intr+0x17/0x1ac 
[ide_core]
Jun 10 02:41:53 localhost kernel:   [<f8e07825>] ide_polling+0x22/0x64 
[ide_core]
Jun 10 02:41:53 localhost kernel:   [<c0430446>] 
run_timer_softirq+0x11a/0x182
Jun 10 02:41:53 localhost kernel:   [<c042d286>] __do_softirq+0x6f/0xe9
Jun 10 02:41:53 localhost kernel:   [<c0406f72>] do_softirq+0x61/0xc7
Jun 10 02:41:53 localhost kernel:   [<ffffffff>] 0xffffffff
Jun 10 02:41:53 localhost kernel:
Jun 10 02:41:53 localhost kernel: to a soft-irq-unsafe lock:
Jun 10 02:41:53 localhost kernel:  (resource_lock){--..}
Jun 10 02:41:53 localhost kernel: ... which became soft-irq-unsafe at:
Jun 10 02:41:53 localhost kernel: ...  [<c04441e4>] 
__lock_acquire+0x420/0xb12
Jun 10 02:41:53 localhost kernel:   [<c0444c97>] lock_acquire+0x56/0x6f
Jun 10 02:41:53 localhost kernel:   [<c0616e5e>] _write_lock+0x2b/0x38
Jun 10 02:41:53 localhost kernel:   [<c042dc60>] request_resource+0x13/0x36
Jun 10 02:41:53 localhost kernel:   [<c05068bb>] vgacon_startup+0x196/0x349
Jun 10 02:41:53 localhost kernel:   [<c075d3d5>] con_init+0x1a/0x217
Jun 10 02:41:53 localhost kernel:   [<c075cee5>] console_init+0x19/0x27
Jun 10 02:41:53 localhost kernel:   [<c07428b5>] start_kernel+0x242/0x34c
Jun 10 02:41:53 localhost kernel:   [<00000000>] 0x0
Jun 10 02:41:53 localhost kernel:   [<ffffffff>] 0xffffffff
Jun 10 02:41:53 localhost kernel:
Jun 10 02:41:53 localhost kernel: other info that might help us debug this:
Jun 10 02:41:53 localhost kernel:
Jun 10 02:41:53 localhost kernel: 2 locks held by pccardd/355:
Jun 10 02:41:53 localhost kernel:  #0:  (&socket->skt_mutex){--..}, at: 
[<c0615d3b>] mutex_lock+0x21/0x24
Jun 10 02:41:53 localhost kernel:  #1:  (ide_lock){.+..}, at: 
[<f8e0269d>] ide_unregister+0x11d/0x56e [ide_core]
Jun 10 02:41:53 localhost kernel:
Jun 10 02:41:53 localhost kernel: the soft-irq-safe lock's dependencies:
Jun 10 02:41:53 localhost kernel: -> (ide_lock){.+..} ops: 0 {
Jun 10 02:41:53 localhost kernel:    initial-use  at:
Jun 10 02:41:53 localhost kernel:                         [<c04441f9>] 
__lock_acquire+0x435/0xb12
Jun 10 02:41:53 localhost kernel:                         [<c0444c97>] 
lock_acquire+0x56/0x6f
Jun 10 02:41:53 localhost kernel:                         [<c061711f>] 
_spin_lock_irqsave+0x34/0x44
Jun 10 02:41:53 localhost kernel:                         [<f8e04679>] 
ide_intr+0x17/0x1ac [ide_core]
Jun 10 02:41:53 localhost kernel:                         [<f8e07825>] 
ide_polling+0x22/0x64 [ide_core]
Jun 10 02:41:53 localhost kernel:                         [<f8e07a62>] 
init_irq+0x1fb/0x3bd [ide_core]
Jun 10 02:41:53 localhost kernel:                         [<f8e07d4e>] 
hwif_init+0x12a/0x302 [ide_core]
Jun 10 02:41:53 localhost kernel:                         [<f8e0808c>] 
probe_hwif_init_with_fixup+0x20/0x8c [ide_core]
Jun 10 02:41:53 localhost kernel:                         [<f8e02c11>] 
ide_register_hw_with_fixup+0x123/0x156 [ide_core]
Jun 10 02:41:53 localhost kernel:                         [<f8cae0b8>] 
idecs_register+0x72/0x7a [ide_cs]
Jun 10 02:41:53 localhost kernel:                         [<f8cae464>] 
ide_probe+0x3a4/0x4c0 [ide_cs]
Jun 10 02:41:53 localhost kernel:                         [<c0566ac3>] 
pcmcia_device_probe+0xab/0xff
Jun 10 02:41:53 localhost kernel:                         [<c055ccdc>] 
driver_probe_device+0xe9/0x16a
Jun 10 02:41:53 localhost kernel:                         [<c055ce86>] 
__driver_attach+0x76/0xaf
Jun 10 02:41:53 localhost kernel:                         [<c055c1cc>] 
bus_for_each_dev+0x3a/0x5f
Jun 10 02:41:53 localhost kernel:                         [<c055cb27>] 
driver_attach+0x19/0x1b
Jun 10 02:41:53 localhost kernel:                         [<c055c4ea>] 
bus_add_driver+0x79/0x181
Jun 10 02:41:53 localhost kernel:                         [<c055d081>] 
driver_register+0x67/0x6c
Jun 10 02:41:53 localhost kernel:                         [<c0567565>] 
pcmcia_register_driver+0xf7/0x128
Jun 10 02:41:53 localhost kernel:                         [<f8a2f00d>] 
0xf8a2f00d
Jun 10 02:41:53 localhost kernel:                         [<c044c2eb>] 
sys_init_module+0x1579/0x16ca
Jun 10 02:41:53 localhost kernel:                         [<c0404e26>] 
sysenter_past_esp+0x5f/0x99
Jun 10 02:41:53 localhost kernel:                         [<ffffffff>] 
0xffffffff
Jun 10 02:41:53 localhost kernel:    in-softirq-W at:
Jun 10 02:41:53 localhost kernel:                         [<c0444171>] 
__lock_acquire+0x3ad/0xb12
Jun 10 02:41:53 localhost kernel:                         [<c0444c97>] 
lock_acquire+0x56/0x6f
Jun 10 02:41:53 localhost kernel:                         [<c061711f>] 
_spin_lock_irqsave+0x34/0x44
Jun 10 02:41:53 localhost kernel:                         [<f8e04679>] 
ide_intr+0x17/0x1ac [ide_core]
Jun 10 02:41:53 localhost kernel:                         [<f8e07825>] 
ide_polling+0x22/0x64 [ide_core]
Jun 10 02:41:53 localhost kernel:                         [<c0430446>] 
run_timer_softirq+0x11a/0x182
Jun 10 02:41:53 localhost kernel:                         [<c042d286>] 
__do_softirq+0x6f/0xe9
Jun 10 02:41:53 localhost kernel:                         [<c0406f72>] 
do_softirq+0x61/0xc7
Jun 10 02:41:53 localhost kernel:                         [<ffffffff>] 
0xffffffff
Jun 10 02:41:53 localhost kernel:  }
Jun 10 02:41:53 localhost kernel:  ... key      at: [<f8e13c10>] 
ide_lock+0x10/0xffff6afd [ide_core]
Jun 10 02:41:53 localhost kernel:  -> (&n->list_lock){.+..} ops: 0 {
Jun 10 02:41:53 localhost kernel:     initial-use  at:
Jun 10 02:41:53 localhost kernel:                           [<c04441f9>] 
__lock_acquire+0x435/0xb12
Jun 10 02:41:53 localhost kernel:                           [<c0444c97>] 
lock_acquire+0x56/0x6f
Jun 10 02:41:53 localhost kernel:                           [<c0616de9>] 
_spin_lock+0x2b/0x38
Jun 10 02:41:53 localhost kernel:                           [<c04788ee>] 
add_partial+0xe/0x27
Jun 10 02:41:53 localhost kernel:                           [<c04794ed>] 
__slab_free+0x5e/0x278
Jun 10 02:41:53 localhost kernel:                           [<c0479ec2>] 
kmem_cache_free+0x77/0x97
Jun 10 02:41:53 localhost kernel:                           [<c05119ac>] 
acpi_os_release_object+0x8/0xc
Jun 10 02:41:53 localhost kernel:                           [<c0527d9a>] 
acpi_ut_delete_object_desc+0x47/0x4d
Jun 10 02:41:53 localhost kernel:                           [<c05274c5>] 
acpi_ut_delete_internal_obj+0x141/0x148
Jun 10 02:41:53 localhost kernel:                           [<c0527519>] 
acpi_ut_update_ref_count+0x4d/0xa6
Jun 10 02:41:53 localhost kernel:                           [<c0527631>] 
acpi_ut_update_object_reference+0xbf/0x125
Jun 10 02:41:53 localhost kernel:                           [<c05276bc>] 
acpi_ut_remove_reference+0x25/0x28
Jun 10 02:41:53 localhost kernel:                           [<c051c4e9>] 
acpi_ex_create_method+0x99/0xa3
Jun 10 02:41:53 localhost kernel:                           [<c0515729>] 
acpi_ds_load1_end_op+0xfd/0x144
Jun 10 02:41:53 localhost kernel:                           [<c0522e32>] 
acpi_ps_parse_loop+0x587/0x719
Jun 10 02:41:53 localhost kernel:                           [<c0522292>] 
acpi_ps_parse_aml+0x68/0x246
Jun 10 02:41:53 localhost kernel:                           [<c0521c42>] 
acpi_ns_one_complete_parse+0xbe/0xd1
Jun 10 02:41:53 localhost kernel:                           [<c0521c67>] 
acpi_ns_parse_table+0x12/0x23
Jun 10 02:41:53 localhost kernel:                           [<c051fda2>] 
acpi_ns_load_table+0x3e/0x80
Jun 10 02:41:53 localhost kernel:                           [<c0524bbb>] 
acpi_load_tables+0xd3/0x17f
Jun 10 02:41:53 localhost kernel:                           [<c075aa59>] 
acpi_early_init+0x71/0x105
Jun 10 02:41:53 localhost kernel:                           [<c07429b2>] 
start_kernel+0x33f/0x34c
Jun 10 02:41:53 localhost kernel:                           [<00000000>] 0x0
Jun 10 02:41:53 localhost kernel:                           [<ffffffff>] 
0xffffffff
Jun 10 02:41:53 localhost kernel:     in-softirq-W at:
Jun 10 02:41:53 localhost kernel:                           [<c0444171>] 
__lock_acquire+0x3ad/0xb12
Jun 10 02:41:53 localhost kernel:                           [<c0444c97>] 
lock_acquire+0x56/0x6f
Jun 10 02:41:53 localhost kernel:                           [<c0616de9>] 
_spin_lock+0x2b/0x38
Jun 10 02:41:53 localhost kernel:                           [<c04788ee>] 
add_partial+0xe/0x27
Jun 10 02:41:53 localhost kernel:                           [<c04794ed>] 
__slab_free+0x5e/0x278
Jun 10 02:41:53 localhost kernel:                           [<c0479ec2>] 
kmem_cache_free+0x77/0x97
Jun 10 02:41:53 localhost kernel:                           [<c048c53a>] 
__d_free+0x23/0x26
Jun 10 02:41:53 localhost kernel:                           [<c048c5b5>] 
d_callback+0xb/0xd
Jun 10 02:41:53 localhost kernel:                           [<c043766f>] 
__rcu_process_callbacks+0xff/0x16f
Jun 10 02:41:53 localhost kernel:                           [<c04376fa>] 
rcu_process_callbacks+0x1b/0x35
Jun 10 02:41:53 localhost kernel:                           [<c042d386>] 
tasklet_action+0x53/0xa8
Jun 10 02:41:53 localhost kernel:                           [<c042d286>] 
__do_softirq+0x6f/0xe9
Jun 10 02:41:53 localhost kernel:                           [<c0406f72>] 
do_softirq+0x61/0xc7
Jun 10 02:41:53 localhost kernel:                           [<ffffffff>] 
0xffffffff
Jun 10 02:41:53 localhost kernel:   }
Jun 10 02:41:53 localhost kernel:   ... key      at: [<c0a1f0e4>] 
__key.17793+0x0/0x8
Jun 10 02:41:53 localhost kernel:  ... acquired at:
Jun 10 02:41:53 localhost kernel:    [<c044475d>] __lock_acquire+0x999/0xb12
Jun 10 02:41:53 localhost kernel:    [<c0444c97>] lock_acquire+0x56/0x6f
Jun 10 02:41:53 localhost kernel:    [<c0616de9>] _spin_lock+0x2b/0x38
Jun 10 02:41:53 localhost kernel:    [<c04788ee>] add_partial+0xe/0x27
Jun 10 02:41:53 localhost kernel:    [<c04794ed>] __slab_free+0x5e/0x278
Jun 10 02:41:53 localhost kernel:    [<c0479ca6>] kfree+0x82/0xa2
Jun 10 02:41:53 localhost kernel:    [<f8e08223>] 
drive_release_dev+0x67/0xae [ide_core]
Jun 10 02:41:53 localhost kernel:    [<c055a228>] device_release+0x3c/0x7e
Jun 10 02:41:53 localhost kernel:    [<c04ea5b3>] kobject_cleanup+0x45/0x5f
Jun 10 02:41:53 localhost kernel:    [<c04ea5d8>] kobject_release+0xb/0xd
Jun 10 02:41:53 localhost kernel:    [<c04eb1df>] kref_put+0x63/0x71
Jun 10 02:41:53 localhost kernel:    [<c04ea56c>] kobject_put+0x14/0x16
Jun 10 02:41:53 localhost kernel:    [<c055a37b>] put_device+0x11/0x13
Jun 10 02:41:53 localhost kernel:    [<c055ab1f>] 
device_unregister+0x12/0x15
Jun 10 02:41:53 localhost kernel:    [<f8e02623>] 
ide_unregister+0xa3/0x56e [ide_core]
Jun 10 02:41:53 localhost kernel:    [<f8cae01b>] ide_release+0x1b/0x2d 
[ide_cs]
Jun 10 02:41:53 localhost kernel:    [<f8cae038>] ide_detach+0xb/0x19 
[ide_cs]
Jun 10 02:41:53 localhost kernel:    [<c056697d>] 
pcmcia_device_remove+0x53/0xb9
Jun 10 02:41:53 localhost kernel:    [<c055caf2>] 
__device_release_driver+0x74/0x90
Jun 10 02:41:53 localhost kernel:    [<c055cef4>] 
device_release_driver+0x35/0x4c
Jun 10 02:41:53 localhost kernel:    [<c055c462>] 
bus_remove_device+0x73/0x82
Jun 10 02:41:53 localhost kernel:    [<c055aa97>] device_del+0x218/0x28e
Jun 10 02:41:53 localhost kernel:    [<c055ab18>] device_unregister+0xb/0x15
Jun 10 02:41:53 localhost kernel:    [<c05665a1>] 
pcmcia_card_remove+0x5a/0x7d
Jun 10 02:41:53 localhost kernel:    [<c0566f88>] ds_event+0x59/0x8b
Jun 10 02:41:53 localhost kernel:    [<c0562c20>] send_event+0x3e/0x57
Jun 10 02:41:53 localhost kernel:    [<c0562e0b>] 
socket_remove_drivers+0x12/0x14
Jun 10 02:41:53 localhost kernel:    [<c0562e1c>] socket_shutdown+0xf/0xb5
Jun 10 02:41:53 localhost kernel:    [<c0562ee8>] socket_remove+0x26/0x2b
Jun 10 02:41:53 localhost kernel:    [<c05634b4>] pccardd+0x12a/0x1e6
Jun 10 02:41:53 localhost kernel:    [<c0439600>] kthread+0x3b/0x63
Jun 10 02:41:53 localhost kernel:    [<c0405b13>] 
kernel_thread_helper+0x7/0x10
Jun 10 02:41:53 localhost kernel:    [<ffffffff>] 0xffffffff
Jun 10 02:41:53 localhost kernel:
Jun 10 02:41:53 localhost kernel:
Jun 10 02:41:53 localhost kernel: the soft-irq-unsafe lock's dependencies:
Jun 10 02:41:53 localhost kernel: -> (resource_lock){--..} ops: 0 {
Jun 10 02:41:53 localhost kernel:    initial-use  at:
Jun 10 02:41:53 localhost kernel:                         [<c04441f9>] 
__lock_acquire+0x435/0xb12
Jun 10 02:41:53 localhost kernel:                         [<c0444c97>] 
lock_acquire+0x56/0x6f
Jun 10 02:41:53 localhost kernel:                         [<c0616e5e>] 
_write_lock+0x2b/0x38
Jun 10 02:41:53 localhost kernel:                         [<c042dc60>] 
request_resource+0x13/0x36
Jun 10 02:41:53 localhost kernel:                         [<c05068bb>] 
vgacon_startup+0x196/0x349
Jun 10 02:41:53 localhost kernel:                         [<c075d3d5>] 
con_init+0x1a/0x217
Jun 10 02:41:53 localhost kernel:                         [<c075cee5>] 
console_init+0x19/0x27
Jun 10 02:41:53 localhost kernel:                         [<c07428b5>] 
start_kernel+0x242/0x34c
Jun 10 02:41:53 localhost kernel:                         [<00000000>] 0x0
Jun 10 02:41:53 localhost kernel:                         [<ffffffff>] 
0xffffffff
Jun 10 02:41:53 localhost kernel:    softirq-on-W at:
Jun 10 02:41:53 localhost kernel:                         [<c04441e4>] 
__lock_acquire+0x420/0xb12
Jun 10 02:41:53 localhost kernel:                         [<c0444c97>] 
lock_acquire+0x56/0x6f
Jun 10 02:41:53 localhost kernel:                         [<c0616e5e>] 
_write_lock+0x2b/0x38
Jun 10 02:41:53 localhost kernel:                         [<c042dc60>] 
request_resource+0x13/0x36
Jun 10 02:41:53 localhost kernel:                         [<c05068bb>] 
vgacon_startup+0x196/0x349
Jun 10 02:41:53 localhost kernel:                         [<c075d3d5>] 
con_init+0x1a/0x217
Jun 10 02:41:53 localhost kernel:                         [<c075cee5>] 
console_init+0x19/0x27
Jun 10 02:41:53 localhost kernel:                         [<c07428b5>] 
start_kernel+0x242/0x34c
Jun 10 02:41:53 localhost kernel:                         [<00000000>] 0x0
Jun 10 02:41:53 localhost kernel:                         [<ffffffff>] 
0xffffffff
Jun 10 02:41:53 localhost kernel:    hardirq-on-W at:
Jun 10 02:41:53 localhost kernel:                         [<c04441c0>] 
__lock_acquire+0x3fc/0xb12
Jun 10 02:41:53 localhost kernel:                         [<c0444c97>] 
lock_acquire+0x56/0x6f
Jun 10 02:41:53 localhost kernel:                         [<c0616e5e>] 
_write_lock+0x2b/0x38
Jun 10 02:41:53 localhost kernel:                         [<c042dc60>] 
request_resource+0x13/0x36
Jun 10 02:41:53 localhost kernel:                         [<c05068bb>] 
vgacon_startup+0x196/0x349
Jun 10 02:41:53 localhost kernel:                         [<c075d3d5>] 
con_init+0x1a/0x217
Jun 10 02:41:53 localhost kernel:                         [<c075cee5>] 
console_init+0x19/0x27
Jun 10 02:41:53 localhost kernel:                         [<c07428b5>] 
start_kernel+0x242/0x34c
Jun 10 02:41:53 localhost kernel:                         [<00000000>] 0x0
Jun 10 02:41:53 localhost kernel:                         [<ffffffff>] 
0xffffffff
Jun 10 02:41:53 localhost kernel:  }
Jun 10 02:41:53 localhost kernel:  ... key      at: [<c06fce14>] 
resource_lock+0x10/0x1c
Jun 10 02:41:53 localhost kernel:
Jun 10 02:41:53 localhost kernel: stack backtrace:
Jun 10 02:41:53 localhost kernel:  [<c0405e6a>] show_trace_log_lvl+0x1a/0x2f
Jun 10 02:41:53 localhost kernel:  [<c04068cf>] show_trace+0x12/0x14
Jun 10 02:41:53 localhost kernel:  [<c0406928>] dump_stack+0x16/0x18
Jun 10 02:41:53 localhost kernel:  [<c0443d30>] check_usage+0x258/0x262
Jun 10 02:41:53 localhost kernel:  [<c04446c2>] __lock_acquire+0x8fe/0xb12
Jun 10 02:41:53 localhost kernel:  [<c0444c97>] lock_acquire+0x56/0x6f
Jun 10 02:41:53 localhost kernel:  [<c0616e5e>] _write_lock+0x2b/0x38
Jun 10 02:41:53 localhost kernel:  [<c042dcb2>] __release_region+0x2f/0xdd
Jun 10 02:41:53 localhost kernel:  [<f8e02521>] 
ide_hwif_release_regions+0x37/0x96 [ide_core]
Jun 10 02:41:53 localhost kernel:  [<f8e026a4>] 
ide_unregister+0x124/0x56e [ide_core]
Jun 10 02:41:53 localhost kernel:  [<f8cae01b>] ide_release+0x1b/0x2d 
[ide_cs]
Jun 10 02:41:53 localhost kernel:  [<f8cae038>] ide_detach+0xb/0x19 [ide_cs]
Jun 10 02:41:53 localhost kernel:  [<c056697d>] 
pcmcia_device_remove+0x53/0xb9
Jun 10 02:41:53 localhost kernel:  [<c055caf2>] 
__device_release_driver+0x74/0x90
Jun 10 02:41:53 localhost kernel:  [<c055cef4>] 
device_release_driver+0x35/0x4c
Jun 10 02:41:53 localhost kernel:  [<c055c462>] bus_remove_device+0x73/0x82
Jun 10 02:41:53 localhost kernel:  [<c055aa97>] device_del+0x218/0x28e
Jun 10 02:41:53 localhost kernel:  [<c055ab18>] device_unregister+0xb/0x15
Jun 10 02:41:53 localhost kernel:  [<c05665a1>] pcmcia_card_remove+0x5a/0x7d
Jun 10 02:41:53 localhost kernel:  [<c0566f88>] ds_event+0x59/0x8b
Jun 10 02:41:53 localhost kernel:  [<c0562c20>] send_event+0x3e/0x57
Jun 10 02:41:53 localhost kernel:  [<c0562e0b>] 
socket_remove_drivers+0x12/0x14
Jun 10 02:41:53 localhost kernel:  [<c0562e1c>] socket_shutdown+0xf/0xb5
Jun 10 02:41:53 localhost kernel:  [<c0562ee8>] socket_remove+0x26/0x2b
Jun 10 02:41:53 localhost kernel:  [<c05634b4>] pccardd+0x12a/0x1e6
Jun 10 02:41:53 localhost kernel:  [<c0439600>] kthread+0x3b/0x63
Jun 10 02:41:53 localhost kernel:  [<c0405b13>] 
kernel_thread_helper+0x7/0x10
Jun 10 02:41:53 localhost kernel:  =======================
Jun 10 02:41:53 localhost kernel: BUG: sleeping function called from 
invalid context at kernel/rwsem.c:20
Jun 10 02:41:53 localhost kernel: in_atomic():0, irqs_disabled():1
Jun 10 02:41:53 localhost kernel: INFO: lockdep is turned off.
Jun 10 02:41:53 localhost kernel: irq event stamp: 3798
Jun 10 02:41:53 localhost kernel: hardirqs last  enabled at (3797): 
[<c06171ed>] _spin_unlock_irqrestore+0x36/0x3c
Jun 10 02:41:53 localhost kernel: hardirqs last disabled at (3798): 
[<c0617032>] _spin_lock_irq+0xf/0x3e
Jun 10 02:41:53 localhost kernel: softirqs last  enabled at (3656): 
[<c042d2fa>] __do_softirq+0xe3/0xe9
Jun 10 02:41:53 localhost kernel: softirqs last disabled at (3647): 
[<c0406f72>] do_softirq+0x61/0xc7
Jun 10 02:41:53 localhost kernel:  [<c0405e6a>] show_trace_log_lvl+0x1a/0x2f
Jun 10 02:41:53 localhost kernel:  [<c04068cf>] show_trace+0x12/0x14
Jun 10 02:41:53 localhost kernel:  [<c0406928>] dump_stack+0x16/0x18
Jun 10 02:41:53 localhost kernel:  [<c0422152>] __might_sleep+0xce/0xd5
Jun 10 02:41:53 localhost kernel:  [<c043ca58>] down_read+0x18/0x51
Jun 10 02:41:53 localhost kernel:  [<c04f9066>] pci_get_subsys+0x69/0xe9
Jun 10 02:41:53 localhost kernel:  [<c04f90ff>] pci_get_device+0x19/0x1b
Jun 10 02:41:53 localhost kernel:  [<f8e0223a>] 
init_hwif_default+0x2d/0xf4 [ide_core]
Jun 10 02:41:53 localhost kernel:  [<f8e027c6>] 
ide_unregister+0x246/0x56e [ide_core]
Jun 10 02:41:53 localhost kernel:  [<f8cae01b>] ide_release+0x1b/0x2d 
[ide_cs]
Jun 10 02:41:53 localhost kernel:  [<f8cae038>] ide_detach+0xb/0x19 [ide_cs]
Jun 10 02:41:53 localhost kernel:  [<c056697d>] 
pcmcia_device_remove+0x53/0xb9
Jun 10 02:41:53 localhost kernel:  [<c055caf2>] 
__device_release_driver+0x74/0x90
Jun 10 02:41:53 localhost kernel:  [<c055cef4>] 
device_release_driver+0x35/0x4c
Jun 10 02:41:53 localhost kernel:  [<c055c462>] bus_remove_device+0x73/0x82
Jun 10 02:41:53 localhost kernel:  [<c055aa97>] device_del+0x218/0x28e
Jun 10 02:41:53 localhost kernel:  [<c055ab18>] device_unregister+0xb/0x15
Jun 10 02:41:53 localhost kernel:  [<c05665a1>] pcmcia_card_remove+0x5a/0x7d
Jun 10 02:41:53 localhost kernel:  [<c0566f88>] ds_event+0x59/0x8b
Jun 10 02:41:53 localhost kernel:  [<c0562c20>] send_event+0x3e/0x57
Jun 10 02:41:53 localhost kernel:  [<c0562e0b>] 
socket_remove_drivers+0x12/0x14
Jun 10 02:41:53 localhost kernel:  [<c0562e1c>] socket_shutdown+0xf/0xb5
Jun 10 02:41:53 localhost kernel:  [<c0562ee8>] socket_remove+0x26/0x2b
Jun 10 02:41:53 localhost kernel:  [<c05634b4>] pccardd+0x12a/0x1e6
Jun 10 02:41:53 localhost kernel:  [<c0439600>] kthread+0x3b/0x63
Jun 10 02:41:53 localhost kernel:  [<c0405b13>] 
kernel_thread_helper+0x7/0x10
Jun 10 02:41:53 localhost kernel:  =======================



