Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbZG1SQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbZG1SQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 14:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755360AbZG1SQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 14:16:39 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:33922 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755359AbZG1SQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 14:16:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=H5ZHOHVatINXaH/LX04umERPMIJJQ9gK3Yavvw+t3Yqnb/AmeqKR1jXvNYw0TMwffq
         7ckceEbTgNrpPx5/YIVHGRcI5HNh3KFGy3TFPGWVq37E7DuIpVaJBBJ3kDylinTBmNcy
         PH7/IYAIj81+HEqM9eOOtO3/YH7SjSFI0URYY=
Message-ID: <4A6F4036.3010305@gmail.com>
Date: Tue, 28 Jul 2009 20:15:18 +0200
From: Niel Lambrechts <niel.lambrechts@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: "linux.kernel" <linux-kernel@vger.kernel.org>
Subject: 2.6.30.2 - 2.6.31-rc4: Warning at i915_gem_idle
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I noticed the following error today after noticing that Xorg became 100% busy.

When checking my logs for details I discovered that the error is present in most kernels I test, up to 2.6.31-rc4. In most cases, I *think* I would have tried 
switching to a text console to do "init 3; init 5", at the point where the vblank error occurs.

Error on 2.6.30.2:
Jul 28 12:30:31 localhost kernel: ------------[ cut here ]------------
Jul 28 12:30:31 localhost kernel: WARNING: at drivers/gpu/drm/i915/i915_gem.c:3840 i915_gem_idle+0x172/0x277 [i915]()
Jul 28 12:30:31 localhost kernel: Hardware name: 40622XG
Jul 28 12:30:31 localhost kernel: Modules linked in: tun fuse rndis_wlan rndis_host cdc_ether usbnet cdc_acm mii i915 drm i2c_algo_bit rfcomm bridge stp llc 
bnep sco af_packet l2cap sunrpc ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 xt_state 
nf_conntrack ip6table_filter ip6_tables x_tables ipv6 acpi_cpufreq binfmt_misc nls_utf8 ext3 jbd loop dm_multipath uinput snd_hda_codec_conexant snd_hda_intel 
arc4 ecb snd_hda_codec pcmcia iwlagn snd_hwdep snd_pcm iwlcore snd_timer thinkpad_acpi snd yenta_socket ohci1394 ieee1394 rsrc_nonstatic rfkill usbhid soundcore 
pcmcia_core btusb mac80211 intel_agp led_class hid bluetooth i2c_i801 sr_mod snd_page_alloc i2c_core iTCO_wdt e1000e agpgart cdrom joydev nvram sg wmi rtc_cmos 
iTCO_vendor_support processor battery cfg80211 rtc_core video thermal ac button rtc_lib output dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod ahci 
libata sd_mod scsi_mod ext4 mbcache jbd2 crc16 uhci_hcd ohci_hcd ehci_hcd usbcore [l
Jul 28 12:30:31 localhost kernel: ast unloaded: scsi_wait_scan]
Jul 28 12:30:31 localhost kernel: Pid: 11299, comm: X Not tainted 2.6.30.2-pae #97
Jul 28 12:30:31 localhost kernel: Call Trace:
Jul 28 12:30:31 localhost kernel: [<c0126175>] warn_slowpath_common+0x65/0x7c
Jul 28 12:30:31 localhost kernel: [<f9188a3a>] ? i915_gem_idle+0x172/0x277 [i915]
Jul 28 12:30:31 localhost kernel: [<c0126199>] warn_slowpath_null+0xd/0x10
Jul 28 12:30:31 localhost kernel: [<f9188a3a>] i915_gem_idle+0x172/0x277 [i915]
Jul 28 12:30:31 localhost kernel: [<f9188b8e>] i915_gem_leavevt_ioctl+0x1f/0x2e [i915]
Jul 28 12:30:31 localhost kernel: [<f8a8657c>] drm_ioctl+0x1fd/0x28d [drm]
Jul 28 12:30:31 localhost kernel: [<f9188b6f>] ? i915_gem_leavevt_ioctl+0x0/0x2e [i915]
Jul 28 12:30:31 localhost kernel: [<f8e2561b>] ? agp_controller_release_current+0x4a/0x4c [agpgart]
Jul 28 12:30:31 localhost kernel: [<f8e2562c>] ? agpioc_release_wrap+0xf/0x13 [agpgart]
Jul 28 12:30:31 localhost kernel: [<f8e26225>] ? agp_ioctl+0x3ae/0x3d1 [agpgart]
Jul 28 12:30:31 localhost kernel: [<c01f5a95>] ? cpumask_any_but+0x21/0x2d
Jul 28 12:30:31 localhost kernel: [<c01189dd>] ? flush_tlb_page+0x4a/0x63
Jul 28 12:30:31 localhost kernel: [<c0118396>] ? ptep_set_access_flags+0x37/0x3f
Jul 28 12:30:31 localhost kernel: [<c013d34a>] ? getnstimeofday+0x4e/0xd8
Jul 28 12:30:31 localhost kernel: [<c01191ac>] ? kunmap_atomic+0x60/0x6e
Jul 28 12:30:31 localhost kernel: [<c019630c>] vfs_ioctl+0x57/0x71
Jul 28 12:30:31 localhost kernel: [<c019678d>] do_vfs_ioctl+0x467/0x4a1
Jul 28 12:30:31 localhost kernel: [<c0178146>] ? handle_mm_fault+0x5a2/0x5fd
Jul 28 12:30:31 localhost kernel: [<c015498c>] ? audit_syscall_entry+0x188/0x1aa
Jul 28 12:30:31 localhost kernel: [<c0196808>] sys_ioctl+0x41/0x61
Jul 28 12:30:31 localhost kernel: [<c0102914>] sysenter_do_call+0x12/0x28
Jul 28 12:30:31 localhost kernel: ---[ end trace ca0a048277a14a17 ]---
Jul 28 12:30:31 localhost kernel: [drm:gm45_get_vblank_counter] *ERROR* trying to get vblank count for disabled pipe 0
Jul 28 12:30:31 localhost kernel: mtrr: no MTRR for d0000000,10000000 found
Jul 28 12:30:37 localhost kernel: thinkpad_acpi: EC reports that Thermal Table has changed
Jul 28 13:13:37 localhost kernel: CPU0 attaching NULL sched-domain.

