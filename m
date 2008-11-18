Return-Path: <linux-kernel-owner+w=401wt.eu-S1752344AbYKRKSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344AbYKRKSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 05:18:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751361AbYKRKSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 05:18:40 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:31246 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbYKRKSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 05:18:39 -0500
X-Greylist: delayed 1277 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Nov 2008 05:18:38 EST
X-Spam-Flag: NO
X-Spam-Score: -9.189
Message-ID: <4922917E.8070201@tudelft.nl>
Date: Tue, 18 Nov 2008 10:57:18 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <E.A.B.Piel@tudelft.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.17) Gecko/20080929 Mandriva/2.0.0.17-2mdv2009.0 (2009.0) Thunderbird/2.0.0.17 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.28-rc4: Resource map sanity check conflict between vesafb and
 intel X driver?
Content-Type: multipart/mixed;
 boundary="------------010604070002020602030300"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010604070002020602030300
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello,

Booting a nearly 2.6.28-rc5 kernel, I got this warning which I never had
before (latest previous kernel being some 2.6.28-rc2). 

 resource map sanity check conflict: 0xd0000000 0xdfffffff 0xd0000000 0xd076ffff vesafb
 ------------[ cut here ]------------
 WARNING: at arch/x86/mm/ioremap.c:226 __ioremap_caller+0x329/0x370()
 Modules linked in: i915 drm usblp ipv6 microcode usbhid bluetooth binfmt_misc loop fuse cpufreq_conservative cpufreq_powersave acpi_cpufreq nvram hp_wmi af_packet rfkill_input snd_hda_intel snd_hwdep arc4 snd_seq_dummy ecb snd_seq_oss snd_seq_midi_event b43 snd_seq rfkill snd_seq_device rng_core snd_pcm_oss mac80211 sdhci_pci snd_pcm fan cfg80211 input_polldev ohci_hcd mmc_block snd_timer thermal ssb sdhci hp_accel processor tpm_infineon snd_page_alloc tpm ohci1394 yenta_socket rsrc_nonstatic pcmcia joydev serio_raw evdev sr_mod sg ehci_hcd iTCO_wdt ricoh_mmc mmc_core led_class snd_mixer_oss ieee1394 container video output tpm_bios uhci_hcd lis3lv02d wmi battery button e1000e pcmcia_core ac snd soundcore usbcore ext3 jbd [last unloaded: l2cap]
 Pid: 3413, comm: X Not tainted 2.6.28-rc4-git-eric #39
 Call Trace:
  [<ffffffff8024515f>] warn_on_slowpath+0x5f/0x90
  [<ffffffff8022e87a>] ? change_page_attr_set_clr+0xda/0x380
  [<ffffffff8022ee82>] ? _set_memory_uc+0x22/0x30
  [<ffffffff804ecec6>] ? _read_lock+0x16/0x30
  [<ffffffff804ed141>] ? _read_unlock+0x11/0x40
  [<ffffffff8022d689>] __ioremap_caller+0x329/0x370
  [<ffffffffa04048fd>] ? i915_gem_entervt_ioctl+0x2fd/0x5d0 [i915]
  [<ffffffff8022d816>] ioremap_wc+0x26/0x30
  [<ffffffffa04048fd>] i915_gem_entervt_ioctl+0x2fd/0x5d0 [i915]
  [<ffffffffa03e57ba>] drm_ioctl+0x10a/0x330 [drm]
  [<ffffffffa0404600>] ? i915_gem_entervt_ioctl+0x0/0x5d0 [i915]
  [<ffffffff802d690d>] vfs_ioctl+0x7d/0xa0
  [<ffffffff802d69a4>] do_vfs_ioctl+0x74/0x470
  [<ffffffff802d6dea>] sys_ioctl+0x4a/0x80
  [<ffffffff8020c5ca>] system_call_fastpath+0x16/0x1b
 ---[ end trace f2aad082f0b30467 ]---


If I remove the vesafb driver, the warning goes away. That seems to be a
new warning. Probably is has always been happening on my laptop, how bad
is that? My X intel driver is 2.5.0 . If one driver has to be fixed, which
one: vesafb or intel?

Regards,
Eric

--------------010604070002020602030300
Content-Type: text/x-vcard; charset=utf-8;
 name="E_A_B_Piel.vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="E_A_B_Piel.vcf"

YmVnaW46dmNhcmQNCmZuO3F1b3RlZC1wcmludGFibGU6PUMzPTg5cmljIFBpZWwNCm47cXVv
dGVkLXByaW50YWJsZTpQaWVsOz1DMz04OXJpYw0Kb3JnOlRlY2huaWNhbCBVbml2ZXJzaXR5
IG9mIERlbGZ0O1NvZnR3YXJlIEVuZ2luZWVyaW5nIFJlc2VhcmNoIEdyb3VwDQphZHI6SEIg
MDguMDgwOztNZWtlbHdlZyA0O0RlbGZ0OzsyNjI4IENEO1RoZSBOZXRoZXJsYW5kcw0KZW1h
aWw7aW50ZXJuZXQ6RS5BLkIuUGllbEB0dWRlbGZ0Lm5sDQp0ZWw7d29yazorMzEgMTUgMjc4
IDYzMzgNCnRlbDtjZWxsOiszMSA2IDI0MzcgOTEzNQ0KeC1tb3ppbGxhLWh0bWw6RkFMU0UN
CnVybDpodHRwOi8vcGllbGVyaWMuZnJlZS5mcg0KdmVyc2lvbjoyLjENCmVuZDp2Y2FyZA0K
DQo=
--------------010604070002020602030300--
