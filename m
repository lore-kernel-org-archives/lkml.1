Return-Path: <linux-kernel-owner+w=401wt.eu-S1757020AbZFVO5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020AbZFVO5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 10:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbZFVO5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 10:57:41 -0400
Received: from mail-qy0-f171.google.com ([209.85.221.171]:42632 "EHLO
	mail-qy0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbZFVO5l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 10:57:41 -0400
MIME-Version: 1.0
In-Reply-To: <a44ae5cd0906191432o7c7b602dsc099cff1c4fcd84a@mail.gmail.com>
References: <a44ae5cd0906191432o7c7b602dsc099cff1c4fcd84a@mail.gmail.com>
Date: Mon, 22 Jun 2009 10:57:42 -0400
Message-ID: <7e0fb38c0906220757l73684e5bkbe5128531c7bccbe@mail.gmail.com>
Subject: Re: 2.6.30-git14 -- BUG inotify_inode_mark_entry: Poison overwritten
From: Eric Paris <eparis@parisplace.org>
To: Miles Lane <miles.lane@gmail.com>
Cc: John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
       LKML <linux-kernel@vger.kernel.org>, Stephen Tweedie <sct@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andreas Dilger <adilger@sun.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 19, 2009 at 5:32 PM, Miles Lane<miles.lane@gmail.com> wrote:
> I will send the .config file separately, to avoid rejection by vger.
>
> Linux ubuntu 2.6.30-git14 #4 SMP PREEMPT Fri Jun 19 16:40:52 EDT 2009
> i686 GNU/Linux
>
> Gnu C                  4.4.0
> Gnu make               3.81
> binutils               2.19.51.20090515
> util-linux             2.15.1-rc1
> mount                  support
> module-init-tools      3.8
> e2fsprogs              1.41.5
> reiserfsprogs          3.6.21
> pcmciautils            014
> Linux C Library        2.9
> Dynamic linker (ldd)   2.9
> Procps                 3.2.8
> Net-tools              1.60
> Kbd                    1.14.1
> Sh-utils               7.4
> wireless-tools         29
> Modules Loaded         vfat fat sco bnep rfcomm l2cap bluetooth
> snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm psmouse
> snd_seq_dummy snd_seq_oss snd_seq_midi_event iTCO_wdt
> iTCO_vendor_support ath9k snd_seq rng_core mac80211 ath snd_timer
> snd_seq_device cfg80211 snd soundcore snd_page_alloc shpchp
> pci_hotplug rtc_cmos rtc_core rtc_lib eeepc_laptop hwmon rfkill
> hid_logitech usb_storage usb_libusual usbhid sg ehci_hcd uhci_hcd
> usbcore atl1e
>
> Distro:  Ubuntu 9.10 development packages
>
> [   15.458756] idr_remove called for id=31 which is not allocated.
> [   15.463938] Pid: 1446, comm: udevd Not tainted 2.6.30-git14 #4
> [   15.469161] Call Trace:
> [   15.474347]  [<c1309bab>] ? printk+0xf/0x14
> [   15.479553]  [<c116ca04>] idr_remove+0xcd/0x128
> [   15.484640]  [<c130b995>] ? _spin_lock+0x2c/0x34
> [   15.489697]  [<c10cb5d9>] inotify_destroy_mark_entry+0x87/0x9a
> [   15.494544]  [<c10cad13>] inotify_freeing_mark+0x8/0xa
> [   15.499312]  [<c10c9af9>] fsnotify_destroy_mark_by_entry+0x119/0x13d
> [   15.504466]  [<c10cb57a>] inotify_destroy_mark_entry+0x28/0x9a
> [   15.509032]  [<c10cb665>] sys_inotify_rm_watch+0x79/0x98
> [   15.513550]  [<c1002c5c>] syscall_call+0x7/0xb

Should be fixed by:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=528da3e9e237059a84a2625e942811cf824a6efd

If you have any problems with Linus' latest kernels please let me know!

-Eric
