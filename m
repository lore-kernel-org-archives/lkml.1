Return-Path: <linux-kernel-owner+w=401wt.eu-S1755659AbZEZMUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbZEZMUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 08:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754743AbZEZMUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 08:20:23 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:43195 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911AbZEZMUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 08:20:22 -0400
MIME-Version: 1.0
Date: Tue, 26 May 2009 13:20:18 +0100
X-Google-Sender-Auth: d5e2a93f4684e4d3
Message-ID: <b2cdc9f30905260520m6d779cdof202dabe511ed49b@mail.gmail.com>
Subject: i915_gem_retire_requests oops on 2.6.30-rc7
From: Alex Bennee <kernel-hacker@bennee.com>
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've just had X crash on me with an attendant oops in the kernel as it did so:

[99666.683322] ------------[ cut here ]------------
[99666.683332] WARNING: at drivers/gpu/drm/i915/i915_gem.c:3832
i915_gem_idle+0x1ae/0x2da()
[99666.683334] Hardware name: System Product Name
[99666.683336] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat
nls_base bridge stp llc bnep rfcomm l2cap bluetooth ipv6 af_packet
snd_pcm_oss snd_mixer_oss snd_seq_oss snd_seq_midi_event snd_seq
snd_seq_device kvm_intel kvm acpi_cpufreq snd_hda_codec_analog
usb_storage usb_libusual snd_hda_intel snd_hda_codec uhci_hcd ehci_hcd
snd_hwdep snd_pcm snd_timer snd soundcore snd_page_alloc firewire_ohci
firewire_core ide_cd_mod cdrom pcspkr evdev usbcore crc_itu_t unix
[99666.683374] Pid: 5330, comm: X Not tainted 2.6.30-rc7-ajb #65
[99666.683376] Call Trace:
[99666.683382]  [<ffffffff803d3db8>] ? i915_gem_retire_requests+0x164/0x184
[99666.683386]  [<ffffffff803d553d>] ? i915_gem_idle+0x1ae/0x2da
[99666.683390]  [<ffffffff802378e9>] warn_slowpath_common+0x7c/0xa9
[99666.683393]  [<ffffffff8023792a>] warn_slowpath_null+0x14/0x16
[99666.683396]  [<ffffffff803d553d>] i915_gem_idle+0x1ae/0x2da
[99666.683399]  [<ffffffff803d5687>] i915_gem_lastclose+0x1e/0x3b
[99666.683402]  [<ffffffff803ce725>] i915_driver_lastclose+0x37/0x5a
[99666.683406]  [<ffffffff803be306>] drm_lastclose+0x47/0x2b1
[99666.683409]  [<ffffffff803bea4e>] drm_release+0x4d1/0x4ee
[99666.683413]  [<ffffffff802ad8ad>] __fput+0xe4/0x19d
[99666.683416]  [<ffffffff802ad983>] fput+0x1d/0x1f
[99666.683419]  [<ffffffff802aac02>] filp_close+0x5e/0x68
[99666.683422]  [<ffffffff80239307>] put_files_struct+0x70/0xc7
[99666.683425]  [<ffffffff802393aa>] exit_files+0x4c/0x55
[99666.683427]  [<ffffffff8023ac40>] do_exit+0x1c7/0x644
[99666.683431]  [<ffffffff80242c98>] ? __dequeue_signal+0x108/0x134
[99666.683434]  [<ffffffff8023b134>] do_group_exit+0x77/0xa4
[99666.683437]  [<ffffffff80244984>] get_signal_to_deliver+0x318/0x338
[99666.683442]  [<ffffffff8020a525>] do_notify_resume+0x90/0x6f9
[99666.683444]  [<ffffffff80242962>] ? lock_task_sighand+0x3a/0x63
[99666.683447]  [<ffffffff802ad959>] ? __fput+0x190/0x19d
[99666.683450]  [<ffffffff80241a32>] ? sigprocmask+0xb1/0xd2
[99666.683453]  [<ffffffff80241ef6>] ? sys_rt_sigprocmask+0x59/0xd3
[99666.683456]  [<ffffffff80241a32>] ? sigprocmask+0xb1/0xd2
[99666.683459]  [<ffffffff8020b235>] sysret_signal+0x6d/0xb7
[99666.683462] ---[ end trace 59cc4070da9f68b2 ]---
[99666.694008] [drm:i915_get_vblank_counter] *ERROR* trying to get
vblank count for disabled pipe 0

I've been seeing these for most of the 2.6.30 series but I thought
they had been banished with the latest updates. Please advise if you
would like to see any other information?

-- 
Alex, homepage: http://www.bennee.com/~alex/
CV: http://www.bennee.com/~alex/cv.php
