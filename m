Return-Path: <linux-kernel-owner+w=401wt.eu-S1759299AbZCSRjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759299AbZCSRjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 13:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753081AbZCSRj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 13:39:26 -0400
Received: from orion.ambsoft.pl ([212.109.144.130]:50489 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbZCSRjZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 13:39:25 -0400
X-Greylist: delayed 455 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Mar 2009 13:39:25 EDT
Date: Thu, 19 Mar 2009 18:31:44 +0100
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Frans Pop <elendil@planet.nl>
Cc: dri-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       airlied@linux.ie
Subject: Re: DRM oops while starting second X.org session in chroot
Message-ID: <20090319183144.0d772a61@mako-laptop>
In-Reply-To: <200903141534.43443.elendil@planet.nl>
References: <200903141534.43443.elendil@planet.nl>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia 2009-03-14, o godz. 15:34:42
Frans Pop <elendil@planet.nl> napisał(a):

> I had the oops below today after I tried to start a second X.org
> session in a chroot using 'startx -- :1'. I think the problem here is
> that the driver was loaded, but that the corresponding device did not
> exist in /dev in the chroot (forgot to bind mount it). If that is the
> cause, it would be nice if it was handled more gracefully than
> this :-P
> 
> The oops also hung my primary X session. I could no longer switch
> consoles. Sysrq did still work.

FYI, I run into this today as well. I'm using regular ubuntu
installation. The only major change is that I use 2.6.29-rc8 at the
moment. I did not do anything different than usual. I started my x61s,
kernel was booting and when it came to start X the screen went black.
sysrq still worked etc. but I coulnd switch back to console - reboot was
needed so I don't think its related to your chroot etcetra. BTW it is not
easily reproducible - it just happens sometimes.

	Mariusz


kernel BUG at drivers/gpu/drm/drm_fops.c:146!
invalid opcode: 0000 [#1] PREEMPT SMP 
last sysfs file: /sys/devices/virtual/backlight/thinkpad_screen/brightness
Modules linked in: i915 drm i2c_algo_bit i2c_core binfmt_misc kvm_intel kvm ppdev acpi_cpufreq cpufreq_stats cpufreq_powersave cpufreq_userspace cpufreq_conservative cpufreq_ondemand freq_table fan sbs sbshc container pci_slot iptable_filter ip_tables x_tables sbp2 parport_pc parport fuse snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy pcmcia arc4 ecb snd_seq_oss snd_seq_midi_event snd_seq thinkpad_acpi iwl3945 snd_timer snd_seq_device rfkill mac80211 nvram evdev led_class ohci1394 psmouse snd lib80211 serio_raw ieee1394 pcspkr thermal yenta_socket rsrc_nonstatic pcmcia_core ac battery soundcore cfg80211 intel_agp sg ehci_hcd uhci_hcd button processor agpgart snd_page_alloc e1000e usbcore [last unloaded: lp]

Pid: 3797, comm: Xorg Not tainted (2.6.29-rc8 #9) 7667Y24
EIP: 0060:[<f87d7558>] EFLAGS: 00213202 CPU: 1
EIP is at drm_open+0x3f8/0x500 [drm]
EAX: f61ba808 EBX: 00000000 ECX: f87fc8c0 EDX: f6186000
ESI: f60a8c00 EDI: f6082220 EBP: f61bfe38 ESP: f61bfe00
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process Xorg (pid: 3797, ti=f61be000 task=f6158000 task.ti=f61be000)
Stack:
 f61bfe10 f6bc0480 f61bfe14 c02412f2 f6186000 f60a8c14 f61ac200 f6082220
 f6504660 00000000 f6504674 ffffffed f61ac200 f6082220 f61bfe64 f87d777f
 f7024000 000000ff f60a8c00 00000001 f61bfe60 f87e5520 00000000 f6bc0480
Call Trace:
 [<c02412f2>] ? kobject_get+0x12/0x20
 [<f87d777f>] ? drm_stub_open+0x11f/0x200 [drm]
 [<c01a4e82>] ? chrdev_open+0x102/0x1f0
 [<c019ff31>] ? __dentry_open+0xf1/0x2c0
 [<c01a995c>] ? inode_permission+0x8c/0xc0
 [<c01a01f3>] ? nameidata_to_filp+0x53/0x60
 [<c01a4d80>] ? chrdev_open+0x0/0x1f0
 [<c01ad041>] ? do_filp_open+0x1c1/0x7a0
 [<c01b819d>] ? mntput_no_expire+0x1d/0x130
 [<c038ca13>] ? _spin_unlock+0x13/0x30
 [<c01b6a68>] ? alloc_fd+0xe8/0x100
 [<c019fcf9>] ? do_sys_open+0x59/0xf0
 [<c019fdf9>] ? sys_open+0x29/0x40
 [<c01035a7>] ? sysenter_do_call+0x12/0x33
 [<c0380000>] ? msi_ht_cap_enabled+0x73/0xaa
Code: 46 34 00 00 00 00 89 f0 e8 c6 e7 ff ff 89 c3 85 c0 0f 89 ae fe ff ff e9 83 fc ff ff 8b 7d e4 3b 87 a4 00 00 00 0f 84 85 fc ff ff <0f> 0b eb fe 8d 74 26 00 8b 45 e8 e8 58 5c 9c c7 8b 7d e0 8d 46 
EIP: [<f87d7558>] drm_open+0x3f8/0x500 [drm] SS:ESP 0068:f61bfe00
