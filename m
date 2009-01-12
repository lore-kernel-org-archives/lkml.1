Return-Path: <linux-kernel-owner+w=401wt.eu-S1753374AbZALCui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbZALCui (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 21:50:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbZALCu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 21:50:29 -0500
Received: from vms044pub.verizon.net ([206.46.252.44]:55360 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbZALCu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 21:50:27 -0500
Date: Sun, 11 Jan 2009 21:50:16 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Linux 2.6.29-rc1 MAJOR advisory
In-reply-to: <64bb37e0901111306sf1efbachbeb5ad523fa17e26@mail.gmail.com>
To: "Torsten Kaiser" <just.for.lkml@googlemail.com>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Message-id: <200901112150.16108.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <alpine.LFD.2.00.0901101551420.6528@localhost.localdomain>
 <200901111510.30064.gene.heskett@gmail.com>
 <64bb37e0901111306sf1efbachbeb5ad523fa17e26@mail.gmail.com>
User-Agent: KMail/1.9.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 January 2009, Torsten Kaiser wrote:
>On Sun, Jan 11, 2009 at 9:10 PM, Gene Heskett <gene.heskett@gmail.com> wrote:
>> I don't believe it is.  MAJOR problem. I have an ASUS M2N-SLI Deluxe
>> motherboard I paid about $275 for in late Sept 2008, and one attempt to
>> boot the 2.6.29-rc1 I had built destroyed the MCP55 eth0 port, no power on
>> the port at all now, and I've rebooted to 2.6.28, still no eth0, so I have
>> now enabled in the bios and am using the 2nd & last eth1 port on this
>> mobo.
>
>I have also an ASUS MCP55 board, a KFN5-D.
>
>To save the crash I reported in the "[git pull] x86 fixes" thread, I
>had to boot the patch -rc1 a second time.
>After saving the Oops on my second pc I rebooted my test system (the
>one with the MCP55) into 2.6.28 and the boot process hung as it wanted
>to mount its NFS filesystems. Trying to connect from the second system
>failed, not even a ping reply.
>But: Just removing the ethernet cable and immediately reconnecting it
>seemed to have kicked my MCP55 ethernet port back in working order.
>
I unplugged it and plugged it back in a couple of times.  Absolutely NO led 
activity in the connector was observed, but since this board has 2 ethernet 
ports, the other port lit up like the 4th of July when I stuck the cable 
into it.  So I rebooted, and enabled that port in the bios, then booted 2.6.28, 
copied /etc/sysconfig/network-scripts/ifcfg-eth0 to ifcfg-eth1, edited it to 
call itself eth1 without even changing the mac address, did a 
'service network restart' which reported a failure downing eth0, then another 
upping it, and success upping eth1.  Pinged yahoo, works.

I will call my friend at the shop where I bought all this and see if he can 
arrange a preship of another board since ASUS has a years warranty.  But to 
me, its pretty fishy that it was working normally when I shut down 2.6.28, 
failed on the boot to 2.6.29-rc1, twice, and was still dead when 2.6.28
was rebooted.  That points an awfully straight and strong finger at 2.6.29-rc1.

>No fishy things in the syslog...

As you can see in the dmesg I attached, I had problems from the gitgo.
But just for grins, I'll check messages too, for the first boot, hang on a sec.

First was the usual your bios is crap, fixing it notice, then:
Jan 11 14:15:13 coyote kernel: [    0.000000] ACPI: RSDP 000F7D20, 0024 (r2 Nvidia)
Jan 11 14:15:13 coyote kernel: [    0.000000] ACPI: XSDT DFEE3100, 004C (r1 Nvidia ASUSACPI 42302E31 AWRD        
0)
Jan 11 14:15:13 coyote kernel: [    0.000000] ACPI: FACP DFEEADC0, 00F4 (r3 Nvidia ASUSACPI 42302E31 AWRD        
0)
Jan 11 14:15:13 coyote kernel: [    0.000000] ACPI Warning (tbfadt-0568): 32/64X length mismatch in 
Pm1aEventBlock: 32/8 [20081204]
Jan 11 14:15:13 coyote kernel: [    0.000000] ACPI Warning (tbfadt-0568): 32/64X length mismatch in 
Pm1aControlBlock: 16/8 [20081204]
Jan 11 14:15:13 coyote kernel: [    0.000000] ACPI Warning (tbfadt-0568): 32/64X length mismatch in 
PmTimerBlock: 32/8 [20081204]
Jan 11 14:15:13 coyote kernel: [    0.000000] ACPI Warning (tbfadt-0568): 32/64X length mismatch in Gpe0Block: 
64/8 [20081204]
Jan 11 14:15:13 coyote kernel: [    0.000000] ACPI Warning (tbfadt-0568): 32/64X length mismatch in Gpe1Block: 
128/8 [20081204]
Jan 11 14:15:13 coyote kernel: [    0.000000] ACPI Warning (tbfadt-0412): Invalid length for Pm1aEventBlock: 8, 
using default 32 [20081204]
Jan 11 14:15:13 coyote kernel: [    0.000000] ACPI Warning (tbfadt-0412): Invalid length for Pm1aControlBlock: 
8, using default 16 [20081204]
Jan 11 14:15:13 coyote kernel: [    0.000000] ACPI Warning (tbfadt-0412): Invalid length for PmTimerBlock: 8, 
using default 32 [20081204]
Jan 11 14:15:13 coyote kernel: [    0.000000] FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN 
(4)

No idea what that means.  Then:

Jan 11 14:15:13 coyote kernel: [   18.231132] BUG: unable to handle kernel NULL pointer dereference at (null)
Jan 11 14:15:13 coyote kernel: [   18.231202] IP: [<c05fe336>] __mutex_lock_slowpath+0x26/0x90
Jan 11 14:15:13 coyote kernel: [   18.231253] *pdpt = 000000003651f001 *pde = 0000000000000000
Jan 11 14:15:13 coyote kernel: [   18.231257] Oops: 0002 [#1] PREEMPT SMP
Jan 11 14:15:13 coyote kernel: [   18.231341] last sysfs 
file: /sys/devices/pci0000:00/0000:00:06.0/0000:01:08.0/video4linux/radio0/dev
Jan 11 14:15:13 coyote kernel: [   18.231370] Modules linked in: cx88_dvb(+) videobuf_dvb dvb_core tuner_simple 
tuner_types tda9887 tda8290 snd_hda_intel(+) snd_seq_dummy snd_hda_codec tuner snd_emu10k1 snd_seq_oss(+) 
snd_seq_midi_event snd_rawmidi snd_seq cx8800 snd_ac97_codec cx8802 cx88xx snd_pcm_oss ac97_bus snd_mixer_oss 
snd_seq_device snd_pcm ir_common snd_util_mem v4l2_common i2c_algo_bit snd_hwdep videodev snd_timer snd 
v4l1_compat tveeprom btcx_risc firewire_ohci videobuf_dma_sg snd_page_alloc firewire_core floppy videobuf_core 
forcedeth ftdi_sio crc_itu_t pcspkr soundcore sg sr_mod cdrom usblp usbserial evdev joydev i2c_nforce2 
parport_pc i2c_core parport button ahci pata_jmicron sata_nv pata_amd libata sd_mod scsi_mod ext3 jbd mbcache 
uhci_hcd ohci_hcd ehci_hcd [last unloaded: scsi_wait_scan]
Jan 11 14:15:13 coyote kernel: [   18.232006]
Jan 11 14:15:13 coyote kernel: [   18.232006] Pid: 1724, comm: modprobe Tainted: G        W  (2.6.29-rc1 #1) 
System Product Name
Jan 11 14:15:13 coyote kernel: [   18.232006] EIP: 0060:[<c05fe336>] EFLAGS: 00010246 CPU: 0
Jan 11 14:15:13 coyote kernel: [   18.232006] EIP is at __mutex_lock_slowpath+0x26/0x90
Jan 11 14:15:13 coyote kernel: [   18.232006] EAX: f6d97b08 EBX: f6d97b04 ECX: 00000086 EDX: 00000000
Jan 11 14:15:13 coyote kernel: [   18.232006] ESI: f6d97b08 EDI: f6d97b0c EBP: f6af2a90 ESP: f640ae7c
Jan 11 14:15:13 coyote kernel: [   18.232006]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Jan 11 14:15:13 coyote kernel: [   18.232006] Process modprobe (pid: 1724, ti=f640a000 task=f6af2a90 
task.ti=f640a000)
Jan 11 14:15:13 coyote kernel: [   18.232006] Stack:
Jan 11 14:15:13 coyote kernel: [   18.232006]  f6d97b0c f640aea2 c0660242 f6d97afc f6984000 00000001 f6d97b04 
c05fe19a
Jan 11 14:15:13 coyote kernel: [   18.232006]  f8404122 ffffffed f6984000 00000001 f6d97a04 f8408453 f840b0a4 
f6984010
Jan 11 14:15:13 coyote kernel: [   18.232006]  00000042 205b4138 38312020 3133322e 5d323131 f6984010 f6d97a00 
f8408150
Jan 11 14:15:13 coyote kernel: [   18.232006] Call Trace:
Jan 11 14:15:13 coyote kernel: [   18.232006]  [<c05fe19a>] mutex_lock+0xa/0x10
Jan 11 14:15:13 coyote kernel: [   18.232006]  [<f8404122>] videobuf_dvb_get_frontend+0x12/0x60 [videobuf_dvb]
Jan 11 14:15:13 coyote kernel: [   18.232006]  [<f8408453>] cx8802_dvb_probe+0xe3/0x1e00 [cx88_dvb]
Jan 11 14:15:13 coyote kernel: [   18.232006]  [<f8408150>] cx8802_dvb_remove+0x0/0x60 [cx88_dvb]
Jan 11 14:15:13 coyote kernel: [   18.232006]  [<f8408370>] cx8802_dvb_probe+0x0/0x1e00 [cx88_dvb]
Jan 11 14:15:13 coyote kernel: [   18.232006]  [<f858c534>] cx8802_register_driver+0x1a4/0x1f0 [cx8802]
Jan 11 14:15:13 coyote kernel: [   18.232006]  [<f840a210>] dvb_init+0x0/0x40 [cx88_dvb]
Jan 11 14:15:13 coyote kernel: [   18.232006]  [<c0401032>] _stext+0x32/0x170
Jan 11 14:15:13 coyote kernel: [   18.232006]  [<c042146a>] enqueue_task_fair+0x1a/0x40
Jan 11 14:15:13 coyote kernel: [   18.232006]  [<c041f2f3>] resched_task+0x53/0x60
Jan 11 14:15:13 coyote kernel: [   18.232006]  [<c04224d6>] try_to_wake_up+0xd6/0x160
Jan 11 14:15:13 coyote kernel: [   18.232006]  [<c044d637>] sys_init_module+0x87/0x1b0
Jan 11 14:15:13 coyote kernel: [   18.232006]  [<c044d637>] sys_init_module+0x87/0x1b0
Jan 11 14:15:13 coyote kernel: [   18.232006]  [<c04878f1>] sys_read+0x41/0x70
Jan 11 14:15:13 coyote kernel: [   18.232006]  [<c04032ed>] sysenter_do_call+0x12/0x21
Jan 11 14:15:13 coyote kernel: [   18.232006] Code: b6 00 00 00 00 55 57 56 53 89 c3 8d 70 04 83 ec 0c 89 f0 64 
8b 2d 00 c0 72 c0 e8 06 10 00 00 8d 7b 08 8b 57 04 89 3c 24 89 67 04 <89> 22 89 54 24 04 ba ff ff ff ff 89 6c 
24 08 89 d0 87 03 83 e8
Jan 11 14:15:13 coyote kernel: [   18.232006] EIP: [<c05fe336>] __mutex_lock_slowpath+0x26/0x90 SS:ESP 
0068:f640ae7c
Jan 11 14:15:13 coyote kernel: [   18.237335] ---[ end trace 4eaa2a86a8e2da24 ]---

Now the above claims I am 'tainted' but I am not.

But it was up for about 4 minutes and from the log, I had a network, ntpd reported
sync status as good:

Jan 11 14:15:44 coyote smartd[3089]: smartd has fork()ed into background mode. New PID=3089.
Jan 11 14:19:32 coyote ntpd[2500]: synchronized to 204.9.136.253, stratum 2
Jan 11 14:19:32 coyote ntpd[2500]: kernel time sync status change 0001
Jan 11 14:19:38 coyote shutdown[3256]: shutting down for system reboot

So the first boot worked!  Long enough for ntpd, but once logged in, I had no 
network, and the leds on the port were dark.  Hence the 2nd reboot.

Then the next one, again to 2.6.29-rc1 had another Oops:

Jan 11 14:20:57 coyote kernel: [   18.057070] *pdpt = 0000000036859001 *pde = 0000000000000000
Jan 11 14:20:57 coyote kernel: [   18.057074] Oops: 0002 [#1] PREEMPT SMP
Jan 11 14:20:57 coyote kernel: [   18.057158] last sysfs 
file: /sys/devices/pci0000:00/0000:00:06.0/0000:01:0b.0/fw0/dev
Jan 11 14:20:57 coyote kernel: [   18.057185] Modules linked in: cx88_dvb(+) snd_emu10k1_synth videobuf_dvb 
dvb_core tuner_simple tuner_types tda9887 tda8290 tuner snd_emux_synth snd_seq_virmidi snd_seq_midi_emul 
snd_emu10k1 snd_rawmidi snd_ac97_codec snd_hda_intel(+) snd_hda_codec snd_seq_dummy ac97_bus snd_seq_oss(+) 
snd_seq_midi_event snd_seq cx8800 cx8802 snd_pcm_oss cx88xx snd_mixer_oss snd_pcm ir_common snd_seq_device 
v4l2_common videodev i2c_algo_bit snd_util_mem v4l1_compat tveeprom firewire_ohci snd_hwdep btcx_risc snd_timer 
videobuf_dma_sg firewire_core snd videobuf_core ftdi_sio floppy forcedeth snd_page_alloc crc_itu_t soundcore 
usbserial sr_mod pcspkr sg usblp parport_pc cdrom evdev joydev i2c_nforce2 parport i2c_core button ahci 
pata_jmicron sata_nv pata_amd libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last 
unloaded: scsi_wait_scan]
Jan 11 14:20:57 coyote kernel: [   18.057379]
Jan 11 14:20:57 coyote kernel: [   18.057379] Pid: 1780, comm: modprobe Tainted: G        W  (2.6.29-rc1 #1) 
System Product Name
Jan 11 14:20:57 coyote kernel: [   18.057379] EIP: 0060:[<c05fe336>] EFLAGS: 00010246 CPU: 3
Jan 11 14:20:57 coyote kernel: [   18.057379] EIP is at __mutex_lock_slowpath+0x26/0x90
Jan 11 14:20:57 coyote kernel: [   18.057379] EAX: f64eb308 EBX: f64eb304 ECX: 00000086 EDX: 00000000
Jan 11 14:20:57 coyote kernel: [   18.057379] ESI: f64eb308 EDI: f64eb30c EBP: f76158d0 ESP: f6464e7c
Jan 11 14:20:57 coyote kernel: [   18.057379]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Jan 11 14:20:57 coyote kernel: [   18.057379] Process modprobe (pid: 1780, ti=f6464000 task=f76158d0 
task.ti=f6464000)
Jan 11 14:20:57 coyote kernel: [   18.057379] Stack:
Jan 11 14:20:57 coyote kernel: [   18.057379]  f64eb30c f6464ea2 c0660242 f64eb2fc f691c800 00000001 f64eb304 
c05fe19a
Jan 11 14:20:57 coyote kernel: [   18.057379]  f845a122 ffffffed f691c800 00000001 f64eb204 f9644453 f96470a4 
f691c810
Jan 11 14:20:57 coyote kernel: [   18.057379]  00000042 205b5138 38312020 3635302e 5d303339 f691c810 f64eb200 
f9644150
Jan 11 14:20:57 coyote kernel: [   18.057379] Call Trace:
Jan 11 14:20:57 coyote kernel: [   18.057379]  [<c05fe19a>] mutex_lock+0xa/0x10
Jan 11 14:20:57 coyote kernel: [   18.057379]  [<f845a122>] videobuf_dvb_get_frontend+0x12/0x60 [videobuf_dvb]
Jan 11 14:20:57 coyote kernel: [   18.057379]  [<f9644453>] cx8802_dvb_probe+0xe3/0x1e00 [cx88_dvb]
Jan 11 14:20:57 coyote kernel: [   18.057379]  [<f9644150>] cx8802_dvb_remove+0x0/0x60 [cx88_dvb]
Jan 11 14:20:57 coyote kernel: [   18.057379]  [<f9644370>] cx8802_dvb_probe+0x0/0x1e00 [cx88_dvb]
Jan 11 14:20:57 coyote kernel: [   18.057379]  [<f843c534>] cx8802_register_driver+0x1a4/0x1f0 [cx8802]
Jan 11 14:20:57 coyote kernel: [   18.057379]  [<f9646210>] dvb_init+0x0/0x40 [cx88_dvb]
Jan 11 14:20:57 coyote kernel: [   18.057379]  [<c0401032>] _stext+0x32/0x170
Jan 11 14:20:57 coyote kernel: [   18.057379]  [<c042146a>] enqueue_task_fair+0x1a/0x40
Jan 11 14:20:57 coyote kernel: [   18.057379]  [<c041f2f3>] resched_task+0x53/0x60
Jan 11 14:20:57 coyote kernel: [   18.057379]  [<c04224d6>] try_to_wake_up+0xd6/0x160
Jan 11 14:20:57 coyote kernel: [   18.057379]  [<c044d637>] sys_init_module+0x87/0x1b0
Jan 11 14:20:57 coyote kernel: [   18.057379]  [<c04878f1>] sys_read+0x41/0x70
Jan 11 14:20:57 coyote kernel: [   18.057379]  [<c04032ed>] sysenter_do_call+0x12/0x21
Jan 11 14:20:57 coyote kernel: [   18.057379] Code: b6 00 00 00 00 55 57 56 53 89 c3 8d 70 04 83 ec 0c 89 f0 64 
8b 2d 00 c0 72 c0 e8 06 10 00 00 8d 7b 08 8b 57 04 89 3c 24 89 67 04 <89> 22 89 54 24 04 ba ff ff ff ff 89 6c 
24 08 89 d0 87 03 83 e8
Jan 11 14:20:57 coyote kernel: [   18.057379] EIP: [<c05fe336>] __mutex_lock_slowpath+0x26/0x90 SS:ESP 
0068:f6464e7c
Jan 11 14:20:57 coyote kernel: [   18.063279] ---[ end trace 4eaa2a86a8e2da24 ]---
Jan 11 14:20:57 coyote kernel: [   18.063340] note: modprobe[1780] exited with preempt_count 1
Jan 11 14:20:57 coyote kernel: [   18.063411] BUG: scheduling while atomic: modprobe/1780/0x10000002
Jan 11 14:20:57 coyote kernel: [   18.063472] Modules linked in: cx88_dvb(+) snd_emu10k1_synth videobuf_dvb 
dvb_core tuner_simple tuner_types tda9887 tda8290 tuner snd_emux_synth snd_seq_virmidi snd_seq_midi_emul 
snd_emu10k1 snd_rawmidi snd_ac97_codec snd_hda_intel(+) snd_hda_codec snd_seq_dummy ac97_bus snd_seq_oss(+) 
snd_seq_midi_event snd_seq cx8800 cx8802 snd_pcm_oss cx88xx snd_mixer_oss snd_pcm ir_common snd_seq_device 
v4l2_common videodev i2c_algo_bit snd_util_mem v4l1_compat tveeprom firewire_ohci snd_hwdep btcx_risc snd_timer 
videobuf_dma_sg firewire_core snd videobuf_core ftdi_sio floppy forcedeth snd_page_alloc crc_itu_t soundcore 
usbserial sr_mod pcspkr sg usblp parport_pc cdrom evdev joydev i2c_nforce2 parport i2c_core button ahci 
pata_jmicron sata_nv pata_amd libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last 
unloaded: scsi_wait_scan]
Jan 11 14:20:57 coyote kernel: [   18.065501] Pid: 1780, comm: modprobe Tainted: G      D W  2.6.29-rc1 #1
Jan 11 14:20:57 coyote kernel: [   18.065554] Call Trace:
Jan 11 14:20:57 coyote kernel: [   18.065614]  [<c05fdbdc>] schedule+0x66c/0x790
Jan 11 14:20:57 coyote kernel: [   18.065674]  [<c044624d>] tick_dev_program_event+0x3d/0xc0
Jan 11 14:20:57 coyote kernel: [   18.065737]  [<c047bc9d>] free_pages_and_swap_cache+0x8d/0xb0
Jan 11 14:20:57 coyote kernel: [   18.065799]  [<c04240e3>] __cond_resched+0x13/0x30
Jan 11 14:20:57 coyote kernel: [   18.065853]  [<c05fde47>] _cond_resched+0x27/0x30
Jan 11 14:20:57 coyote kernel: [   18.065913]  [<c04708fb>] unmap_vmas+0x7ab/0x7e0
Jan 11 14:20:57 coyote kernel: [   18.065976]  [<c042d1f5>] irq_exit+0x45/0x50
Jan 11 14:20:57 coyote kernel: [   18.066038]  [<c0474c6e>] exit_mmap+0x8e/0x150
Jan 11 14:20:57 coyote kernel: [   18.066100]  [<c0426723>] mmput+0x33/0xa0
Jan 11 14:20:57 coyote kernel: [   18.066160]  [<c042a026>] exit_mm+0xc6/0xf0
Jan 11 14:20:57 coyote kernel: [   18.06621Jan 11 14:20:57 coyote kernel: [   18.066267]  [<c04066f0>] 
oops_begin+0x0/0x90
Jan 11 14:20:57 coyote kernel: [   18.066325]  [<c041831c>] do_page_fault+0x1ec/0x830
Jan 11 14:20:57 coyote kernel: [   18.066391]  [<c044046a>] sched_clock_cpu+0x12a/0x180
Jan 11 14:20:57 coyote kernel: [   18.066445]  [<c0418130>] do_page_fault+0x0/0x830
Jan 11 14:20:57 coyote kernel: [   18.066511]  [<c05ff9a2>] error_code+0x72/0x78
Jan 11 14:20:57 coyote kernel: [   18.066564]  [<c05fe336>] __mutex_lock_slowpath+0x26/0x90
Jan 11 14:20:57 coyote kernel: [   18.066623]  [<c05fe19a>] mutex_lock+0xa/0x10
Jan 11 14:20:57 coyote kernel: [   18.066684]  [<f845a122>] videobuf_dvb_get_frontend+0x12/0x60 [videobuf_dvb]
Jan 11 14:20:57 coyote kernel: [   18.066740]  [<f9644453>] cx8802_dvb_probe+0xe3/0x1e00 [cx88_dvb]
Jan 11 14:20:57 coyote kernel: [   18.066812]  [<f9644150>] cx8802_dvb_remove+0x0/0x60 [cx88_dvb]
Jan 11 14:20:57 coyote kernel: [   18.066867]  [<f9644370>] cx8802_dvb_probe+0x0/0x1e00 [cx88_dvb]
Jan 11 14:20:57 coyote kernel: [   18.066935]  [<f843c534>] cx8802_register_driver+0x1a4/0x1f0 [cx8802]
Jan 11 14:20:57 coyote kernel: [   18.067005]  [<f9646210>] dvb_init+0x0/0x40 [cx88_dvb]
Jan 11 14:20:57 coyote kernel: [   18.067059]  [<c0401032>] _stext+0x32/0x170
Jan 11 14:20:57 coyote kernel: [   18.067119]  [<c042146a>] enqueue_task_fair+0x1a/0x40
Jan 11 14:20:57 coyote kernel: [   18.067181]  [<c041f2f3>] resched_task+0x53/0x60
Jan 11 14:20:57 coyote kernel: [   18.067240]  [<c04224d6>] try_to_wake_up+0xd6/0x160
Jan 11 14:20:57 coyote kernel: [   18.067314]  [<c044d637>] sys_init_module+0x87/0x1b0
Jan 11 14:20:57 coyote kernel: [   18.067369]  [<c04878f1>] sys_read+0x41/0x70
Jan 11 14:20:57 coyote kernel: [   18.067436]  [<c04032ed>] sysenter_do_call+0x12/0x212]  [<c042b476>] 
do_exit+0x106/0x7d0

And again it claims I'm tainted.  There are no proprietary drivers in use
that I'm aware of.

Then, just about 10 lines later:
Jan 11 14:20:57 coyote kernel: [   22.214383] eth0: no link during initialization.
Jan 11 14:20:57 coyote kernel: [   23.784997] eth0: link up.

But it wasn't. ifconfig said it was, but no pings worked.  So I fixed the 
ifcfg-eth1 script to run, rebooted, enabling the other port in the bios as I 
did so, and here I am.  The one thing I haven't done is a full powerdown, 
which is next.

And I have now done that full powerdown reset, but the eth0 port is still dark
and powerless.

And this is all that showed up in dmesg's output when I moved the cable back
for a few seconds:

[  135.940984] eth1: link down.
[  145.266298] eth1: link up.

No note that a cable had been plugged into eth0. But it was.

This could be a 'co-inky dance', but my almost 60 years in electronics 
troubleshooting says there is a connection.

I sure won't reboot to 2.6.29-rc1 again until I have a replacement
motherboard sitting next to me, I don't want to wreck the last port
cuz I have no slots left to stick a nic in this one.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
I surely do hope that's a syntax error.
             -- Larry Wall in <199710011752.KAA21624@wall.org>
