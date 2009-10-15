Return-Path: <linux-kernel-owner+w=401wt.eu-S1762576AbZJOKkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762576AbZJOKkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 06:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762077AbZJOKkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 06:40:21 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.123]:50246 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757324AbZJOKkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 06:40:17 -0400
Message-ID: <4AD6FB9B.5030704@cfl.rr.com>
Date: Thu, 15 Oct 2009 06:38:19 -0400
From: Mark Hounschell <dmarkh@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Mark Hounschell <markh@compro.net>
Subject: WARNING: at lib/kref.c:43 kref_get+0x18/0x20()
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am using 3 different digi products and using their out of kernel GPL drivers.
I am trying to get them to work with the 2.6.31.4 kernel. The digi people are
not really doing much to keep them current so I have to do it myself if I want
to run the latest kernels. I'm going from a 2.6.26 series to 2.6.31 BTW.

I have them all working but all 3 cause the following WARNING when I open the
ports on the board. Then one of the 3 causes the BUG msg below when I close
ports at task exit time and the task can't exit. They do function correctly
while the task is running BTW.

I know there have been many changes to the serial/tty stuff recently. I think
this is not a driver but kernel issue so I thought I'd bring it up here in hope
to find out for sure.

I know my Tainted flag is set here as I do use the nvidia driver but I have it
unloaded and do have other machines where this happens not using it at all.

WARNING: at lib/kref.c:43 kref_get+0x18/0x20()
Hardware name: Unknow
Modules linked in: rtom snd_pcm_oss snd_mixer_oss binfmt_misc snd_seq
snd_seq_device iptable_filter ip_tables ip6table_filter ip6_tables x_tables ipv6
fuse loop dm_mod tnt4882 synclink_gt snd_hda_codec_realtek nec7210 snd_hda_intel
dgap hdlc 3c59x snd_hda_codec dgdm st mii gpib_common osst snd_pcm snd_timer snd
rtc_cmos shpchp rtc_core pci_hotplug i2c_piix4 soundcore wmi sr_mod ati_agp
snd_page_alloc cdrom sky2 rtc_lib agpgart i2c_core sg sd_mod edd ext3 mbcache
jbd aic79xx aic7xxx scsi_transport_spi ide_pci_generic atiixp ide_core
ata_generic pata_atiixp ahci libata scsi_mod thermal processor thermal_sys [last
unloaded: rfm2g]
Pid: 5364, comm: vrsx Tainted: P           2.6.31.4 #1
Call Trace:
 [<c0125281>] ? warn_slowpath_common+0x5e/0x8a
 [<c01252b7>] ? warn_slowpath_null+0xa/0xc
 [<c0208108>] ? kref_get+0x18/0x20
 [<c025a5ec>] ? tty_open+0x128/0x384
 [<c0197553>] ? chrdev_open+0x15a/0x171
 [<c0193a75>] ? __dentry_open+0x14f/0x23e
 [<c0193bf5>] ? nameidata_to_filp+0x29/0x3c
 [<c01973f9>] ? chrdev_open+0x0/0x171
 [<c019ebd1>] ? do_filp_open+0x418/0x7fb
 [<c0313a74>] ? _spin_unlock+0xc/0x1f
 [<c018fe10>] ? __slab_free+0xa8/0x286
 [<c01832cf>] ? remove_vma+0x3e/0x43
 [<c0313a74>] ? _spin_unlock+0xc/0x1f
 [<c01a606b>] ? alloc_fd+0xc3/0xcd
 [<c019382f>] ? do_sys_open+0x4c/0xe4
 [<c019390b>] ? sys_open+0x1e/0x23
 [<c01027f4>] ? sysenter_do_call+0x12/0x26
---[ end trace 1963594fafbe52d2 ]---

After task starts it shows 24 opens

#lsmod | grep dgdm
dgdm                  300712  24


