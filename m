Return-Path: <linux-kernel-owner+w=401wt.eu-S1756588AbZKMRoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588AbZKMRoo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 12:44:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754775AbZKMRoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 12:44:38 -0500
Received: from mail.vyatta.com ([76.74.103.46]:40405 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754704AbZKMRog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 12:44:36 -0500
Date: Fri, 13 Nov 2009 09:44:25 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: John Johansen <john.johansen@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [AppArmor #3 0/12] AppArmor security module
Message-ID: <20091113094425.5b4c553b@s6510>
In-Reply-To: <1257869585-7092-1-git-send-email-john.johansen@canonical.com>
References: <1257869585-7092-1-git-send-email-john.johansen@canonical.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Nov 2009 08:12:53 -0800
John Johansen <john.johansen@canonical.com> wrote:

> This is the newest version of the AppArmor security module it has been
> rewritten to use the security_path hooks instead of the previous vfs
> approach.  The current implementation is aimed at being as semantically
> close to previous versions of AppArmor as possible while using the
> existing LSM infrastructure.

Does it fix the problem reported as the #1 failure on kernel oops:

Oops 718946 first showed up in kernel version 2.6.31-14-generic
Oops 718946 last showed up in version 2.6.31-13-generic
2.6.31 -- 512

BUG: unable to handle kernel NULL pointer dereference at 00000040
IP: [] apparmor_bprm_set_creds+0x370/0x400
*pde = 00000000 
Oops: 0000 [#1] SMP 
last sysfs file: /sys/devices/LNXSYSTM:00/device:00/PNP0C0A:00/power_supply/BAT1/charge_full
Modules linked in: binfmt_misc ppdev lp parport joydev snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm_oss mmc_block snd_mixer_oss snd_pcm snd_seq_dummy arc4 ecb snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq ath5k acerhdf mac80211 snd_timer ath uvcvideo videodev sdhci_pci snd_seq_device psmouse sdhci v4l1_compat serio_raw cfg80211 jmb38x_ms memstick led_class snd soundcore snd_page_alloc usbhid r8169 mii fbcon tileblit font bitblit softcursor i915 drm i2c_algo_bit video output intel_agp agpgart

Pid: 3316, comm: hamachi-init Not tainted (2.6.31-10-generic #32-Ubuntu) AOA110
EIP: 0060:[] EFLAGS: 00010246 CPU: 0
EIP is at apparmor_bprm_set_creds+0x370/0x400
EAX: fffffffe EBX: dde0fe00 ECX: de59df00 EDX: dd4bfee2
ESI: 00000000 EDI: ddf73ba0 EBP: de59df44 ESP: de59deb4
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process hamachi-init (pid: 3316, ti=de59c000 task=de02d7f0 task.ti=de59c000)
Stack:
 de59df00 00000000 00000000 de59ded0 c01c9e40 de5147e8 dec04080 de59deec
<0> c01c9e8f 00000000 00000000 de5147e8 00000000 de5147e8 00000000 000000d0
<0> fffffffe c06ff3a2 00000000 dd4bfee2 00000000 00000000 00000000 00000000
Call Trace:
 [] ? __vma_link_rb+0x30/0x40
 [] ? __vma_link+0x3f/0x80
 [] ? security_bprm_set_creds+0xc/0x10
 [] ? prepare_binprm+0xa1/0xf0
 [] ? T.626+0x3b/0x50
 [] ? do_execve+0x17e/0x2c0
 [] ? strncpy_from_user+0x35/0x60
 [] ? sys_execve+0x28/0x60
 [] ? syscall_call+0x7/0xb
Code: 24 8b 44 24 18 e8 71 f4 ff ff 3d 00 f0 ff ff 89 c1 76 a7 0f b7 44 24 60 f6 c4 40 74 50 c7 44 24 48 a7 f3 6f c0 e9 98 fe ff ff 90  46 40 08 0f 84 e6 fe ff ff e9 d9 fe ff ff 90 8b 54 24 4c 8b 
EIP: [] apparmor_bprm_set_creds+0x370/0x400 SS:ESP 0068:de59deb4
CR2: 0000000000000040
---[ end trace 203b1750ff60d177 ]---

http://kerneloops.org/guilty.php?guilty=apparmor_bprm_set_creds&version=2.6.31-release&start=2064384&end=2097151&class=oops
