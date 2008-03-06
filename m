Return-Path: <linux-kernel-owner+w=401wt.eu-S933149AbYCFMO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933149AbYCFMO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 07:14:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753645AbYCFMOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 07:14:15 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:50395 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbYCFMOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 07:14:14 -0500
Message-ID: <f4fe1c2a0803060414j17fb5209tca92c7c61f6189d9@mail.gmail.com>
Date: Thu, 6 Mar 2008 13:14:11 +0100
From: "=?UTF-8?Q?Szekeres_Istv=C3=A1n?=" <szekeres@iii.hu>
To: linux-kernel@vger.kernel.org
Subject: Lockdep warning
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found this on my computer after an uptime of 7 days. I don't know if
it is harmless or not. "dirty" is only because of an uncommitted HID
input quirk entry.
Config is available if needed.


------------[ cut here ]------------
WARNING: at kernel/lockdep.c:2662 check_flags+0x13b/0x160()
Modules linked in: tsl2550 pcf8591 pcf8575 pcf8574 max6875 eeprom
ds1682 i2c_via i2c_algo_bit i2c_dev nls_iso8859_1 nls_cp437 vfat fat
nls_base sg sd_mod usb_storage libusual usbhid rfcomm l2cap bluetooth
video output sbs sbshc container dock backlight ac battery joydev
evdev 8250_pnp 8250 serial_core psmouse rtc serio_raw pcspkr
snd_via82xx snd_ac97_codec ac97_bus snd_pcm snd_page_alloc
snd_mpu401_uart snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq
snd_timer snd_seq_device snd soundcore i2c_viapro i2c_core hid button
floppy ehci_hcd uhci_hcd usbcore dm_mirror dm_snapshot dm_mod unix
thermal processor fan fuse [last unloaded: usbhid]
Pid: 24638, comm: totem Not tainted 2.6.25-rc3pista-00081-g7704a8b-dirty #14
 [warn_on_slowpath+84/112] warn_on_slowpath+0x54/0x70
 [native_calculate_cpu_khz+240/352] ? native_calculate_cpu_khz+0xf0/0x160
 [unqueue_me+63/128] ? unqueue_me+0x3f/0x80
 [_spin_unlock+39/80] ? _spin_unlock+0x27/0x50
 [unqueue_me+71/128] ? unqueue_me+0x47/0x80
 [futex_wait+566/768] ? futex_wait+0x236/0x300
 [check_flags+315/352] check_flags+0x13b/0x160
 [lock_acquire+65/160] lock_acquire+0x41/0xa0
 [down_read+61/128] down_read+0x3d/0x80
 [futex_wake+46/240] ? futex_wake+0x2e/0xf0
 [futex_wake+46/240] futex_wake+0x2e/0xf0
 [do_futex+163/2688] do_futex+0xa3/0xa80
 [do_notify_resume+97/1968] ? do_notify_resume+0x61/0x7b0
 [sysenter_past_esp+157/165] ? sysenter_past_esp+0x9d/0xa5
 [search_exception_tables+23/48] ? search_exception_tables+0x17/0x30
 [fixup_exception+14/48] ? fixup_exception+0xe/0x30
 [do_general_protection+343/656] ? do_general_protection+0x157/0x290
 [ktime_get_ts+59/64] ? ktime_get_ts+0x3b/0x40
 [ktime_get+17/48] ? ktime_get+0x11/0x30
 [sys_futex+138/240] sys_futex+0x8a/0xf0
 [sysenter_past_esp+95/165] sysenter_past_esp+0x5f/0xa5
 =======================
---[ end trace cf60772f91bc8ecf ]---
possible reason: unannotated irqs-on.
irq event stamp: 21512
hardirqs last  enabled at (21511): [sysenter_past_esp+154/165]
sysenter_past_esp+0x9a/0xa5
