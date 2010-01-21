Return-Path: <linux-kernel-owner+w=401wt.eu-S1752747Ab0AUPGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab0AUPGP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 10:06:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752256Ab0AUPGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 10:06:14 -0500
Received: from kroah.org ([198.145.64.141]:56640 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539Ab0AUPGM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 10:06:12 -0500
Date: Thu, 21 Jan 2010 07:05:17 -0800
From: Greg KH <greg@kroah.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: softlockup problem on resume from ram
Message-ID: <20100121150517.GA12241@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When resuming from S3 on a number of laptops, with the 2.6.32.2 kernel
and CONFIG_DETECT_SOFTLOCKUP enabled, I'm getting the following series
of kernel "bug" messages:

[1266874879.580346] CPU0: Thermal monitoring enabled (TM1)
[1266874879.580404] Extended CMOS year: 2000
[1266874879.580428] Enabling non-boot CPUs ...
[1266874879.580671] SMP alternatives: switching to SMP code
[1266874879.585114] BUG: soft lockup - CPU#0 stuck for 0s! [s2ram:17200]
[1266874879.585115] Modules linked in: nfs lockd fscache nfs_acl auth_rpcgss sunrpc af_packet btusb sco bridge stp llc bnep rfcomm l2cap crc16 bluetooth rfkill ip6t_LOG xt_tcpudp xt_pkttype ipt_LOG xt_limit binfmt_misc snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device ip6t_REJECT nf_conntrack_ipv6 ip6table_raw xt_NOTRACK ipt_REJECT xt_state iptable_raw iptable_filter ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq ip6table_filter speedstep_lib ip6_tables x_tables ipv6 microcode fuse nls_iso8859_1 nls_cp437 vfat fat loop dm_mod snd_hda_codec_intelhdmi snd_hda_codec_realtek snd_hda_intel i915 snd_hda_codec drm_kms_helper uvcvideo drm videodev i2c_algo_bit usb_storage video v4l1_compat pcspkr snd_hwdep joydev ac button battery i2c_i801 intel_agp sr_mod cdrom wmi snd_pcm snd_timer snd soundcore r8169 snd_page_alloc sg sd_mod ehci_hcd usbcore edd fan thermal processor the
rmal_sys ahci libata scsi_mod
[1266874879.585161] Supported: Yes
[1266874879.585162] 
[1266874879.585164] Pid: 17200, comm: s2ram Tainted: G          N  (2.6.32.2-9-pae #1) Presario CQ42 Notebook PC
[1266874879.585166] EIP: 0060:[<c059b19b>] EFLAGS: 00000286 CPU: 0
[1266874879.585171] EIP is at text_poke+0x18b/0x220
[1266874879.585173] EAX: 000000f0 EBX: 00100800 ECX: ee7cfe2f EDX: 00000001
[1266874879.585174] ESI: ee7cfe30 EDI: ff5b627f EBP: f6ca9680 ESP: ee7cfdf4
[1266874879.585176]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[1266874879.585177] CR0: 8005003b CR2: 0805c8d0 CR3: 34326000 CR4: 000006f0
[1266874879.585179] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874879.585180] DR6: ffff0ff0 DR7: 00000400
[1266874879.585182] Call Trace:
[1266874879.585195]  [<c02084e6>] alternatives_smp_switch+0xe6/0x190
[1266874879.585201]  [<c059473d>] do_boot_cpu+0x97/0x4ed
[1266874879.585204]  [<c0594c7c>] native_cpu_up+0xe9/0x1c6
[1266874879.585207]  [<c059603c>] _cpu_up+0x7c/0x10c
[1266874879.585212]  [<c0587fdc>] enable_nonboot_cpus+0x8c/0xc0
[1266874879.585218]  [<c027d276>] suspend_enter+0xa6/0x120
[1266874879.585222]  [<c027d377>] suspend_devices_and_enter+0x87/0xa0
[1266874879.585225]  [<c027d44b>] enter_state+0xbb/0xf0
[1266874879.585228]  [<c027cb67>] state_store+0x97/0xd0
[1266874879.585233]  [<c03ee9f4>] kobj_attr_store+0x24/0x30
[1266874879.585239]  [<c0358be1>] sysfs_write_file+0xa1/0x100
[1266874879.585243]  [<c03026ee>] vfs_write+0x9e/0x110
[1266874879.585247]  [<c030289f>] sys_write+0x4f/0xc0
[1266874879.585249]  [<c02030a4>] sysenter_do_call+0x12/0x22
[1266874879.585255]  [<ffffe424>] 0xffffe424

I have a question about the "CPU#0 stuck for 0s!" message.

In looking at the softlockup code, it shouldn't be triggering for "0"
seconds, but I'm wondering if the resume from ram sequence is causing
something to break.

Any ideas or patches I could try?  Or should I just disable this kernel
config option as it's not that useful for end-users?

thanks,

greg k-h