Error on 2.6.31-rc2:
Jul 13 17:33:26 localhost kernel: ------------[ cut here ]------------
Jul 13 17:33:26 localhost kernel: WARNING: at drivers/gpu/drm/i915/i915_gem.c:3931 i915_gem_idle+0x174/0x279 [i915]()
Jul 13 17:33:26 localhost kernel: Hardware name: 40622XG
Jul 13 17:33:26 localhost kernel: Modules linked in: fuse i915 drm i2c_algo_bit rfcomm bridge stp llc bnep sco l2cap sunrpc ipt_REJECT nf_conntrack_ipv4 
nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ipv6 acpi_cpufreq 
af_packet binfmt_misc nls_utf8 ext3 jbd loop dm_multipath uinput arc4 snd_hda_codec_conexant ecb snd_hda_intel snd_hda_codec iwlagn iwlcore snd_hwdep snd_pcm 
snd_timer mac80211 pcmcia btusb usbhid snd ohci1394 cfg80211 bluetooth intel_agp i2c_i801 hid soundcore thinkpad_acpi ieee1394 sr_mod led_class snd_page_alloc 
iTCO_wdt rfkill i2c_core joydev agpgart yenta_socket cdrom e1000e rsrc_nonstatic sg rtc_cmos pcmcia_core rtc_core video processor battery iTCO_vendor_support 
nvram wmi rtc_lib output ac thermal button ahci libata sd_mod scsi_mod dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod ext4 mbcache jbd2 crc16 
uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded: scsi_wait_scan]
Jul 13 17:33:26 localhost kernel: Pid: 2198, comm: Xorg Not tainted 2.6.31-rc2-pae #89
Jul 13 17:33:26 localhost kernel: Call Trace:
Jul 13 17:33:26 localhost kernel: [<c012c139>] warn_slowpath_common+0x65/0x7c
Jul 13 17:33:26 localhost kernel: [<f9209dec>] ? i915_gem_idle+0x174/0x279 [i915]
Jul 13 17:33:26 localhost kernel: [<c012c15d>] warn_slowpath_null+0xd/0x10
Jul 13 17:33:26 localhost kernel: [<f9209dec>] i915_gem_idle+0x174/0x279 [i915]
Jul 13 17:33:26 localhost kernel: [<f9209f40>] i915_gem_leavevt_ioctl+0x1f/0x2e [i915]
Jul 13 17:33:26 localhost kernel: [<f8740478>] drm_ioctl+0x1f5/0x283 [drm]
Jul 13 17:33:26 localhost kernel: [<f9209f21>] ? i915_gem_leavevt_ioctl+0x0/0x2e [i915]
Jul 13 17:33:26 localhost kernel: [<c02a912b>] ? raw_pci_read+0x37/0x46
Jul 13 17:33:26 localhost kernel: [<f8ebc623>] ? agp_controller_release_current+0x4a/0x4c [agpgart]
Jul 13 17:33:26 localhost kernel: [<c0210bbd>] ? cpumask_any_but+0x21/0x2d
Jul 13 17:33:26 localhost kernel: [<c011bf75>] ? flush_tlb_page+0x4a/0x63
Jul 13 17:33:26 localhost kernel: [<c011b80e>] ? ptep_set_access_flags+0x37/0x3f
Jul 13 17:33:26 localhost kernel: [<c011c6ca>] ? kunmap_atomic+0x5a/0x69
Jul 13 17:33:26 localhost kernel: [<c018a293>] ? do_wp_page+0x65e/0x6e3
Jul 13 17:33:26 localhost kernel: [<c01aa398>] vfs_ioctl+0x57/0x71
Jul 13 17:33:26 localhost kernel: [<c01aa8e0>] do_vfs_ioctl+0x48d/0x4cb
Jul 13 17:33:26 localhost kernel: [<c018b8f4>] ? handle_mm_fault+0x733/0x7af
Jul 13 17:33:26 localhost kernel: [<c0104a1d>] ? timer_interrupt+0x35/0x3c
Jul 13 17:33:26 localhost kernel: [<c015eec6>] ? handle_IRQ_event+0x52/0xf8
Jul 13 17:33:26 localhost kernel: [<c015cdd1>] ? audit_syscall_entry+0x19a/0x1bc
Jul 13 17:33:26 localhost kernel: [<c01aa95f>] sys_ioctl+0x41/0x61
Jul 13 17:33:26 localhost kernel: [<c0102914>] sysenter_do_call+0x12/0x28
Jul 13 17:33:26 localhost kernel: ---[ end trace 8aea149052ba59cb ]---
Jul 13 17:33:26 localhost kernel: [drm:gm45_get_vblank_counter] *ERROR* trying to get vblank count for disabled pipe 0
Jul 13 17:33:30 localhost kernel: type=1305 audit(1247499210.630:68): audit_pid=0 old=1024 auid=4294967295 ses=4294967295 res=1

