Return-Path: <linux-kernel-owner+w=401wt.eu-S1752317AbZIIKOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317AbZIIKOl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 06:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbZIIKOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 06:14:40 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:31626 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbZIIKOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 06:14:39 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=w4iE+TBsmj5y1WloLYF40w==:17 a=HFfdeltRjPSqsbdUFf4A:9
 a=-0RaFIhfvaQtjYrSugIA:7 a=6IFSSwHVZhXcwfqtMRwol5D0Oo0A:4
From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Reply-To: tfjellstrom@shaw.ca
To: linux-kernel@vger.kernel.org
Subject: 2.6.31-rc8 libata WARNING?
Date: Wed, 9 Sep 2009 04:14:41 -0600
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc8; KDE/4.3.1; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200909090414.41274.tfjellstrom@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, After doing some more tests, I can be fairly certain that my disk is not 
at fault, testing just ONE of my 2 WD Green drives, not using any md raid, or 
filesystem on top I get the following:

[  329.394283] ------------[ cut here ]------------
[  329.394361] WARNING: at drivers/ata/libata-core.c:5129 
ata_qc_issue+0x10a/0x347 [libata]()
[  329.394367] Hardware name: GA-MA790FXT-UD5P
[  329.394371] Modules linked in: powernow_k8 cpufreq_conservative 
cpufreq_stats cpufreq_userspace cpufreq_powersave kvm_amd kvm nfsd exportfs 
nfs lockd fscache nfs_acl auth_rpcgss sunrpc bridge stp it87 hwmon_vid adt7473 
firewire_sbp2 loop md_mod snd_hda_codec_realtek snd_hda_intel snd_hda_codec 
snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm amd64_edac_mod snd_seq_midi 
snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device edac_core snd 
i2c_piix4 soundcore i2c_core snd_page_alloc evdev parport_pc parport button 
wmi processor ext3 jbd mbcache dm_mod sg usbhid sr_mod hid cdrom pata_jmicron 
firewire_ohci firewire_core ata_generic sd_mod crc_t10dif ohci_hcd crc_itu_t 
atiixp ide_pci_generic ide_core ahci mvsas ehci_hcd libsas libata 
scsi_transport_sas scsi_mod r8169 mii floppy thermal fan thermal_sys [last 
unloaded: scsi_wait_scan]
[  329.394488] Pid: 3103, comm: hddtemp Not tainted 2.6.31-rc8 #1
[  329.394493] Call Trace:
[  329.394540]  [<ffffffffa007cf90>] ? ata_qc_issue+0x10a/0x347 [libata]
[  329.394583]  [<ffffffffa007cf90>] ? ata_qc_issue+0x10a/0x347 [libata]
[  329.394596]  [<ffffffff8104aca0>] ? warn_slowpath_common+0x77/0xa3
[  329.394639]  [<ffffffffa00810ce>] ? ata_scsi_pass_thru+0x0/0x240 [libata]
[  329.394680]  [<ffffffffa007cf90>] ? ata_qc_issue+0x10a/0x347 [libata]
[  329.394726]  [<ffffffffa00401d6>] ? scsi_get_command+0x75/0x97 [scsi_mod]
[  329.394768]  [<ffffffffa00810ce>] ? ata_scsi_pass_thru+0x0/0x240 [libata]
[  329.394807]  [<ffffffffa003f7aa>] ? scsi_done+0x0/0xc [scsi_mod]
[  329.394850]  [<ffffffffa00824d5>] ? __ata_scsi_queuecmd+0x185/0x1dc 
[libata]
[  329.394889]  [<ffffffffa003f7aa>] ? scsi_done+0x0/0xc [scsi_mod]
[  329.394911]  [<ffffffffa00abc8e>] ? sas_queuecommand+0x83/0x25d [libsas]
[  329.394949]  [<ffffffffa003fa7c>] ? scsi_dispatch_cmd+0x1c0/0x23c 
[scsi_mod]
[  329.394988]  [<ffffffffa0044ff0>] ? scsi_request_fn+0x3a5/0x506 [scsi_mod]
[  329.394999]  [<ffffffff810546e0>] ? del_timer+0x59/0x62
[  329.395009]  [<ffffffff81163b08>] ? blk_execute_rq_nowait+0x65/0x89
[  329.395024]  [<ffffffffa016764f>] ? sg_common_write+0x489/0x4ab [sg]
[  329.395034]  [<ffffffff8115deee>] ? __freed_request+0x26/0x83
[  329.395048]  [<ffffffffa01681da>] ? sg_new_write+0x23e/0x269 [sg]
[  329.395062]  [<ffffffffa0168473>] ? sg_ioctl+0x26e/0xb63 [sg]
[  329.395072]  [<ffffffff81100ef8>] ? inotify_d_instantiate+0x12/0x39
[  329.395081]  [<ffffffff8105eee6>] ? autoremove_wake_function+0x0/0x2e
[  329.395090]  [<ffffffff810d8097>] ? fd_install+0x2e/0x5a
[  329.395097]  [<ffffffff810e5207>] ? vfs_ioctl+0x56/0x6c
[  329.395104]  [<ffffffff810e56ca>] ? do_vfs_ioctl+0x437/0x475
[  329.395111]  [<ffffffff810e5759>] ? sys_ioctl+0x51/0x70
[  329.395121]  [<ffffffff81010a02>] ? system_call_fastpath+0x16/0x1b
[  329.395127] ---[ end trace 2e6f5d9886b0398e ]---


And that happens after only a couple minutes of: dd if=/dev/sdc of=/dev/null

And this is with the WD that wasn't previously showing up in any dmesg logs. 
I'm assuming if I let the dd test run, I will continue to see more errors 
until the entire libata subsystem causes the sata driver to kneel over and 
die.

I'm going to let it run for a while to see what happens.

-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
