Return-Path: <linux-kernel-owner+w=401wt.eu-S1754053AbZBGTor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbZBGTor (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 14:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753097AbZBGToj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 14:44:39 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:53473 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbZBGToh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 14:44:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=i/n00mR0VXVWd1Fja7pUgs/afCqCHoCbuYkQqzyCvEktG/qGYO1HK7BTk5zc3rlErC
         BoBMWudCFiWPAQYcAUpg6aYVaCBpS+7lw0v01o9lByd+s29w/94mpKOdWjlsd4WVsVT3
         ska6JAma9CzJXeHapgIX+DtOEjoz21bfcH7Ro=
MIME-Version: 1.0
Date: Sat, 7 Feb 2009 20:44:35 +0100
Message-ID: <c43b2e150902071144j4f01e754y83205ad8d734fd95@mail.gmail.com>
Subject: viafb triggers BUG at mm/vmalloc.c:294 [kernel 2.6.28.3]
From: wixor <wixorpeek@gmail.com>
To: JosephChan@via.com.tw
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following happens regularly when trying to modprobe viafb module
on p4m900 chip (amilo pro v3515 laptop).

VIA Graphics Intergration Chipset framebuffer 2.4 initializing
------------[ cut here ]------------
kernel BUG at mm/vmalloc.c:294!
invalid opcode: 0000 [#1]
last sysfs file: /sys/devices/virtual/block/loop7/range
Modules linked in: viafb(+) fb i2c_algo_bit cfbcopyarea cfbimgblt
cfbfillrect af_packet p4_clockmod speedstep_lib loop sr_mod arc4 ecb
cdrom cryptomgr aead crypto_blkcipher crypto_algapi ath5k mac80211
rtc_cmos rtc_core rtc_lib crypto snd_hda_intel led_class ehci_hcd
uhci_hcd pcspkr snd_pcm snd_timer snd_page_alloc i2c_viapro snd_hwdep
snd psmouse evdev cfg80211 via_rhine mii i2c_core soundcore usbcore
pata_via fan thermal battery ac button processor thermal_sys via_agp
agpgart hwmon unix

Pid: 1689, comm: modprobe Not tainted (2.6.28.3 #6) AMILO PRO V3515
EIP: 0060:[<c0161d70>] EFLAGS: 00010207 CPU: 0
EIP is at __insert_vmap_area+0x90/0xc0
EAX: 00701000 EBX: f0700000 ECX: ef9ceacc EDX: ef85460c
ESI: ee9f3a00 EDI: 00080000 EBP: 10001000 ESP: ee8b1d34
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process modprobe (pid: 1689, ti=ee8b0000 task=ef965ea0 task.ti=ee8b0000)
Stack:
 f0700000 f0700000 c0161f18 00000005 00701000 ee9f3a00 00000000 ee9f3a00
 0007ffff fff80000 ee166c4c 00000000 ee1df160 00080000 ee1df160 10001000
 c016205d ff7fe000 ffffffff 000000d0 f0690000 00000001 ff7fe000 00000573
Call Trace:
 [<f0700000>] snd_interval_ratnum+0x1b0/0x2a0 [snd_pcm]
 [<f0700000>] snd_interval_ratnum+0x1b0/0x2a0 [snd_pcm]
 [<c0161f18>] alloc_vmap_area+0x178/0x210
 [<c016205d>] __get_vm_area_node+0xad/0x160
 [<c01621a8>] get_vm_area_caller+0x48/0x50
 [<f0ac523e>] viafb_init+0x23e/0xe67 [viafb]
 [<c0116ccf>] __ioremap_caller+0x15f/0x2d0
 [<c0116f54>] ioremap_nocache+0x14/0x20
 [<f0ac523e>] viafb_init+0x23e/0xe67 [viafb]
 [<f0ac523e>] viafb_init+0x23e/0xe67 [viafb]
 [<f0ac5000>] viafb_init+0x0/0xe67 [viafb]
 [<c0101126>] do_one_initcall+0x36/0x1b0
 [<c01af450>] sysfs_ilookup_test+0x0/0x10
 [<c01af891>] __sysfs_add_one+0x11/0xa0
 [<c01afbf4>] sysfs_addrm_finish+0x14/0x1b0
 [<c0162340>] __vunmap+0xb0/0xe0
 [<c014160a>] load_module+0x128a/0x13f0
 [<c01418cb>] sys_init_module+0x8b/0x1b0
 [<c0103261>] sysenter_do_call+0x12/0x25
Code: 8b 5a 18 8d 4e 18 89 46 1c 89 5e 18 89 4a 18 89 4b 04 5b 5e c3
8d b6 00 00 00 00 8b 46 04 3b 42 f4 76 08 8d 42 04 89 d1 eb 9d 90 <0f>
0b eb fe a1 04 2c 37 c0 8d 56 18 c7 46 1c 04 2c 37 c0 89 46
EIP: [<c0161d70>] __insert_vmap_area+0x90/0xc0 SS:ESP 0068:ee8b1d34
---[ end trace a37be145f08b1116 ]---

After that screen is totally rubbished and flickering, however rmmod
and vbetool post return it back to working vga console. the module
would not load again ever after (modprobe hangs, nothing in dmesg)

The chip is
01:00.0 VGA compatible controller: VIA Technologies, Inc.
CN896/VN896/P4M900 [Chrome 9 HC] (rev 01) (pciid: 1106:3371)

Kernel version is 2.6.28.3. It is compiled with 8KB stack.

Please CC me, I'm not in the list

--
wixor