Error on 2.6.31-rc4:
Jul 25 23:02:39 localhost kernel: ------------[ cut here ]------------
Jul 25 23:02:39 localhost kernel: WARNING: at drivers/gpu/drm/i915/i915_gem.c:3931 i915_gem_idle+0x174/0x279 [i915]()
Jul 25 23:02:39 localhost kernel: Hardware name: 40622XG
Jul 25 23:02:39 localhost kernel: Modules linked in: tun fuse af_packet i915 drm i2c_algo_bit rfcomm bridge stp llc bnep sco l2cap sunrpc ipt_REJECT 
nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ipv6 
acpi_cpufreq binfmt_misc nls_utf8 ext3 jbd loop dm_multipath uinput arc4 snd_hda_codec_conexant ecb snd_hda_intel snd_hda_codec iwlagn btusb snd_hwdep snd_pcm 
iwlcore bluetooth intel_agp thinkpad_acpi ohci1394 pcmcia mac80211 ieee1394 i2c_i801 e1000e snd_timer led_class sr_mod agpgart cdrom i2c_core joydev nvram snd 
yenta_socket wmi rtc_cmos rsrc_nonstatic iTCO_wdt soundcore rtc_core iTCO_vendor_support cfg80211 pcmcia_core snd_page_alloc video rtc_lib sg output ac battery 
button processor thermal dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod ahci libata sd_mod scsi_mod ext4 mbcache jbd2 crc16 ohci_hcd usbcore [last 
unloaded: uhci_hcd]
Jul 25 23:02:39 localhost kernel: Pid: 1766, comm: Xorg Not tainted 2.6.31-rc4-pae #98
Jul 25 23:02:39 localhost kernel: Call Trace:
Jul 25 23:02:39 localhost kernel: [<c012b3ed>] warn_slowpath_common+0x65/0x7c
Jul 25 23:02:39 localhost kernel: [<f8c31e0c>] ? i915_gem_idle+0x174/0x279 [i915]
Jul 25 23:02:39 localhost kernel: [<c012b411>] warn_slowpath_null+0xd/0x10
Jul 25 23:02:39 localhost kernel: [<f8c31e0c>] i915_gem_idle+0x174/0x279 [i915]
Jul 25 23:02:39 localhost kernel: [<f8c31f60>] i915_gem_leavevt_ioctl+0x1f/0x2e [i915]
Jul 25 23:02:39 localhost kernel: [<f89fb49c>] drm_ioctl+0x1f5/0x283 [drm]
Jul 25 23:02:39 localhost kernel: [<f8c31f41>] ? i915_gem_leavevt_ioctl+0x0/0x2e [i915]
Jul 25 23:02:39 localhost kernel: [<c013fb34>] ? ktime_get+0x13/0x30
Jul 25 23:02:39 localhost kernel: [<f8ee2623>] ? agp_controller_release_current+0x4a/0x4c [agpgart]
Jul 25 23:02:39 localhost kernel: [<f8ee2634>] ? agpioc_release_wrap+0xf/0x13 [agpgart]
Jul 25 23:02:39 localhost kernel: [<f8ee322d>] ? agp_ioctl+0x3ae/0x3d1 [agpgart]
Jul 25 23:02:39 localhost kernel: [<c011c8cf>] ? __wake_up_common+0x34/0x5c
Jul 25 23:02:39 localhost kernel: [<c011f298>] ? __wake_up+0x32/0x3b
Jul 25 23:02:39 localhost kernel: [<c01a5048>] vfs_ioctl+0x57/0x71
Jul 25 23:02:39 localhost kernel: [<c01a5590>] do_vfs_ioctl+0x48d/0x4cb
Jul 25 23:02:39 localhost kernel: [<c0314960>] ? schedule+0x7c6/0x844
Jul 25 23:02:39 localhost kernel: [<c015c11a>] ? audit_syscall_entry+0x19a/0x1bc
Jul 25 23:02:39 localhost kernel: [<c01a560f>] sys_ioctl+0x41/0x61
Jul 25 23:02:39 localhost kernel: [<c0102914>] sysenter_do_call+0x12/0x28
Jul 25 23:02:39 localhost kernel: ---[ end trace 76277bc18967b862 ]---
Jul 25 23:02:39 localhost kernel: [drm:gm45_get_vblank_counter] *ERROR* trying to get vblank count for disabled pipe 0
Jul 25 23:02:40 localhost kernel: mtrr: no MTRR for d0000000,10000000 found
Jul 25 23:02:46 localhost kernel: type=1305 audit(1248555766.215:158): audit_pid=0 old=709 auid=4294967295 ses=4294967295 res=1
Jul 25 23:02:46 localhost kernel: Kernel logging (proc) stopped.


Regards,
Niel
