Return-Path: <linux-kernel-owner+w=401wt.eu-S1760951AbZDSQxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760951AbZDSQxg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 12:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbZDSQx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 12:53:26 -0400
Received: from mail-bw0-f211.google.com ([209.85.218.211]:32915 "EHLO
	mail-bw0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbZDSQxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 12:53:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=eDoqMRkOLN4uTM2SAvKiWwrYIrcWsfvNgDzsdgeSH93iVjTbCkWShNHDs4vDrL8u2v
         XDMUgv26EBQIKLb8IIA+B+3XR00s6IzzhB9MId1uX+NWyafapY22pE85QdhmxJXXIbUx
         Fo/87wGuwiuV4ufuYCKvZ0bkvTAYsak9+/Y5k=
MIME-Version: 1.0
Date: Sun, 19 Apr 2009 20:53:22 +0400
Message-ID: <208cbae30904190953t58105f13p6e11efca6d6f5322@mail.gmail.com>
Subject: [warn_once] warning: at kernel/hrtimer.c:625 hres_timers_resume+0x24/0x38()
From: Alexey Klimov <klimov.linux@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all
When testing behaviour of radio-mr800 drvier when doing suspend/resume
to disk, using echo disk > /sys/power/state i have such warning in
dmesg(see below please).
Kernel is 30-rc2, up-to-date. If you need more information, feel free to ask.
The code in hrtimer.c is:

void hres_timers_resume(void)
{
        WARN_ONCE(!irqs_disabled(),
                  KERN_INFO "hres_timers_resume() called with IRQs enabled!");



------------[ cut here ]------------
WARNING: at kernel/hrtimer.c:625 hres_timers_resume+0x24/0x38()
Hardware name: TravelMate 2350
hres_timers_resume() called with IRQs enabled!Modules linked in:
radio_mr800 v4l2_common videodev snd_intel8x0 nls_utf8 cifs
snd_usb_audio snd_usb_lib snd_rawmidi snd_hwdep nls_iso8859_1
nls_cp437 vfat fat nls_base v4l1_compat i915 drm cpufreq_ondemand
acpi_cpufreq snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq
snd_seq_device snd_pcm_oss snd_mixer_oss usbhid hid snd_ac97_codec
ac97_bus yenta_socket snd_pcm rsrc_nonstatic 8139cp pcmcia_core
rtc_cmos snd_timer 8139too libipw ehci_hcd snd lib80211 psmouse
rtc_core uhci_hcd mii soundcore usbcore shpchp sr_mod serio_raw cdrom
ac thermal i2c_i801 battery button rtc_lib pci_hotplug sg
snd_page_alloc [last unloaded: radio_mr800]
Pid: 25506, comm: bash Not tainted 2.6.30-rc2 #43
Call Trace:
 [<c011852d>] ? warn_slowpath+0x80/0xae
 [<c01fd36a>] ? acpi_ns_lookup+0x1fa/0x316
 [<c011452e>] ? wakeup_preempt_entity+0xc3/0xe9
 [<c012aa73>] ? getnstimeofday+0x4c/0xc9
 [<c010d02f>] ? lapic_next_event+0x13/0x16
 [<c012cb79>] ? clockevents_program_event+0xc2/0xd0
 [<c012d687>] ? tick_dev_program_event+0x1e/0x81
 [<c012d729>] ? tick_program_event+0xf/0x11
 [<c01288be>] ? notifier_call_chain+0x2a/0x47
 [<c0127ec6>] ? hres_timers_resume+0x24/0x38
 [<c012a1b5>] ? timekeeping_resume+0xcb/0xd0
 [<c02307f4>] ? __sysdev_resume+0x11/0x34
 [<c0230835>] ? sysdev_resume+0x1e/0x50
 [<c01344e0>] ? hibernation_snapshot+0xd5/0x15b
 [<c01345f2>] ? hibernate+0x8c/0x141
 [<c0133566>] ? state_store+0x0/0x9a
 [<c01335b4>] ? state_store+0x4e/0x9a
 [<c0133566>] ? state_store+0x0/0x9a
 [<c01ca6f7>] ? kobj_attr_store+0x18/0x1c
 [<c018b929>] ? sysfs_write_file+0xb0/0xdd
 [<c018b879>] ? sysfs_write_file+0x0/0xdd
 [<c015a537>] ? vfs_write+0x84/0xf7
 [<c015a642>] ? sys_write+0x3c/0x63
 [<c0102788>] ? sysenter_do_call+0x12/0x26
---[ end trace df0f2ac34650ffc9 ]---
