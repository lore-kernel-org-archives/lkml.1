Return-Path: <linux-kernel-owner+w=401wt.eu-S1753466AbZI0IFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466AbZI0IFL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 04:05:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbZI0IFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 04:05:10 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:35466 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428AbZI0IFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 04:05:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=w/KB8D6P43lzKqWQ8xTl9Ono901PXgkYQ4TzJfCQuoOrKbJha6Ii/UMSoArmcgU/91
         gz9RZEKjWDKgpS+oIzO7cXcPvj1kiON71wzW0q/hlX6m+XE+dafnGuXRAp0g5RZL0zq+
         pVIccHrnwK5uKNYUVd0X+WAA5rsVkPkbnSGBQ=
MIME-Version: 1.0
Date: Sun, 27 Sep 2009 10:05:05 +0200
Message-ID: <8db1092f0909270105x4b49daf8k268e453d2379020c@mail.gmail.com>
Subject: [2.6.31-git17] WARNING: at kernel/hrtimer.c:648 hres_timers_resume+0x40/0x50()/WARNING: 
	at drivers/base/sys.c:353 __sysdev_resume+0xc3/0xe0()
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, clemens@ladisch.de,
       venkatesh.pallipadi@intel.com, gregkh@suse.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel: 2.6.31-git17

During suspend to disk & resume I got it in dmesg:

