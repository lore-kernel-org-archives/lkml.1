Return-Path: <linux-kernel-owner+w=401wt.eu-S1752468AbYG3EQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbYG3EQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 00:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750860AbYG3EQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 00:16:24 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:60521 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750767AbYG3EQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 00:16:23 -0400
To: linux-kernel@vger.kernel.org
Subject: Oops in 2.6.26-rc1: in kernel/sched.c:sched_power_savings_store()
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
Message-Id: <E1KO36q-0004K6-DL@closure.thunk.org>
Date: Wed, 30 Jul 2008 00:16:20 -0400
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here is the dmesg; the oops seems to be from this shell script (see
below) when writing to /sys/devices/system/cpu/sched_mc_power_savings.

       	    					- Ted

[   44.145128] [drm] Initialized i915 1.6.0 20060119 on minor 0
[   44.940413] mtrr: type mismatch for e0000000,10000000 old: write-back new: write-combining
[   53.008495] input: Virtual ThinkFinger Keyboard as /class/input/input10
[   66.063378] BUG: unable to handle kernel NULL pointer dereference at 00000002
[   66.063394] IP: [<c0123016>] sched_power_savings_store+0x7/0x49
[   66.063410] *pdpt = 000000002c5b7001 *pde = 0000000000000000 
[   66.063426] Oops: 0000 [#1] SMP 
[   66.063436] Modules linked in: i915 drm nfsd auth_rpcgss exportfs kvm_intel kvm autofs4 sbshc pci_slot container wmi cpufreq_stats cpufreq_conservative cpufreq_userspace cpufreq_powersave nfs lockd sunrpc iptable_filter ip_tables x_tables deflate zlib_deflate ctr twofish twofish_common camellia serpent blowfish des_generic cbc aes_i586 aes_generic xcbc rmd160 sha256_generic sha1_generic crypto_null crypto_blkcipher af_key ext3 jbd uinput acpi_cpufreq loop snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_hwdep serio_raw snd_seq_dummy psmouse snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq battery shpchp snd_timer pci_hotplug snd_seq_device snd soundcore video output button intel_agp thinkpad_acpi evdev rfkill led_class nvram ide_pci_generic piix ide_core sg sd_mod crc_t10dif ata_piix ata_generic ahci libata scsi_mod dock dm_mirror dm_log dm_snapshot dm_mod thermal processor fan fuse ext4dev mbcache jbd2 crc16
[   66.063586] 
[   66.063590] Pid: 8095, comm: sched-powersave Not tainted (2.6.27-rc1-00041-g12d06f6 #34)
[   66.063594] EIP: 0060:[<c0123016>] EFLAGS: 00010246 CPU: 0
[   66.063601] EIP is at sched_power_savings_store+0x7/0x49
[   66.063605] EAX: 00000002 EBX: c012306c ECX: 00000000 EDX: c0400938
[   66.063608] ESI: c0400938 EDI: ec568000 EBP: ec56cf28 ESP: ec56cf20
[   66.063612]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[   66.063616] Process sched-powersave (pid: 8095, ti=ec56c000 task=ec5dc5c0 task.ti=ec56c000)
[   66.063619] Stack: c012306c c0400cdc ec56cf30 c012307b ec56cf44 c02647f3 c0400938 f740b6f0 
[   66.063633]        00000002 ec56cf74 c01cef23 00000002 00000002 080fc408 ec56e540 f5445814 
[   66.063645]        c0400938 c0400cdc 00000002 ec56e540 080fc408 ec56cf90 c0191df7 ec56cf9c 
[   66.063658] Call Trace:
[   66.063664]  [<c012306c>] ? sched_mc_power_savings_store+0x0/0x11
[   66.063673]  [<c012307b>] ? sched_mc_power_savings_store+0xf/0x11
[   66.063681]  [<c02647f3>] ? sysdev_class_store+0x25/0x2a
[   66.063690]  [<c01cef23>] ? sysfs_write_file+0xbd/0xe8
[   66.063698]  [<c0191df7>] ? vfs_write+0x7f/0xaf
[   66.063706]  [<c01cee66>] ? sysfs_write_file+0x0/0xe8
[   66.063713]  [<c0191ec5>] ? sys_write+0x40/0x62
[   66.063720]  [<c0103a63>] ? sysenter_do_call+0x12/0x3f
[   66.063728]  =======================
[   66.063731] Code: 40 ba 34 c6 3e c0 e8 43 c4 0a 00 5b 5d c3 55 89 e5 e8 ef 6f 00 00 e8 b8 57 03 00 e8 2d 70 00 00 31 c0 5d c3 55 89 e5 56 89 d6 53 <8a> 10 89 cb b9 ea ff ff ff 8d 42 d0 3c 01 77 2c 85 db 74 0f 31 
[   66.063814] EIP: [<c0123016>] sched_power_savings_store+0x7/0x49 SS:ESP 0068:ec56cf20
[   66.063830] ---[ end trace 82b9c50266b3c24a ]---


------------------- Begin /usr/lib/pm-utils/power.d/sched-powersave
#!/bin/bash

path_mc="/sys/devices/system/cpu/sched_mc_power_savings"
path_smp="/sys/devices/system/cpu/sched_smp_power_savings"
val=0

case "$1" in
	true)
		echo "**sched policy powersave ON"
		val=1
		;;
	false)
		echo "**sched policy powersave OFF"
		val=0
		;;
esac

# Based on the values (1-enable, 0-disable) for these controls,
# sched groups cpu power will be determined for different domains.
# When power savings policy is enabled and under light load conditions,
# scheduler will minimize the physical packages/cpu cores carrying the
# load and thus conserving power

if [ -w "$path_mc" ] ; then
	echo $val > $path_mc
fi
if [ -w "$path_smp" ] ; then
	echo $val > $path_smp
fi

exit 0
------------------- End /usr/lib/pm-utils/power.d/sched-powersave
