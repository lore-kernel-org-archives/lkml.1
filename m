Return-Path: <linux-kernel-owner+w=401wt.eu-S1754886AbYHGUFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbYHGUFq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 16:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbYHGUFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 16:05:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36372 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580AbYHGUFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 16:05:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Charles@schwieters.org
Subject: Re: resume problem with i915/drm
Date: Thu, 7 Aug 2008 22:08:05 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
References: <E1KQYiX-0002Nl-Ud@oaf.wireless>
In-Reply-To: <E1KQYiX-0002Nl-Ud@oaf.wireless>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808072208.05887.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 6 of August 2008, Charles@schwieters.org wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> 
> Hi--
> 
>   I'm having a problem resuming (from RAM) if the i915 and drm modules
> are loaded (these are needed for running X on my machine). Vanilla
> kernel versions 2.6.25.x and 2.6.26.x. I get the same behavior with
> Debian linux-image-2.6.25-2-686 kernel. I can't believe I'm the first to
> encounter this.

Can you retest with 2.6.27-rc2, please?

> suspend-to-ram and resuming works fine with earlier kernels
> (e.g. 2.6.17), but I haven't tested exhaustively.
> 
> Possibly related is a failure in modprobe -r i915 after it is
> loaded. The message printed is
> 
> Aug  5 21:39:47 oaf kernel: WARNING: at fs/proc/generic.c:799 remove_proc_entry+0xf9/0x115()
> Aug  5 21:39:47 oaf kernel: Modules linked in: drm(-) binfmt_misc rfcomm l2cap bluetooth lp nfsd exportfs nfs lockd nfs_acl sunrpc deflate zlib_deflate zlib_inflate ctr twofish twofish_common camellia serpent blowfish des_generic cbc aes_i586 aes_generic xcbc sha256_generic sha1_generic md5 crypto_null af_key fuse dm_crypt crypto_blkcipher dm_snapshot dm_mirror dm_log dm_mod eeprom i2c_core snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_pcm snd_mixer_oss snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi pcmcia crc32 snd_seq_midi_event snd_seq snd_timer snd_seq_device ipw2200 snd ieee80211 ieee80211_crypt soundcore 8250_pnp firmware_class yenta_socket rsrc_nonstatic 8250_pci snd_page_alloc pcspkr parport_pc psmouse 8250 pcmcia_core parport e100 serial_core cdrom iTCO_wdt fan bay dock ehci_hcd toshiba_acpi backlight thermal battery ac uhci_hcd processor button usbcore intel_agp agpgart unix [last unloaded: i915]
> Aug  5 21:39:47 oaf kernel: Pid: 3890, comm: modprobe Not tainted 2.6.26.1 #9
> Aug  5 21:39:47 oaf kernel:  [<c0114778>] warn_on_slowpath+0x40/0x79
> Aug  5 21:39:47 oaf kernel:  [<c0110b90>] check_preempt_wakeup+0x8f/0xc3
> Aug  5 21:39:47 oaf kernel:  [<c01220d5>] autoremove_wake_function+0xd/0x2d
> Aug  5 21:39:47 oaf kernel:  [<c010ff37>] __wake_up_common+0x2d/0x52
> Aug  5 21:39:47 oaf kernel:  [<c010ff6b>] __wake_up+0xf/0x15
> Aug  5 21:39:47 oaf kernel:  [<c0114cee>] wake_up_klogd+0x2b/0x2d
> Aug  5 21:39:47 oaf kernel:  [<c0144237>] vma_merge+0x1a3/0x23a
> Aug  5 21:39:47 oaf kernel:  [<c0179649>] remove_proc_entry+0xf9/0x115
> Aug  5 21:39:47 oaf kernel:  [<c014260c>] free_pgtables+0x67/0x7b
> Aug  5 21:39:47 oaf kernel:  [<dff46f7b>] drm_core_exit+0xc/0x2a [drm]
> Aug  5 21:39:47 oaf kernel:  [<c012df88>] sys_delete_module+0x193/0x1eb
> Aug  5 21:39:47 oaf kernel:  [<c014345b>] remove_vma+0x43/0x48
> Aug  5 21:39:47 oaf kernel:  [<c0144046>] do_munmap+0x1ba/0x1d4
> Aug  5 21:39:47 oaf kernel:  [<c0102a55>] sysenter_past_esp+0x6a/0x91
> Aug  5 21:39:47 oaf kernel:  =======================
> Aug  5 21:39:47 oaf kernel: ---[ end trace dd188b4354a41352 ]---
> 
> For 2.6.26.1, if I don't start X, I have the following list of modules
> 


