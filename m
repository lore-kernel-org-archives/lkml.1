Return-Path: <linux-kernel-owner+w=401wt.eu-S1759330AbYHTPFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330AbYHTPFH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 11:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758153AbYHTPEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 11:04:52 -0400
Received: from xenotime.net ([66.160.160.81]:57651 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756752AbYHTPEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 11:04:50 -0400
Date: Wed, 20 Aug 2008 08:04:48 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: Andrew Morton <akpm@linux-foundation.org>
cc: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: [-mm] sysfs: duplicate filename 'acpi' can not be created
In-Reply-To: <20080819224732.5b1393c1.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0808200804130.23549@shark.he.net>
References: <48ABACF2.4060503@cn.fujitsu.com> <20080819224732.5b1393c1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Aug 2008, Andrew Morton wrote:

> On Wed, 20 Aug 2008 13:34:42 +0800 Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
> > When I compiled latest -mm and booted up:

See this thread, although there has not been any clear resolution to it:

http://marc.info/?l=linux-next&m=121872830921819&w=2


> > ------------[ cut here ]------------
> > WARNING: at fs/sysfs/dir.c:463 sysfs_add_one+0x27/0x2f()
> > sysfs: duplicate filename 'acpi' can not be created
> > Modules linked in:
> > Pid: 1, comm: swapper Not tainted 2.6.27-rc3-mm1 #2
> >  [<c0421173>] warn_slowpath+0x61/0x83
> >  [<c043b422>] __lock_acquire+0x601/0x658
> >  [<c047ea0d>] ifind+0x13/0x79
> >  [<c05c2ce9>] _spin_unlock+0x14/0x1c
> >  [<c047ea6d>] ifind+0x73/0x79
> >  [<c04a5a32>] sysfs_find_dirent+0x13/0x23
> >  [<c04a5ac5>] sysfs_add_one+0x27/0x2f
> >  [<c04a5f83>] create_dir+0x3c/0x81
> >  [<c04a5ff1>] sysfs_create_dir+0x29/0x3b
> >  [<c05c2ce9>] _spin_unlock+0x14/0x1c
> >  [<c04c466d>] kobject_add_internal+0xb1/0x14a
> >  [<c04c490b>] kobject_init_and_add+0x29/0x2c
> >  [<c06ea613>] kernel_param_sysfs_setup+0x4f/0x9f
> >  [<c06ea753>] param_sysfs_init+0xf0/0x147
> >  [<c0401122>] _stext+0x3a/0x12f
> >  [<c06ea663>] param_sysfs_init+0x0/0x147
> >  [<c041b3ee>] try_to_wake_up+0x146/0x14f
> >  [<c042d9f5>] __create_workqueue_key+0xa0/0x13c
> >  [<c06d9550>] kernel_init+0x18d/0x1f1
> >  [<c06d93c3>] kernel_init+0x0/0x1f1
> >  [<c04044ff>] kernel_thread_helper+0x7/0x10
> >  =======================
> > ---[ end trace 4eaa2a86a8e2da22 ]---
> > kobject_add_internal failed for acpi with -EEXIST, don't try to register things with the same name in the same directory.
> > Pid: 1, comm: swapper Tainted: G        W 2.6.27-rc3-mm1 #2
> >  [<c04c46d0>] kobject_add_internal+0x114/0x14a
> >  [<c04c490b>] kobject_init_and_add+0x29/0x2c
> >  [<c06ea613>] kernel_param_sysfs_setup+0x4f/0x9f
> >  [<c06ea753>] param_sysfs_init+0xf0/0x147
> >  [<c0401122>] _stext+0x3a/0x12f
> >  [<c06ea663>] param_sysfs_init+0x0/0x147
> >  [<c041b3ee>] try_to_wake_up+0x146/0x14f
> >  [<c042d9f5>] __create_workqueue_key+0xa0/0x13c
> >  [<c06d9550>] kernel_init+0x18d/0x1f1
> >  [<c06d93c3>] kernel_init+0x0/0x1f1
> >  [<c04044ff>] kernel_thread_helper+0x7/0x10
> >  =======================
> > Module 'acpi' failed to be added to sysfs, error number -17
> > The system will be unstable now.
> 
> The only acpi-specific patches in mm(otm) are
> 
> acpi-add-checking-for-null-early-param.patch
> acpi-avoid-dropping-rapid-hotkey-events-or-other-gpes-on-asus-eeepc.patch
> mm-only-enforce-acpi-resource-conflict-checks.patch
> 
> so I'd say you've hit a linux-next regression there.
> 
> Random-possible-feel-it-in-my-water-guess: do you have CONFIG_FASTBOOT
> set and if so, does unsetting it fix things?
> --

-- 
~Randy