[  587.940010] ------------[ cut here ]------------
[  587.940010] WARNING: at kernel/hrtimer.c:648 hres_timers_resume+0x40/0x50()
[  587.940010] Hardware name: HP Compaq nx6310 (EY501ES#AKD)
[  587.940010] hres_timers_resume() called with IRQs enabled!
[  587.940010] Modules linked in: btusb i915 drm_kms_helper drm
i2c_algo_bit i2c_core sco bnep rfcomm l2cap crc16 bluetooth xt_tcpudp
xt_limit xt_state iptable_filter nf_conntrack_ipv4 nf_conntrack
nf_defrag_ipv4 ip_tables x_tables aes_i586 aes_generic cbc dm_crypt
dm_snapshot dm_mirror dm_region_hash dm_log dm_mod hp_wmi fuse sbp2
loop snd_hda_codec_si3054 snd_hda_codec_analog snd_hda_intel
snd_hda_codec arc4 snd_pcm_oss snd_mixer_oss snd_pcm ecb snd_seq_dummy
snd_seq_oss snd_seq_midi iwl3945 iwlcore snd_rawmidi
snd_seq_midi_event snd_seq firmware_class pcmcia snd_timer
snd_seq_device mac80211 b44 snd rtc_cmos video led_class ohci1394
uhci_hcd yenta_socket intel_agp ssb soundcore rsrc_nonstatic backlight
rtc_core ehci_hcd cfg80211 agpgart rtc_lib pcmcia_core mii
snd_page_alloc ieee1394 rfkill sg output psmouse fan button ac usbcore
battery serio_raw evdev
[  587.940010] Pid: 4761, comm: pm-hibernate Not tainted 2.6.31-git17 #1
[  587.940010] Call Trace:
[  587.940010]  [<c015b340>] ? hres_timers_resume+0x40/0x50
[  587.940010]  [<c015b340>] ? hres_timers_resume+0x40/0x50
[  587.940010]  [<c013c3a1>] warn_slowpath_common+0x71/0xc0
[  587.940010]  [<c015b340>] ? hres_timers_resume+0x40/0x50
[  587.940010]  [<c013c43b>] warn_slowpath_fmt+0x2b/0x30
[  587.940010]  [<c015b340>] hres_timers_resume+0x40/0x50
[  587.940010]  [<c015f9b7>] timekeeping_resume+0x1a7/0x1c0
[  587.940010]  [<c030f3fc>] __sysdev_resume+0x1c/0xe0
[  587.940010]  [<c030f50f>] sysdev_resume+0x4f/0xc0
[  587.940010]  [<c0176909>] ? hibernate_nvs_restore+0x19/0x60
[  587.940010]  [<c0172ac1>] hibernation_snapshot+0x1d1/0x210
[  587.940010]  [<c0171b54>] ? freeze_processes+0x44/0xa0
[  587.940010]  [<c0172bef>] hibernate+0xef/0x190
[  587.940010]  [<c0171590>] ? state_store+0x0/0xc0
[  587.940010]  [<c017163b>] state_store+0xab/0xc0
[  587.940010]  [<c0171590>] ? state_store+0x0/0xc0
[  587.940010]  [<c0285e04>] kobj_attr_store+0x24/0x30
[  587.940010]  [<c0223d82>] sysfs_write_file+0xa2/0x100
[  587.940010]  [<c01d880c>] vfs_write+0x9c/0x150
[  587.940010]  [<c0223ce0>] ? sysfs_write_file+0x0/0x100
[  587.940010]  [<c01d8982>] sys_write+0x42/0x70
[  587.940010]  [<c0102f04>] sysenter_do_call+0x12/0x22
[  587.940010] ---[ end trace d928cdf192623f0f ]---
[  587.940010] ------------[ cut here ]------------
[  587.940010] WARNING: at drivers/base/sys.c:353 __sysdev_resume+0xc3/0xe0()
[  587.940010] Hardware name: HP Compaq nx6310 (EY501ES#AKD)
[  587.940010] Interrupts enabled after timekeeping_resume+0x0/0x1c0
[  587.940010] Modules linked in: btusb i915 drm_kms_helper drm
i2c_algo_bit i2c_core sco bnep rfcomm l2cap crc16 bluetooth xt_tcpudp
xt_limit xt_state iptable_filter nf_conntrack_ipv4 nf_conntrack
nf_defrag_ipv4 ip_tables x_tables aes_i586 aes_generic cbc dm_crypt
dm_snapshot dm_mirror dm_region_hash dm_log dm_mod hp_wmi fuse sbp2
loop snd_hda_codec_si3054 snd_hda_codec_analog snd_hda_intel
snd_hda_codec arc4 snd_pcm_oss snd_mixer_oss snd_pcm ecb snd_seq_dummy
snd_seq_oss snd_seq_midi iwl3945 iwlcore snd_rawmidi
snd_seq_midi_event snd_seq firmware_class pcmcia snd_timer
snd_seq_device mac80211 b44 snd rtc_cmos video led_class ohci1394
uhci_hcd yenta_socket intel_agp ssb soundcore rsrc_nonstatic backlight
rtc_core ehci_hcd cfg80211 agpgart rtc_lib pcmcia_core mii
snd_page_alloc ieee1394 rfkill sg output psmouse fan button ac usbcore
battery serio_raw evdev
[  587.940010] Pid: 4761, comm: pm-hibernate Tainted: G        W
2.6.31-git17 #1
[  587.940010] Call Trace:
[  587.940010]  [<c030f4a3>] ? __sysdev_resume+0xc3/0xe0
[  587.940010]  [<c030f4a3>] ? __sysdev_resume+0xc3/0xe0
[  587.940010]  [<c013c3a1>] warn_slowpath_common+0x71/0xc0
[  587.940010]  [<c030f4a3>] ? __sysdev_resume+0xc3/0xe0
[  587.940010]  [<c013c43b>] warn_slowpath_fmt+0x2b/0x30
[  587.940010]  [<c030f4a3>] __sysdev_resume+0xc3/0xe0
[  587.940010]  [<c015f810>] ? timekeeping_resume+0x0/0x1c0
[  587.940010]  [<c030f50f>] sysdev_resume+0x4f/0xc0
[  587.940010]  [<c0176909>] ? hibernate_nvs_restore+0x19/0x60
[  587.940010]  [<c0172ac1>] hibernation_snapshot+0x1d1/0x210
[  587.940010]  [<c0171b54>] ? freeze_processes+0x44/0xa0
[  587.940010]  [<c0172bef>] hibernate+0xef/0x190
[  587.940010]  [<c0171590>] ? state_store+0x0/0xc0
[  587.940010]  [<c017163b>] state_store+0xab/0xc0
[  587.940010]  [<c0171590>] ? state_store+0x0/0xc0
[  587.940010]  [<c0285e04>] kobj_attr_store+0x24/0x30
[  587.940010]  [<c0223d82>] sysfs_write_file+0xa2/0x100
[  587.940010]  [<c01d880c>] vfs_write+0x9c/0x150
[  587.940010]  [<c0223ce0>] ? sysfs_write_file+0x0/0x100
[  587.940010]  [<c01d8982>] sys_write+0x42/0x70
[  587.940010]  [<c0102f04>] sysenter_do_call+0x12/0x22
[  587.940010] ---[ end trace d928cdf192623f10 ]---


After resume system seems works OK.

Dmesg, config, /proc/interrupts:
http://unixy.pl/maciek/download/kernel/2.6.31-git17/gumis/

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
