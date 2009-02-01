Return-Path: <linux-kernel-owner+w=401wt.eu-S1756529AbZBAWu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529AbZBAWu2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 17:50:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753393AbZBAWuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 17:50:19 -0500
Received: from mail-bw0-f12.google.com ([209.85.218.12]:43145 "EHLO
	mail-bw0-f12.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206AbZBAWuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 17:50:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=ewDansvMK2XPl1G3fJ2Rav0Smy1Up9nsm1DWhY0RUb2Ch/ZxT2VH/3iqJMRfrEloTQ
         DY4gF9RhB+bgMSehq8aLK+rz9iad3QH9AxSnGXhQuqFoZyvMwZsZSkf/yjmkzjX796/m
         gbu7H1OEoin3UarEtyRCtZSjubNv1mLHKhjp0=
Message-ID: <49862722.7020109@gmail.com>
Date: Sun, 01 Feb 2009 23:50:10 +0100
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@mail.ru>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
       Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       linux-pm@lists.linux-foundation.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [Linux-fbdev-devel] [2.6.29-rc2] fb_mmap: circular locking dependency
 on hibernation
References: <200901272137.57757.arvidjaar@mail.ru> <200901300716.06137.arvidjaar@mail.ru> <498485E0.4080501@gmail.com> <200902011015.45562.arvidjaar@mail.ru>
In-Reply-To: <200902011015.45562.arvidjaar@mail.ru>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-02-01 08:15, Andrey Borzenkov wrote:
> On 31 of January 2009 20:09:52 Andrea Righi wrote:
>> On 2009-01-30 05:15, Andrey Borzenkov wrote:
>>> On 29 of January 2009 12:10:11 Geert Uytterhoeven wrote:
>>>> On Tue, 27 Jan 2009, Andrey Borzenkov wrote:
>>>>> I do not know if this is new; I usually do not hibernate at all
>>>>> and was testing another driver actually. I do not remember such
>>>>> issues in 2.6.28 though. Dmesg follows; config attached.
>>>>>
>>>>> [11715.652498]
>>>>> =======================================================
>>>>> [11715.652520] [ INFO: possible circular locking dependency
>>>>> detected ] [11715.652534] 2.6.29-rc2-1avb #11
>>>>> [11715.652541]
>>>>> -------------------------------------------------------
>>>>> [11715.652550] s2disk/25519 is trying to acquire lock:
>>>>> [11715.652562]  (&fb_info->lock){--..}, at: [<c0223017>]
>>>>> fb_mmap+0x97/0x170 [11715.652623]
>>>>> [11715.652625] but task is already holding lock:
>>>>> [11715.652632]  (&mm->mmap_sem){----}, at: [<c010639e>]
>>>>> sys_mmap2+0x8e/0xc0 [11715.652669]
>>>>> [11715.652671] which lock already depends on the new lock.
>>>>> [11715.652675]
>>>>> [11715.652681]
>>>>> [11715.652683] the existing dependency chain (in reverse order)
>>>>> is: [11715.652691]
>>>>> [11715.652693] -> #1 (&mm->mmap_sem){----}:
>>>>> [11715.652707]        [<c0144ecf>] __lock_acquire+0x129f/0x1930
>>>>> [11715.652730]        [<c01455bc>] lock_acquire+0x5c/0x80
>>>>> [11715.652742]        [<c0181e57>] might_fault+0x77/0xa0
>>>>> [11715.652764]        [<c0209325>] copy_from_user+0x35/0x130
>>>>> [11715.652782]        [<c0223ef5>] fb_ioctl+0x1d5/0x3f0
>>>>> [11715.652797]        [<c01a51d0>] vfs_ioctl+0x20/0x80
>>>>> [11715.652832]        [<c01a53e2>] do_vfs_ioctl+0x72/0x570
>>>>> [11715.652845]        [<c01a5919>] sys_ioctl+0x39/0x70
>>>>> [11715.652857]        [<c0103371>] sysenter_do_call+0x12/0x31
>>>>> [11715.652870]        [<ffffffff>] 0xffffffff
>>>>> [11715.652973]
>>>>> [11715.652975] -> #0 (&fb_info->lock){--..}:
>>>>> [11715.652988]        [<c014503c>] __lock_acquire+0x140c/0x1930
>>>>> [11715.653000]        [<c01455bc>] lock_acquire+0x5c/0x80
>>>>> [11715.653011]        [<c030761a>] mutex_lock_nested+0xba/0x2f0
>>>>> [11715.653032]        [<c0223017>] fb_mmap+0x97/0x170
>>>>> [11715.653044]        [<c0188996>] mmap_region+0x1d6/0x530
>>>>> [11715.653067]        [<c0188ec3>] do_mmap_pgoff+0x1d3/0x2f0
>>>>> [11715.653079]        [<c01063bd>] sys_mmap2+0xad/0xc0
>>>>> [11715.653091]        [<c0103371>] sysenter_do_call+0x12/0x31
>>>>> [11715.653102]        [<ffffffff>] 0xffffffff
>>>>> [11715.653116]
>>>>> [11715.653119] other info that might help us debug this:
>>>>> [11715.653122]
>>>>> [11715.653130] 1 lock held by s2disk/25519:
>>>>> [11715.653137]  #0:  (&mm->mmap_sem){----}, at: [<c010639e>]
>>>>> sys_mmap2+0x8e/0xc0
>>>>> [11715.653156]
>>>>> [11715.653158] stack backtrace:
>>>>> [11715.653170] Pid: 25519, comm: s2disk Not tainted
>>>>> 2.6.29-rc2-1avb #11 [11715.653179] Call Trace:
>>>>> [11715.653190]  [<c0306248>] ? printk+0x18/0x20
>>>>> [11715.653202]  [<c01437df>] print_circular_bug_tail+0xcf/0xe0
>>>>> [11715.653213]  [<c014503c>] __lock_acquire+0x140c/0x1930
>>>>> [11715.653224]  [<c014328b>] ? trace_hardirqs_on+0xb/0x10
>>>>> [11715.653242]  [<c0309125>] ? _spin_unlock_irqrestore+0x35/0x60
>>>>> [11715.653254]  [<c0140dc5>] ? lock_release_holdtime+0x35/0x210
>>>>> [11715.653265]  [<c01455bc>] lock_acquire+0x5c/0x80
>>>>> [11715.653277]  [<c0223017>] ? fb_mmap+0x97/0x170
>>>>> [11715.653287]  [<c030761a>] mutex_lock_nested+0xba/0x2f0
>>>>> [11715.653298]  [<c0223017>] ? fb_mmap+0x97/0x170
>>>>> [11715.653309]  [<c0223017>] ? fb_mmap+0x97/0x170
>>>>> [11715.653335]  [<c019514d>] ? kmem_cache_alloc+0xad/0x100
>>>>> [11715.653347]  [<c0223017>] fb_mmap+0x97/0x170
>>>>> [11715.653358]  [<c0188996>] mmap_region+0x1d6/0x530
>>>>> [11715.653371]  [<c0186a9d>] ?
>>>>> arch_get_unmapped_area_topdown+0x10d/0x170 [11715.653383]
>>>>> [<c0188ec3>] do_mmap_pgoff+0x1d3/0x2f0
>>>>> [11715.653395]  [<c01063bd>] sys_mmap2+0xad/0xc0
>>>>> [11715.653406]  [<c0103371>] sysenter_do_call+0x12/0x31
>>>> Is this fixed by http://patchwork.kernel.org/patch/3259/?
>>> No. It just makes stack a bit more deep :)
>>>
>>> [  408.267429]
>>> ======================================================= [ 
>>> 408.267448] [ INFO: possible circular locking dependency detected ]
>>> [  408.267462] 2.6.29-rc3-1avb #14
>>> [  408.267469]
>>> ------------------------------------------------------- [ 
>>> 408.267478] s2disk/5695 is trying to acquire lock:
>>> [  408.267487]  (&fb_info->lock){--..}, at: [<c02235e7>]
>>> fb_mmap+0x97/0x170
>>> [  408.267544]
>>> [  408.267546] but task is already holding lock:
>>> [  408.267553]  (&mm->mmap_sem){----}, at: [<c010639e>]
>>> sys_mmap2+0x8e/0xc0
>>> [  408.267591]
>>> [  408.267593] which lock already depends on the new lock.
>>> [  408.267596]
>>> [  408.267603]
>>> [  408.267604] the existing dependency chain (in reverse order) is:
>>> [  408.267612]
>>> [  408.267614] -> #3 (&mm->mmap_sem){----}:
>>> [  408.267628]        [<c014520f>] __lock_acquire+0x129f/0x1930
>>> [  408.267650]        [<c01458fc>] lock_acquire+0x5c/0x80
>>> [  408.267661]        [<c0182117>] might_fault+0x77/0xa0
>>> [  408.267683]        [<c0209916>] copy_to_user+0x36/0x120
>>> [  408.267699]        [<c01a60f7>] filldir+0x97/0xe0
>>> [  408.267735]        [<c01de339>] sysfs_readdir+0x129/0x220
>>> [  408.267751]        [<c01a62a6>] vfs_readdir+0x86/0xa0
>>> [  408.267763]        [<c01a63e8>] sys_getdents+0x68/0xc0
>>> [  408.267775]        [<c010344a>] syscall_call+0x7/0xb
>>> [  408.267787]        [<ffffffff>] 0xffffffff
>>> [  408.267862]
>>> [  408.267864] -> #2 (sysfs_mutex){--..}:
>>> [  408.267877]        [<c014520f>] __lock_acquire+0x129f/0x1930
>>> [  408.267889]        [<c01458fc>] lock_acquire+0x5c/0x80
>>> [  408.267899]        [<c0307f3a>] mutex_lock_nested+0xba/0x2f0
>>> [  408.267921]        [<c01de6cc>] sysfs_addrm_start+0x2c/0xc0
>>> [  408.267933]        [<c01dec80>] create_dir+0x40/0x90
>>> [  408.267944]        [<c01decfb>] sysfs_create_dir+0x2b/0x50
>>> [  408.267955]        [<c02036bc>] kobject_add_internal+0xbc/0x1b0
>>> [  408.267984]        [<c0203881>] kobject_add_varg+0x31/0x50
>>> [  408.267996]        [<c02038fc>] kobject_add+0x2c/0x60
>>> [  408.268008]        [<c0273448>] device_add+0xa8/0x550
>>> [  408.268041]        [<c0273902>] device_register+0x12/0x20
>>> [  408.268053]        [<c02739bb>] device_create_vargs+0xab/0xc0
>>> [  408.268065]        [<c02739f8>] device_create+0x28/0x30
>>> [  408.268077]        [<c026cc6d>] register_con_driver+0xed/0x130
>>> [  408.268090]        [<c026e18b>] take_over_console+0x1b/0x50
>>> [  408.268102]        [<c023052d>] fbcon_takeover+0x5d/0xb0
>>> [  408.268125]        [<c02311a0>] fbcon_event_notify+0x820/0x900
>>> [  408.268137]        [<c030c3b3>] notifier_call_chain+0x53/0xa0
>>> [  408.268161]        [<c0138ab4>]
>>> __blocking_notifier_call_chain+0x44/0x60
>>> [  408.268184]        [<c0138aea>]
>>> blocking_notifier_call_chain+0x1a/0x20
>>> [  408.268197]        [<c0222f81>] fb_notifier_call_chain+0x11/0x20
>>> [  408.268209]        [<c0223f08>] register_framebuffer+0x168/0x220
>>> [  408.268223]        [<c0414ba2>] vesafb_probe+0x542/0x783
>>> [  408.268250]        [<c02765af>] platform_drv_probe+0xf/0x20
>>> [  408.268269]        [<c02757c7>] driver_probe_device+0x87/0x1b0
>>> [  408.268281]        [<c0275988>] __device_attach+0x8/0x10
>>> [  408.268291]        [<c0274e0b>] bus_for_each_drv+0x5b/0x80
>>> [  408.268308]        [<c0275a36>] device_attach+0x76/0x80
>>> [  408.268319]        [<c0274c27>] bus_attach_device+0x47/0x70
>>> [  408.268331]        [<c02736c3>] device_add+0x323/0x550
>>> [  408.268342]        [<c0276f85>] platform_device_add+0x175/0x1c0
>>> [  408.268358]        [<c0414e7d>] vesafb_init+0x9a/0x1ec
>>> [  408.268370]        [<c010111a>] do_one_initcall+0x2a/0x160
>>> [  408.268382]        [<c04004d5>] kernel_init+0x83/0xd5
>>> [  408.268411]        [<c0103a77>] kernel_thread_helper+0x7/0x10
>>> [  408.268423]        [<ffffffff>] 0xffffffff
>>> [  408.268436]
>>> [  408.268438] -> #1 ((fb_notifier_list).rwsem){----}:
>>> [  408.268451]        [<c014520f>] __lock_acquire+0x129f/0x1930
>>> [  408.268463]        [<c01458fc>] lock_acquire+0x5c/0x80
>>> [  408.268474]        [<c0308879>] down_read+0x49/0x90
>>> [  408.268484]        [<c0138a9a>]
>>> __blocking_notifier_call_chain+0x2a/0x60
>>> [  408.268497]        [<c0138aea>]
>>> blocking_notifier_call_chain+0x1a/0x20
>>> [  408.268509]        [<c0222f81>] fb_notifier_call_chain+0x11/0x20
>>> [  408.268521]        [<c022459e>] do_fb_ioctl+0x2ae/0x5d0
>>> [  408.268533]        [<c02248dd>] fb_ioctl+0x1d/0x20
>>> [  408.268545]        [<c01a54b0>] vfs_ioctl+0x20/0x80
>>> [  408.268558]        [<c01a56c2>] do_vfs_ioctl+0x72/0x570
>>> [  408.268570]        [<c01a5bf9>] sys_ioctl+0x39/0x70
>>> [  408.268581]        [<c0103371>] sysenter_do_call+0x12/0x31
>>> [  408.268592]        [<ffffffff>] 0xffffffff
>>> [  408.268623]
>>> [  408.268625] -> #0 (&fb_info->lock){--..}:
>>> [  408.268638]        [<c014537c>] __lock_acquire+0x140c/0x1930
>>> [  408.268649]        [<c01458fc>] lock_acquire+0x5c/0x80
>>> [  408.268661]        [<c0307f3a>] mutex_lock_nested+0xba/0x2f0
>>> [  408.268672]        [<c02235e7>] fb_mmap+0x97/0x170
>>> [  408.268684]        [<c0188c76>] mmap_region+0x1d6/0x530
>>> [  408.268706]        [<c01891a3>] do_mmap_pgoff+0x1d3/0x2f0
>>> [  408.268718]        [<c01063bd>] sys_mmap2+0xad/0xc0
>>> [  408.268729]        [<c0103371>] sysenter_do_call+0x12/0x31
>>> [  408.268740]        [<ffffffff>] 0xffffffff
>>> [  408.268752]
>>> [  408.268754] other info that might help us debug this:
>>> [  408.268758]
>>> [  408.268767] 1 lock held by s2disk/5695:
>>> [  408.268773]  #0:  (&mm->mmap_sem){----}, at: [<c010639e>]
>>> sys_mmap2+0x8e/0xc0
>>> [  408.268792]
>>> [  408.268794] stack backtrace:
>>> [  408.268805] Pid: 5695, comm: s2disk Not tainted 2.6.29-rc3-1avb
>>> #14 [  408.268814] Call Trace:
>>> [  408.268825]  [<c0306b68>] ? printk+0x18/0x20
>>> [  408.268836]  [<c0143b1f>] print_circular_bug_tail+0xcf/0xe0
>>> [  408.268847]  [<c014537c>] __lock_acquire+0x140c/0x1930
>>> [  408.268862]  [<c01487f0>] ? futex_wait+0x170/0x450
>>> [  408.268881]  [<c011826c>] ? try_to_wake_up+0x10c/0x120
>>> [  408.268894]  [<c0309a45>] ? _spin_unlock_irqrestore+0x35/0x60
>>> [  408.268906]  [<c0141105>] ? lock_release_holdtime+0x35/0x210
>>> [  408.268917]  [<c01458fc>] lock_acquire+0x5c/0x80
>>> [  408.268928]  [<c02235e7>] ? fb_mmap+0x97/0x170
>>> [  408.268939]  [<c0307f3a>] mutex_lock_nested+0xba/0x2f0
>>> [  408.268950]  [<c02235e7>] ? fb_mmap+0x97/0x170
>>> [  408.268961]  [<c02235e7>] ? fb_mmap+0x97/0x170
>>> [  408.268987]  [<c019542d>] ? kmem_cache_alloc+0xad/0x100
>>> [  408.268999]  [<c02235e7>] fb_mmap+0x97/0x170
>>> [  408.269010]  [<c0188c76>] mmap_region+0x1d6/0x530
>>> [  408.269023]  [<c0186d7d>] ?
>>> arch_get_unmapped_area_topdown+0x10d/0x170
>>> [  408.269035]  [<c01891a3>] do_mmap_pgoff+0x1d3/0x2f0
>>> [  408.269047]  [<c01063bd>] sys_mmap2+0xad/0xc0
>>> [  408.269058]  [<c0103371>] sysenter_do_call+0x12/0x31
>> Anyway, looking at this trace in detail, it seems that in the fbcon
>> notifier the FB_EVENT_SET_CONSOLE_MAP handler doesn't use fb_info at
>> all.
>>
>> So, just for this particular case, we could unlock fb_info->lock
>> before calling the routine that might acquire mm->mmap_sem, and avoid
>> the circular locking dependency.
>>
>> Any chance to do a test with the following patch?
>>
> 
> Step by step ... :)
> 
> With both patches applied:
> 
> [  113.949848] =======================================================
> [  113.950054] [ INFO: possible circular locking dependency detected ]
> [  113.950054] 2.6.29-rc3-1avb #16
> [  113.950054] -------------------------------------------------------
> [  113.950054] s2disk/4168 is trying to acquire lock:
> [  113.950054]  (&fb_info->lock){--..}, at: [<c0230c56>] 
> fbcon_event_notify+0x2d6/0x950
> [  113.950054]
> [  113.950054] but task is already holding lock:
> [  113.950054]  ((fb_notifier_list).rwsem){----}, at: [<c0138a9a>] 
> __blocking_notifier_call_chain+0x2a/0x60
> [  113.950054]
> [  113.950054] which lock already depends on the new lock.
> [  113.950054]
> [  113.950054]
> [  113.950054] the existing dependency chain (in reverse order) is:
> [  113.950054]
> [  113.950054] -> #1 ((fb_notifier_list).rwsem){----}:
> [  113.950054]        [<c014520f>] __lock_acquire+0x129f/0x1930
> [  113.950054]        [<c01458fc>] lock_acquire+0x5c/0x80
> [  113.950054]        [<c03088c9>] down_read+0x49/0x90
> [  113.950054]        [<c0138a9a>] __blocking_notifier_call_chain+0x2a/0x60
> [  113.950054]        [<c0138aea>] blocking_notifier_call_chain+0x1a/0x20
> [  113.950054]        [<c0222f81>] fb_notifier_call_chain+0x11/0x20
> [  113.950054]        [<c022459e>] do_fb_ioctl+0x2ae/0x5d0
> [  113.950054]        [<c02248dd>] fb_ioctl+0x1d/0x20
> [  113.950054]        [<c01a54b0>] vfs_ioctl+0x20/0x80
> [  113.950054]        [<c01a56c2>] do_vfs_ioctl+0x72/0x570
> [  113.950054]        [<c01a5bf9>] sys_ioctl+0x39/0x70
> [  113.950054]        [<c0103371>] sysenter_do_call+0x12/0x31
> [  113.950054]        [<ffffffff>] 0xffffffff
> [  113.950054]
> [  113.950054] -> #0 (&fb_info->lock){--..}:
> [  113.950054]        [<c014537c>] __lock_acquire+0x140c/0x1930
> [  113.950054]        [<c01458fc>] lock_acquire+0x5c/0x80
> [  113.950054]        [<c0307f8a>] mutex_lock_nested+0xba/0x2f0
> [  113.950054]        [<c0230c56>] fbcon_event_notify+0x2d6/0x950
> [  113.950054]        [<c030c403>] notifier_call_chain+0x53/0xa0
> [  113.950054]        [<c0138ab4>] __blocking_notifier_call_chain+0x44/0x60
> [  113.950054]        [<c0138aea>] blocking_notifier_call_chain+0x1a/0x20
> [  113.950054]        [<c0222f81>] fb_notifier_call_chain+0x11/0x20
> [  113.950054]        [<c02246ca>] do_fb_ioctl+0x3da/0x5d0
> [  113.950054]        [<c02248dd>] fb_ioctl+0x1d/0x20
> [  113.950054]        [<c01a54b0>] vfs_ioctl+0x20/0x80
> [  113.950054]        [<c01a56c2>] do_vfs_ioctl+0x72/0x570
> [  113.950054]        [<c01a5bf9>] sys_ioctl+0x39/0x70
> [  113.950054]        [<c0103371>] sysenter_do_call+0x12/0x31
> [  113.950054]        [<ffffffff>] 0xffffffff
> [  113.950054]
> [  113.950054] other info that might help us debug this:
> [  113.950054]
> [  113.950054] 1 lock held by s2disk/4168:
> [  113.950054]  #0:  ((fb_notifier_list).rwsem){----}, at: [<c0138a9a>] 
> __blocking_notifier_call_chain+0x2a/0x60
> [  113.950054]
> [  113.950054] stack backtrace:
> [  113.950054] Pid: 4168, comm: s2disk Not tainted 2.6.29-rc3-1avb #16
> [  113.950054] Call Trace:
> [  113.950054]  [<c0306bb8>] ? printk+0x18/0x20
> [  113.950054]  [<c0143b1f>] print_circular_bug_tail+0xcf/0xe0
> [  113.950054]  [<c014537c>] __lock_acquire+0x140c/0x1930
> [  113.950054]  [<c0141105>] ? lock_release_holdtime+0x35/0x210
> [  113.950054]  [<c0143992>] ? check_noncircular+0x92/0x150
> [  113.950054]  [<c01463ce>] ? lock_release_non_nested+0x16e/0x2a0
> [  113.950054]  [<c0138a9a>] ? __blocking_notifier_call_chain+0x2a/0x60
> [  113.950054]  [<c01458fc>] lock_acquire+0x5c/0x80
> [  113.950054]  [<c0230c56>] ? fbcon_event_notify+0x2d6/0x950
> [  113.950054]  [<c0307f8a>] mutex_lock_nested+0xba/0x2f0
> [  113.950054]  [<c0230c56>] ? fbcon_event_notify+0x2d6/0x950
> [  113.950054]  [<c0230c56>] ? fbcon_event_notify+0x2d6/0x950
> [  113.950054]  [<c0230c56>] fbcon_event_notify+0x2d6/0x950
> [  113.950054]  [<c010b9ab>] ? save_stack_trace+0x2b/0x50
> [  113.950054]  [<c014185c>] ? save_trace+0x3c/0xa0
> [  113.950054]  [<c01418fd>] ? add_lock_to_list+0x3d/0xb0
> [  113.950054]  [<c0141105>] ? lock_release_holdtime+0x35/0x210
> [  113.950054]  [<c01462fd>] ? lock_release_non_nested+0x9d/0x2a0
> [  113.950054]  [<c0138a9a>] ? __blocking_notifier_call_chain+0x2a/0x60
> [  113.950054]  [<c030c403>] notifier_call_chain+0x53/0xa0
> [  113.950054]  [<c03088e5>] ? down_read+0x65/0x90
> [  113.950054]  [<c0138ab4>] __blocking_notifier_call_chain+0x44/0x60
> [  113.950054]  [<c0138aea>] blocking_notifier_call_chain+0x1a/0x20
> [  113.950054]  [<c0222f81>] fb_notifier_call_chain+0x11/0x20
> [  113.950054]  [<c02246ca>] do_fb_ioctl+0x3da/0x5d0
> [  113.950054]  [<c01820e6>] ? might_fault+0x46/0xa0
> [  113.950054]  [<c01820e6>] ? might_fault+0x46/0xa0
> [  113.950054]  [<c0182131>] ? might_fault+0x91/0xa0
> [  113.950054]  [<c01820e6>] ? might_fault+0x46/0xa0
> [  113.950054]  [<c0141105>] ? lock_release_holdtime+0x35/0x210
> [  113.950054]  [<c01462fd>] ? lock_release_non_nested+0x9d/0x2a0
> [  113.950054]  [<c01820e6>] ? might_fault+0x46/0xa0
> [  113.950054]  [<c01820e6>] ? might_fault+0x46/0xa0
> [  113.950054]  [<c0182131>] ? might_fault+0x91/0xa0
> [  113.950054]  [<c01820e6>] ? might_fault+0x46/0xa0
> [  113.950054]  [<c0209916>] ? copy_to_user+0x36/0x120
> [  113.950054]  [<c02248c0>] ? fb_ioctl+0x0/0x20
> [  113.950054]  [<c02248dd>] fb_ioctl+0x1d/0x20
> [  113.950054]  [<c01a54b0>] vfs_ioctl+0x20/0x80
> [  113.950054]  [<c01a56c2>] do_vfs_ioctl+0x72/0x570
> [  113.950054]  [<c019c762>] ? sys_fstat64+0x22/0x30
> [  113.950054]  [<c01a2180>] ? __link_path_walk+0x240/0xd40
> [  113.950054]  [<c010339f>] ? sysenter_exit+0xf/0x16
> [  113.950054]  [<c01a5bf9>] sys_ioctl+0x39/0x70
> [  113.950054]  [<c0103371>] sysenter_do_call+0x12/0x31
> [  117.846986] Syncing filesystems ... done.
> 
> In case it helps - suspend to RAM does not exhibit this issue.

