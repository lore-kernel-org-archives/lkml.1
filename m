Return-Path: <linux-kernel-owner+w=401wt.eu-S1757173AbZCOAjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173AbZCOAjV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 20:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbZCOAjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 20:39:13 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:10385 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbZCOAjL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 20:39:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PlCIS1xNGVMc4/tbE+xK8bcLZLFN1uQa9zOzahpj2qmNxAhasKmI9z5eGZLqX90Lru
         WCoWgG37Uig7uLG1Uocodthx4+jOHNNVrQOmXWtB9ou+b6ioO5TsHjBAQ/OZhPiaZBZl
         WcQ78PVaO30b6YhYdGpDlbeynX+GblC4EgOrM=
MIME-Version: 1.0
In-Reply-To: <200903141534.43443.elendil@planet.nl>
References: <200903141534.43443.elendil@planet.nl>
Date: Sun, 15 Mar 2009 10:39:08 +1000
Message-ID: <21d7e9970903141739td91f90sc7f8b2fd8ec06f49@mail.gmail.com>
Subject: Re: DRM oops while starting second X.org session in chroot
From: Dave Airlie <airlied@gmail.com>
To: Frans Pop <elendil@planet.nl>
Cc: dri-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       airlied@linux.ie
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 15, 2009 at 12:34 AM, Frans Pop <elendil@planet.nl> wrote:
> I had the oops below today after I tried to start a second X.org session
> in a chroot using 'startx -- :1'. I think the problem here is that the
> driver was loaded, but that the corresponding device did not exist in
> /dev in the chroot (forgot to bind mount it). If that is the cause,
> it would be nice if it was handled more gracefully than this :-P

Its a bug in userspace we can't do anything about at this point,

The problem is we attach some information to the device inode and if you
starting using an alternate inode it screws up, I think Thomas had
suggested ways aruond
this. We could probably make it a WARN_ON and fail DRI setup.

Dave.

