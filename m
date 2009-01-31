Return-Path: <linux-kernel-owner+w=401wt.eu-S1753463AbZAaQFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbZAaQFj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 11:05:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbZAaQFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 11:05:31 -0500
Received: from mx6.mail.ru ([194.67.23.26]:31912 "EHLO mx6.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457AbZAaQFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 11:05:30 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: righi.andrea@gmail.com
Subject: Re: [Linux-fbdev-devel] [2.6.29-rc2] fb_mmap: circular locking dependency on hibernation
Date: Sat, 31 Jan 2009 19:05:21 +0300
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc3-1avb; KDE/4.2.0; i686; ; )
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       linux-pm@lists.linux-foundation.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
References: <200901272137.57757.arvidjaar@mail.ru> <4982D522.20009@gmail.com> <498473F3.3050208@gmail.com>
In-Reply-To: <498473F3.3050208@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7069804.8tGTJ4p463";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200901311905.24186.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart7069804.8tGTJ4p463
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 31 of January 2009 18:53:23 Andrea Righi wrote:
> On 2009-01-30 11:23, Andrea Righi wrote:
> > On 2009-01-30 05:15, Andrey Borzenkov wrote:
> >> On 29 of January 2009 12:10:11 Geert Uytterhoeven wrote:
> >>> On Tue, 27 Jan 2009, Andrey Borzenkov wrote:
> >>>> I do not know if this is new; I usually do not hibernate at all
> >>>> and was testing another driver actually. I do not remember such
> >>>> issues in 2.6.28 though. Dmesg follows; config attached.
> >>>>
> >>>> [11715.652498]
> >>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> >>>> [11715.652520] [ INFO: possible circular locking dependency
> >>>> detected ] [11715.652534] 2.6.29-rc2-1avb #11
> >>>> [11715.652541]
> >>>> -------------------------------------------------------
> >>>> [11715.652550] s2disk/25519 is trying to acquire lock:
> >>>> [11715.652562]  (&fb_info->lock){--..}, at: [<c0223017>]
> >>>> fb_mmap+0x97/0x170 [11715.652623]
> >>>> [11715.652625] but task is already holding lock:
> >>>> [11715.652632]  (&mm->mmap_sem){----}, at: [<c010639e>]
> >>>> sys_mmap2+0x8e/0xc0 [11715.652669]
> >>>> [11715.652671] which lock already depends on the new lock.
> >>>> [11715.652675]
> >>>> [11715.652681]
> >>>> [11715.652683] the existing dependency chain (in reverse order)
> >>>> is: [11715.652691]
> >>>> [11715.652693] -> #1 (&mm->mmap_sem){----}:
> >>>> [11715.652707]        [<c0144ecf>] __lock_acquire+0x129f/0x1930
> >>>> [11715.652730]        [<c01455bc>] lock_acquire+0x5c/0x80
> >>>> [11715.652742]        [<c0181e57>] might_fault+0x77/0xa0
> >>>> [11715.652764]        [<c0209325>] copy_from_user+0x35/0x130
> >>>> [11715.652782]        [<c0223ef5>] fb_ioctl+0x1d5/0x3f0
> >>>> [11715.652797]        [<c01a51d0>] vfs_ioctl+0x20/0x80
> >>>> [11715.652832]        [<c01a53e2>] do_vfs_ioctl+0x72/0x570
> >>>> [11715.652845]        [<c01a5919>] sys_ioctl+0x39/0x70
> >>>> [11715.652857]        [<c0103371>] sysenter_do_call+0x12/0x31
> >>>> [11715.652870]        [<ffffffff>] 0xffffffff
> >>>> [11715.652973]
> >>>> [11715.652975] -> #0 (&fb_info->lock){--..}:
> >>>> [11715.652988]        [<c014503c>] __lock_acquire+0x140c/0x1930
> >>>> [11715.653000]        [<c01455bc>] lock_acquire+0x5c/0x80
> >>>> [11715.653011]        [<c030761a>] mutex_lock_nested+0xba/0x2f0
> >>>> [11715.653032]        [<c0223017>] fb_mmap+0x97/0x170
> >>>> [11715.653044]        [<c0188996>] mmap_region+0x1d6/0x530
> >>>> [11715.653067]        [<c0188ec3>] do_mmap_pgoff+0x1d3/0x2f0
> >>>> [11715.653079]        [<c01063bd>] sys_mmap2+0xad/0xc0
> >>>> [11715.653091]        [<c0103371>] sysenter_do_call+0x12/0x31
> >>>> [11715.653102]        [<ffffffff>] 0xffffffff
> >>>> [11715.653116]
> >>>> [11715.653119] other info that might help us debug this:
> >>>> [11715.653122]
> >>>> [11715.653130] 1 lock held by s2disk/25519:
> >>>> [11715.653137]  #0:  (&mm->mmap_sem){----}, at: [<c010639e>]
> >>>> sys_mmap2+0x8e/0xc0
> >>>> [11715.653156]
> >>>> [11715.653158] stack backtrace:
> >>>> [11715.653170] Pid: 25519, comm: s2disk Not tainted
> >>>> 2.6.29-rc2-1avb #11 [11715.653179] Call Trace:
> >>>> [11715.653190]  [<c0306248>] ? printk+0x18/0x20
> >>>> [11715.653202]  [<c01437df>] print_circular_bug_tail+0xcf/0xe0
> >>>> [11715.653213]  [<c014503c>] __lock_acquire+0x140c/0x1930
> >>>> [11715.653224]  [<c014328b>] ? trace_hardirqs_on+0xb/0x10
> >>>> [11715.653242]  [<c0309125>] ? _spin_unlock_irqrestore+0x35/0x60
> >>>> [11715.653254]  [<c0140dc5>] ? lock_release_holdtime+0x35/0x210
> >>>> [11715.653265]  [<c01455bc>] lock_acquire+0x5c/0x80
> >>>> [11715.653277]  [<c0223017>] ? fb_mmap+0x97/0x170
> >>>> [11715.653287]  [<c030761a>] mutex_lock_nested+0xba/0x2f0
> >>>> [11715.653298]  [<c0223017>] ? fb_mmap+0x97/0x170
> >>>> [11715.653309]  [<c0223017>] ? fb_mmap+0x97/0x170
> >>>> [11715.653335]  [<c019514d>] ? kmem_cache_alloc+0xad/0x100
> >>>> [11715.653347]  [<c0223017>] fb_mmap+0x97/0x170
> >>>> [11715.653358]  [<c0188996>] mmap_region+0x1d6/0x530
> >>>> [11715.653371]  [<c0186a9d>] ?
> >>>> arch_get_unmapped_area_topdown+0x10d/0x170 [11715.653383]
> >>>> [<c0188ec3>] do_mmap_pgoff+0x1d3/0x2f0
> >>>> [11715.653395]  [<c01063bd>] sys_mmap2+0xad/0xc0
> >>>> [11715.653406]  [<c0103371>] sysenter_do_call+0x12/0x31
> >>>
> >>> Is this fixed by http://patchwork.kernel.org/patch/3259/?
> >>
> >> No. It just makes stack a bit more deep :)
> >
> > yep! :)
> >
> > Probably we should simply use an atomic notifier there, instead of
> > blocking. I'll do some tests and post a new fix.
>
> No, the solution is no so trivial. Some notifier callbacks can sleep,
> so the usage of a blocking notifier is mandatory. It seems we need a
> more complicated solution to totally fix it. At least the previous
> fix avoids the circular locking of fb_info->lock and mm->mmap_sem due
> to copy_from/to_user() called with fb_info->lock held...
>

