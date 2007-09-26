Return-Path: <linux-kernel-owner+w=401wt.eu-S1761857AbXIZWRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761857AbXIZWRo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 18:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbXIZWRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 18:17:36 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:49981 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868AbXIZWRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 18:17:35 -0400
Subject: Re: [Bluez-devel] Warnings and Oops on 2.6.23-rc6 while activily
	using rfcomm links (mm/slab.c)
From: Marcel Holtmann <marcel@holtmann.org>
To: BlueZ development <bluez-devel@lists.sourceforge.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <46F92364.3080603@idlum.be>
References: <46F92364.3080603@idlum.be>
Content-Type: text/plain
Date: Thu, 27 Sep 2007 00:16:22 +0200
Message-Id: <1190844983.6484.39.camel@aeonflux.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre-Yves,

> Putting the bluetooth system under load (opening and closing several 
> rfcomm links off several USB adapters, and transmitting data over
> them), 
> I got the Oops below. The computer hung completely, as you can see.
> Just 
> before, I also got those warnings.

I got another one that also seems to involve device_move() in some way.
No idea on how I really got there. One time after resume it was there
and I was simply using my UMTS mobile phone for Internet connection.

Regards

Marcel


general protection fault: 0000 [#2]
Modules linked in: battery ac thermal fan button ipw2200 ieee80211 ieee80211_cry
pt tg3 btusb ppp_deflate zlib_deflate bsd_comp ppp_async crc_ccitt ppp_generic s
lhc option usbserial ohci_hcd bnep bridge llc rfcomm l2cap bluetooth binfmt_misc
 nfsd exportfs lockd sunrpc uinput parport_pc ppdev parport i915 drm ipv6 acpi_c
pufreq cpufreq_stats cpufreq_powersave cpufreq_performance cpufreq_ondemand freq
_table cpufreq_conservative sbs container bay dock fuse snd_intel8x0 snd_ac97_co
dec ac97_bus pcmcia snd_pcm_oss snd_pcm snd_mixer_oss snd_seq_oss snd_seq_midi s
nd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device sdhci firmware_cl
ass evdev sg mmc_core yenta_socket rsrc_nonstatic pcmcia_core snd ehci_hcd uhci_
hcd 8250_pci 8250 serial_core thinkpad_acpi hwmon video output soundcore snd_pag
e_alloc backlight nvram usbcore processor unix
CPU:    0
EIP:    0060:[<c017135d>]    Tainted: G      D VLI
EFLAGS: 00010282   (2.6.23-rc7 #41)
EIP is at dput+0xf/0xf4
eax: fffffffe   ebx: fffffffe   ecx: 00000000   edx: f70f6d04
esi: fffffffe   edi: f76e14b0   ebp: d16b5de0   esp: d16b5dd8
ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
Process wvdial (pid: 5229, ti=d16b5000 task=c46a6cb0 task.ti=d16b5000)
Stack: f1d8b0a8 fffffffe d16b5e18 c019539c ffffffff fffffffe ffffffff 00000000 
       f77c8ac8 f1d8b0a8 00000000 fffffffe 00000000 f1d8b0a8 f72f9dc0 f72f9f40 
       d16b5e48 c01d8fea c5d8bec0 c0359476 f72f9f40 fffffff4 c5d8bec0 c5d8bec0 
Call Trace:
 [<c0106d8a>] show_trace_log_lvl+0x1a/0x2f
 [<c0106e3c>] show_stack_log_lvl+0x9d/0xa5
 [<c0106ff9>] show_registers+0x1b5/0x287
 [<c01071bc>] die+0xf1/0x225
 [<c02cd537>] do_general_protection+0x1b8/0x1c0
 [<c02ccf1a>] error_code+0x6a/0x70
 [<c019539c>] sysfs_move_dir+0x1a0/0x1b2
 [<c01d8fea>] kobject_move+0xab/0xf6
 [<c023c9d9>] device_move+0x52/0xed
 [<f8e36dbf>] rfcomm_tty_open+0x1b9/0x1c4 [rfcomm]
 [<c0222fa6>] tty_open+0x170/0x2b1
 [<c0164662>] chrdev_open+0xf1/0x137
 [<c0160d99>] __dentry_open+0xb8/0x169
 [<c0160ecb>] nameidata_to_filp+0x27/0x37
 [<c0160f0e>] do_filp_open+0x33/0x3b
 [<c0160f5b>] do_sys_open+0x45/0xc4
 [<c0161012>] sys_open+0x1c/0x1e
 [<c0105d4e>] sysenter_past_esp+0x6b/0xa1
 =======================
Code: 49 43 83 f9 ff 75 e5 89 75 e8 8d 55 e8 89 f8 e8 f0 fd ff ff 83 c4 0c 5b 5e
 5f 5d c3 55 89 e5 56 53 89 c3 85 c0 0f 84 e1 00 00 00 <83> 38 01 75 05 e8 17 a0
 15 00 ba 40 8b 39 c0 89 d8 e8 cd 6a 06 
EIP: [<c017135d>] dput+0xf/0xf4 SS:ESP 0068:d16b5dd8


