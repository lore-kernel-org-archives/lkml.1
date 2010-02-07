Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab0BGJaJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 04:30:09 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:55117 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab0BGJaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 04:30:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=MwWu9NIDuSOFhh986UxVc7rVvCXc+Y055HfHOnK1H+W34S200mOJM7KeeLpVtl82Z5
         qWyUODWe3F9QgBd3fU3WQLo9iu1ETnaCGGtZoVtQ8lf0Uc4Hka6apLJ3lY1B1N+grINR
         aK6B34pmrNk12YaVAE54Q291uh+enpne2wt9A=
Date: Sun, 7 Feb 2010 17:29:59 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: David Airlie <airlied@linux.ie>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: mmotm 2010-02-05-15-06 : i915 ioremap failed
Message-ID: <20100207092959.GA2596@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

i915 try to ioremap normal ram, please see following warning:

[    1.850361] ------------[ cut here ]------------
[    1.850409] WARNING: at arch/x86/mm/ioremap.c:111 __ioremap_caller+0xcc/0x241()
[    1.850774] Hardware name: Latitude E5400                  
[    1.851172] Modules linked in:
[    1.851593] Pid: 1, comm: swapper Not tainted 2.6.33-rc6-mm1 #1
[    1.852061] Call Trace:
[    1.852527]  [<c102ea1e>] warn_slowpath_common+0x60/0x90
[    1.853059]  [<c102ea5b>] warn_slowpath_null+0xd/0x10
[    1.853618]  [<c101c4ae>] __ioremap_caller+0xcc/0x241
[    1.854194]  [<c11b67e5>] ? pci_bus_read_config_dword+0x57/0x63
[    1.854835]  [<c101c693>] ioremap_nocache+0x10/0x12
[    1.855502]  [<c125aa41>] ? intel_opregion_init+0x8a/0x2ed
[    1.856182]  [<c125aa41>] intel_opregion_init+0x8a/0x2ed
[    1.856912]  [<c123ad02>] i915_driver_load+0x916/0x984
[    1.857640]  [<c123126d>] drm_get_dev+0x32d/0x3fc
[    1.858411]  [<c13c444d>] i915_pci_probe+0xd/0xf
[    1.859202]  [<c11bac08>] local_pci_probe+0xe/0x10
[    1.860037]  [<c11bb760>] pci_device_probe+0x43/0x66
[    1.860877]  [<c126618c>] driver_probe_device+0xcb/0x1eb
[    1.861751]  [<c12662f3>] __driver_attach+0x47/0x63
[    1.862657]  [<c1265a43>] bus_for_each_dev+0x3d/0x67
[    1.863599]  [<c1265f8f>] driver_attach+0x14/0x16
[    1.864546]  [<c12662ac>] ? __driver_attach+0x0/0x63
[    1.865542]  [<c126541c>] bus_add_driver+0xc4/0x20c
[    1.866545]  [<c1266553>] driver_register+0x8b/0xeb
[    1.867601]  [<c11acac7>] ? __raw_spin_lock_init+0x24/0x49
[    1.868638]  [<c11bb94d>] __pci_register_driver+0x4c/0xa5
[    1.869657]  [<c122d199>] drm_init+0x58/0xb0
[    1.870669]  [<c1660da4>] ? i915_init+0x0/0x4d
[    1.871671]  [<c1660def>] i915_init+0x4b/0x4d
[    1.872654]  [<c1001139>] do_one_initcall+0x4c/0x13f
[    1.873645]  [<c163d315>] kernel_init+0x123/0x174
[    1.874585]  [<c163d1f2>] ? kernel_init+0x0/0x174
[    1.875525]  [<c10035ba>] kernel_thread_helper+0x6/0x10
[    1.876464] ---[ end trace 890121b055b2c551 ]---
[    1.877381] ioremap reserve_memtype failed -22
[    1.878299] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
