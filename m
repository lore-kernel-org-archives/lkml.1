Return-Path: <linux-kernel-owner+w=401wt.eu-S1759788AbZE1AOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759788AbZE1AOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 20:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755119AbZE1AOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 20:14:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40883 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754129AbZE1AOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 20:14:43 -0400
Date: Wed, 27 May 2009 17:14:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Niel Lambrechts <niel.lambrechts@gmail.com>
Cc: linux-kernel@vger.kernel.org, eric@anholt.net, jbarnes@virtuousgeek.org,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.30-rc6: i915: Xserver crash - oops after rmmod
Message-Id: <20090527171414.108710cf.akpm@linux-foundation.org>
In-Reply-To: <4A11B52E.7080808@gmail.com>
References: <4A11B52E.7080808@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 May 2009 21:21:18 +0200
Niel Lambrechts <niel.lambrechts@gmail.com> wrote:

> Hi,

Huge response, huh?

> I use s2disk on a daily basis, and I recently tried to switch to UXA in 
> xorg.conf in anticipation of KMS, for my Lenovo W500 with the integrated 
> Intel card active:
> 00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series 
> Chipset Integrated Graphics Controller (rev 07)
> 
> Resuming worked just fine the last couple of days using UXA but I 
> admittedly frequently update Mesa/Xorg/git kernel.
> 
> Tonight the X server crashed on resume and I was placed back at the KDM 
> prompt. I thought "$%^&$ the one time I actually had real applications 
> open! I am switching back to EXA!", so I changed AccelMethod back to 
> "exa" and decided to unload all i915 modules - i915, drm, and video.
> 
> The latter unexpectedly returned "Killed", although none of these 
> modules showed any 'used by' count.
> 
> I then did 'init 5' upon which I had a black screen, and decided to 
> reboot. I then noticed that the following OOPS occurred prior to the 
> reboot, likely the result of my "rmmod drm" or "rmmod output".
> 
> May 18 19:35:56 linux-7vph kernel: Restarting tasks ... done.
> May 18 19:36:07 linux-7vph kdm[2882]: X server for display :0 terminated 
> unexpectedly
> May 18 19:36:18 linux-7vph bonobo-activation-server (niella-10440): 
> could not associate with desktop session: Failed to connect to socket 
> /tmp/dbus-snlESQlAbp: Connection refused
> May 18 19:36:32 linux-7vph kernel: [drm:gm45_get_vblank_counter] *ERROR* 
> trying to get vblank count for disabled pipe 0
> May 18 19:37:01 linux-7vph kernel: [drm:gm45_get_vblank_counter] *ERROR* 
> trying to get vblank count for disabled pipe 0
> May 18 19:37:03 linux-7vph init: Switching to runlevel: 3
> May 18 19:37:34 linux-7vph kernel: mtrr: MTRR 4 not used
> May 18 19:37:34 linux-7vph kernel: [drm] Module unloaded
> May 18 19:37:47 linux-7vph kernel: BUG: unable to handle kernel NULL 
> pointer dereference at 00000010
> May 18 19:37:47 linux-7vph kernel: IP: [<c02fbbef>] klist_put+0x12/0x6f
> May 18 19:37:47 linux-7vph kernel: *pde = 00000000
> May 18 19:37:47 linux-7vph kernel: Oops: 0000 [#1] SMP
> May 18 19:37:47 linux-7vph kernel: last sysfs file: 
> /sys/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/rfkill/rfkill1/state
> May 18 19:37:47 linux-7vph kernel: Modules linked in: usbhid hid tun 
> i2c_algo_bit af_packet ip6t_LOG xt_tcpudp xt_pkttype ipt_LOG xt_limit 
> snd_pcm_oss snd_mixer_oss snd_seq binfmt_misc ip6t_REJECT 
> nf_conntrack_ipv6 ip6table_raw xt_NOTRACK ipt_REJECT xt_state 
> cpufreq_conservative cpufreq_userspace iptable_raw cpufreq_powersave 
> iptable_filter acpi_cpufreq speedstep_lib ip6table_mangle 
> nf_conntrack_netbios_ns nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 
> ip_tables ip6table_filter ip6_tables x_tables ipv6 microcode fuse loop 
> dm_mod snd_usb_audio snd_usb_lib snd_rawmidi snd_seq_device arc4 ecb 
> iwlagn iwlcore thinkpad_acpi rfkill led_class snd_hda_codec_conexant 
> video(-) mac80211 ohci1394 battery ac output nvram ieee1394 rtc_cmos 
> snd_hda_intel wmi snd_hda_codec rtc_core button snd_hwdep snd_pcm 
> snd_timer snd i2c_i801 soundcore iTCO_wdt snd_page_alloc 
> iTCO_vendor_support intel_agp cfg80211 rtc_lib e1000e i2c_core agpgart 
> sr_mod cdrom joydev sg ehci_hcd uhci_hcd sd_mod usbcore ext4 jbd2 crc16 
> edd ext3 mbcache jbd fan ahci l
> May 18 19:37:47 linux-7vph kernel: ibata scsi_mod thermal processor 
> [last unloaded: drm]
> May 18 19:37:47 linux-7vph kernel:
> May 18 19:37:47 linux-7vph kernel: Pid: 10594, comm: rmmod Not tainted 
> (2.6.30-rc6-pae #47) 40622XG
> May 18 19:37:47 linux-7vph kernel: EIP: 0060:[<c02fbbef>] EFLAGS: 
> 00010246 CPU: 1
> May 18 19:37:47 linux-7vph kernel: EIP is at klist_put+0x12/0x6f
> May 18 19:37:47 linux-7vph kernel: EAX: f5c281f8 EBX: 00000001 ECX: 
> 00000004 EDX: 00000001
> May 18 19:37:47 linux-7vph kernel: ESI: 00000000 EDI: f5c281f8 EBP: 
> f44adef0 ESP: f44adedc
> May 18 19:37:47 linux-7vph kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0033 
> SS: 0068
> May 18 19:37:47 linux-7vph kernel: Process rmmod (pid: 10594, 
> ti=f44ac000 task=f5c7f0b0 task.ti=f44ac000)
> May 18 19:37:47 linux-7vph kernel: Stack:
> May 18 19:37:47 linux-7vph kernel:  c0134d30 00000000 00000002 00000000 
> c04297b4 f44adef8 c02fbc77 f44adf18
> May 18 19:37:47 linux-7vph kernel:  c02fbd7b c04376d0 c04376d0 f5c281f8 
> f5c7f0b0 00000000 f85e08c0 f44adf2c
> May 18 19:37:47 linux-7vph kernel:  c026d83e 00000000 f85e08c0 00000000 
> f44adf3c c026e6e1 f85e0980 bf994ca0
> May 18 19:37:47 linux-7vph kernel: Call Trace:
> May 18 19:37:47 linux-7vph kernel:  [<c0134d30>] ? insert_work+0x78/0x81
> May 18 19:37:47 linux-7vph kernel:  [<c02fbc77>] ? klist_del+0xd/0xf
> May 18 19:37:47 linux-7vph kernel:  [<c02fbd7b>] ? klist_remove+0x58/0x81
> May 18 19:37:47 linux-7vph kernel:  [<c026d83e>] ? 
> bus_remove_driver+0x5c/0x89
> May 18 19:37:47 linux-7vph kernel:  [<c026e6e1>] ? 
> driver_unregister+0x2a/0x2e
> May 18 19:37:47 linux-7vph kernel:  [<c0226253>] ? 
> acpi_bus_unregister_driver+0xd/0xf
> May 18 19:37:47 linux-7vph kernel:  [<f85de371>] ? 
> cleanup_module+0xd/0x25 [video]
> May 18 19:37:47 linux-7vph kernel:  [<c01477d5>] ? 
> sys_delete_module+0x18a/0x1e3
> May 18 19:37:47 linux-7vph kernel:  [<c017b9be>] ? remove_vma+0x46/0x4c
> May 18 19:37:47 linux-7vph kernel:  [<c017c5d2>] ? do_munmap+0x20a/0x225
> May 18 19:37:47 linux-7vph kernel:  [<c01029d4>] ? 
> sysenter_do_call+0x12/0x28
> May 18 19:37:47 linux-7vph kernel: Code: 90 83 7d f0 00 74 09 85 ff 74 
> 05 89 f8 ff 55 f0 8b 46 04 5a 5b 5e 5f 5d c3 55 89 e5 57 89 c7 56 53 89 
> d3 83 ec 08 8b 30 83 e6 fe <8b> 46 10 89 45 f0 89 f0 e8 0b f4 00 00 84 
> db 74 17 f6 07 01 74
> May 18 19:37:47 linux-7vph kernel: EIP: [<c02fbbef>] klist_put+0x12/0x6f 
> SS:ESP 0068:f44adedc
> May 18 19:37:47 linux-7vph kernel: CR2: 0000000000000010
> May 18 19:37:47 linux-7vph kernel: ---[ end trace c76e3f0980caa485 ]---
> May 18 19:38:41 linux-7vph sudo:   niella : TTY=tty2 ; PWD=/home/niella 
> ; USER=root ; COMMAND=/sbin/reboot
> 

The wordwrapping makes this painful to read.

rmmod crashed under drivers/acpi/video.c:acpi_video_exit()'s call to
acpi_bus_unregister_driver().  So it might be an acpi-related bug.

If it's reproducible at all, please raise a (non-wordwrapped!) report
against acpi at bugzilla.kernel.org, thanks.

