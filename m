Return-Path: <linux-kernel-owner+w=401wt.eu-S1753177AbZIZSz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbZIZSz0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 14:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbZIZSzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 14:55:15 -0400
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:53536 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750867AbZIZSzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 14:55:11 -0400
From: Frans Pop <elendil@planet.nl>
To: "Darko K." <darko.koruga@siol.net>
Subject: Re: 2.6.31 crash when resuming from hibernation
Date: Sat, 26 Sep 2009 20:55:08 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
       dri-devel@lists.sourceforge.net,
       Chris Wilson <chris@chris-wilson.co.uk>
References: <20090926193336.3e3a8985@beavis.confused.org>
In-reply-To: <20090926193336.3e3a8985@beavis.confused.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909262055.10700.elendil@planet.nl>
X-OriginalArrivalTime: 26 Sep 2009 18:55:14.0044 (UTC) FILETIME=[E17E8BC0:01CA3EDA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Darko K. wrote:
> I've just experienced a kernel crash when resuming from hibernation
> (suspend to disk). System was still operational so I was able to gather
> dmesg output before rebooting the machine (dmesg output is attached
> to this mail). This is first time this has happened with 2.6.31. I was
> getting occasional crash when resuming from hibernation with 2.6.28.4
> although I was never able to capture dmesg output as machine was just
> frozen, I could not even ping it.
> 
> My hardware is:
> - Intel G41 chipset
> - 2GB RAM
> - Intel Pentium E5200
> 
> System has been running for a few days with at least one hibernation
> per day (sometimes more) and one suspend to RAM (for testing purposes).
> /usr/sbin/s2disk is used to put system into hibernation.
> 
> OS is Debian testing running kernel 2.6.31, X.Org 1.6.3. Intel
> video driver 2.8.1.

The crash looks to be in i915 drm/gem. Adding relevant developers in CC.

BUG: unable to handle kernel NULL pointer dereference at 00000040
IP: [<c11ebabe>] i915_gem_free_object+0xe/0xb0
*pde = 00000000 
Oops: 0000 [#1] PREEMPT SMP 
last sysfs file: /sys/devices/platform/it87.656/fan1_input
Modules linked in: it87 hwmon_vid coretemp fuse snd_hda_codec_realtek
snd_hda_intel snd_hda_codec snd_pcm snd_timer snd sr_mod snd_page_alloc

Pid: 21713, comm: Xorg Not tainted (2.6.31 #10) EG41MF-S2H
EIP: 0060:[<c11ebabe>] EFLAGS: 00013282 CPU: 0
EIP is at i915_gem_free_object+0xe/0xb0
EAX: f6e369c0 EBX: f6e369c0 ECX: 00000000 EDX: c11ebab0
ESI: 00000000 EDI: f7268400 EBP: f44a1df8 ESP: f44a1dec
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process Xorg (pid: 21713, ti=f44a0000 task=e76765d0 task.ti=f44a0000)
Stack:
 f7268400 f6e369c0 f69f1f24 f44a1e08 c11d3d74 f6e369c0 c11d3d50 f44a1e18
<0> c1157e1d f6e369c0 f7268414 f44a1e34 c11d3eb7 0000010f f7268400 f44a1e74
<0> c142d74c f44a1e74 f44a1f00 c11d282a 00000001 c13b81ae c1340676 c13c4dcc
Call Trace:
 [<c11d3d74>] ? drm_gem_object_free+0x24/0x60
 [<c11d3d50>] ? drm_gem_object_free+0x0/0x60
 [<c1157e1d>] ? kref_put+0x2d/0x60
 [<c11d3eb7>] ? drm_gem_close_ioctl+0x97/0xc0
 [<c11d282a>] ? drm_ioctl+0x18a/0x390
 [<c11d3e20>] ? drm_gem_close_ioctl+0x0/0xc0
 [<c106f5c8>] ? __dec_zone_page_state+0x18/0x20
 [<c1079f35>] ? page_remove_rmap+0x25/0x30
 [<c106ee42>] ? vma_prio_tree_remove+0x72/0xf0
 [<c1098dc0>] ? vfs_ioctl+0x80/0x90
 [<c1099282>] ? do_vfs_ioctl+0x3e2/0x5e0
 [<c1076806>] ? remove_vma+0x46/0x60
 [<c1076806>] ? remove_vma+0x46/0x60
 [<c1076806>] ? remove_vma+0x46/0x60
 [<c107772a>] ? do_munmap+0x22a/0x280
 [<c10994b9>] ? sys_ioctl+0x39/0x70
 [<c1002f21>] ? syscall_call+0x7/0xb
Code: 00 20 75 10 89 d8 e8 c2 96 fe ff 89 d8 e8 6b fc ff ff 89 c2 89 d0 5b c9 c3 8d 74 26 00 55 89 e5 57 56 53 89 c3 
8b 78 08 8b 70 50 <8b> 46 40 85 c0 7e 11 8d 76 00 89 d8 e8 51 d4 ff ff 8b 46 40 85 
EIP: [<c11ebabe>] i915_gem_free_object+0xe/0xb0 SS:ESP 0068:f44a1dec
CR2: 0000000000000040
