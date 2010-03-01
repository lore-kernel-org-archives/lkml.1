Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663Ab0CAVFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 16:05:04 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34236 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054Ab0CAVFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 16:05:03 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michal Hocko <mstsxfx@gmail.com>
Subject: Re: unable to handle kernel paging request on resume with 2.6.33-00001-gbaac35c
Date: Mon, 1 Mar 2010 22:07:37 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-git-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
References: <20100301175256.GA4034@tiehlicka.suse.cz>
In-Reply-To: <20100301175256.GA4034@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201003012207.37582.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 March 2010, Michal Hocko wrote:
> Hi,
> 
> I have experienced the following kernel BUG on resume from suspend from
> disk (the whole log from  hibarnation to suspend along with kernel
> config are attached):
> 
> BUG: unable to handle kernel paging request at 00aaaaaa
> IP: [<c019e28c>] anon_vma_link+0x2c/0x39
> *pde = 00000000
> Oops: 0002 [#1] PREEMPT SMP
> last sysfs file: /sys/devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0003:00/power_supply/AC/type
> Modules linked in: aes_i586 aes_generic iwl3945 iwlcore mac80211 cfg80211 fbcon font bitblit softcursor i915 drm_kms_helper drm fb i2c_algo_bit cfbcopyarea i2c_core cfbimgblt cfbfillrect fuse tun coretemp hwmon snd_hda_codec_realtek snd_hda_intel snd_hda_codec arc4 ecb snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_oss snd_seq_midi_event snd_seq snd_timer fujitsu_laptop snd_seq_device rtc_cmos rtc_core led_class rtc_lib snd snd_page_alloc video backlight output [last unloaded: cfg80211]
> 
> Pid: 3942, comm: kxkb Not tainted 2.6.33-00001-gbaac35c #11 FJNB1B5/LIFEBOOK S7110
> EIP: 0060:[<c019e28c>] EFLAGS: 00010246 CPU: 1
> EIP is at anon_vma_link+0x2c/0x39
> EAX: 00aaaaaa EBX: f69c6410 ECX: f69c6414 EDX: f63e4df4
> ESI: f63e4dc0 EDI: f63e4e14 EBP: f6901ec0 ESP: f6901eb8
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process kxkb (pid: 3942, ti=f6901000 task=f6aa6ff0 task.ti=f6901000)
> Stack:
>  f63e4dc0 f23fc7e4 f6901efc c012fc28 f6aa6ff0 f63e4e30 f63e4e34 f63e4e24
> <0> ca4656f4 f6ace734 f6aa6ff0 f6ace700 ca4656c0 f23fc790 ca560000 fffffff4
> <0> f659ef94 f6901f38 c0130821 f6aa6ff0 f6901fb4 bff441f0 ca560208 00000000
> Call Trace:
>  [<c012fc28>] ? dup_mm+0x1c7/0x3d3
>  [<c0130821>] ? copy_process+0x98e/0xf26
>  [<c0130ed6>] ? do_fork+0x11d/0x2a1
>  [<c0434547>] ? _raw_spin_unlock+0x14/0x28
>  [<c01b6795>] ? set_close_on_exec+0x45/0x4b
>  [<c01b6e98>] ? do_fcntl+0x15f/0x3f1
>  [<c0108678>] ? sys_clone+0x20/0x25
>  [<c010291d>] ? ptregs_clone+0x15/0x38
>  [<c0102850>] ? sysenter_do_call+0x12/0x26
> Code: 89 e5 56 53 0f 1f 44 00 00 8b 58 3c 89 c6 85 db 74 22 89 d8 e8 54 65 29 00 8b 43 08 8d 56 34 8d 4b 04 89 53 08 89 4e 34 89 46 38 <89> 10 89 d8 e8 9e 62 29 00 5b 5e 5d c3 55 89 e5 0f 1f 44 00 00
> EIP: [<c019e28c>] anon_vma_link+0x2c/0x39 SS:ESP 0068:f6901eb8
> CR2: 0000000000aaaaaa
> ---[ end trace b7f008b0e5aa7c65 ]---

This looks like a low-level memory management issue of some sort.

What's the HEAD commit in this kernel tree?

Also, is the problem reproducible?

Rafael