Well, this is serious regression that must be fixed before release. It=20
apparently prevents other notifiers from being called, with the effect=20
that e.g. firmware is no more cached on suspend and applied later on=20
resume -> controller non-functional.

*Any* workaround would still be useful.

> -Andrea
>
> > Thanks,
> > -Andrea
> >
> >> [  408.267429]
> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D [=20
> >> 408.267448] [ INFO: possible circular locking dependency detected
> >> ] [  408.267462] 2.6.29-rc3-1avb #14
> >> [  408.267469]
> >> ------------------------------------------------------- [=20
> >> 408.267478] s2disk/5695 is trying to acquire lock:
> >> [  408.267487]  (&fb_info->lock){--..}, at: [<c02235e7>]
> >> fb_mmap+0x97/0x170
> >> [  408.267544]
> >> [  408.267546] but task is already holding lock:
> >> [  408.267553]  (&mm->mmap_sem){----}, at: [<c010639e>]
> >> sys_mmap2+0x8e/0xc0
> >> [  408.267591]
> >> [  408.267593] which lock already depends on the new lock.
> >> [  408.267596]
> >> [  408.267603]
> >> [  408.267604] the existing dependency chain (in reverse order)
> >> is: [  408.267612]
> >> [  408.267614] -> #3 (&mm->mmap_sem){----}:
> >> [  408.267628]        [<c014520f>] __lock_acquire+0x129f/0x1930
> >> [  408.267650]        [<c01458fc>] lock_acquire+0x5c/0x80
> >> [  408.267661]        [<c0182117>] might_fault+0x77/0xa0
> >> [  408.267683]        [<c0209916>] copy_to_user+0x36/0x120
> >> [  408.267699]        [<c01a60f7>] filldir+0x97/0xe0
> >> [  408.267735]        [<c01de339>] sysfs_readdir+0x129/0x220
> >> [  408.267751]        [<c01a62a6>] vfs_readdir+0x86/0xa0
> >> [  408.267763]        [<c01a63e8>] sys_getdents+0x68/0xc0
> >> [  408.267775]        [<c010344a>] syscall_call+0x7/0xb
> >> [  408.267787]        [<ffffffff>] 0xffffffff
> >> [  408.267862]
> >> [  408.267864] -> #2 (sysfs_mutex){--..}:
> >> [  408.267877]        [<c014520f>] __lock_acquire+0x129f/0x1930
> >> [  408.267889]        [<c01458fc>] lock_acquire+0x5c/0x80
> >> [  408.267899]        [<c0307f3a>] mutex_lock_nested+0xba/0x2f0
> >> [  408.267921]        [<c01de6cc>] sysfs_addrm_start+0x2c/0xc0
> >> [  408.267933]        [<c01dec80>] create_dir+0x40/0x90
> >> [  408.267944]        [<c01decfb>] sysfs_create_dir+0x2b/0x50
> >> [  408.267955]        [<c02036bc>] kobject_add_internal+0xbc/0x1b0
> >> [  408.267984]        [<c0203881>] kobject_add_varg+0x31/0x50
> >> [  408.267996]        [<c02038fc>] kobject_add+0x2c/0x60
> >> [  408.268008]        [<c0273448>] device_add+0xa8/0x550
> >> [  408.268041]        [<c0273902>] device_register+0x12/0x20
> >> [  408.268053]        [<c02739bb>] device_create_vargs+0xab/0xc0
> >> [  408.268065]        [<c02739f8>] device_create+0x28/0x30
> >> [  408.268077]        [<c026cc6d>] register_con_driver+0xed/0x130
> >> [  408.268090]        [<c026e18b>] take_over_console+0x1b/0x50
> >> [  408.268102]        [<c023052d>] fbcon_takeover+0x5d/0xb0
> >> [  408.268125]        [<c02311a0>] fbcon_event_notify+0x820/0x900
> >> [  408.268137]        [<c030c3b3>] notifier_call_chain+0x53/0xa0
> >> [  408.268161]        [<c0138ab4>]
> >> __blocking_notifier_call_chain+0x44/0x60
> >> [  408.268184]        [<c0138aea>]
> >> blocking_notifier_call_chain+0x1a/0x20
> >> [  408.268197]        [<c0222f81>]
> >> fb_notifier_call_chain+0x11/0x20 [  408.268209]      =20
> >> [<c0223f08>] register_framebuffer+0x168/0x220 [  408.268223]     =20
> >>  [<c0414ba2>] vesafb_probe+0x542/0x783 [  408.268250]      =20
> >> [<c02765af>] platform_drv_probe+0xf/0x20 [  408.268269]      =20
> >> [<c02757c7>] driver_probe_device+0x87/0x1b0 [  408.268281]      =20
> >> [<c0275988>] __device_attach+0x8/0x10 [  408.268291]      =20
> >> [<c0274e0b>] bus_for_each_drv+0x5b/0x80 [  408.268308]      =20
> >> [<c0275a36>] device_attach+0x76/0x80 [  408.268319]      =20
> >> [<c0274c27>] bus_attach_device+0x47/0x70 [  408.268331]      =20
> >> [<c02736c3>] device_add+0x323/0x550 [  408.268342]      =20
> >> [<c0276f85>] platform_device_add+0x175/0x1c0 [  408.268358]      =20
> >> [<c0414e7d>] vesafb_init+0x9a/0x1ec [  408.268370]      =20
> >> [<c010111a>] do_one_initcall+0x2a/0x160 [  408.268382]      =20
> >> [<c04004d5>] kernel_init+0x83/0xd5
> >> [  408.268411]        [<c0103a77>] kernel_thread_helper+0x7/0x10
> >> [  408.268423]        [<ffffffff>] 0xffffffff
> >> [  408.268436]
> >> [  408.268438] -> #1 ((fb_notifier_list).rwsem){----}:
> >> [  408.268451]        [<c014520f>] __lock_acquire+0x129f/0x1930
> >> [  408.268463]        [<c01458fc>] lock_acquire+0x5c/0x80
> >> [  408.268474]        [<c0308879>] down_read+0x49/0x90
> >> [  408.268484]        [<c0138a9a>]
> >> __blocking_notifier_call_chain+0x2a/0x60
> >> [  408.268497]        [<c0138aea>]
> >> blocking_notifier_call_chain+0x1a/0x20
> >> [  408.268509]        [<c0222f81>]
> >> fb_notifier_call_chain+0x11/0x20 [  408.268521]      =20
> >> [<c022459e>] do_fb_ioctl+0x2ae/0x5d0 [  408.268533]      =20
> >> [<c02248dd>] fb_ioctl+0x1d/0x20
> >> [  408.268545]        [<c01a54b0>] vfs_ioctl+0x20/0x80
> >> [  408.268558]        [<c01a56c2>] do_vfs_ioctl+0x72/0x570
> >> [  408.268570]        [<c01a5bf9>] sys_ioctl+0x39/0x70
> >> [  408.268581]        [<c0103371>] sysenter_do_call+0x12/0x31
> >> [  408.268592]        [<ffffffff>] 0xffffffff
> >> [  408.268623]
> >> [  408.268625] -> #0 (&fb_info->lock){--..}:
> >> [  408.268638]        [<c014537c>] __lock_acquire+0x140c/0x1930
> >> [  408.268649]        [<c01458fc>] lock_acquire+0x5c/0x80
> >> [  408.268661]        [<c0307f3a>] mutex_lock_nested+0xba/0x2f0
> >> [  408.268672]        [<c02235e7>] fb_mmap+0x97/0x170
> >> [  408.268684]        [<c0188c76>] mmap_region+0x1d6/0x530
> >> [  408.268706]        [<c01891a3>] do_mmap_pgoff+0x1d3/0x2f0
> >> [  408.268718]        [<c01063bd>] sys_mmap2+0xad/0xc0
> >> [  408.268729]        [<c0103371>] sysenter_do_call+0x12/0x31
> >> [  408.268740]        [<ffffffff>] 0xffffffff
> >> [  408.268752]
> >> [  408.268754] other info that might help us debug this:
> >> [  408.268758]
> >> [  408.268767] 1 lock held by s2disk/5695:
> >> [  408.268773]  #0:  (&mm->mmap_sem){----}, at: [<c010639e>]
> >> sys_mmap2+0x8e/0xc0
> >> [  408.268792]
> >> [  408.268794] stack backtrace:
> >> [  408.268805] Pid: 5695, comm: s2disk Not tainted 2.6.29-rc3-1avb
> >> #14 [  408.268814] Call Trace:
> >> [  408.268825]  [<c0306b68>] ? printk+0x18/0x20
> >> [  408.268836]  [<c0143b1f>] print_circular_bug_tail+0xcf/0xe0
> >> [  408.268847]  [<c014537c>] __lock_acquire+0x140c/0x1930
> >> [  408.268862]  [<c01487f0>] ? futex_wait+0x170/0x450
> >> [  408.268881]  [<c011826c>] ? try_to_wake_up+0x10c/0x120
> >> [  408.268894]  [<c0309a45>] ? _spin_unlock_irqrestore+0x35/0x60
> >> [  408.268906]  [<c0141105>] ? lock_release_holdtime+0x35/0x210
> >> [  408.268917]  [<c01458fc>] lock_acquire+0x5c/0x80
> >> [  408.268928]  [<c02235e7>] ? fb_mmap+0x97/0x170
> >> [  408.268939]  [<c0307f3a>] mutex_lock_nested+0xba/0x2f0
> >> [  408.268950]  [<c02235e7>] ? fb_mmap+0x97/0x170
> >> [  408.268961]  [<c02235e7>] ? fb_mmap+0x97/0x170
> >> [  408.268987]  [<c019542d>] ? kmem_cache_alloc+0xad/0x100
> >> [  408.268999]  [<c02235e7>] fb_mmap+0x97/0x170
> >> [  408.269010]  [<c0188c76>] mmap_region+0x1d6/0x530
> >> [  408.269023]  [<c0186d7d>] ?
> >> arch_get_unmapped_area_topdown+0x10d/0x170
> >> [  408.269035]  [<c01891a3>] do_mmap_pgoff+0x1d3/0x2f0
> >> [  408.269047]  [<c01063bd>] sys_mmap2+0xad/0xc0
> >> [  408.269058]  [<c0103371>] sysenter_do_call+0x12/0x31


--nextPart7069804.8tGTJ4p463
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmEdsQACgkQR6LMutpd94zYNACgnCyN4pL7dOWhyiN11rqugl7m
WYwAoMcAnWbeO9ZMazDlUoWBB3dbtgCB
=mXxA
-----END PGP SIGNATURE-----

--nextPart7069804.8tGTJ4p463--
