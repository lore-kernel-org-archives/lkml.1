Return-Path: <linux-kernel-owner+w=401wt.eu-S1753687AbZBAOfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbZBAOfP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 09:35:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752100AbZBAOfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 09:35:00 -0500
Received: from wf-out-1314.google.com ([209.85.200.172]:5411 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbZBAOe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 09:34:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=X1Q4JcLyRqWwELqIsODOXAI7vlYKrINNJGpkoCM/P0gxLZQJ3VWFiHqocQe0KPIb08
         zBpRWv/BJJYdPX/BiVSZtEs7GWhMOnaDZ2UOP0Xq7eRW/CZC8//wuzKHhvlQy/qzovux
         gc/dmzY0uQE1bSYHgYCb9ArlfOz0cgNfm4XIM=
MIME-Version: 1.0
Date: Sun, 1 Feb 2009 22:34:58 +0800
Message-ID: <d82e647a0902010634o1b4e4075m7d38365f605d3c31@mail.gmail.com>
Subject: [possible BUG] PM suspend warning in 2.6.29-rc3-00227-gf1dd849
From: Ming Lei <tom.leiming@gmail.com>
To: Linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ 9861.405683] uhci_hcd 0000:00:1d.1: release dev 2 ep81-INT, period
8, phase 4, 99 us
[ 9865.305619] PM: Syncing filesystems ... done.
[ 9865.313642] Freezing user space processes ... (elapsed 0.08 seconds) done.
[ 9865.402590] Freezing remaining freezable tasks ... (elapsed 0.00
seconds) done.
[ 9865.403013] Suspending console(s) (use no_console_suspend to debug)
[ 9865.407679] usb 7-1.2: usb suspend
[ 9865.418277] hub 7-1:1.0: hub_suspend
[ 9865.419658] uhci_hcd 0000:00:1d.2: release dev 2 ep81-INT, period
128, phase 0, 12 us
[ 9865.420690] usb 7-1: usb suspend
[ 9865.431279] ch341 6-2:1.0: forced unbind
[ 9865.431956] ch341-uart ttyUSB0: ch341-uart converter now
disconnected from ttyUSB0
[ 9865.431983] ch341 6-2:1.0: device disconnected
[ 9865.432001] usb 6-2: usb suspend
[ 9865.444823] usb 6-1: usb suspend
[ 9865.455301] sd 2:0:0:0: [sda] Synchronizing SCSI cache
[ 9865.520674] sd 2:0:0:0: [sda] Stopping disk
[ 9866.014995] usb 2-1: usb suspend
[ 9866.025319] hub 7-0:1.0: hub_suspend
[ 9866.025332] usb usb7: bus suspend
[ 9866.025335] usb usb7: suspend_rh
[ 9866.025372] hub 6-0:1.0: hub_suspend
[ 9866.025379] usb usb6: bus suspend
[ 9866.025380] usb usb6: suspend_rh
[ 9866.025438] hub 2-0:1.0: hub_suspend
[ 9866.025444] usb usb2: bus suspend
[ 9866.025446] ehci_hcd 0000:00:1d.7: suspend root hub
[ 9866.578701] serial 00:09: disabled
[ 9866.580895] ACPI handle has no context!
[ 9866.591279] pci 0000:03:01.0: PCI INT A disabled
[ 9866.639663] tg3 0000:09:00.0: PME# enabled
[ 9866.661281] ------------[ cut here ]------------
[ 9866.661285] WARNING: at drivers/pci/pci-driver.c:368
pci_legacy_suspend+0x7b/0xb8()
[ 9866.661289] Hardware name: Latitude D630
[ 9866.661291] Modules linked in: vfat fat fuse nfsd lockd nfs_acl
auth_rpcgss exportfs autofs4 sunrpc ipv6 acpi_cpufreq kvm_intel kvm
snd_hda_codec_idt arc4 ecb cryptomgr aead crypto_blkcipher
snd_hda_intel snd_hda_codec snd_hwdep snd_seq_device snd_pcm_oss
snd_mixer_oss snd_pcm snd_timer ub usb_storage ch341 crypto_hash
crypto_algapi usbserial iwl3945 mac80211 led_class lib80211 i2c_i801
snd usbhid cfg80211 tg3 ohci1394 snd_page_alloc thermal libphy
ieee1394 i2c_core processor sg button battery ac sr_mod cdrom evdev
dcdbas ata_generic ata_piix libata sd_mod scsi_mod ext3 jbd mbcache
uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded: microcode]
[ 9866.661370] Pid: 6816, comm: pm-suspend Not tainted
2.6.29-rc3-00227-gf1dd849 #66
[ 9866.661372] Call Trace:
[ 9866.661377]  [<ffffffff8023d04d>] warn_slowpath+0xb1/0xed
[ 9866.661383]  [<ffffffff80450b5e>] ? _spin_unlock_irqrestore+0x5c/0x78
[ 9866.661386]  [<ffffffff80254f08>] ? up+0x34/0x39
[ 9866.661390]  [<ffffffff80362311>] ? acpi_ut_release_mutex+0x5d/0x61
[ 9866.661393]  [<ffffffff803584aa>] ? acpi_get_data+0x5e/0x70
[ 9866.661396]  [<ffffffff80363dd1>] ? acpi_bus_get_device+0x25/0x39
[ 9866.661399]  [<ffffffff80363e90>] ? acpi_bus_power_manageable+0x11/0x29
[ 9866.661403]  [<ffffffff803462ef>] ? acpi_pci_power_manageable+0x17/0x19
[ 9866.661406]  [<ffffffff8033ddfd>] ? pci_set_power_state+0xcc/0x101
[ 9866.661411]  [<ffffffff803401dc>] pci_legacy_suspend+0x7b/0xb8
[ 9866.661414]  [<ffffffff8034030c>] pci_pm_suspend+0x34/0x86
[ 9866.661418]  [<ffffffff8039d7c6>] pm_op+0x52/0xe5
[ 9866.661420]  [<ffffffff8039dd70>] device_suspend+0x32a/0x451
[ 9866.661424]  [<ffffffff80269ec2>] suspend_devices_and_enter+0x3e/0x13a
[ 9866.661428]  [<ffffffff8026a128>] enter_state+0x110/0x164
[ 9866.661431]  [<ffffffff8026a233>] state_store+0xb7/0xd7
[ 9866.661435]  [<ffffffff8032f95f>] kobj_attr_store+0x17/0x19
[ 9866.661438]  [<ffffffff80307d64>] sysfs_write_file+0xe4/0x119
[ 9866.661442]  [<ffffffff802baa7a>] vfs_write+0xae/0x137
[ 9866.661445]  [<ffffffff802babc7>] sys_write+0x47/0x70
[ 9866.661449]  [<ffffffff8020b73a>] system_call_fastpath+0x16/0x1b
[ 9866.661451] ---[ end trace da0410afb81f3af7 ]---


-- 
Lei Ming
