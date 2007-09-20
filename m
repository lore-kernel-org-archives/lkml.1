Return-Path: <linux-kernel-owner+w=401wt.eu-S1759433AbXITR0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759433AbXITR0s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 13:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756611AbXITR0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 13:26:40 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1196 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756820AbXITR0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 13:26:38 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Cornelia Huck <huckc@de.ibm.com>
Subject: Re: kobject: Temporarily save k_name on cleanup for debug message.
Date: Thu, 20 Sep 2007 19:26:25 +0200
User-Agent: KMail/1.9.7
Cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <20070919200205.057e3fbc@gondolin.boeblingen.de.ibm.com> <20070920094350.6417a547@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070920094350.6417a547@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709201926.25701.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> > > kobject drivers: cleaning up
> > > kobject '<NULL>' does not have a release() function, if this is not a directory kobject, it is broken and must be fixed.
> > 
> > <Unrelated side note: We should probably save the kobject's name for
> > printing this debug message, it looks a bit odd :)>
> 
> kobject: Temporarily save k_name on cleanup for debug message.
> 
> Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
> 
> ---
>  lib/kobject.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> --- linux-2.6.orig/lib/kobject.c
> +++ linux-2.6/lib/kobject.c
> @@ -498,9 +498,9 @@ void kobject_cleanup(struct kobject * ko
>  	struct kobj_type * t = get_ktype(kobj);
>  	struct kset * s = kobj->kset;
>  	struct kobject * parent = kobj->parent;
> +	const char *k_name = kobj->k_name;
>  
>  	pr_debug("kobject %s: cleaning up\n",kobject_name(kobj));
> -	kfree(kobj->k_name);
>  	kobj->k_name = NULL;
>  	if (t && t->release)
>  		t->release(kobj);
> @@ -508,8 +508,8 @@ void kobject_cleanup(struct kobject * ko
>  		pr_debug("kobject '%s' does not have a release() function, "
>  			"if this is not a directory kobject, it is broken "
>  			"and must be fixed.\n",
> -			kobject_name(kobj));
> -
> +			k_name);
> +	kfree(k_name);
>  	if (s)
>  		kset_put(s);
>  	kobject_put(parent);
> 

Just FYI this is what it looks like with your patch applied:

kobject mmc_core: registering. parent: <NULL>, set: module
kobject holders: registering. parent: mmc_core, set: <NULL>
kobject_uevent_env
kobject filter function caused the event to drop!
kobject_uevent_env
fill_kobj_path: path = '/module/mmc_core'
---- begin silly warning ----
This is a janitorial warning, not a kernel bug.
The kobject at, or inside 'mmc_bus_type'@(0xdee71c10) is not dynamically allocated.
kobjects must be dynamically allocated, not static
---- end silly warning ----
kobject mmc: registering. parent: <NULL>, set: bus
kobject_uevent_env
fill_kobj_path: path = '/bus/mmc'
---- begin silly warning ----
This is a janitorial warning, not a kernel bug.
The kobject at, or inside 'mmc_bus_type'@(0xdee71cf0) is not dynamically allocated.
kobjects must be dynamically allocated, not static
---- end silly warning ----
kobject devices: registering. parent: mmc, set: <NULL>
kobject_uevent_env
kobject filter function caused the event to drop!
---- begin silly warning ----
This is a janitorial warning, not a kernel bug.
The kobject at, or inside 'mmc_bus_type'@(0xdee71c80) is not dynamically allocated.
kobjects must be dynamically allocated, not static
---- end silly warning ----
kobject drivers: registering. parent: mmc, set: <NULL>
kobject_uevent_env
kobject filter function caused the event to drop!
---- begin silly warning ----
This is a janitorial warning, not a kernel bug.
The kobject at, or inside 'mmc_host_class'@(0xdee71f58) is not dynamically allocated.
kobjects must be dynamically allocated, not static
---- end silly warning ----
---- begin silly warning ----
This is a janitorial warning, not a kernel bug.
The kobject at, or inside 'mmc_host_class'@(0xdee71ed0) is not dynamically allocated.
kobjects must be dynamically allocated, not static
---- end silly warning ----
kobject mmc_host: registering. parent: <NULL>, set: class
kobject_uevent_env
fill_kobj_path: path = '/class/mmc_host'
---- begin silly warning ----
This is a janitorial warning, not a kernel bug.
The kobject at, or inside 'sdio_bus_type'@(0xdee721f0) is not dynamically allocated.
kobjects must be dynamically allocated, not static
---- end silly warning ----
kobject sdio: registering. parent: <NULL>, set: bus
kobject_uevent_env
fill_kobj_path: path = '/bus/sdio'
---- begin silly warning ----
This is a janitorial warning, not a kernel bug.
The kobject at, or inside 'sdio_bus_type'@(0xdee722d0) is not dynamically allocated.
kobjects must be dynamically allocated, not static
---- end silly warning ----
kobject devices: registering. parent: sdio, set: <NULL>
kobject_uevent_env
kobject filter function caused the event to drop!
---- begin silly warning ----
This is a janitorial warning, not a kernel bug.
The kobject at, or inside 'sdio_bus_type'@(0xdee72260) is not dynamically allocated.
kobjects must be dynamically allocated, not static
---- end silly warning ----
kobject drivers: registering. parent: sdio, set: <NULL>
kobject_uevent_env
kobject filter function caused the event to drop!
kobject drivers: unregistering
kobject_uevent_env
kobject filter function caused the event to drop!
kobject drivers: cleaning up
kobject 'drivers' does not have a release() function, if this is not a directory kobject, it is broken and must be fixed.
kobject devices: unregistering
kobject_uevent_env
kobject filter function caused the event to drop!
kobject devices: cleaning up
kobject 'devices' does not have a release() function, if this is not a directory kobject, it is broken and must be fixed.
kobject sdio: unregistering
kobject_uevent_env
fill_kobj_path: path = '/bus/sdio'
kobject sdio: cleaning up
kobject 'sdio' does not have a release() function, if this is not a directory kobject, it is broken and must be fixed.
WARNING: at lib/kref.c:33 kref_get()
 [<c0104a1c>] dump_trace+0x202/0x22b
 [<c0104a5f>] show_trace_log_lvl+0x1a/0x30
 [<c0105608>] show_trace+0x12/0x14
 [<c010572c>] dump_stack+0x15/0x17
 [<c024c6bf>] kref_get+0x40/0x42
 [<c024b850>] kobject_get+0x12/0x17
 [<c02d5960>] bus_get+0x11/0x22
 [<c02d5be9>] bus_remove_file+0xe/0x27
 [<c02d5c12>] remove_probe_files+0x10/0x1f
 [<c02d5c5c>] bus_unregister+0x3b/0x66
 [<dee6a83d>] sdio_unregister_bus+0xd/0xf [mmc_core]
 [<dee6bcdd>] mmc_exit+0xd/0x23 [mmc_core]
 [<c013c9d6>] sys_delete_module+0x154/0x202
 [<c010406a>] sysenter_past_esp+0x5f/0x99
 [<ffffe410>] 0xffffe410
 =======================
kobject <NULL>: cleaning up
kobject '<NULL>' does not have a release() function, if this is not a directory kobject, it is broken and must be fixed.
WARNING: at lib/kref.c:33 kref_get()
 [<c0104a1c>] dump_trace+0x202/0x22b
 [<c0104a5f>] show_trace_log_lvl+0x1a/0x30
 [<c0105608>] show_trace+0x12/0x14
 [<c010572c>] dump_stack+0x15/0x17
 [<c024c6bf>] kref_get+0x40/0x42
 [<c024b850>] kobject_get+0x12/0x17
 [<c02d5960>] bus_get+0x11/0x22
 [<c02d5be9>] bus_remove_file+0xe/0x27
 [<c02d5c1e>] remove_probe_files+0x1c/0x1f
 [<c02d5c5c>] bus_unregister+0x3b/0x66
 [<dee6a83d>] sdio_unregister_bus+0xd/0xf [mmc_core]
 [<dee6bcdd>] mmc_exit+0xd/0x23 [mmc_core]
 [<c013c9d6>] sys_delete_module+0x154/0x202
 [<c010406a>] sysenter_past_esp+0x5f/0x99
 [<ffffe410>] 0xffffe410
 =======================
kobject <NULL>: cleaning up
kobject '<NULL>' does not have a release() function, if this is not a directory kobject, it is broken and must be fixed.
kobject <NULL>: unregistering
kobject_uevent_env
kobject filter function caused the event to drop!
BUG: atomic counter underflow at:
 [<c0104a1c>] dump_trace+0x202/0x22b
 [<c0104a5f>] show_trace_log_lvl+0x1a/0x30
 [<c0105608>] show_trace+0x12/0x14
 [<c010572c>] dump_stack+0x15/0x17
 [<c024c70d>] kref_put+0x4c/0xaf
 [<c024b74e>] kobject_put+0x14/0x16
 [<c024b83b>] unlink+0x3b/0x3e
 [<c024b8b8>] kobject_del+0x16/0x19
 [<c024b8ed>] kobject_unregister+0x32/0x3f
 [<c024b909>] kset_unregister+0xf/0x11
 [<c02d5c64>] bus_unregister+0x43/0x66
 [<dee6a83d>] sdio_unregister_bus+0xd/0xf [mmc_core]
 [<dee6bcdd>] mmc_exit+0xd/0x23 [mmc_core]
 [<c013c9d6>] sys_delete_module+0x154/0x202
 [<c010406a>] sysenter_past_esp+0x5f/0x99
 [<ffffe410>] 0xffffe410
 =======================
kobject <NULL>: unregistering
kobject_uevent_env
kobject filter function caused the event to drop!
BUG: atomic counter underflow at:
 [<c0104a1c>] dump_trace+0x202/0x22b
 [<c0104a5f>] show_trace_log_lvl+0x1a/0x30
 [<c0105608>] show_trace+0x12/0x14
 [<c010572c>] dump_stack+0x15/0x17
 [<c024c70d>] kref_put+0x4c/0xaf
 [<c024b74e>] kobject_put+0x14/0x16
 [<c024b83b>] unlink+0x3b/0x3e
 [<c024b8b8>] kobject_del+0x16/0x19
 [<c024b8ed>] kobject_unregister+0x32/0x3f
 [<c024b909>] kset_unregister+0xf/0x11
 [<c02d5c6f>] bus_unregister+0x4e/0x66
 [<dee6a83d>] sdio_unregister_bus+0xd/0xf [mmc_core]
 [<dee6bcdd>] mmc_exit+0xd/0x23 [mmc_core]
 [<c013c9d6>] sys_delete_module+0x154/0x202
 [<c010406a>] sysenter_past_esp+0x5f/0x99
 [<ffffe410>] 0xffffe410
 =======================
WARNING: at lib/kref.c:33 kref_get()
 [<c0104a1c>] dump_trace+0x202/0x22b
 [<c0104a5f>] show_trace_log_lvl+0x1a/0x30
 [<c0105608>] show_trace+0x12/0x14
 [<c010572c>] dump_stack+0x15/0x17
 [<c024c6bf>] kref_get+0x40/0x42
 [<c024b850>] kobject_get+0x12/0x17
 [<c02d5960>] bus_get+0x11/0x22
 [<c02d5be9>] bus_remove_file+0xe/0x27
 [<c02d5c7b>] bus_unregister+0x5a/0x66
 [<dee6a83d>] sdio_unregister_bus+0xd/0xf [mmc_core]
 [<dee6bcdd>] mmc_exit+0xd/0x23 [mmc_core]
 [<c013c9d6>] sys_delete_module+0x154/0x202
 [<c010406a>] sysenter_past_esp+0x5f/0x99
 [<ffffe410>] 0xffffe410
 =======================
kobject <NULL>: cleaning up
kobject '<NULL>' does not have a release() function, if this is not a directory kobject, it is broken and must be fixed.
kobject <NULL>: unregistering
kobject_uevent_env
BUG: atomic counter underflow at:
 [<c0104a1c>] dump_trace+0x202/0x22b
 [<c0104a5f>] show_trace_log_lvl+0x1a/0x30
 [<c0105608>] show_trace+0x12/0x14
 [<c010572c>] dump_stack+0x15/0x17
 [<c024c70d>] kref_put+0x4c/0xaf
 [<c024b74e>] kobject_put+0x14/0x16
 [<c024b83b>] unlink+0x3b/0x3e
 [<c024b8b8>] kobject_del+0x16/0x19
 [<c024b8ed>] kobject_unregister+0x32/0x3f
 [<c024b909>] kset_unregister+0xf/0x11
 [<c024b913>] subsystem_unregister+0x8/0xa
 [<c02d5c83>] bus_unregister+0x62/0x66
 [<dee6a83d>] sdio_unregister_bus+0xd/0xf [mmc_core]
 [<dee6bcdd>] mmc_exit+0xd/0x23 [mmc_core]
 [<c013c9d6>] sys_delete_module+0x154/0x202
 [<c010406a>] sysenter_past_esp+0x5f/0x99
 [<ffffe410>] 0xffffe410
 =======================
kobject mmc_host: unregistering
kobject_uevent_env
fill_kobj_path: path = '/class/mmc_host'
kobject mmc_host: cleaning up
kobject drivers: unregistering
kobject_uevent_env
kobject filter function caused the event to drop!
kobject drivers: cleaning up
kobject 'drivers' does not have a release() function, if this is not a directory kobject, it is broken and must be fixed.
kobject devices: unregistering
kobject_uevent_env
kobject filter function caused the event to drop!
kobject devices: cleaning up
kobject 'devices' does not have a release() function, if this is not a directory kobject, it is broken and must be fixed.
kobject mmc: unregistering
kobject_uevent_env
fill_kobj_path: path = '/bus/mmc'
kobject mmc: cleaning up
kobject 'mmc' does not have a release() function, if this is not a directory kobject, it is broken and must be fixed.
kobject holders: unregistering
kobject_uevent_env
kobject filter function caused the event to drop!
kobject holders: cleaning up
kobject mmc_core: unregistering
kobject_uevent_env
fill_kobj_path: path = '/module/mmc_core'
kobject mmc_core: cleaning up
kobject 'mmc_core' does not have a release() function, if this is not a directory kobject, it is broken and must be fixed.

Thanks,

	Mariusz
