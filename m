Return-Path: <linux-kernel-owner+w=401wt.eu-S1753605AbZBDIUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605AbZBDIUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 03:20:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbZBDIUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 03:20:21 -0500
Received: from mx71.mail.ru ([194.67.23.4]:64537 "EHLO mx71.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781AbZBDIUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 03:20:19 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: righi.andrea@gmail.com
Subject: Re: [Linux-fbdev-devel] [2.6.29-rc2] fb_mmap: circular locking dependency on hibernation
Date: Wed, 4 Feb 2009 11:19:35 +0300
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc3-1avb; KDE/4.2.0; i686; ; )
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       linux-pm@lists.linux-foundation.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
References: <200901272137.57757.arvidjaar@mail.ru> <200902022036.42805.arvidjaar@mail.ru> <498817E2.3020008@gmail.com>
In-Reply-To: <498817E2.3020008@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3530833.e1fuFumMns";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200902041119.43047.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3530833.e1fuFumMns
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 3 of February 2009 13:09:38 Andrea Righi wrote:
> On 2009-02-02 18:36, Andrey Borzenkov wrote:
> > I hope you do not think I'm doing this on purpose? :)
>
> LOL!
>
> Don't worry, we'll be able to fix it before linux 3.0.0 (maybe).
>

My be earlier.

Tested-by: Andrey Borzenkov <arvidjaar@mail.ru>

This bug causes text mode corruption sometimes so patch should=20
definitely go into 2.6.29.

