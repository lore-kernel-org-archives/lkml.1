Return-Path: <linux-kernel-owner+w=401wt.eu-S1755160AbZBBOOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160AbZBBOOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 09:14:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbZBBOOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 09:14:37 -0500
Received: from wf-out-1314.google.com ([209.85.200.173]:2205 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbZBBOOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 09:14:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RW1ZZVh14j5EFJTFLgKxf/TA74g3Sf2DV4ym9j7DVKCSV2HaX5wQ4IN1I7hyuWelJ5
         JtDj/4OEIuM8HBNEvuClspjRbafOxXTsmeuU/IWfP4SvbYCeOi7ezKIADt9EpXFPVKNY
         5OsD3fI50MeD6EnoJIH+AzY2zN9iLYZnJ1xH4=
MIME-Version: 1.0
In-Reply-To: <200902012208.40758.rjw@sisk.pl>
References: <d82e647a0902010634o1b4e4075m7d38365f605d3c31@mail.gmail.com>
	 <200902012208.40758.rjw@sisk.pl>
Date: Mon, 2 Feb 2009 22:14:34 +0800
Message-ID: <d82e647a0902020614q4f772816s7a6c8d143fd58662@mail.gmail.com>
Subject: Re: [possible BUG] PM suspend warning in 2.6.29-rc3-00227-gf1dd849
From: Ming Lei <tom.leiming@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
After applying your patch, following is the dmesg output, so it is the
iwl3945 driver that does not save pci state.

[  115.012278] ------------[ cut here ]------------
[  115.012281] WARNING: at drivers/pci/pci-driver.c:370
pci_legacy_suspend+0x85/0xc2()
[  115.012285] Hardware name: Latitude D630
[  115.012301] PCI PM: Device state not saved by
iwl3945_pci_suspend+0x0/0x4c [iwl3945]
[  115.012304] Modules linked in: fuse nfsd lockd nfs_acl auth_rpcgss
exportfs sunrpc ipv6 acpi_cpufreq kvm_intel kvm snd_hda_codec_idt
snd_hda_intel snd_hda_codec snd_hwdep arc4 snd_seq_device snd_pcm_oss
snd_mixer_oss ecb snd_pcm cryptomgr aead snd_timer crypto_blkcipher
snd snd_page_alloc ohci1394 crypto_hash crypto_algapi ch341 ieee1394
usbserial thermal iwl3945 mac80211 led_class lib80211 tg3 processor
i2c_i801 i2c_core sg cfg80211 libphy usbhid battery ac button sr_mod
cdrom evdev dcdbas ata_generic ata_piix libata sd_mod scsi_mod ext3
jbd mbcache uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded:
microcode]
[  115.012374] Pid: 4163, comm: pm-suspend Not tainted
2.6.29-rc3-00227-gf1dd849-dirty #67
[  115.012377] Call Trace:
[  115.012382]  [<ffffffff8023d04d>] warn_slowpath+0xb1/0xed
[  115.012387]  [<ffffffff80450b5e>] ? _spin_unlock_irqrestore+0x5c/0x78
[  115.012390]  [<ffffffff80254f08>] ? up+0x34/0x39
[  115.012394]  [<ffffffff80362319>] ? acpi_ut_release_mutex+0x5d/0x61
[  115.012397]  [<ffffffff803584b2>] ? acpi_get_data+0x5e/0x70
[  115.012400]  [<ffffffff80363dd9>] ? acpi_bus_get_device+0x25/0x39
[  115.012403]  [<ffffffff80363e98>] ? acpi_bus_power_manageable+0x11/0x29
[  115.012406]  [<ffffffff803462f7>] ? acpi_pci_power_manageable+0x17/0x19
[  115.012410]  [<ffffffff8033ddfd>] ? pci_set_power_state+0xcc/0x101
[  115.012418]  [<ffffffffa01f28e9>] ? iwl3945_pci_suspend+0x0/0x4c [iwl3945]
[  115.012422]  [<ffffffff803401e6>] pci_legacy_suspend+0x85/0xc2
[  115.012425]  [<ffffffff80340316>] pci_pm_suspend+0x34/0x86
[  115.012429]  [<ffffffff8039d7ce>] pm_op+0x52/0xe5
[  115.012432]  [<ffffffff8039dd78>] device_suspend+0x32a/0x451
[  115.012436]  [<ffffffff80269ec2>] suspend_devices_and_enter+0x3e/0x13a
[  115.012439]  [<ffffffff8026a128>] enter_state+0x110/0x164
[  115.012442]  [<ffffffff8026a233>] state_store+0xb7/0xd7
[  115.012446]  [<ffffffff8032f95f>] kobj_attr_store+0x17/0x19
[  115.012449]  [<ffffffff80307d64>] sysfs_write_file+0xe4/0x119
[  115.012453]  [<ffffffff802baa7a>] vfs_write+0xae/0x137
[  115.012456]  [<ffffffff802babc7>] sys_write+0x47/0x70
[  115.012459]  [<ffffffff8020b73a>] system_call_fastpath+0x16/0x1b
[  115.012467] ---[ end trace 829828966f6f24dc ]---



