Return-Path: <linux-kernel-owner+w=401wt.eu-S1758187AbZJBUpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187AbZJBUpu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 16:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758143AbZJBUpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 16:45:50 -0400
Received: from mbox2.netikka.net ([213.250.81.203]:36700 "EHLO
	mbox2.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756902AbZJBUps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 16:45:48 -0400
Message-ID: <4AC6667F.5070100@mandriva.org>
Date: Fri, 02 Oct 2009 23:45:51 +0300
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090830)
MIME-Version: 1.0
To: Luca Tettamanti <kronos.it@gmail.com>
CC: Robert Hancock <hancockrwd@gmail.com>, Jean Delvare <khali@linux-fr.org>,
       "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "astarikovskiy@suse.de" <astarikovskiy@suse.de>
Subject: Re: [PATCH] asus_atk0110: add support for Asus P7P55D
References: <51f3faa70909282134o1d60efekeded09f09b192df6@mail.gmail.com> <68676e00909290707u70d192f2j2f2d4dd07bd07234@mail.gmail.com> <51f3faa70909290740l4f4df186w114bf48e1db3a948@mail.gmail.com> <4AC21E7B.70000@mandriva.org> <51f3faa70909301638s4eff14edg46420e2e8877fd15@mail.gmail.com> <20091001085002.1dbc7eee@hyperion.delvare> <51f3faa70910010740s2a412d07qf29f56ad8a3c59eb@mail.gmail.com> <20091001144914.GA18675@nb-core2.darkstar.lan> <4AC4D6F5.6080005@mandriva.org> <68676e00910011205t506604e5y5a0a04fec0821dc0@mail.gmail.com> <20091002122636.GA25505@nb-core2.darkstar.lan> <4AC665E4.8060200@mandriva.org>
In-Reply-To: <4AC665E4.8060200@mandriva.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Backlund wrote:
> Luca Tettamanti wrote:
>> On Thu, Oct 01, 2009 at 09:05:36PM +0200, Luca Tettamanti wrote:
>>> On Thu, Oct 1, 2009 at 6:21 PM, Thomas Backlund <tmb@mandriva.org> 
>>> wrote:
>>>>>
>>>> I tried your latest patch on a P7P55D Deluxe and get this:
>>>>> [   10.419119] ACPI Error: Field [PR11] at 64 exceeds Buffer [NULL] 
>>>>> size
>>>>> 32 (bits) (20090903/dsopcode-596)
>>>>> [   10.419125] ACPI Error (psparse-0537): Method parse/execution 
>>>>> failed
>>>>> [\_SB_.PCI0.SBRG.ASOC.GITM] (Node ffff88023f8147a0), 
>>>>> AE_AML_BUFFER_LIMIT
>>>>> [   10.419157] ATK0110 ATK0110:00: GITM[0x11060004] ACPI exception:
>>>>> AE_AML_BUFFER_LIMIT
>>>>> [   10.419158] ATK0110 ATK0110:00: Unable to query EC status
>>>>> [   10.419161] ATK0110: probe of ATK0110:00 failed with error -5
>>> I see. GITM probably expects the same buffer structure as SITM, though
>>> in older models the upper bits were never used (hence I never noticed
>>> the problem). Working on a patch.
>>
>> Ok, here it is:
>>
> 
> no go...
> 

Sorry, forgot to post the full bug:

