Return-Path: <linux-kernel-owner+w=401wt.eu-S1755483AbYJIIaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbYJIIaG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 04:30:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490AbYJII3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 04:29:54 -0400
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:4408 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbYJII3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 04:29:52 -0400
Date: Thu, 9 Oct 2008 10:29:50 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: linux-kernel@vger.kernel.org
Subject: [2.6.27-rc7] oops in usbcore
Message-ID: <20081009082946.GG23933@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Reply-By: Wed Sep 24 12:11:28 CEST 2008
X-Message-Flag: MultiTail - tail on steroids
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I got the following oops:

[  135.687646] BUG: unable to handle kernel paging request at f88643c8
[  135.687654] IP: [<f883c70a>] :usbcore:unlink1+0xab/0xb9
[  135.687703] *pde = 34824067 *pte = 00000000 
[  135.687710] Oops: 0000 [#1] 
[  135.687715] Modules linked in: sata_via via_rng cpufreq_userspace snd_usb_audio snd_via82xx snd_mpu401_uart ff_memless i2c_viapro snd_hwdep snd_hda_intel dm_snapshot psmouse parport_pc cpufreq_powersave ide_pci_generic fan ppdev parport tun cpufreq_ondemand ipv6 nls_utf8 cifs nls_base nfsd auth_rpcgss exportfs nfs lockd nfs_acl sunrpc freq_table crypto_blkcipher aes_generic rng_core snd_pcm_oss snd_mixer_oss rfcomm l2cap bluetooth gameport snd_ac97_codec ac97_bus hwmon_vid firewire_sbp2 firewire_core crc_itu_t cdrom serio_raw snd_pcm snd_usb_lib snd_timer snd_page_alloc snd_rawmidi snd_seq_device videodev ftdi_sio v4l1_compat snd soundcore i2c_core hid usbserial pci_hotplug via_agp agpgart evdev ext3 jbd mbcache dm_mirror dm_log dm_mod ide_disk libata scsi_mod dock via_rhine mii via82cxxx usbcore ide_core via_velocity crc_ccitt processor thermal_sys [last unloaded: ehci_hcd]
[  135.687798] 
[  135.687803] Pid: 3589, comm: lpc-ntpd Not tainted (2.6.27-rc7-c7-c7temp-100hz-ch341 #1)
[  135.687809] EIP: 0060:[<f883c70a>] EFLAGS: 00010286 CPU: 0
[  135.687841] EIP is at unlink1+0xab/0xb9 [usbcore]
[  135.687846] EAX: f4b62000 EBX: f8864394 ECX: fffffffe EDX: f74a4d40
[  135.687851] ESI: f4b62000 EDI: f74a4d40 EBP: f609ade8 ESP: f609add4
[  135.687856]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[  135.687861] Process lpc-ntpd (pid: 3589, ti=f609a000 task=f6fb8ae0 task.ti=f609a000)
[  135.687865] Stack: fffffffe f609adec f74a4d40 f422f680 00000000 f609adf4 f883c7f6 f74a4d40 
[  135.687875]        f609ae1c f883d8db f4802758 f4802740 f609ae14 c012b8b1 f42d0800 f42d0800 
[  135.687885]        f422f680 00000000 f609ae34 f8976e03 22222222 f897fc08 f42d0800 f42d08c4 
[  135.687894] Call Trace:
[  135.687901]  [<f883c7f6>] ? usb_hcd_unlink_urb+0x15/0x22 [usbcore]
[  135.687937]  [<f883d8db>] ? usb_kill_urb+0x4d/0xc8 [usbcore]
[  135.687970]  [<c012b8b1>] ? flush_workqueue+0x3b/0x42
[  135.687987]  [<f8976e03>] ? ftdi_close+0xce/0xd6 [ftdi_sio]
[  135.688022]  [<f893782b>] ? serial_close+0x82/0x103 [usbserial]
[  135.688042]  [<c0230e38>] ? release_dev+0x18c/0x405
[  135.688056]  [<c0138f4c>] ? trace_hardirqs_on+0xb/0xd
[  135.688068]  [<c023117e>] ? tty_release+0xa/0xe
[  135.688075]  [<c0178279>] ? __fput+0x99/0x169
[  135.688086]  [<c017835f>] ? fput+0x16/0x18
[  135.688092]  [<c0175abd>] ? filp_close+0x50/0x5a
[  135.688099]  [<c011f6a7>] ? put_files_struct+0x67/0xa9
[  135.688108]  [<c011f720>] ? exit_files+0x37/0x3c
[  135.688115]  [<c0120c68>] ? do_exit+0x1c9/0x6e8
[  135.688121]  [<c011ad5d>] ? finish_task_switch+0x0/0xa1
[  135.688129]  [<c02c3715>] ? schedule+0x38c/0x3c0
[  135.688139]  [<c025c945>] ? sys_socketcall+0xe2/0x1a1
[  135.688150]  [<c01211e4>] ? do_group_exit+0x5d/0x83
[  135.688156]  [<c012121d>] ? sys_exit_group+0x13/0x15
[  135.688163]  [<c0103857>] ? sysenter_do_call+0x12/0x3f
[  135.688171]  =======================
[  135.688173] Code: 89 fa e8 e7 fe ff ff b8 00 4f 85 f8 e8 b8 8e a8 c7 8b 55 f0 b8 00 4f 85 f8 e8 9f 8d a8 c7 eb 10 8b 9e bc 00 00 00 89 f0 8b 4d ec <ff> 53 34 89 c3 5e 89 d8 5f 5b 5e 5f 5d c3 55 89 e5 57 56 89 d6 
[  135.688216] EIP: [<f883c70a>] unlink1+0xab/0xb9 [usbcore] SS:ESP 0068:f609add4
[  135.688256] ---[ end trace 72b733a963031dcf ]---
[  135.688260] Fixing recursive fault but reboot is needed!

System:
VIA SN18000G epia C7 with 4GB of ram

lpc-ntpd is a atomic clock receiver driver doing read()-calls on an fd
from a serial device (connected via usb), nothing fancy
(http://vanheusden.com/lpc-ntpd/ ).

This oops is very much reproducable using the following script:

pyk-perl.mod:
=----------=--------------------------------------------------
#! /usr/bin/perl -w

use POSIX;

@mods = <>;

for(;;)
{
	$n = floor(rand(@mods));

	print $mods[$n]."\n";
	if (rand(2) < 1.0)
	{
		system('rmmod ' . $mods[$n]);
	}
	else
	{
		system('modprobe ' . $mods[$n]);
	}
}
--------------------------------------------------------------

invoked with:
lsmod | grep -v -e via_rhine -v -e mii | awk '{ print $1; }' | ./pyk-perl.mod


Folkert van Heusden

-- 
MultiTail cok yonlu kullanimli bir program, loglari okumak, verilen
kommandolari yerine getirebilen. Filter, renk verme, merge, 'diff-
view', vs.  http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
