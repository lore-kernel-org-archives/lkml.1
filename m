Return-Path: <linux-kernel-owner+w=401wt.eu-S1754956AbYLHARx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956AbYLHARx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 19:17:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753088AbYLHARn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 19:17:43 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:42463 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbYLHARl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 19:17:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=mxyC6GDsQygoMQrPAXBNy1LzqsJK7kWPw43/kj6oNNUiGCFqDYcJkUVY1hRxfJjpAi
         1vad7oc9RIesJyBIs8prJd0CZrxVw/NDS0s1zrdRUHbuALRWLz3zmSpSwzVr6zKUVAhP
         VqVPRlB+gNTJGOWOkVm6XF4Zw5ByS+TIpAHs8=
Message-ID: <21d7e9970812071617u72d5f6d9k1bbde5a09ed9412f@mail.gmail.com>
Date: Mon, 8 Dec 2008 10:17:40 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
Subject: Re: next-2008120[3,4] drm oops (was Re: vanilla kernels hang randomly under Fedora 10 on system with Radeon card)
Cc: linux-kernel@vger.kernel.org, "Benny Amorsen" <benny+usenet@amorsen.dk>,
       linux-next@vger.kernel.org
In-Reply-To: <200812051950.28443.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200812012342.32575.bzolnier@gmail.com>
	 <200812040107.36616.bzolnier@gmail.com>
	 <200812042055.13731.bzolnier@gmail.com>
	 <200812051950.28443.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 6, 2008 at 4:50 AM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
> On Thursday 04 December 2008, Bartlomiej Zolnierkiewicz wrote:
>
> [...]
>
>> To add more fun I'm getting following DRM oops with next-2008120[3,4]:
>
> Here is refreshed oops (I needed to tweak/rebuild the kernel):
>
> BUG: unable to handle kernel NULL pointer dereference at 00000144
> IP: [<c0247371>] drm_addmap_core+0x548/0x561
> *pde = 00000000
> Oops: 0000 [#1] PREEMPT SMP
> last sysfs file: /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/enable
> Modules linked in: radeon(+) lib80211_crypt_tkip xt_state ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 acerhk cpufreq_ondemand binfmt_misc snd_intel8x0 snd_intel8x0m snd_ac97_codec snd_seq_dummy ac97_bus snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm ipw2200 snd_timer libipw snd soundcore snd_page_alloc lib80211 ehci_hcd uhci_hcd parport_pc parport
>
> Pid: 1740, comm: modprobe Not tainted (2.6.28-rc7-next-20081204 #268) Extensa 2900
> EIP: 0060:[<c0247371>] EFLAGS: 00213202 CPU: 0
> EIP is at drm_addmap_core+0x548/0x561
> EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: da1dec00
> ESI: da2baac0 EDI: da177a80 EBP: e0010000 ESP: da2c1ea4
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process modprobe (pid: 1740, ti=da2c1000 task=df8741b0 task.ti=da2c1000)
> Stack:
>  da177a80 00010000 da1dec00 00000002 da1dec20 da177a88 da1decd4 da1decd4
>  da1dece0 00010000 da2c1eec da285800 da285b44 da1dec00 c02473f2 00000001
>  00000082 da2c1eec da2c1ef4 00010000 e085674c 00000001 00000082 da285b40
> Call Trace:
>  [<c02473f2>] drm_addmap+0x14/0x2e
>  [<e085674c>] radeon_driver_load+0xef/0x15a [radeon]
>  [<c024bb73>] drm_get_dev+0x240/0x4ab
>  [<c01e48af>] kobject_get+0xf/0x13
>  [<c024821d>] drm_init+0x5a/0x89
>  [<e0832000>] radeon_init+0x0/0x14 [radeon]
>  [<c010112c>] _stext+0x44/0x108
>  [<c01430a8>] sys_init_module+0x87/0x174
>  [<c0102eb1>] sysenter_do_call+0x12/0x25
>  [<c0310000>] rtl8139_init_one+0x685/0x85e
> Code: 12 0d 00 eb 35 8b 3c 24 8b 47 10 c7 47 1c 00 00 00 00 c1 e0 0c 89 47 18 8b 44 24 10 e8 a8 12 0d 00 8b 54 24 08 8b 82 b0 02 00 00 <8b> 80 44 01 00 00 89 47 20 8b 4c 24 44 89 39 83 c4 28 89 d8 5b
> EIP: [<c0247371>] drm_addmap_core+0x548/0x561 SS:ESP 0068:da2c1ea4
> ---[ end trace b2c7f2a062698806 ]---
>
> [...]
>
>> which I think may be caused by:
>>
>> commit c2f29f764c0daa0084674d4a463e7158ac5c4dc4
>> Author: Dave Airlie <airlied@redhat.com>
>> Date:   Fri Nov 28 14:22:24 2008 +1000
>>
>>     drm: move to kref per-master structures.
>>
>> however I haven't verified it yet.


Thanks for that, I've pushed the fix into drm-next
(d5de2d1a3a88628396c895410ae9e06f732d6591)
which was to reorganise the startup sequence so things happened in a
more correct order.

Let me know if it still breaks.

Dave.
