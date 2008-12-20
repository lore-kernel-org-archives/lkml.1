Return-Path: <linux-kernel-owner+w=401wt.eu-S1753046AbYLTGFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046AbYLTGFU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 01:05:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbYLTGFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 01:05:06 -0500
Received: from main.gmane.org ([80.91.229.2]:35843 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbYLTGFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 01:05:04 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: need pci=nomsi or ahci fails to resume
Date: Sat, 20 Dec 2008 00:02:31 -0600
Message-ID: <494C8A77.2020900@shaw.ca>
References: <gihoel$p0c$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
In-Reply-To: <gihoel$p0c$1@ger.gmane.org>
Cc: linux-acpi@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian J. Murrell wrote:
> Hi,
> 
> I've got an Acer Aspire 4350 here which I'm having some suspend/resume 
> difficulties.  I'm using the Ubuntu 2.6.27-9-generic kernel (I've also
> had the same problems with a 2.6.28-rc8 kernel.org kernel and it 
> suspends just fine and mostly resumes fine with the exception that I 
> don't seem to have a working disk after the resume.  In dmesg I see the 
> following errors:
> 
> [   94.436968] NVRM: RmPowerManagement: 5
> [   95.093046] ata6: SATA link down (SStatus 0 SControl 300)
> [   95.093085] ata5: SATA link down (SStatus 0 SControl 300)
> [   95.093109] ata3: SATA link down (SStatus 0 SControl 300)
> [   95.093133] ata4: SATA link down (SStatus 0 SControl 300)
> [   95.257023] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [   95.761025] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  100.257019] ata2.00: qc timeout (cmd 0xa1)
> [  100.257029] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> [  100.257031] ata2.00: revalidation failed (errno=-5)
> [  100.741023] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  100.761016] ata1.00: qc timeout (cmd 0xec)
> [  100.761023] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> [  100.761025] ata1.00: revalidation failed (errno=-5)
> [  101.245023] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  110.741015] ata2.00: qc timeout (cmd 0xa1)
> [  110.741021] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> [  110.741024] ata2.00: revalidation failed (errno=-5)
> [  111.225024] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  111.245016] ata1.00: qc timeout (cmd 0xec)
> [  111.245024] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> [  111.245026] ata1.00: revalidation failed (errno=-5)
> [  111.729024] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ...
> [  141.224101] ata2.00: qc timeout (cmd 0xa1)
> [  141.224110] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> [  141.224114] ata2.00: revalidation failed (errno=-5)
> [  141.224116] ata2.00: disabled
> [  141.224131] ata2: hard resetting link
> [  141.709018] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  141.709022] ata2: EH complete
> [  141.729016] ata1.00: qc timeout (cmd 0xec)
> [  141.729021] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> [  141.729023] ata1.00: revalidation failed (errno=-5)
> [  141.729025] ata1.00: disabled
> [  141.729030] ata1: hard resetting link
> [  142.317017] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  142.317021] ata1: EH complete
> [  142.317055] sd 0:0:0:0: [sda] START_STOP FAILED
> [  142.317057] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
> [  142.317068] PM: Device 0:0:0:0 failed to resume: error 262144
> [  142.828749] PM: resume devices took 48.708 seconds
> [  142.828758] ------------[ cut here ]------------
> [  142.828761] WARNING: at /build/buildd/linux-2.6.27/kernel/power/main.c:176 suspend_test_finish+0x74/0x80()
> [  142.828764] Modules linked in: rfcomm sco bridge stp bnep l2cap bluetooth ppdev powernow_k8 cpufreq_ondemand cpufreq_powersave cpufreq_userspace cpufreq_stats cpufreq_conservative freq_table sbs sbshc container pci_slot ipv6 af_packet iptable_filter ip_tables x_tables parport_pc lp parport snd_hda_intel arc4 ecb snd_pcm_oss snd_mixer_oss joydev crypto_blkcipher acer_wmi snd_pcm led_class ath9k psmouse mac80211 pcspkr evdev serio_raw nvidia(P) snd_seq_dummy agpgart cfg80211 snd_seq_oss snd_seq_midi i2c_core snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device snd shpchp pci_hotplug soundcore snd_page_alloc video output battery wmi button ac ext3 jbd mbcache loop sd_mod sr_mod cdrom crc_t10dif sg usb_storage libusual ahci tg3 libphy libata scsi_mod dock ehci_hcd ohci_hcd usbcor
>  e thermal processor fan fbcon tileblit font bitblit softcursor fuse
> [  142.828821] Pid: 5796, comm: pm-suspend Tainted: P          2.6.27-9-generic #1
> [  142.828825]  [<c037c4b6>] ? printk+0x1d/0x1f
> [  142.828832]  [<c0131de9>] warn_on_slowpath+0x59/0x90
> [  142.828838]  [<c014d255>] ? sched_clock_cpu+0xd5/0x170
> [  142.828843]  [<c014c0af>] ? down_trylock+0x2f/0x40
> [  142.828847]  [<c01324c2>] ? try_acquire_console_sem+0x12/0x40
> [  142.828851]  [<c024e580>] ? kobject_put+0x20/0x50
> [  142.828856]  [<c015d204>] suspend_test_finish+0x74/0x80
> [  142.828860]  [<c015d2f6>] suspend_devices_and_enter+0xe6/0x190
> [  142.828865]  [<c015d571>] enter_state+0xd1/0x100
> [  142.828867]  [<c015d625>] state_store+0x85/0xd0
> [  142.828870]  [<c015d5a0>] ? state_store+0x0/0xd0
> [  142.828873]  [<c024e444>] kobj_attr_store+0x24/0x30
> [  142.828876]  [<c01ff4c7>] sysfs_write_file+0x97/0x100
> [  142.828880]  [<c01b24c0>] vfs_write+0xa0/0x110
> [  142.828883]  [<c01ff430>] ? sysfs_write_file+0x0/0x100
> [  142.828887]  [<c01b2602>] sys_write+0x42/0x70
> [  142.828890]  [<c0103f7b>] sysenter_do_call+0x12/0x2f
> [  142.828894]  =======================
> [  142.828896] ---[ end trace 25d69a100d20ea19 ]---
> [  142.829545] PM: Finishing wakeup.
> [  142.829548] Restarting tasks ... done.
> [  143.062508] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
> [  143.062524] end_request: I/O error, dev sda, sector 67465536
> [  143.062624] Buffer I/O error on device sda2, logical block 5811496
> [  143.063189] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
> [  143.063194] end_request: I/O error, dev sda, sector 67465536
> [  143.063288] Buffer I/O error on device sda2, logical block 5811496
> [  143.064581] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
> [  143.064590] end_request: I/O error, dev sda, sector 67465536
> [  143.064685] Buffer I/O error on device sda2, logical block 5811496
> [  143.065017] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
> [  143.065022] end_request: I/O error, dev sda, sector 67465536
> [  143.065116] Buffer I/O error on device sda2, logical block 5811496
> [  143.848550] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
> [  143.848573] end_request: I/O error, dev sda, sector 27309280
> [  143.848692] Buffer I/O error on device sda2, logical block 791964
> [  143.848801] lost page write due to I/O error on sda2
> [  143.848835] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
> [  143.848844] end_request: I/O error, dev sda, sector 53386904
> [  143.848950] Buffer I/O error on device sda2, logical block 4051667
> [  143.849069] lost page write due to I/O error on sda2
> 
> The hardware inventory is:
> 
> 00:00.0 RAM memory: nVidia Corporation MCP78S [GeForce 8200] Memory Controller (rev a2)
> 00:01.0 ISA bridge: nVidia Corporation Device 075e (rev a2)
> 00:01.1 SMBus: nVidia Corporation MCP78S [GeForce 8200] SMBus (rev a1)
> 00:01.3 Co-processor: nVidia Corporation MCP78S [GeForce 8200] Co-Processor (rev a2)
> 00:01.4 RAM memory: nVidia Corporation MCP78S [GeForce 8200] Memory Controller (rev a1)
> 00:02.0 USB Controller: nVidia Corporation MCP78S [GeForce 8200] OHCI USB 1.1 Controller (rev a1)
> 00:02.1 USB Controller: nVidia Corporation MCP78S [GeForce 8200] EHCI USB 2.0 Controller (rev a1)
> 00:04.0 USB Controller: nVidia Corporation MCP78S [GeForce 8200] OHCI USB 1.1 Controller (rev a1)
> 00:04.1 USB Controller: nVidia Corporation MCP78S [GeForce 8200] EHCI USB 2.0 Controller (rev a1)
> 00:07.0 Audio device: nVidia Corporation Realtek ALC1200 8-Channel High Definition Audio Codec (rev a1)
> 00:08.0 PCI bridge: nVidia Corporation MCP78S [GeForce 8200] PCI Bridge (rev a1)
> 00:09.0 SATA controller: nVidia Corporation Device 0ad5 (rev a2)
> 00:0b.0 PCI bridge: nVidia Corporation MCP78S [GeForce 8200] PCI Express Bridge (rev a1)
> 00:13.0 PCI bridge: nVidia Corporation Device 077a (rev a1)
> 00:14.0 PCI bridge: nVidia Corporation Device 077a (rev a1)
> 00:15.0 PCI bridge: nVidia Corporation Device 077a (rev a1)
> 00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 11h HyperTransport Configuration (rev 40)
> 00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 11h Address Map
> 00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 11h DRAM Controller
> 00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 11h Miscellaneous Control
> 00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 11h Link Control
> 02:00.0 VGA compatible controller: nVidia Corporation GeForce 9100M G (rev a2)
> 08:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5764M Gigabit Ethernet PCIe (rev 10)
> 0b:00.0 Network controller: Atheros Communications Inc. AR928X Wireless Network Adapter (PCI-Express) (rev 01)
> 
> Through some poking around, I have come to discover that I need to boot 
> the kernel with pci=nomsi in order to have the SATA disk work after a 
> resume (I don't really need the option just to have it boot with this 
> kernel though unlike previous 2.6.24 kernels).
> 
> This bug looks remarkably like http://bugzilla.kernel.org/show_bug.cgi?
> id=11178 however I've checked the source for the kernel I'm using and it
> has the patch from that bug in it already and I've even built a
> 2.6.28-rc8 kernel and I still have the same problem.

You might want to verify this still happens without the nvidia driver 
loaded..

