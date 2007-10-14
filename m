Return-Path: <linux-kernel-owner+w=401wt.eu-S1756206AbXJNKWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbXJNKWj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 06:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755170AbXJNKWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 06:22:31 -0400
Received: from main.gmane.org ([80.91.229.2]:35685 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753247AbXJNKWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 06:22:30 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
Subject: 2.6.23(.1) Regression? i915 oopses and panics
Date: Sun, 14 Oct 2007 12:22:14 +0200
Message-ID: <fesqkn$lml$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: port-83-236-56-183.dynamic.qsc.de
User-Agent: Thunderbird 2.0.0.6 (X11/20070802)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I first discovered this problem when updating to 2.6.23 final on x86_64.
When I launched google earth, the kernel paniced. When I tried to
reproduce, it oopsed instead of panicing.

dri/drm seems to work generally, as I am running beryl without trouble,
so far I could only reproduce the problem with google earth.

I have been using 2.6.23-rc6 for a while before, but I cannot tell if
the problem already occured there. I am sure though that it wasn't there
on 2.6.22(.Y). If anyone can tell me which commit might have caused
this, I can revert it and test though.

I don't have a trace of the panic, but I can give you the oops:

Oct 11 19:53:04 artin Unable to handle kernel paging request at
0000000000200200 RIP:
Oct 11 19:53:04 artin [<ffffffff8029142e>] __kmalloc+0x6e/0xb0
Oct 11 19:53:04 artin PGD 25ea2067 PUD 25ea0067 PMD 0
Oct 11 19:53:04 artin Oops: 0000 [1] PREEMPT SMP
Oct 11 19:53:04 artin CPU 1
Oct 11 19:53:04 artin Modules linked in: i915 drm michael_mic arc4
rfcomm ecb hidp hid ieee80211_crypt_tkip l2cap ieee80211_crypt_ccmp
cpufreq_ondemand joydev ohci1394 ieee1394 pcmcia hci_usb bluetooth
firewire_ohci firewire_core crc_itu_t sdhci mmc_core yenta_socket
rsrc_nonstatic pcmcia_core tsdev ipw3945 ieee80211 ieee80211_crypt
rtc_cmos rtc_core rtc_lib i2c_i801 i2c_core serio_raw psmouse ehci_hcd
uhci_hcd intel_agp sg thermal evdev fan button battery ac coretemp video
output fuse tun acpi_cpufreq freq_table processor snd_seq_oss
snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss
snd_hda_intel snd_pcm snd_timer snd_page_alloc snd_hwdep snd soundcore
8139too mii usbcore ext3 jbd mbcache sha256 aes_x86_64 dm_crypt dm_mod
sd_mod sr_mod cdrom ata_piix libata
Oct 11 19:53:04 artin Pid: 7870, comm: X Not tainted 2.6.23-ARCH #1
Oct 11 19:53:04 artin RIP: 0010:[<ffffffff8029142e>]
[<ffffffff8029142e>] __kmalloc+0x6e/0xb0
Oct 11 19:53:04 artin RSP: 0018:ffff810025ef7df8 EFLAGS: 00010006
Oct 11 19:53:04 artin RAX: 0000000000000000 RBX: ffffffff805c1e18 RCX:
ffffffff88324e4b
Oct 11 19:53:04 artin RDX: ffff810001ce45d0 RSI: 00000000000080d0 RDI:
0000000000000003
Oct 11 19:53:04 artin RBP: 00000000000080d0 R08: 0000000000000001 R09:
0000000000818580
Oct 11 19:53:04 artin R10: 0000000000000000 R11: 0000000000003202 R12:
0000000000200200
Oct 11 19:53:04 artin R13: 0000000000000282 R14: ffff810037cd092c R15:
0000000000000202
Oct 11 19:53:04 artin FS: 00002b1a198525c0(0000)
GS:ffff81003f6d1100(0000) knlGS:0000000000000000
Oct 11 19:53:04 artin CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Oct 11 19:53:04 artin CR2: 0000000000200200 CR3: 0000000027a85000 CR4:
00000000000006e0
Oct 11 19:53:04 artin DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
Oct 11 19:53:04 artin DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
Oct 11 19:53:04 artin Process X (pid: 7870, threadinfo ffff810025ef6000,
task ffff810027938000)
Oct 11 19:53:04 artin Stack: 0000000000000202 ffff810028425000
ffff810037cd0800 ffff810037cd0938
Oct 11 19:53:04 artin 0000000000000001 ffffffff88324e4b ffff810025ef7e68
00007fff92cb0580
Oct 11 19:53:04 artin 2000000000000002 ffff810000000e1f ffff8100000060a1
ffffffff88324c60
Oct 11 19:53:04 artin Call Trace:
Oct 11 19:53:04 artin [<ffffffff88324e4b>]
:i915:i915_vblank_swap+0x1eb/0x3e0
Oct 11 19:53:04 artin [<ffffffff88324c60>] :i915:i915_vblank_swap+0x0/0x3e0
Oct 11 19:53:04 artin [<ffffffff8830fe0a>] :drm:drm_ioctl+0xda/0x250
Oct 11 19:53:04 artin [<ffffffff804abdcc>] thread_return+0x442/0x606
Oct 11 19:53:04 artin [<ffffffff802a267d>] do_ioctl+0x7d/0xa0
Oct 11 19:53:04 artin [<ffffffff802a28c0>] vfs_ioctl+0x220/0x2c0
Oct 11 19:53:04 artin [<ffffffff80294d95>] vfs_read+0x155/0x170
Oct 11 19:53:04 artin [<ffffffff802a29f5>] sys_ioctl+0x95/0xb0
Oct 11 19:53:04 artin [<ffffffff8020c43e>] system_call+0x7e/0x83
Oct 11 19:53:04 artin
Oct 11 19:53:04 artin
Oct 11 19:53:04 artin Code: 49 8b 04 c4 48 89 42 10 41 55 9d 66 85 ed 79
13 4d 85 e4 74
Oct 11 19:53:04 artin RIP [<ffffffff8029142e>] __kmalloc+0x6e/0xb0
Oct 11 19:53:04 artin RSP <ffff810025ef7df8>
Oct 11 19:53:04 artin CR2: 0000000000200200
Oct 11 19:53:04 artin [drm:drm_release] *ERROR* Device busy: 1 0