Another attempt... ignore the previous patch and try to apply this one
on top of "fbmem: copy_from/to_user() with mutex held (v3)".

Thanks a lot for the tests!

-Andrea

---
fbmem: fix circular locking dependency pushing down fb_info->lock

Push down fb_info->lock into each framebuffer notifier callback to avoid
a circular locking dependency between fb_info->lock and
fb_notifier_list->rwsem.

Reported-by: Andrey Borzenkov <arvidjaar@mail.ru>
Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 drivers/video/backlight/backlight.c |    3 ++
 drivers/video/backlight/lcd.c       |    3 ++
 drivers/video/console/fbcon.c       |   62 +++++++++++++++++++++++++++++++----
 drivers/video/fbmem.c               |    7 ----
 4 files changed, 61 insertions(+), 14 deletions(-)

diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index 157057c..dd37cbc 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -35,6 +35,8 @@ static int fb_notifier_callback(struct notifier_block *self,
 		return 0;
 
 	bd = container_of(self, struct backlight_device, fb_notif);
+	if (!lock_fb_info(evdata->info))
+		return -ENODEV;
 	mutex_lock(&bd->ops_lock);
 	if (bd->ops)
 		if (!bd->ops->check_fb ||
@@ -47,6 +49,7 @@ static int fb_notifier_callback(struct notifier_block *self,
 			backlight_update_status(bd);
 		}
 	mutex_unlock(&bd->ops_lock);
+	unlock_fb_info(evdata->info);
 	return 0;
 }
 
diff --git a/drivers/video/backlight/lcd.c b/drivers/video/backlight/lcd.c
index b644947..0bb13df 100644
--- a/drivers/video/backlight/lcd.c
+++ b/drivers/video/backlight/lcd.c
@@ -40,6 +40,8 @@ static int fb_notifier_callback(struct notifier_block *self,
 	if (!ld->ops)
 		return 0;
 
+	if (!lock_fb_info(evdata->info))
+		return -ENODEV;
 	mutex_lock(&ld->ops_lock);
 	if (!ld->ops->check_fb || ld->ops->check_fb(ld, evdata->info)) {
 		if (event == FB_EVENT_BLANK) {
@@ -51,6 +53,7 @@ static int fb_notifier_callback(struct notifier_block *self,
 		}
 	}
 	mutex_unlock(&ld->ops_lock);
+	unlock_fb_info(evdata->info);
 	return 0;
 }
 
diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 81fc2f7..7bc2a26 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -3144,57 +3144,105 @@ static int fbcon_event_notify(struct notifier_block *self,
 
 	switch(action) {
 	case FB_EVENT_SUSPEND:
+		if (!lock_fb_info(info)) {
+			ret = -ENODEV;
+			goto done;
+		}
 		fbcon_suspended(info);
+		unlock_fb_info(info);
 		break;
 	case FB_EVENT_RESUME:
+		if (!lock_fb_info(info)) {
+			ret = -ENODEV;
+			goto done;
+		}
 		fbcon_resumed(info);
+		unlock_fb_info(info);
 		break;
 	case FB_EVENT_MODE_CHANGE:
+		if (!lock_fb_info(info)) {
+			ret = -ENODEV;
+			goto done;
+		}
 		fbcon_modechanged(info);
+		unlock_fb_info(info);
 		break;
 	case FB_EVENT_MODE_CHANGE_ALL:
+		if (!lock_fb_info(info)) {
+			ret = -ENODEV;
+			goto done;
+		}
 		fbcon_set_all_vcs(info);
+		unlock_fb_info(info);
 		break;
 	case FB_EVENT_MODE_DELETE:
 		mode = event->data;
+		if (!lock_fb_info(info)) {
+			ret = -ENODEV;
+			goto done;
+		}
 		ret = fbcon_mode_deleted(info, mode);
+		unlock_fb_info(info);
 		break;
 	case FB_EVENT_FB_UNBIND:
+		if (!lock_fb_info(info)) {
+			ret = -ENODEV;
+			goto done;
+		}
 		ret = fbcon_fb_unbind(info->node);
+		unlock_fb_info(info);
 		break;
 	case FB_EVENT_FB_REGISTERED:
+		if (!lock_fb_info(info)) {
+			ret = -ENODEV;
+			goto done;
+		}
 		ret = fbcon_fb_registered(info);
+		unlock_fb_info(info);
 		break;
 	case FB_EVENT_FB_UNREGISTERED:
+		if (!lock_fb_info(info)) {
+			ret = -ENODEV;
+			goto done;
+		}
 		ret = fbcon_fb_unregistered(info);
+		unlock_fb_info(info);
 		break;
 	case FB_EVENT_SET_CONSOLE_MAP:
-		/*
-		 * XXX: info is not used here, we can unlock it to avoid
-		 * circular locking with &current->mm->mmap_sem in fb_mmap().
-		 */
-		unlock_fb_info(info);
 		con2fb = event->data;
 		ret = set_con2fb_map(con2fb->console - 1,
 				     con2fb->framebuffer, 1);
-		lock_fb_info(info);
 		break;
 	case FB_EVENT_GET_CONSOLE_MAP:
 		con2fb = event->data;
 		con2fb->framebuffer = con2fb_map[con2fb->console - 1];
 		break;
 	case FB_EVENT_BLANK:
+		if (!lock_fb_info(info)) {
+			ret = -ENODEV;
+			goto done;
+		}
 		fbcon_fb_blanked(info, *(int *)event->data);
+		unlock_fb_info(info);
 		break;
 	case FB_EVENT_NEW_MODELIST:
+		if (!lock_fb_info(info)) {
+			ret = -ENODEV;
+			goto done;
+		}
 		fbcon_new_modelist(info);
+		unlock_fb_info(info);
 		break;
 	case FB_EVENT_GET_REQ:
 		caps = event->data;
+		if (!lock_fb_info(info)) {
+			ret = -ENODEV;
+			goto done;
+		}
 		fbcon_get_requirement(info, caps);
+		unlock_fb_info(info);
 		break;
 	}
-
 done:
 	return ret;
 }
diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index cfd9dce..5cdee72 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1086,12 +1086,8 @@ static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
 			return -EINVAL;
 		con2fb.framebuffer = -1;
 		event.data = &con2fb;
-
-		if (!lock_fb_info(info))
-			return -ENODEV;
 		event.info = info;
 		fb_notifier_call_chain(FB_EVENT_GET_CONSOLE_MAP, &event);
-		unlock_fb_info(info);
 
 		ret = copy_to_user(argp, &con2fb, sizeof(con2fb)) ? -EFAULT : 0;
 		break;
@@ -1109,12 +1105,9 @@ static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
 			break;
 		}
 		event.data = &con2fb;
-		if (!lock_fb_info(info))
-			return -ENODEV;
 		event.info = info;
 		ret = fb_notifier_call_chain(FB_EVENT_SET_CONSOLE_MAP,
 					      &event);
-		unlock_fb_info(info);
 		break;
 	case FBIOBLANK:
 		if (!lock_fb_info(info))
-- 
1.5.6.3
