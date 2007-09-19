Return-Path: <linux-kernel-owner+w=401wt.eu-S1762250AbXISQod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762250AbXISQod (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 12:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761465AbXISQoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 12:44:13 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:3033 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760966AbXISQoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 12:44:09 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: 2.6.23-rc6-mm1: atomic counter underflow
Date: Wed, 19 Sep 2007 18:43:54 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <200709182345.13435.m.kozlowski@tuxland.pl> <20070919102716.09004317@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070919102716.09004317@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200709191843.54902.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> > 	I wrote a simple script that finds all modules in /lib/modules/`uname -r`
> > and performs sth like 'modprobe $x; rmmod $x;' for every of them. The result is the
> > output below. This actually happens when rmmod'ing a module.
> > 
> > I narrowed it down to modules mmc_core and firewire_core. To reproduce that just
> > rmmod them.
> 
> Hm, does that mean you can reproduce this when you modprobe/rmmod
> either of them on a fresh boot? (There could be follow-on errors...)

On fresh boot it happens with mmc_core. On the next fresh boot it didn't happen with
firewire_core. So you can be right that some of them are follow-on errors. Anyway to
trigger it just run these commands:

# logger -t "foobar" "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
# modprobe mmc_core
# rmmod mmc_core
# logger -t "foobar" "yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy"

> Could you try with DEBUG_KOBJECT set?

Please find it attached below.

Regards,

	Mariusz



xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
kobject mmc_core: registering. parent: <NULL>, set: module
kobject holders: registering. parent: mmc_core, set: <NULL>
kobject_uevent_env
kobject filter function caused the event to drop!
kobject_uevent_env
fill_kobj_path: path = '/module/mmc_core'
---- begin silly warning ----
This is a janitorial warning, not a kernel bug.
The kobject at, or inside 'mmc_bus_type'@(0xded0c1b0) is not dynamically allocated.
kobjects must be dynamically allocated, not static
---- end silly warning ----
kobject mmc: registering. parent: <NULL>, set: bus
kobject_uevent_env
fill_kobj_path: path = '/bus/mmc'
---- begin silly warning ----
This is a janitorial warning, not a kernel bug.
The kobject at, or inside 'mmc_bus_type'@(0xded0c290) is not dynamically allocated.
kobjects must be dynamically allocated, not static
---- end silly warning ----
kobject devices: registering. parent: mmc, set: <NULL>
kobject_uevent_env
kobject filter function caused the event to drop!
---- begin silly warning ----
This is a janitorial warning, not a kernel bug.
The kobject at, or inside 'mmc_bus_type'@(0xded0c220) is not dynamically allocated.
kobjects must be dynamically allocated, not static
---- end silly warning ----
kobject drivers: registering. parent: mmc, set: <NULL>
kobject_uevent_env
kobject filter function caused the event to drop!
---- begin silly warning ----
This is a janitorial warning, not a kernel bug.
The kobject at, or inside 'mmc_host_class'@(0xded0c4f8) is not dynamically allocated.
kobjects must be dynamically allocated, not static
---- end silly warning ----
---- begin silly warning ----
This is a janitorial warning, not a kernel bug.
The kobject at, or inside 'mmc_host_class'@(0xded0c470) is not dynamically allocated.
kobjects must be dynamically allocated, not static
---- end silly warning ----
kobject mmc_host: registering. parent: <NULL>, set: class
kobject_uevent_env
fill_kobj_path: path = '/class/mmc_host'
---- begin silly warning ----
This is a janitorial warning, not a kernel bug.
The kobject at, or inside 'sdio_bus_type'@(0xded0c790) is not dynamically allocated.
kobjects must be dynamically allocated, not static
---- end silly warning ----
kobject sdio: registering. parent: <NULL>, set: bus
kobject_uevent_env
fill_kobj_path: path = '/bus/sdio'
---- begin silly warning ----
This is a janitorial warning, not a kernel bug.
The kobject at, or inside 'sdio_bus_type'@(0xded0c870) is not dynamically allocated.
kobjects must be dynamically allocated, not static
---- end silly warning ----
kobject devices: registering. parent: sdio, set: <NULL>
kobject_uevent_env
kobject filter function caused the event to drop!
---- begin silly warning ----
This is a janitorial warning, not a kernel bug.
The kobject at, or inside 'sdio_bus_type'@(0xded0c800) is not dynamically allocated.
kobjects must be dynamically allocated, not static
---- end silly warning ----
kobject drivers: registering. parent: sdio, set: <NULL>
kobject_uevent_env
kobject filter function caused the event to drop!
kobject drivers: unregistering
kobject_uevent_env
kobject filter function caused the event to drop!
kobject drivers: cleaning up
kobject '<NULL>' does not have a release() function, if this is not a directory kobject, it is broken and must be fixed.
kobject devices: unregistering
kobject_uevent_env
kobject filter function caused the event to drop!
kobject devices: cleaning up
kobject '<NULL>' does not have a release() function, if this is not a directory kobject, it is broken and must be fixed.
kobject sdio: unregistering
kobject_uevent_env
fill_kobj_path: path = '/bus/sdio'
kobject sdio: cleaning up
kobject '<NULL>' does not have a release() function, if this is not a directory kobject, it is broken and must be fixed.
WARNING: at lib/kref.c:33 kref_get()
 [<c0104a1c>] dump_trace+0x202/0x22b
 [<c0104a5f>] show_trace_log_lvl+0x1a/0x30
 [<c0105608>] show_trace+0x12/0x14
 [<c010572c>] dump_stack+0x15/0x17
 [<c024c6cf>] kref_get+0x40/0x42
 [<c024b852>] kobject_get+0x12/0x17
 [<c02d5970>] bus_get+0x11/0x22
 [<c02d5bf9>] bus_remove_file+0xe/0x27
 [<c02d5c22>] remove_probe_files+0x10/0x1f
 [<c02d5c6c>] bus_unregister+0x3b/0x66
 [<ded052bd>] sdio_unregister_bus+0xd/0xf [mmc_core]
 [<ded0666d>] mmc_exit+0xd/0x23 [mmc_core]
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
 [<c024c6cf>] kref_get+0x40/0x42
 [<c024b852>] kobject_get+0x12/0x17
 [<c02d5970>] bus_get+0x11/0x22
 [<c02d5bf9>] bus_remove_file+0xe/0x27
 [<c02d5c2e>] remove_probe_files+0x1c/0x1f
 [<c02d5c6c>] bus_unregister+0x3b/0x66
 [<ded052bd>] sdio_unregister_bus+0xd/0xf [mmc_core]
 [<ded0666d>] mmc_exit+0xd/0x23 [mmc_core]
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
 [<c024c71d>] kref_put+0x4c/0xaf
 [<c024b74e>] kobject_put+0x14/0x16
 [<c024b83d>] unlink+0x3b/0x3e
 [<c024b8ba>] kobject_del+0x16/0x19
 [<c024b8ef>] kobject_unregister+0x32/0x3f
 [<c024b90b>] kset_unregister+0xf/0x11
 [<c02d5c74>] bus_unregister+0x43/0x66
 [<ded052bd>] sdio_unregister_bus+0xd/0xf [mmc_core]
 [<ded0666d>] mmc_exit+0xd/0x23 [mmc_core]
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
 [<c024c71d>] kref_put+0x4c/0xaf
 [<c024b74e>] kobject_put+0x14/0x16
 [<c024b83d>] unlink+0x3b/0x3e
 [<c024b8ba>] kobject_del+0x16/0x19
 [<c024b8ef>] kobject_unregister+0x32/0x3f
 [<c024b90b>] kset_unregister+0xf/0x11
 [<c02d5c7f>] bus_unregister+0x4e/0x66
 [<ded052bd>] sdio_unregister_bus+0xd/0xf [mmc_core]
 [<ded0666d>] mmc_exit+0xd/0x23 [mmc_core]
 [<c013c9d6>] sys_delete_module+0x154/0x202
 [<c010406a>] sysenter_past_esp+0x5f/0x99
 [<ffffe410>] 0xffffe410
 =======================
WARNING: at lib/kref.c:33 kref_get()
 [<c0104a1c>] dump_trace+0x202/0x22b
 [<c0104a5f>] show_trace_log_lvl+0x1a/0x30
 [<c0105608>] show_trace+0x12/0x14
 [<c010572c>] dump_stack+0x15/0x17
 [<c024c6cf>] kref_get+0x40/0x42
 [<c024b852>] kobject_get+0x12/0x17
 [<c02d5970>] bus_get+0x11/0x22
 [<c02d5bf9>] bus_remove_file+0xe/0x27
 [<c02d5c8b>] bus_unregister+0x5a/0x66
 [<ded052bd>] sdio_unregister_bus+0xd/0xf [mmc_core]
 [<ded0666d>] mmc_exit+0xd/0x23 [mmc_core]
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
 [<c024c71d>] kref_put+0x4c/0xaf
 [<c024b74e>] kobject_put+0x14/0x16
 [<c024b83d>] unlink+0x3b/0x3e
 [<c024b8ba>] kobject_del+0x16/0x19
 [<c024b8ef>] kobject_unregister+0x32/0x3f
 [<c024b90b>] kset_unregister+0xf/0x11
 [<c024b915>] subsystem_unregister+0x8/0xa
 [<c02d5c93>] bus_unregister+0x62/0x66
 [<ded052bd>] sdio_unregister_bus+0xd/0xf [mmc_core]
 [<ded0666d>] mmc_exit+0xd/0x23 [mmc_core]
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
kobject '<NULL>' does not have a release() function, if this is not a directory kobject, it is broken and must be fixed.
kobject devices: unregistering
kobject_uevent_env
kobject filter function caused the event to drop!
kobject devices: cleaning up
kobject '<NULL>' does not have a release() function, if this is not a directory kobject, it is broken and must be fixed.
kobject mmc: unregistering
kobject_uevent_env
fill_kobj_path: path = '/bus/mmc'
kobject mmc: cleaning up
kobject '<NULL>' does not have a release() function, if this is not a directory kobject, it is broken and must be fixed.
kobject holders: unregistering
kobject_uevent_env
kobject filter function caused the event to drop!
kobject holders: cleaning up
kobject mmc_core: unregistering
kobject_uevent_env
fill_kobj_path: path = '/module/mmc_core'
kobject mmc_core: cleaning up
kobject '<NULL>' does not have a release() function, if this is not a directory kobject, it is broken and must be fixed.
yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
