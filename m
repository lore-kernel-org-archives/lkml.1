Return-Path: <linux-kernel-owner+w=401wt.eu-S1753496AbZI0I1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496AbZI0I1g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 04:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbZI0I1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 04:27:35 -0400
Received: from mail-px0-f194.google.com ([209.85.216.194]:32888 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbZI0I1d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 04:27:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gHsoMTJ/XsulGaihxGz04+Xvb15Ff2Vbe5VVQRNmwyQbprymVfM9q266qho7hMRYwD
         EJYMH12/O31Gw7aTt+mR569f9r6ghgODOFBR1NCa+2Ujl4rRc831Wl4PKEmg/dacldz5
         MvaHrbWfiB4zfFtMJaECokUlGqLBHOrUzr+yA=
MIME-Version: 1.0
In-Reply-To: <8db1092f0909270105x4b49daf8k268e453d2379020c@mail.gmail.com>
References: <8db1092f0909270105x4b49daf8k268e453d2379020c@mail.gmail.com>
Date: Sun, 27 Sep 2009 16:27:36 +0800
Message-ID: <2674af740909270127s464a3cb2xef5e7f4cd61b0eb7@mail.gmail.com>
Subject: Re: [2.6.31-git17] WARNING: at kernel/hrtimer.c:648 
	hres_timers_resume+0x40/0x50()/WARNING: at drivers/base/sys.c:353 
	__sysdev_resume+0xc3/0xe0()
From: Yong Zhang <yong.zhang0@gmail.com>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, clemens@ladisch.de,
       venkatesh.pallipadi@intel.com, gregkh@suse.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 27, 2009 at 4:05 PM, Maciej Rutecki
<maciej.rutecki@gmail.com> wrote:
> Kernel: 2.6.31-git17
>
> During suspend to disk & resume I got it in dmesg:
>
> [  587.940010] ------------[ cut here ]------------
> [  587.940010] WARNING: at kernel/hrtimer.c:648 hres_timers_resume+0x40/0x50()
> [  587.940010] Hardware name: HP Compaq nx6310 (EY501ES#AKD)
> [  587.940010] hres_timers_resume() called with IRQs enabled!
> [  587.940010] Modules linked in: btusb i915 drm_kms_helper drm
> i2c_algo_bit i2c_core sco bnep rfcomm l2cap crc16 bluetooth xt_tcpudp
> xt_limit xt_state iptable_filter nf_conntrack_ipv4 nf_conntrack
> nf_defrag_ipv4 ip_tables x_tables aes_i586 aes_generic cbc dm_crypt
> dm_snapshot dm_mirror dm_region_hash dm_log dm_mod hp_wmi fuse sbp2
> loop snd_hda_codec_si3054 snd_hda_codec_analog snd_hda_intel
> snd_hda_codec arc4 snd_pcm_oss snd_mixer_oss snd_pcm ecb snd_seq_dummy
> snd_seq_oss snd_seq_midi iwl3945 iwlcore snd_rawmidi
> snd_seq_midi_event snd_seq firmware_class pcmcia snd_timer
> snd_seq_device mac80211 b44 snd rtc_cmos video led_class ohci1394
> uhci_hcd yenta_socket intel_agp ssb soundcore rsrc_nonstatic backlight
> rtc_core ehci_hcd cfg80211 agpgart rtc_lib pcmcia_core mii
> snd_page_alloc ieee1394 rfkill sg output psmouse fan button ac usbcore
> battery serio_raw evdev
> [  587.940010] Pid: 4761, comm: pm-hibernate Not tainted 2.6.31-git17 #1
> [  587.940010] Call Trace:
> [  587.940010]  [<c015b340>] ? hres_timers_resume+0x40/0x50
> [  587.940010]  [<c015b340>] ? hres_timers_resume+0x40/0x50
> [  587.940010]  [<c013c3a1>] warn_slowpath_common+0x71/0xc0
> [  587.940010]  [<c015b340>] ? hres_timers_resume+0x40/0x50
> [  587.940010]  [<c013c43b>] warn_slowpath_fmt+0x2b/0x30
> [  587.940010]  [<c015b340>] hres_timers_resume+0x40/0x50
> [  587.940010]  [<c015f9b7>] timekeeping_resume+0x1a7/0x1c0
> [  587.940010]  [<c030f3fc>] __sysdev_resume+0x1c/0xe0
> [  587.940010]  [<c030f50f>] sysdev_resume+0x4f/0xc0
> [  587.940010]  [<c0176909>] ? hibernate_nvs_restore+0x19/0x60
> [  587.940010]  [<c0172ac1>] hibernation_snapshot+0x1d1/0x210
> [  587.940010]  [<c0171b54>] ? freeze_processes+0x44/0xa0
> [  587.940010]  [<c0172bef>] hibernate+0xef/0x190
> [  587.940010]  [<c0171590>] ? state_store+0x0/0xc0
> [  587.940010]  [<c017163b>] state_store+0xab/0xc0
> [  587.940010]  [<c0171590>] ? state_store+0x0/0xc0
> [  587.940010]  [<c0285e04>] kobj_attr_store+0x24/0x30
> [  587.940010]  [<c0223d82>] sysfs_write_file+0xa2/0x100
> [  587.940010]  [<c01d880c>] vfs_write+0x9c/0x150
> [  587.940010]  [<c0223ce0>] ? sysfs_write_file+0x0/0x100
> [  587.940010]  [<c01d8982>] sys_write+0x42/0x70
> [  587.940010]  [<c0102f04>] sysenter_do_call+0x12/0x22
> [  587.940010] ---[ end trace d928cdf192623f0f ]---
> [  587.940010] ------------[ cut here ]------------
> [  587.940010] WARNING: at drivers/base/sys.c:353 __sysdev_resume+0xc3/0xe0()
> [  587.940010] Hardware name: HP Compaq nx6310 (EY501ES#AKD)
> [  587.940010] Interrupts enabled after timekeeping_resume+0x0/0x1c0
> [  587.940010] Modules linked in: btusb i915 drm_kms_helper drm
> i2c_algo_bit i2c_core sco bnep rfcomm l2cap crc16 bluetooth xt_tcpudp
> xt_limit xt_state iptable_filter nf_conntrack_ipv4 nf_conntrack
> nf_defrag_ipv4 ip_tables x_tables aes_i586 aes_generic cbc dm_crypt
> dm_snapshot dm_mirror dm_region_hash dm_log dm_mod hp_wmi fuse sbp2
> loop snd_hda_codec_si3054 snd_hda_codec_analog snd_hda_intel
> snd_hda_codec arc4 snd_pcm_oss snd_mixer_oss snd_pcm ecb snd_seq_dummy
> snd_seq_oss snd_seq_midi iwl3945 iwlcore snd_rawmidi
> snd_seq_midi_event snd_seq firmware_class pcmcia snd_timer
> snd_seq_device mac80211 b44 snd rtc_cmos video led_class ohci1394
> uhci_hcd yenta_socket intel_agp ssb soundcore rsrc_nonstatic backlight
> rtc_core ehci_hcd cfg80211 agpgart rtc_lib pcmcia_core mii
> snd_page_alloc ieee1394 rfkill sg output psmouse fan button ac usbcore
> battery serio_raw evdev
> [  587.940010] Pid: 4761, comm: pm-hibernate Tainted: G        W
> 2.6.31-git17 #1
> [  587.940010] Call Trace:
> [  587.940010]  [<c030f4a3>] ? __sysdev_resume+0xc3/0xe0
> [  587.940010]  [<c030f4a3>] ? __sysdev_resume+0xc3/0xe0
> [  587.940010]  [<c013c3a1>] warn_slowpath_common+0x71/0xc0
> [  587.940010]  [<c030f4a3>] ? __sysdev_resume+0xc3/0xe0
> [  587.940010]  [<c013c43b>] warn_slowpath_fmt+0x2b/0x30
> [  587.940010]  [<c030f4a3>] __sysdev_resume+0xc3/0xe0
> [  587.940010]  [<c015f810>] ? timekeeping_resume+0x0/0x1c0
> [  587.940010]  [<c030f50f>] sysdev_resume+0x4f/0xc0
> [  587.940010]  [<c0176909>] ? hibernate_nvs_restore+0x19/0x60
> [  587.940010]  [<c0172ac1>] hibernation_snapshot+0x1d1/0x210
> [  587.940010]  [<c0171b54>] ? freeze_processes+0x44/0xa0
> [  587.940010]  [<c0172bef>] hibernate+0xef/0x190
> [  587.940010]  [<c0171590>] ? state_store+0x0/0xc0
> [  587.940010]  [<c017163b>] state_store+0xab/0xc0
> [  587.940010]  [<c0171590>] ? state_store+0x0/0xc0
> [  587.940010]  [<c0285e04>] kobj_attr_store+0x24/0x30
> [  587.940010]  [<c0223d82>] sysfs_write_file+0xa2/0x100
> [  587.940010]  [<c01d880c>] vfs_write+0x9c/0x150
> [  587.940010]  [<c0223ce0>] ? sysfs_write_file+0x0/0x100
> [  587.940010]  [<c01d8982>] sys_write+0x42/0x70
> [  587.940010]  [<c0102f04>] sysenter_do_call+0x12/0x22
> [  587.940010] ---[ end trace d928cdf192623f10 ]---
>
>
> After resume system seems works OK.
>

Does the below patch work?

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index fb0f46f..b39b828 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -573,7 +573,8 @@ static int timekeeping_resume(struct sys_device *dev)

        clocksource_resume();

-       write_seqlock_irqsave(&xtime_lock, flags);
+       local_irq_save(flags);
+       write_seqlock(&xtime_locks);

        if (timespec_compare(&ts, &timekeeping_suspend_time) > 0) {
                ts = timespec_sub(ts, timekeeping_suspend_time);
@@ -586,7 +587,7 @@ static int timekeeping_resume(struct sys_device *dev)
        timekeeper.clock->cycle_last = timekeeper.clock->read(timekeeper.clock);
        timekeeper.ntp_error = 0;
        timekeeping_suspended = 0;
-       write_sequnlock_irqrestore(&xtime_lock, flags);
+       write_sequnlock(&xtime_locks);

        touch_softlockup_watchdog();

@@ -594,6 +595,7 @@ static int timekeeping_resume(struct sys_device *dev)

        /* Resume hrtimers */
        hres_timers_resume();
+       local_irq_restore(flags);

        return 0;
 }


> Dmesg, config, /proc/interrupts:
> http://unixy.pl/maciek/download/kernel/2.6.31-git17/gumis/
>
> Regards
> --
> Maciej Rutecki
> http://www.maciek.unixy.pl
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