> [ 2270.697725] BUG: unable to handle kernel NULL pointer dereference at 0000000000000011
> [ 2270.697728] IP: [<ffffffff811cc2f1>] acpi_ut_initialize_buffer+0x5c/0x6c
> [ 2270.697734] PGD 2300a7067 PUD 23641e067 PMD 0 
> [ 2270.697739] Oops: 0002 [#1] PREEMPT SMP 
> [ 2270.697741] last sysfs file: /sys/module/ipv6/initstate
> [ 2270.697742] CPU 3 
> [ 2270.697742] Modules linked in: asus_atk0110(+) af_packet bonding ipv6 binfmt_misc loop xfs exportfs usblp joydev hid_logitech ff_memless usbhid cpufreq_ondemand hid cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table radeon ttm drm_kms_helper drm i2c_algo_bit snd_hda_codec_atihdmi snd_hda_codec_via snd_hda_intel firewire_ohci snd_hda_codec firewire_core crc_itu_t snd_seq_dummy snd_hwdep snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_pcm snd_timer snd_mixer_oss snd ohci1394 soundcore ieee1394 r8169 snd_page_alloc i2c_i801 ehci_hcd i2c_core pcspkr mii serio_raw sr_mod sg wmi rtc_cmos processor button thermal evdev usbcore pata_jmicron dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod ata_piix ahci libata sd_mod scsi_mod crc_t10dif ext4 jbd2 crc16 [last unloaded: scsi_wait_scan]
> [ 2270.697773] Pid: 20267, comm: modprobe Tainted: G        W  2.6.31.1-tmb-desktop-9mdv #1 System Product Name
> [ 2270.697775] RIP: 0010:[<ffffffff811cc2f1>]  [<ffffffff811cc2f1>] acpi_ut_initialize_buffer+0x5c/0x6c
> [ 2270.697777] RSP: 0018:ffff880232d47ba8  EFLAGS: 00010246
> [ 2270.697778] RAX: 0000000000000000 RBX: ffff880232d47c88 RCX: 0000000000000218
> [ 2270.697779] RDX: 0000000000000011 RSI: 0000000000000218 RDI: 0000000000000011
> [ 2270.697780] RBP: ffff880232d47bb8 R08: 0000000000000000 R09: ffff88023f8512d0
> [ 2270.697782] R10: 0000000000000002 R11: 0000000000000000 R12: 0000000000000218
> [ 2270.697783] R13: ffff880232d47c98 R14: ffff880236c42640 R15: ffff880232d47c88
> [ 2270.697784] FS:  00007fb0a9b876f0(0000) GS:ffff88002807f000(0000) knlGS:0000000000000000
> [ 2270.697786] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 2270.697787] CR2: 0000000000000011 CR3: 0000000231479000 CR4: 00000000000006e0
> [ 2270.697788] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 2270.697789] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [ 2270.697791] Process modprobe (pid: 20267, threadinfo ffff880232d46000, task ffff88023e7b4980)
> [ 2270.697792] Stack:
> [ 2270.697792]  0000000000000000 ffff88023f8147c0 ffff880232d47c18 ffffffff811c4a71
> [ 2270.697794] <0> ffff880232d47c28 ffffffff00000000 ffff880238843dd8 0000000000000218
> [ 2270.697796] <0> ffff880232d47c08 ffff880232d47c88 ffff880200000001 ffff88023917f2e0
> [ 2270.697799] Call Trace:
> [ 2270.697802]  [<ffffffff811c4a71>] acpi_evaluate_object+0x191/0x1f2
> [ 2270.697804]  [<ffffffff811c4afa>] acpi_evaluate_object_typed+0x28/0xd2
> [ 2270.697807]  [<ffffffffa04bb30c>] atk_ec_ctl+0x7c/0x220 [asus_atk0110]
> [ 2270.697809]  [<ffffffffa04bb1e9>] ? atk_gitm+0x79/0x120 [asus_atk0110]
> [ 2270.697811]  [<ffffffffa04bc1b2>] atk_add+0x232/0x72c [asus_atk0110]
> [ 2270.697814]  [<ffffffff81128d0b>] ? sysfs_do_create_link+0xcb/0x170
> [ 2270.697818]  [<ffffffff811aee48>] acpi_device_probe+0x4b/0x11d
> [ 2270.697821]  [<ffffffff812070e6>] driver_probe_device+0x86/0x180
> [ 2270.697823]  [<ffffffff812071e0>] ? __driver_attach+0x0/0xa0
> [ 2270.697825]  [<ffffffff81207273>] __driver_attach+0x93/0xa0
> [ 2270.697826]  [<ffffffff812071e0>] ? __driver_attach+0x0/0xa0
> [ 2270.697828]  [<ffffffff81206658>] bus_for_each_dev+0x68/0x90
> [ 2270.697830]  [<ffffffff81206f49>] driver_attach+0x19/0x20
> [ 2270.697832]  [<ffffffff812068f8>] bus_add_driver+0xb8/0x250
> [ 2270.697833]  [<ffffffff81207568>] driver_register+0x78/0x140
> [ 2270.697835]  [<ffffffffa016c000>] ? atk0110_init+0x0/0x31 [asus_atk0110]
> [ 2270.697837]  [<ffffffff811af6bf>] acpi_bus_register_driver+0x3e/0x40
> [ 2270.697839]  [<ffffffffa016c015>] atk0110_init+0x15/0x31 [asus_atk0110]
> [ 2270.697845]  [<ffffffff81009047>] do_one_initcall+0x37/0x1a0
> [ 2270.697848]  [<ffffffff81071cc9>] sys_init_module+0xd9/0x230
> [ 2270.697850]  [<ffffffff8100bf2b>] system_call_fastpath+0x16/0x1b
> [ 2270.697851] Code: eb 0e 4c 89 e7 e8 a3 ff ff ff 48 89 43 08 eb 05 48 39 f0 72 1c 48 8b 53 08 b8 04 00 00 00 48 85 d2 74 13 31 c0 48 89 d7 4c 89 e1 <f3> aa 31 c0 eb 05 b8 0b 00 00 00 5b 41 5c c9 c3 55 48 8b 3d 27 
> [ 2270.697867] RIP  [<ffffffff811cc2f1>] acpi_ut_initialize_buffer+0x5c/0x6c
> [ 2270.697870]  RSP <ffff880232d47ba8>
> [ 2270.697870] CR2: 0000000000000011
> [ 2270.697957] ---[ end trace f03c8442c43e630d ]---

--
Thomas