>
> The oops also hung my primary X session. I could no longer switch consoles.
> Sysrq did still work.
>
> The first 3 messages are almost certainly from starting X in the main
> X session, but I've left them in to show that that did work.
>
> The "drm:i915_get_vblank_counter" is an extremely annoying message that
> I get with 2.6.29 whenever I suspend the system or start a session for
> a second user. Before 2.6.29 I only very rarely saw it.
>
> Kernel is 2.6.28-rc8 with selected patches on top. Only possibly relevant
> extra patch is Venki's latest PAT fix [1]. I also have Rafael's "rework
> suspend/resume ordering" series applied.
>
> Cheers,
> FJP
>
> [1] http://lkml.org/lkml/2009/3/12/399
>
> Mar 14 08:21:04 aragorn kernel: [drm] Initialized drm 1.1.0 20060810
> Mar 14 08:21:05 aragorn kernel: pci 0000:00:02.0: irq 28 for MSI/MSI-X
> Mar 14 08:21:05 aragorn kernel: [drm] Initialized i915 1.6.0 20080730 on minor 0
> Mar 14 08:22:49 aragorn kernel: [drm:i915_get_vblank_counter] *ERROR* trying to get vblank count for disabled pipe 0
> Mar 14 08:22:52 aragorn kernel: ------------[ cut here ]------------
> Mar 14 08:22:52 aragorn kernel: kernel BUG at /home/fjp/projects/kernel/linux-2.6/drivers/gpu/drm/drm_fops.c:146!
> Mar 14 08:22:52 aragorn kernel: invalid opcode: 0000 [#1] SMP
> Mar 14 08:22:52 aragorn kernel: last sysfs file: /sys/class/backlight/acpi_video0/brightness
> Mar 14 08:22:52 aragorn kernel: CPU 1
> Mar 14 08:22:52 aragorn kernel: Modules linked in: i915 drm i2c_algo_bit i2c_core ppdev parport_pc lp parport ipv6 nfsd exportfs nfs lockd
> nfs_acl auth_rpcgss sunrpc ext2 coretemp hp_wmi acpi_cpufreq loop snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_pcm_oss
> snd_mixer_oss snd_pcm arc4 snd_seq_dummy ecb snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event iwlagn iwlcore snd_seq snd_timer
> rfkill snd_seq_device lib80211 mac80211 pcmcia snd joydev intel_agp psmouse iTCO_wdt serio_raw soundcore snd_page_alloc hp_accel cfg80211
> yenta_socket rsrc_nonstatic pcmcia_core container pcspkr wmi video output battery ac button lis3lv02d evdev ext3 jbd mbcache
> sha256_generic aes_x86_64 aes_generic cbc dm_crypt dm_mirror dm_region_hash dm_log dm_snapshot dm_mod sg sr_mod cdrom sd_mod piix ata_piix
> uhci_hcd ide_pci_generic ide_core pata_acpi ohci1394 sdhci_pci sdhci ricoh_mmc ieee1394 mmc_core led_class ata_generic ehci_hcd libata
> scsi_mod e1000e thermal processor fan thermal_sys
> Mar 14 08:22:52 aragorn kernel: Pid: 5487, comm: Xorg Not tainted 2.6.29-rc8-rjw #6 HP Compaq 2510p Notebook PC
> Mar 14 08:22:52 aragorn kernel: RIP: 0010:[<ffffffffa04eff8b>]  [<ffffffffa04eff8b>] drm_open+0x4b5/0x4ee [drm]
> Mar 14 08:22:52 aragorn kernel: RSP: 0018:ffff8800605b7cd8  EFLAGS: 00010206
> Mar 14 08:22:52 aragorn kernel: RAX: ffff88007bf295c8 RBX: ffff88007bc18038 RCX: 0000000000000000
> Mar 14 08:22:52 aragorn kernel: RDX: ffff880058448528 RSI: ffff8800605b7cc8 RDI: ffff8800605b7c60
> Mar 14 08:22:52 aragorn kernel: RBP: ffff8800605b7d18 R08: ffff88007bc18000 R09: ffff88007e038000
> Mar 14 08:22:52 aragorn kernel: R10: ffff8800605b7e48 R11: 0000000000000007 R12: 0000000000000000
> Mar 14 08:22:52 aragorn kernel: R13: ffff88007bc18000 R14: ffff88007bc18038 R15: ffff880065615f18
> Mar 14 08:22:52 aragorn kernel: FS:  00007f5e523c26f0(0000) GS:ffff88007e002b00(0000) knlGS:0000000000000000
> Mar 14 08:22:52 aragorn kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> Mar 14 08:22:52 aragorn kernel: CR2: 00007f5e4f0d2e60 CR3: 000000007cc16000 CR4: 00000000000006e0
> Mar 14 08:22:52 aragorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> Mar 14 08:22:52 aragorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Mar 14 08:22:52 aragorn kernel: Process Xorg (pid: 5487, threadinfo ffff8800605b6000, task ffff8800605ac200)
> Mar 14 08:22:52 aragorn kernel: Stack:
> Mar 14 08:22:52 aragorn kernel:  ffff88006c4b6b00 ffff880058448528 ffff88007c774c00 00000000ffffffed
> Mar 14 08:22:52 aragorn kernel:  ffffffffa04fe800 ffff88006c4b6b00 ffff880058448528 ffff880058448528
> Mar 14 08:22:52 aragorn kernel:  ffff8800605b7d48 ffffffffa04efa5a 0000000000000000 ffff88007c711900
> Mar 14 08:22:52 aragorn kernel: Call Trace:
> Mar 14 08:22:52 aragorn kernel:  [<ffffffffa04efa5a>] drm_stub_open+0xd8/0x154 [drm]
> Mar 14 08:22:52 aragorn kernel:  [<ffffffff8029cc33>] chrdev_open+0x161/0x180
> Mar 14 08:22:52 aragorn kernel:  [<ffffffff8029cad2>] ? chrdev_open+0x0/0x180
> Mar 14 08:22:52 aragorn kernel:  [<ffffffff80298a01>] __dentry_open+0x157/0x273
> Mar 14 08:22:52 aragorn kernel:  [<ffffffff80298bea>] nameidata_to_filp+0x41/0x52
> Mar 14 08:22:52 aragorn kernel:  [<ffffffff802a3feb>] do_filp_open+0x3e9/0x7fb
> Mar 14 08:22:52 aragorn kernel:  [<ffffffff8044cd5a>] ? _spin_unlock+0x9/0xb
> Mar 14 08:22:52 aragorn kernel:  [<ffffffff802ad4cb>] ? alloc_fd+0x11d/0x12e
> Mar 14 08:22:52 aragorn kernel:  [<ffffffff802987e6>] do_sys_open+0x53/0xda
> Mar 14 08:22:52 aragorn kernel:  [<ffffffff80298896>] sys_open+0x1b/0x1d
> Mar 14 08:22:52 aragorn kernel:  [<ffffffff8020c25b>] system_call_fastpath+0x16/0x1b
> Mar 14 08:22:52 aragorn kernel: Code: 48 89 df e8 20 bd f5 df 48 8b 45 d0 83 78 04 01 75 2f 49 8b 85 38 04 00 00 48 85 c0 74 11 48 8b 55
> c8 48 3b 82 68 01 00 00 74 16 <0f> 0b eb fe 48 8b 55 c8 48 8b 82 68 01 00 00 49 89 85 38 04 00
> Mar 14 08:22:52 aragorn kernel: RIP  [<ffffffffa04eff8b>] drm_open+0x4b5/0x4ee [drm]
> Mar 14 08:22:52 aragorn kernel:  RSP <ffff8800605b7cd8>
> Mar 14 08:22:52 aragorn kernel: ---[ end trace 41be7e0f42a73435 ]---
>
>