2009/2/2 Rafael J. Wysocki <rjw@sisk.pl>:
> On Sunday 01 February 2009, Ming Lei wrote:
>> [ 9861.405683] uhci_hcd 0000:00:1d.1: release dev 2 ep81-INT, period
>> 8, phase 4, 99 us
>> [ 9865.305619] PM: Syncing filesystems ... done.
>> [ 9865.313642] Freezing user space processes ... (elapsed 0.08 seconds) done.
>> [ 9865.402590] Freezing remaining freezable tasks ... (elapsed 0.00
>> seconds) done.
>> [ 9865.403013] Suspending console(s) (use no_console_suspend to debug)
>> [ 9865.407679] usb 7-1.2: usb suspend
>> [ 9865.418277] hub 7-1:1.0: hub_suspend
>> [ 9865.419658] uhci_hcd 0000:00:1d.2: release dev 2 ep81-INT, period
>> 128, phase 0, 12 us
>> [ 9865.420690] usb 7-1: usb suspend
>> [ 9865.431279] ch341 6-2:1.0: forced unbind
>> [ 9865.431956] ch341-uart ttyUSB0: ch341-uart converter now
>> disconnected from ttyUSB0
>> [ 9865.431983] ch341 6-2:1.0: device disconnected
>> [ 9865.432001] usb 6-2: usb suspend
>> [ 9865.444823] usb 6-1: usb suspend
>> [ 9865.455301] sd 2:0:0:0: [sda] Synchronizing SCSI cache
>> [ 9865.520674] sd 2:0:0:0: [sda] Stopping disk
>> [ 9866.014995] usb 2-1: usb suspend
>> [ 9866.025319] hub 7-0:1.0: hub_suspend
>> [ 9866.025332] usb usb7: bus suspend
>> [ 9866.025335] usb usb7: suspend_rh
>> [ 9866.025372] hub 6-0:1.0: hub_suspend
>> [ 9866.025379] usb usb6: bus suspend
>> [ 9866.025380] usb usb6: suspend_rh
>> [ 9866.025438] hub 2-0:1.0: hub_suspend
>> [ 9866.025444] usb usb2: bus suspend
>> [ 9866.025446] ehci_hcd 0000:00:1d.7: suspend root hub
>> [ 9866.578701] serial 00:09: disabled
>> [ 9866.580895] ACPI handle has no context!
>> [ 9866.591279] pci 0000:03:01.0: PCI INT A disabled
>> [ 9866.639663] tg3 0000:09:00.0: PME# enabled
>> [ 9866.661281] ------------[ cut here ]------------
>> [ 9866.661285] WARNING: at drivers/pci/pci-driver.c:368
>> pci_legacy_suspend+0x7b/0xb8()
>> [ 9866.661289] Hardware name: Latitude D630
>> [ 9866.661291] Modules linked in: vfat fat fuse nfsd lockd nfs_acl
>> auth_rpcgss exportfs autofs4 sunrpc ipv6 acpi_cpufreq kvm_intel kvm
>> snd_hda_codec_idt arc4 ecb cryptomgr aead crypto_blkcipher
>> snd_hda_intel snd_hda_codec snd_hwdep snd_seq_device snd_pcm_oss
>> snd_mixer_oss snd_pcm snd_timer ub usb_storage ch341 crypto_hash
>> crypto_algapi usbserial iwl3945 mac80211 led_class lib80211 i2c_i801
>> snd usbhid cfg80211 tg3 ohci1394 snd_page_alloc thermal libphy
>> ieee1394 i2c_core processor sg button battery ac sr_mod cdrom evdev
>> dcdbas ata_generic ata_piix libata sd_mod scsi_mod ext3 jbd mbcache
>> uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded: microcode]
>> [ 9866.661370] Pid: 6816, comm: pm-suspend Not tainted
>> 2.6.29-rc3-00227-gf1dd849 #66
>> [ 9866.661372] Call Trace:
>> [ 9866.661377]  [<ffffffff8023d04d>] warn_slowpath+0xb1/0xed
>> [ 9866.661383]  [<ffffffff80450b5e>] ? _spin_unlock_irqrestore+0x5c/0x78
>> [ 9866.661386]  [<ffffffff80254f08>] ? up+0x34/0x39
>> [ 9866.661390]  [<ffffffff80362311>] ? acpi_ut_release_mutex+0x5d/0x61
>> [ 9866.661393]  [<ffffffff803584aa>] ? acpi_get_data+0x5e/0x70
>> [ 9866.661396]  [<ffffffff80363dd1>] ? acpi_bus_get_device+0x25/0x39
>> [ 9866.661399]  [<ffffffff80363e90>] ? acpi_bus_power_manageable+0x11/0x29
>> [ 9866.661403]  [<ffffffff803462ef>] ? acpi_pci_power_manageable+0x17/0x19
>> [ 9866.661406]  [<ffffffff8033ddfd>] ? pci_set_power_state+0xcc/0x101
>> [ 9866.661411]  [<ffffffff803401dc>] pci_legacy_suspend+0x7b/0xb8
>> [ 9866.661414]  [<ffffffff8034030c>] pci_pm_suspend+0x34/0x86
>> [ 9866.661418]  [<ffffffff8039d7c6>] pm_op+0x52/0xe5
>> [ 9866.661420]  [<ffffffff8039dd70>] device_suspend+0x32a/0x451
>> [ 9866.661424]  [<ffffffff80269ec2>] suspend_devices_and_enter+0x3e/0x13a
>> [ 9866.661428]  [<ffffffff8026a128>] enter_state+0x110/0x164
>> [ 9866.661431]  [<ffffffff8026a233>] state_store+0xb7/0xd7
>> [ 9866.661435]  [<ffffffff8032f95f>] kobj_attr_store+0x17/0x19
>> [ 9866.661438]  [<ffffffff80307d64>] sysfs_write_file+0xe4/0x119
>> [ 9866.661442]  [<ffffffff802baa7a>] vfs_write+0xae/0x137
>> [ 9866.661445]  [<ffffffff802babc7>] sys_write+0x47/0x70
>> [ 9866.661449]  [<ffffffff8020b73a>] system_call_fastpath+0x16/0x1b
>> [ 9866.661451] ---[ end trace da0410afb81f3af7 ]---
>
> It seems that one of the PCI drivers put the device into a low power state
> without changing its state (bad).
>
> Can you please retest with the appended patch applied?
>
> Rafael
>
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PCI PM: Make warning in pci_legacy_suspend more useful
>
> The warning in pci_legacy_suspend() would be much more useful if it
> printed the name of the function that did the wrong thing.  Make it
> do so.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/pci/pci-driver.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> Index: linux-2.6/drivers/pci/pci-driver.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/pci-driver.c
> +++ linux-2.6/drivers/pci/pci-driver.c
> @@ -365,7 +365,9 @@ static int pci_legacy_suspend(struct dev
>                if (pci_dev->state_saved)
>                        goto Fixup;
>
> -               if (WARN_ON_ONCE(pci_dev->current_state != PCI_D0))
> +               if (WARN_ONCE(pci_dev->current_state != PCI_D0,
> +                               "PCI PM: Device state not saved by %pF\n",
> +                               drv->suspend))
>                        goto Fixup;
>        }
>
>



-- 
Lei Ming
