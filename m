Return-Path: <linux-kernel-owner+w=401wt.eu-S1753503AbZAZSJD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbZAZSJD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 13:09:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbZAZSIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 13:08:54 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:44013 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbZAZSIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 13:08:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=uDVNsfQZLpd5t0+Vh4QB1q+Cj5LJM7hFpeysRhdETC8gFlwJnKp8FoQ9d046QFLHEL
         dl9cd5oloBpyF80NQZLumD2SiUQrcfyV0sZftk9InQQPK65iG29iU6DXngTLbar6IBJP
         GDkokx7WBkXWUP1DnNYd06UUT5gaBZPbgbdKU=
Message-ID: <497DFC8B.9040405@gmail.com>
Date: Mon, 26 Jan 2009 19:10:19 +0100
From: Jacek Luczak <difrost.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: eric@anholt.net, LKML <linux-kernel@vger.kernel.org>
Subject: GTT full but LRU empty
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Eric,

Are those errors known?

[drm:i915_gem_object_bind_to_gtt] *ERROR* GTT full, but LRU list empty
[drm:i915_gem_object_pin] *ERROR* Failure to bind:
-12<3>[drm:i915_gem_evict_something] *ERROR* inactive empty 1 request empty 1
flushing empty 1
[drm:i915_gem_object_bind_to_gtt] *ERROR* GTT full, but LRU list empty
[drm:i915_gem_object_pin] *ERROR* Failure to bind:
-12<3>[drm:i915_gem_evict_something] *ERROR* inactive empty 1 request empty 1
flushing empty 1
[drm:i915_gem_object_bind_to_gtt] *ERROR* GTT full, but LRU list empty
[drm:i915_gem_object_pin] *ERROR* Failure to bind:
-12<3>[drm:i915_gem_execbuffer] *ERROR* Failed to pin buffers -12
[drm:i915_gem_object_bind_to_gtt] *ERROR* GTT full, but LRU list empty
[drm:i915_gem_object_pin] *ERROR* Failure to bind:
-12<3>[drm:i915_gem_evict_something] *ERROR* inactive empty 1 request empty 1
flushing empty 1
[drm:i915_gem_object_bind_to_gtt] *ERROR* GTT full, but LRU list empty
[drm:i915_gem_object_pin] *ERROR* Failure to bind:
-12<3>[drm:i915_gem_execbuffer] *ERROR* Failed to pin buffers -12

They appeared once and no more, but I've changed my configuration in between
(switched to UXA, removed IntelFB from kernel).

Also I've got those messages with KMS enabled, but AFAIK those are only
harmless_spamming:

Jan 25 12:01:49 difrost kernel: WARNING: at drivers/gpu/drm/drm_crtc.c:213
drm_mode_object_get+0x36/0x8e()
Jan 25 12:01:49 difrost kernel: Hardware name: AMILO Pro Edition V3505
Jan 25 12:01:49 difrost kernel: drm_mode_object_get called w/o mode_config lock
Jan 25 12:01:49 difrost kernel: Modules linked in:
Jan 25 12:01:49 difrost kernel: Pid: 1, comm: swapper Not tainted
2.6.29-rc2-00013-gf3b8436-dirty #3
Jan 25 12:01:49 difrost kernel: Call Trace:
Jan 25 12:01:49 difrost kernel:  [<c011f310>] warn_slowpath+0x80/0xb6
Jan 25 12:01:49 difrost kernel:  [<c011755c>] dequeue_task+0x60/0x6e
Jan 25 12:01:49 difrost kernel:  [<c033c038>] schedule+0x6e0/0x71c
Jan 25 12:01:49 difrost kernel:  [<c0126894>] lock_timer_base+0x19/0x35
Jan 25 12:01:49 difrost kernel:  [<c01268f4>] try_to_del_timer_sync+0x44/0x4a
Jan 25 12:01:49 difrost kernel:  [<c025c63a>] drm_mode_object_get+0x36/0x8e
Jan 25 12:01:49 difrost kernel:  [<c025c766>]
drm_mode_connector_update_edid_property+0xd4/0x144
Jan 25 12:01:49 difrost kernel:  [<c026d500>] intel_ddc_get_modes+0x24/0x3c
Jan 25 12:01:49 difrost kernel:  [<c026bcc9>] intel_lvds_init+0xe3/0x296
Jan 25 12:01:49 difrost kernel:  [<c026aadc>] intel_modeset_init+0x307/0x5ce
Jan 25 12:01:49 difrost kernel:  [<c026274f>] i915_driver_irq_postinstall+0xa8/0xac
Jan 25 12:01:49 difrost kernel:  [<c0261688>] i915_driver_load+0x6ef/0x73e
Jan 25 12:01:49 difrost kernel:  [<c0259560>] drm_get_dev+0x2be/0x358
Jan 25 12:01:49 difrost kernel:  [<c025552d>] drm_init+0x5a/0x89
Jan 25 12:01:49 difrost kernel:  [<c04574bd>] i915_init+0x0/0x43
Jan 25 12:01:49 difrost kernel:  [<c010112c>] _stext+0x44/0x108
Jan 25 12:01:49 difrost kernel:  [<c0142b38>] register_irq_proc+0x79/0x92
Jan 25 12:01:49 difrost kernel:  [<c0441297>] kernel_init+0x101/0x14f
Jan 25 12:01:49 difrost kernel:  [<c0441196>] kernel_init+0x0/0x14f
Jan 25 12:01:49 difrost kernel:  [<c01034db>] kernel_thread_helper+0x7/0x10
Jan 25 12:01:49 difrost kernel: ---[ end trace 1e62cbea2b78759c ]---

Some details:
	1) Kernel: 2.6.29-rc2-00013-gf3b8436-dirty (marked dirty due to not-yet-in-tree
XFS patch).
	2) xf86-video-intel: 2.6.1
	3) Xorg-server: 1.5.99.901
	4) Mesa: 7.3
	4) DRI2 enabled, now also UXA (with strange screen flickering effect).

-Jacek