> > [  241.668005]
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D [=20
> > 241.668044] [ INFO: possible circular locking dependency detected ]
> > [  241.668068] 2.6.29-rc3-1avb #17
> > [  241.668080]
> > ------------------------------------------------------- [=20
> > 241.668100] s2disk/4219 is trying to acquire lock:
> > [  241.668118]  (&fb_info->lock){--..}, at: [<c02235e7>]
> > fb_mmap+0x97/0x170
> > [  241.668188]
> > [  241.668190] but task is already holding lock:
> > [  241.668207]  (&mm->mmap_sem){----}, at: [<c010639e>]
> > sys_mmap2+0x8e/0xc0
> > [  241.668256]
> > [  241.668258] which lock already depends on the new lock.
> > [  241.668262]
> > [  241.668282]
> > [  241.668284] the existing dependency chain (in reverse order) is:
> > [  241.668305]
> > [  241.668307] -> #2 (&mm->mmap_sem){----}:
> > [  241.668331]        [<c014520f>] __lock_acquire+0x129f/0x1930
> > [  241.668362]        [<c01458fc>] lock_acquire+0x5c/0x80
> > [  241.668382]        [<c0182117>] might_fault+0x77/0xa0
> > [  241.668413]        [<c0209916>] copy_to_user+0x36/0x120
> > [  241.668439]        [<c01a60f7>] filldir+0x97/0xe0
> > [  241.668482]        [<c01de339>] sysfs_readdir+0x129/0x220
> > [  241.668508]        [<c01a62a6>] vfs_readdir+0x86/0xa0
> > [  241.668529]        [<c01a63e8>] sys_getdents+0x68/0xc0
> > [  241.668549]        [<c010344a>] syscall_call+0x7/0xb
> > [  241.668570]        [<ffffffff>] 0xffffffff
> > [  241.668650]
> > [  241.668653] -> #1 (sysfs_mutex){--..}:
> > [  241.668676]        [<c014520f>] __lock_acquire+0x129f/0x1930
> > [  241.668698]        [<c01458fc>] lock_acquire+0x5c/0x80
> > [  241.668718]        [<c030820a>] mutex_lock_nested+0xba/0x2f0
> > [  241.668749]        [<c01de6cc>] sysfs_addrm_start+0x2c/0xc0
> > [  241.668771]        [<c01dec80>] create_dir+0x40/0x90
> > [  241.668792]        [<c01decfb>] sysfs_create_dir+0x2b/0x50
> > [  241.668812]        [<c02036bc>] kobject_add_internal+0xbc/0x1b0
> > [  241.668853]        [<c0203881>] kobject_add_varg+0x31/0x50
> > [  241.668874]        [<c02038fc>] kobject_add+0x2c/0x60
> > [  241.668895]        [<c0273718>] device_add+0xa8/0x550
> > [  241.668938]        [<c0273bd2>] device_register+0x12/0x20
> > [  241.668960]        [<c0273c8b>] device_create_vargs+0xab/0xc0
> > [  241.668982]        [<c0273cc8>] device_create+0x28/0x30
> > [  241.669003]        [<c026cf3d>] register_con_driver+0xed/0x130
> > [  241.669027]        [<c026e45b>] take_over_console+0x1b/0x50
> > [  241.669049]        [<c02304dd>] fbcon_takeover+0x5d/0xb0
> > [  241.669081]        [<c0231457>] fbcon_event_notify+0xb27/0xc20
> > [  241.669104]        [<c030c683>] notifier_call_chain+0x53/0xa0
> > [  241.669138]        [<c0138ab4>]
> > __blocking_notifier_call_chain+0x44/0x60
> > [  241.669218]        [<c0138aea>]
> > blocking_notifier_call_chain+0x1a/0x20
> > [  241.669246]        [<c0222f81>] fb_notifier_call_chain+0x11/0x20
> > [  241.669276]        [<c0223f08>] register_framebuffer+0x168/0x220
> > [  241.669305]        [<c0414ba2>] vesafb_probe+0x542/0x783
> > [  241.669347]        [<c027687f>] platform_drv_probe+0xf/0x20
> > [  241.669378]        [<c0275a97>] driver_probe_device+0x87/0x1b0
> > [  241.669404]        [<c0275c58>] __device_attach+0x8/0x10
> > [  241.669429]        [<c02750db>] bus_for_each_drv+0x5b/0x80
> > [  241.669460]        [<c0275d06>] device_attach+0x76/0x80
> > [  241.669484]        [<c0274ef7>] bus_attach_device+0x47/0x70
> > [  241.669511]        [<c0273993>] device_add+0x323/0x550
> > [  241.669536]        [<c0277255>] platform_device_add+0x175/0x1c0
> > [  241.669567]        [<c0414e7d>] vesafb_init+0x9a/0x1ec
> > [  241.669592]        [<c010111a>] do_one_initcall+0x2a/0x160
> > [  241.669619]        [<c04004d5>] kernel_init+0x83/0xd5
> > [  241.669661]        [<c0103a77>] kernel_thread_helper+0x7/0x10
> > [  241.669688]        [<ffffffff>] 0xffffffff
> > [  241.669737]
> > [  241.669739] -> #0 (&fb_info->lock){--..}:
> > [  241.669770]        [<c014537c>] __lock_acquire+0x140c/0x1930
> > [  241.669797]        [<c01458fc>] lock_acquire+0x5c/0x80
> > [  241.669821]        [<c030820a>] mutex_lock_nested+0xba/0x2f0
> > [  241.669847]        [<c02235e7>] fb_mmap+0x97/0x170
> > [  241.669872]        [<c0188c76>] mmap_region+0x1d6/0x530
> > [  241.669908]        [<c01891a3>] do_mmap_pgoff+0x1d3/0x2f0
> > [  241.669934]        [<c01063bd>] sys_mmap2+0xad/0xc0
> > [  241.669959]        [<c0103371>] sysenter_do_call+0x12/0x31
> > [  241.669984]        [<ffffffff>] 0xffffffff
> > [  241.670009]
> > [  241.670012] other info that might help us debug this:
> > [  241.670015]
> > [  241.670049] 1 lock held by s2disk/4219:
> > [  241.670065]  #0:  (&mm->mmap_sem){----}, at: [<c010639e>]
> > sys_mmap2+0x8e/0xc0
> > [  241.670092]
> > [  241.670092] stack backtrace:
> > [  241.670092] Pid: 4219, comm: s2disk Not tainted 2.6.29-rc3-1avb
> > #17 [  241.670092] Call Trace:
> > [  241.670092]  [<c0306e38>] ? printk+0x18/0x20
> > [  241.670092]  [<c0143b1f>] print_circular_bug_tail+0xcf/0xe0
> > [  241.670092]  [<c014537c>] __lock_acquire+0x140c/0x1930
> > [  241.670092]  [<c01487f0>] ? futex_wait+0x170/0x450
> > [  241.670092]  [<c011826c>] ? try_to_wake_up+0x10c/0x120
> > [  241.670092]  [<c0309d15>] ? _spin_unlock_irqrestore+0x35/0x60
> > [  241.670092]  [<c0141105>] ? lock_release_holdtime+0x35/0x210
> > [  241.670092]  [<c01458fc>] lock_acquire+0x5c/0x80
> > [  241.670092]  [<c02235e7>] ? fb_mmap+0x97/0x170
> > [  241.670092]  [<c030820a>] mutex_lock_nested+0xba/0x2f0
> > [  241.670092]  [<c02235e7>] ? fb_mmap+0x97/0x170
> > [  241.670092]  [<c02235e7>] ? fb_mmap+0x97/0x170
> > [  241.670092]  [<c019542d>] ? kmem_cache_alloc+0xad/0x100
> > [  241.670092]  [<c02235e7>] fb_mmap+0x97/0x170
> > [  241.670092]  [<c0188c76>] mmap_region+0x1d6/0x530
> > [  241.670092]  [<c0186cfd>] ?
> > arch_get_unmapped_area_topdown+0x8d/0x170 [  241.670092]=20
> > [<c01891a3>] do_mmap_pgoff+0x1d3/0x2f0
> > [  241.670092]  [<c01063bd>] sys_mmap2+0xad/0xc0
> > [  241.670092]  [<c0103371>] sysenter_do_call+0x12/0x31
> > [  244.217754] Syncing filesystems ... done.
> > [  244.228175] Freezing user space processes ... (elapsed 0.00
> > seconds) done.
>
> OK, another patch. This one is a cumulative patch against the latest
> Linus' git.
>
> Thanks again!
> -Andrea
>
> ---
> fbmem: fix circular locking dependency between fb_info->lock and
> mm->mmap_sem
>
> Avoid calling copy_from/to_user() with fb_info->lock mutex held in
> the framebuffer's ioctl().
>
> fb_mmap() is called under mm->mmap_sem (A) held, that also acquires
> fb_info->lock (B); fb_ioctl() takes fb_info->lock (B) and does
> copy_from/to_user() that might acquire mm->mmap_sem (A), causing a
> deadlock.
>
> Also fix other potential circular locking dependencies (always
> between fb_info->lock and mm->mmap_sem) in fbcon that occur calling
> the blocking fb_notifier_call_chain() with fb_info->lock held.
>
> NOTE: it doesn't push down the fb_info->lock in each own driver's
> specific fb_ioctl() implementation, so there are still some potential
> deadlocks elsewhere.
>
> CC: Andrey Borzenkov <arvidjaar@mail.ru>
> Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
> ---
>  drivers/video/backlight/backlight.c |    3 +
>  drivers/video/backlight/lcd.c       |    3 +
>  drivers/video/console/fbcon.c       |   73 +++++++++++++++++---
>  drivers/video/fbcmap.c              |   20 ++++--
>  drivers/video/fbmem.c               |  128
> +++++++++++++++++------------------ include/linux/fb.h              =20
>   |   15 ++++
>  6 files changed, 160 insertions(+), 82 deletions(-)
>
> diff --git a/drivers/video/backlight/backlight.c
> b/drivers/video/backlight/backlight.c index 157057c..dd37cbc 100644
> --- a/drivers/video/backlight/backlight.c
> +++ b/drivers/video/backlight/backlight.c
> @@ -35,6 +35,8 @@ static int fb_notifier_callback(struct
> notifier_block *self, return 0;
>
>  	bd =3D container_of(self, struct backlight_device, fb_notif);
> +	if (!lock_fb_info(evdata->info))
> +		return -ENODEV;
>  	mutex_lock(&bd->ops_lock);
>  	if (bd->ops)
>  		if (!bd->ops->check_fb ||
> @@ -47,6 +49,7 @@ static int fb_notifier_callback(struct
> notifier_block *self, backlight_update_status(bd);
>  		}
>  	mutex_unlock(&bd->ops_lock);
> +	unlock_fb_info(evdata->info);
>  	return 0;
>  }
>
> diff --git a/drivers/video/backlight/lcd.c
> b/drivers/video/backlight/lcd.c index b644947..0bb13df 100644
> --- a/drivers/video/backlight/lcd.c
> +++ b/drivers/video/backlight/lcd.c
> @@ -40,6 +40,8 @@ static int fb_notifier_callback(struct
> notifier_block *self, if (!ld->ops)
>  		return 0;
>
> +	if (!lock_fb_info(evdata->info))
> +		return -ENODEV;
>  	mutex_lock(&ld->ops_lock);
>  	if (!ld->ops->check_fb || ld->ops->check_fb(ld, evdata->info)) {
>  		if (event =3D=3D FB_EVENT_BLANK) {
> @@ -51,6 +53,7 @@ static int fb_notifier_callback(struct
> notifier_block *self, }
>  	}
>  	mutex_unlock(&ld->ops_lock);
> +	unlock_fb_info(evdata->info);
>  	return 0;
>  }
>
> diff --git a/drivers/video/console/fbcon.c
> b/drivers/video/console/fbcon.c index 1657b96..2cd500a 100644
> --- a/drivers/video/console/fbcon.c
> +++ b/drivers/video/console/fbcon.c
> @@ -2954,8 +2954,11 @@ static int fbcon_fb_unbind(int idx)
>
>  static int fbcon_fb_unregistered(struct fb_info *info)
>  {
> -	int i, idx =3D info->node;
> +	int i, idx;
>
> +	if (!lock_fb_info(info))
> +		return -ENODEV;
> +	idx =3D info->node;
>  	for (i =3D first_fb_vc; i <=3D last_fb_vc; i++) {
>  		if (con2fb_map[i] =3D=3D idx)
>  			con2fb_map[i] =3D -1;
> @@ -2979,13 +2982,14 @@ static int fbcon_fb_unregistered(struct
> fb_info *info) }
>  	}
>
> -	if (!num_registered_fb)
> -		unregister_con_driver(&fb_con);
> -
> -
>  	if (primary_device =3D=3D idx)
>  		primary_device =3D -1;
>
> +	unlock_fb_info(info);
> +
> +	if (!num_registered_fb)
> +		unregister_con_driver(&fb_con);
> +
>  	return 0;
>  }
>
> @@ -3021,9 +3025,13 @@ static inline void fbcon_select_primary(struct
> fb_info *info)
>
>  static int fbcon_fb_registered(struct fb_info *info)
>  {
> -	int ret =3D 0, i, idx =3D info->node;
> +	int ret =3D 0, i, idx;
>
> +	if (!lock_fb_info(info))
> +		return -ENODEV;
> +	idx =3D info->node;
>  	fbcon_select_primary(info);
> +	unlock_fb_info(info);
>
>  	if (info_idx =3D=3D -1) {
>  		for (i =3D first_fb_vc; i <=3D last_fb_vc; i++) {
> @@ -3124,7 +3132,7 @@ static void fbcon_get_requirement(struct
> fb_info *info, }
>  }
>
> -static int fbcon_event_notify(struct notifier_block *self,
> +static int fbcon_event_notify(struct notifier_block *self,
>  			      unsigned long action, void *data)
>  {
>  	struct fb_event *event =3D data;
> @@ -3132,7 +3140,7 @@ static int fbcon_event_notify(struct
> notifier_block *self, struct fb_videomode *mode;
>  	struct fb_con2fbmap *con2fb;
>  	struct fb_blit_caps *caps;
> -	int ret =3D 0;
> +	int idx, ret =3D 0;
>
>  	/*
>  	 * ignore all events except driver registration and deregistration
> @@ -3144,23 +3152,54 @@ static int fbcon_event_notify(struct
> notifier_block *self,
>
>  	switch(action) {
>  	case FB_EVENT_SUSPEND:
> +		if (!lock_fb_info(info)) {
> +			ret =3D -ENODEV;
> +			goto done;
> +		}
>  		fbcon_suspended(info);
> +		unlock_fb_info(info);
>  		break;
>  	case FB_EVENT_RESUME:
> +		if (!lock_fb_info(info)) {
> +			ret =3D -ENODEV;
> +			goto done;
> +		}
>  		fbcon_resumed(info);
> +		unlock_fb_info(info);
>  		break;
>  	case FB_EVENT_MODE_CHANGE:
> +		if (!lock_fb_info(info)) {
> +			ret =3D -ENODEV;
> +			goto done;
> +		}
>  		fbcon_modechanged(info);
> +		unlock_fb_info(info);
>  		break;
>  	case FB_EVENT_MODE_CHANGE_ALL:
> +		if (!lock_fb_info(info)) {
> +			ret =3D -ENODEV;
> +			goto done;
> +		}
>  		fbcon_set_all_vcs(info);
> +		unlock_fb_info(info);
>  		break;
>  	case FB_EVENT_MODE_DELETE:
>  		mode =3D event->data;
> +		if (!lock_fb_info(info)) {
> +			ret =3D -ENODEV;
> +			goto done;
> +		}
>  		ret =3D fbcon_mode_deleted(info, mode);
> +		unlock_fb_info(info);
>  		break;
>  	case FB_EVENT_FB_UNBIND:
> -		ret =3D fbcon_fb_unbind(info->node);
> +		if (!lock_fb_info(info)) {
> +			ret =3D -ENODEV;
> +			goto done;
> +		}
> +		idx =3D info->node;
> +		unlock_fb_info(info);
> +		ret =3D fbcon_fb_unbind(idx);
>  		break;
>  	case FB_EVENT_FB_REGISTERED:
>  		ret =3D fbcon_fb_registered(info);
> @@ -3178,17 +3217,31 @@ static int fbcon_event_notify(struct
> notifier_block *self, con2fb->framebuffer =3D
> con2fb_map[con2fb->console - 1];
>  		break;
>  	case FB_EVENT_BLANK:
> +		if (!lock_fb_info(info)) {
> +			ret =3D -ENODEV;
> +			goto done;
> +		}
>  		fbcon_fb_blanked(info, *(int *)event->data);
> +		unlock_fb_info(info);
>  		break;
>  	case FB_EVENT_NEW_MODELIST:
> +		if (!lock_fb_info(info)) {
> +			ret =3D -ENODEV;
> +			goto done;
> +		}
>  		fbcon_new_modelist(info);
> +		unlock_fb_info(info);
>  		break;
>  	case FB_EVENT_GET_REQ:
>  		caps =3D event->data;
> +		if (!lock_fb_info(info)) {
> +			ret =3D -ENODEV;
> +			goto done;
> +		}
>  		fbcon_get_requirement(info, caps);
> +		unlock_fb_info(info);
>  		break;
>  	}
> -
>  done:
>  	return ret;
>  }
> diff --git a/drivers/video/fbcmap.c b/drivers/video/fbcmap.c
> index 91b78e6..f53b9f1 100644
> --- a/drivers/video/fbcmap.c
> +++ b/drivers/video/fbcmap.c
> @@ -250,10 +250,6 @@ int fb_set_user_cmap(struct fb_cmap_user *cmap,
> struct fb_info *info) int rc, size =3D cmap->len * sizeof(u16);
>  	struct fb_cmap umap;
>
> -	if (cmap->start < 0 || (!info->fbops->fb_setcolreg &&
> -			        !info->fbops->fb_setcmap))
> -		return -EINVAL;
> -
>  	memset(&umap, 0, sizeof(struct fb_cmap));
>  	rc =3D fb_alloc_cmap(&umap, cmap->len, cmap->transp !=3D NULL);
>  	if (rc)
> @@ -262,11 +258,23 @@ int fb_set_user_cmap(struct fb_cmap_user *cmap,
> struct fb_info *info) copy_from_user(umap.green, cmap->green, size)
> ||
>  	    copy_from_user(umap.blue, cmap->blue, size) ||
>  	    (cmap->transp && copy_from_user(umap.transp, cmap->transp,
> size))) { -		fb_dealloc_cmap(&umap);
> -		return -EFAULT;
> +		rc =3D -EFAULT;
> +		goto out;
>  	}
>  	umap.start =3D cmap->start;
> +	if (!lock_fb_info(info)) {
> +		rc =3D -ENODEV;
> +		goto out;
> +	}
> +	if (cmap->start < 0 || (!info->fbops->fb_setcolreg &&
> +				!info->fbops->fb_setcmap)) {
> +		rc =3D -EINVAL;
> +		goto out1;
> +	}
>  	rc =3D fb_set_cmap(&umap, info);
> +out1:
> +	unlock_fb_info(info);
> +out:
>  	fb_dealloc_cmap(&umap);
>  	return rc;
>  }
> diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
> index 756efeb..5cdee72 100644
> --- a/drivers/video/fbmem.c
> +++ b/drivers/video/fbmem.c
> @@ -1013,132 +1013,132 @@ static long do_fb_ioctl(struct fb_info
> *info, unsigned int cmd, struct fb_var_screeninfo var;
>  	struct fb_fix_screeninfo fix;
>  	struct fb_con2fbmap con2fb;
> +	struct fb_cmap cmap_from;
>  	struct fb_cmap_user cmap;
>  	struct fb_event event;
>  	void __user *argp =3D (void __user *)arg;
>  	long ret =3D 0;
>
> -	fb =3D info->fbops;
> -	if (!fb)
> -		return -ENODEV;
> -
>  	switch (cmd) {
>  	case FBIOGET_VSCREENINFO:
> -		ret =3D copy_to_user(argp, &info->var,
> -				    sizeof(var)) ? -EFAULT : 0;
> +		if (!lock_fb_info(info))
> +			return -ENODEV;
> +		var =3D info->var;
> +		unlock_fb_info(info);
> +
> +		ret =3D copy_to_user(argp, &var, sizeof(var)) ? -EFAULT : 0;
>  		break;
>  	case FBIOPUT_VSCREENINFO:
> -		if (copy_from_user(&var, argp, sizeof(var))) {
> -			ret =3D  -EFAULT;
> -			break;
> -		}
> +		if (copy_from_user(&var, argp, sizeof(var)))
> +			return -EFAULT;
> +		if (!lock_fb_info(info))
> +			return -ENODEV;
>  		acquire_console_sem();
>  		info->flags |=3D FBINFO_MISC_USEREVENT;
>  		ret =3D fb_set_var(info, &var);
>  		info->flags &=3D ~FBINFO_MISC_USEREVENT;
>  		release_console_sem();
> -		if (ret =3D=3D 0 && copy_to_user(argp, &var, sizeof(var)))
> +		unlock_fb_info(info);
> +		if (!ret && copy_to_user(argp, &var, sizeof(var)))
>  			ret =3D -EFAULT;
>  		break;
>  	case FBIOGET_FSCREENINFO:
> -		ret =3D copy_to_user(argp, &info->fix,
> -				    sizeof(fix)) ? -EFAULT : 0;
> +		if (!lock_fb_info(info))
> +			return -ENODEV;
> +		fix =3D info->fix;
> +		unlock_fb_info(info);
> +
> +		ret =3D copy_to_user(argp, &fix, sizeof(fix)) ? -EFAULT : 0;
>  		break;
>  	case FBIOPUTCMAP:
>  		if (copy_from_user(&cmap, argp, sizeof(cmap)))
> -			ret =3D -EFAULT;
> -		else
> -			ret =3D fb_set_user_cmap(&cmap, info);
> +			return -EFAULT;
> +		ret =3D fb_set_user_cmap(&cmap, info);
>  		break;
>  	case FBIOGETCMAP:
>  		if (copy_from_user(&cmap, argp, sizeof(cmap)))
> -			ret =3D -EFAULT;
> -		else
> -			ret =3D fb_cmap_to_user(&info->cmap, &cmap);
> +			return -EFAULT;
> +		if (!lock_fb_info(info))
> +			return -ENODEV;
> +		cmap_from =3D info->cmap;
> +		unlock_fb_info(info);
> +		ret =3D fb_cmap_to_user(&cmap_from, &cmap);
>  		break;
>  	case FBIOPAN_DISPLAY:
> -		if (copy_from_user(&var, argp, sizeof(var))) {
> -			ret =3D -EFAULT;
> -			break;
> -		}
> +		if (copy_from_user(&var, argp, sizeof(var)))
> +			return -EFAULT;
> +		if (!lock_fb_info(info))
> +			return -ENODEV;
>  		acquire_console_sem();
>  		ret =3D fb_pan_display(info, &var);
>  		release_console_sem();
> +		unlock_fb_info(info);
>  		if (ret =3D=3D 0 && copy_to_user(argp, &var, sizeof(var)))
> -			ret =3D -EFAULT;
> +			return -EFAULT;
>  		break;
>  	case FBIO_CURSOR:
>  		ret =3D -EINVAL;
>  		break;
>  	case FBIOGET_CON2FBMAP:
>  		if (copy_from_user(&con2fb, argp, sizeof(con2fb)))
> -			ret =3D -EFAULT;
> -		else if (con2fb.console < 1 || con2fb.console > MAX_NR_CONSOLES)
> -			ret =3D -EINVAL;
> -		else {
> -			con2fb.framebuffer =3D -1;
> -			event.info =3D info;
> -			event.data =3D &con2fb;
> -			fb_notifier_call_chain(FB_EVENT_GET_CONSOLE_MAP,
> -								&event);
> -			ret =3D copy_to_user(argp, &con2fb,
> -				    sizeof(con2fb)) ? -EFAULT : 0;
> -		}
> +			return -EFAULT;
> +		if (con2fb.console < 1 || con2fb.console > MAX_NR_CONSOLES)
> +			return -EINVAL;
> +		con2fb.framebuffer =3D -1;
> +		event.data =3D &con2fb;
> +		event.info =3D info;
> +		fb_notifier_call_chain(FB_EVENT_GET_CONSOLE_MAP, &event);
> +
> +		ret =3D copy_to_user(argp, &con2fb, sizeof(con2fb)) ? -EFAULT : 0;
>  		break;
>  	case FBIOPUT_CON2FBMAP:
> -		if (copy_from_user(&con2fb, argp, sizeof(con2fb))) {
> -			ret =3D -EFAULT;
> -			break;
> -		}
> -		if (con2fb.console < 1 || con2fb.console > MAX_NR_CONSOLES) {
> -			ret =3D -EINVAL;
> -			break;
> -		}
> -		if (con2fb.framebuffer < 0 || con2fb.framebuffer >=3D FB_MAX) {
> -			ret =3D -EINVAL;
> -			break;
> -		}
> +		if (copy_from_user(&con2fb, argp, sizeof(con2fb)))
> +			return -EFAULT;
> +		if (con2fb.console < 1 || con2fb.console > MAX_NR_CONSOLES)
> +			return -EINVAL;
> +		if (con2fb.framebuffer < 0 || con2fb.framebuffer >=3D FB_MAX)
> +			return -EINVAL;
>  		if (!registered_fb[con2fb.framebuffer])
>  			request_module("fb%d", con2fb.framebuffer);
>  		if (!registered_fb[con2fb.framebuffer]) {
>  			ret =3D -EINVAL;
>  			break;
>  		}
> -		event.info =3D info;
>  		event.data =3D &con2fb;
> +		event.info =3D info;
>  		ret =3D fb_notifier_call_chain(FB_EVENT_SET_CONSOLE_MAP,
>  					      &event);
>  		break;
>  	case FBIOBLANK:
> +		if (!lock_fb_info(info))
> +			return -ENODEV;
>  		acquire_console_sem();
>  		info->flags |=3D FBINFO_MISC_USEREVENT;
>  		ret =3D fb_blank(info, arg);
>  		info->flags &=3D ~FBINFO_MISC_USEREVENT;
>  		release_console_sem();
> -		break;;
> +		unlock_fb_info(info);
> +		break;
>  	default:
> -		if (fb->fb_ioctl =3D=3D NULL)
> -			ret =3D -ENOTTY;
> -		else
> +		if (!lock_fb_info(info))
> +			return -ENODEV;
> +		fb =3D info->fbops;
> +		if (fb->fb_ioctl)
>  			ret =3D fb->fb_ioctl(info, cmd, arg);
> +		else
> +			ret =3D -ENOTTY;
> +		unlock_fb_info(info);
>  	}
>  	return ret;
>  }
>
>  static long fb_ioctl(struct file *file, unsigned int cmd, unsigned
> long arg) -__acquires(&info->lock)
> -__releases(&info->lock)
>  {
>  	struct inode *inode =3D file->f_path.dentry->d_inode;
>  	int fbidx =3D iminor(inode);
> -	struct fb_info *info;
> -	long ret;
> +	struct fb_info *info =3D registered_fb[fbidx];
>
> -	info =3D registered_fb[fbidx];
> -	mutex_lock(&info->lock);
> -	ret =3D do_fb_ioctl(info, cmd, arg);
> -	mutex_unlock(&info->lock);
> -	return ret;
> +	return do_fb_ioctl(info, cmd, arg);
>  }
>
>  #ifdef CONFIG_COMPAT
> @@ -1257,8 +1257,6 @@ static int fb_get_fscreeninfo(struct fb_info
> *info, unsigned int cmd,
>
>  static long fb_compat_ioctl(struct file *file, unsigned int cmd,
>  			    unsigned long arg)
> -__acquires(&info->lock)
> -__releases(&info->lock)
>  {
>  	struct inode *inode =3D file->f_path.dentry->d_inode;
>  	int fbidx =3D iminor(inode);
> @@ -1266,7 +1264,6 @@ __releases(&info->lock)
>  	struct fb_ops *fb =3D info->fbops;
>  	long ret =3D -ENOIOCTLCMD;
>
> -	mutex_lock(&info->lock);
>  	switch(cmd) {
>  	case FBIOGET_VSCREENINFO:
>  	case FBIOPUT_VSCREENINFO:
> @@ -1292,7 +1289,6 @@ __releases(&info->lock)
>  			ret =3D fb->fb_compat_ioctl(info, cmd, arg);
>  		break;
>  	}
> -	mutex_unlock(&info->lock);
>  	return ret;
>  }
>  #endif
> diff --git a/include/linux/fb.h b/include/linux/fb.h
> index 818fe21..31527e1 100644
> --- a/include/linux/fb.h
> +++ b/include/linux/fb.h
> @@ -960,6 +960,21 @@ extern struct fb_info *registered_fb[FB_MAX];
>  extern int num_registered_fb;
>  extern struct class *fb_class;
>
> +static inline int lock_fb_info(struct fb_info *info)
> +{
> +	mutex_lock(&info->lock);
> +	if (!info->fbops) {
> +		mutex_unlock(&info->lock);
> +		return 0;
> +	}
> +	return 1;
> +}
> +
> +static inline void unlock_fb_info(struct fb_info *info)
> +{
> +	mutex_unlock(&info->lock);
> +}
> +
>  static inline void __fb_pad_aligned_buffer(u8 *dst, u32 d_pitch,
>  					   u8 *src, u32 s_pitch, u32 height)
>  {


--nextPart3530833.e1fuFumMns
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmJT5oACgkQR6LMutpd94zDyACfdlA6u12T9L3kAqLzMuOMsMJp
YGIAn0e+S7LjORz7JiDuESQ6k66onnfy
=U+04
-----END PGP SIGNATURE-----

--nextPart3530833.e1fuFumMns--