kernel BUG at mm/slub.c:2929!
invalid opcode: 0000 [#1] PREEMPT SMP
last sysfs file: /sys/firmware/edd/int13_dev80/extensions
Modules linked in: af_packet n_hdlc rtom snd_pcm_oss snd_mixer_oss binfmt_misc
snd_seq snd_seq_device iptable_filter ip_tables ip6table_filter ip6_tables
x_tables ipv6 fuse loop dm_mod tnt4882 synclink_gt snd_hda_codec_realtek nec7210
snd_hda_intel dgap hdlc 3c59x snd_hda_codec dgdm st mii gpib_common osst snd_pcm
snd_timer snd rtc_cmos shpchp rtc_core pci_hotplug i2c_piix4 soundcore wmi
sr_mod ati_agp snd_page_alloc cdrom sky2 rtc_lib agpgart i2c_core sg sd_mod edd
ext3 mbcache jbd aic79xx aic7xxx scsi_transport_spi ide_pci_generic atiixp
ide_core ata_generic pata_atiixp ahci libata scsi_mod thermal processor
thermal_sys [last unloaded: rfm2g]

Pid: 5364, comm: vrsx Tainted: P        W  (2.6.31.4-lcrs #1) Unknow
EIP: 0060:[<c01910db>] EFLAGS: 00010246 CPU: 3
EIP is at kfree+0x79/0xd5
EAX: 80000000 EBX: c16d9620 ECX: f2318c60 EDX: 00000000
ESI: c02080e6 EDI: f6cb13cc EBP: 00000047 ESP: f120de60
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process vrsx (pid: 5364, ti=f120c000 task=f1cf0000 task.ti=f120c000)
Stack:
 f2291000 f6cb13d0 c0258646 f6cb13cc 00000047 c02080e6 f1bc4800 f1bc4804
<0> c025a339 f1bc4804 c025a303 00000000 c02080e6 f1bc4800 00000000 c025a2b4
<0> f2a3b080 f1bc491c f1bc4910 0000011c 00000110 00000000 00000001 00000000
Call Trace:
 [<c0258646>] ? destruct_tty_driver+0x0/0x81
 [<c02080e6>] ? kref_put+0x36/0x40
 [<c025a339>] ? release_one_tty+0x36/0x7f
 [<c025a303>] ? release_one_tty+0x0/0x7f
 [<c02080e6>] ? kref_put+0x36/0x40
 [<c025a2b4>] ? tty_release_dev+0x3b9/0x3d3
 [<c019a822>] ? free_pipe_info+0xe/0x1a
 [<c025a2dd>] ? tty_release+0xf/0x18
 [<c0195f28>] ? __fput+0xc0/0x16a
 [<c0193742>] ? filp_close+0x4e/0x54
 [<c012675d>] ? put_files_struct+0x60/0xa6
 [<c0127aef>] ? do_exit+0x1b2/0x59c
 [<c03158a0>] ? do_page_fault+0x359/0x36f
 [<c0127f34>] ? do_group_exit+0x5b/0x82
 [<c0127f6c>] ? sys_exit_group+0x11/0x14
 [<c01027f4>] ? sysenter_do_call+0x12/0x26
Code: ff 10 76 7d 8d 9f 00 00 00 40 c1 eb 0c c1 e3 05 03 1d 40 fa 4e c0 66 83 3b
00 79 03 8b 5b 0c 8b 03 84 c0 78 16 66 a9 00 c0 75 04 <0f> 0b eb fe 5a 89 d8 5b
5e 5f 5d e9 d9 3f fe ff 8b 44 24 14 89
EIP: [<c01910db>] kfree+0x79/0xd5 SS:ESP 0068:f120de60
---[ end trace 1963594fafbe52d3 ]---
Fixing recursive fault but reboot is needed!

After task attempts to exit there are still 2 opens left

# lsmod | grep dgdm
dgdm                  300712  2


Thanks in advance
Mark
