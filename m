Return-Path: <linux-kernel-owner+w=401wt.eu-S1754032AbYIENYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbYIENYp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 09:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbYIENYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 09:24:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60586 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838AbYIENYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 09:24:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Subject: Re: 2.6.27-rc5-mm1: rmmod ide-cd_mod: tried to init an initialized object, something is seriously wrong.
Date: Fri, 5 Sep 2008 15:28:53 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, bzolnier@gmail.com,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       linux-ide@vger.kernel.org
References: <20080904224004.d3dd3076.akpm@linux-foundation.org> <200809051439.32724.m.kozlowski@tuxland.pl>
In-Reply-To: <200809051439.32724.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809051528.54213.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 5 of September 2008, Mariusz Kozlowski wrote:
> Hello, 
> 
> 	Again 100% reproducible rmmod ide-cd_mod problem. Kernel is tainted because
> of earlier sysfs acpi problems similar (probably identical) to those reported
> by Li Zefan here http://marc.info/?l=linux-kernel&m=121921059026064&w=2
> 
> Steps to reproduce: unload ide-cd_mod
> 
> kobject (dd9e4a7c): tried to init an initialized object, something is seriously wrong.
> Pid: 4734, comm: modprobe Tainted: G        W 2.6.27-rc5-mm1 #1
>  [<c01ec982>] kobject_init+0xc4/0xc9
>  [<c02cb84a>] ? _spin_unlock+0x27/0x3f
>  [<c01aff2e>] ? sysfs_find_dirent+0x21/0x2b
>  [<c01aff7e>] ? __sysfs_add_one+0x46/0x6d
>  [<c01affb4>] ? sysfs_add_one+0xf/0x44
>  [<c01b0036>] ? sysfs_addrm_start+0x4d/0x90
>  [<c01b0f31>] ? sysfs_do_create_link+0x9a/0x14c
>  [<c01ec9c5>] kobject_init_and_add+0x14/0x30
>  [<c01b1009>] ? sysfs_create_link+0x12/0x19
>  [<c01e8bad>] blk_register_filter+0x3b/0x46
>  [<ded9e40a>] ide_cd_probe+0x253/0x5a8 [ide_cd_mod]
>  [<c01b0000>] ? sysfs_addrm_start+0x17/0x90
>  [<c01b0f31>] ? sysfs_do_create_link+0x9a/0x14c
>  [<c01b004e>] ? sysfs_addrm_start+0x65/0x90
>  [<c025145f>] generic_ide_probe+0x1f/0x21
>  [<c024c002>] driver_probe_device+0x77/0x15b
>  [<c02cb91b>] ? _spin_unlock_irqrestore+0x39/0x60
>  [<c024c146>] __driver_attach+0x60/0x62
>  [<c024b7bd>] bus_for_each_dev+0x44/0x62
>  [<c0251461>] ? generic_ide_remove+0x0/0x1e
>  [<c024bead>] driver_attach+0x19/0x1b
>  [<c024c0e6>] ? __driver_attach+0x0/0x62
>  [<c024bca8>] bus_add_driver+0x1ab/0x213
>  [<c0251461>] ? generic_ide_remove+0x0/0x1e
>  [<c024c291>] driver_register+0x4f/0x118
>  [<de7bf000>] ? ide_cdrom_init+0x0/0xf [ide_cd_mod]
>  [<de7bf00d>] ide_cdrom_init+0xd/0xf [ide_cd_mod]
>  [<c0101114>] do_one_initcall+0x24/0x12f
>  [<c02c9d8e>] ? mutex_unlock+0x8/0xa
>  [<c01455ca>] sys_init_module+0xa5/0x1c1
>  [<c0176a0a>] ? sys_read+0x3d/0x64
>  [<c01030f1>] sysenter_do_call+0x12/0x35
>  [<c012007b>] ? __set_special_pids+0x43/0x71
> 
> First time I modprobe/rmmod ide-cd_mod the system works but quickly gets unstable.
> Second modprobe/rmmod is 100% fatal. Memory gets corruped seriously I guess.
> pcspeaker beeps all the time, kernel throws dumps on the screen until
> its really dead, sadly blinking 'leds of panic' ;)

Can you please verify if that happens with the current mainline?

Thanks,
Rafael
