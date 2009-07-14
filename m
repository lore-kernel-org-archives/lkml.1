Return-Path: <linux-kernel-owner+w=401wt.eu-S1754802AbZGNOS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbZGNOS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 10:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754506AbZGNOS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 10:18:27 -0400
Received: from mail.gmx.net ([213.165.64.20]:40594 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754008AbZGNOSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 10:18:25 -0400
X-Authenticated: #23875046
X-Provags-ID: V01U2FsdGVkX19gp01smhZg07/gR2TxemKbM6QB51eZEj1PeNFe40
	V0WQkxXYeOdyGx
Message-ID: <4A5C93AD.5050403@fisher-privat.net>
Date: Tue, 14 Jul 2009 16:18:21 +0200
From: Alexey Fisher <bug-track@fisher-privat.net>
User-Agent: Thunderbird 2.0.0.22 (X11/20090710)
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>,
       "kernel-testers-owner@vger.kernel.org" 
	<kernel-testers-owner@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>
Subject: possible memory leak on i915_gem_create_ioctl
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.65
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmemleak report a lot of possible memory leaks if using any glxrelated 
applications like glxgears, glxinfo, compiz, cairo-dock with g45 graphic.

Here is a trace from /sys/kernel/debug/kmemleak:

unreferenced object 0xffff8800b298e000 (size 544):
   comm "openarena", pid 5002, jiffies 4296480664
   backtrace:
     [<ffffffff814ac755>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f4b8b>] kmem_cache_alloc+0xfb/0x180
     [<ffffffff8122404f>] idr_pre_get+0x5f/0x90
     [<ffffffff812c6fed>] drm_gem_handle_create+0x2d/0xa0
     [<ffffffff812e0d60>] i915_gem_create_ioctl+0x60/0xc0
     [<ffffffff812c5c74>] drm_ioctl+0x184/0x3b0
     [<ffffffff8110c6dc>] vfs_ioctl+0x7c/0xa0
     [<ffffffff8110cbaa>] do_vfs_ioctl+0x8a/0x5a0
     [<ffffffff8110d141>] sys_ioctl+0x81/0xa0
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800b5537a78 (size 544):
   comm "cairo-dock", pid 5012, jiffies 4296487097
   backtrace:
     [<ffffffff814ac755>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f4b8b>] kmem_cache_alloc+0xfb/0x180
     [<ffffffff8122404f>] idr_pre_get+0x5f/0x90
     [<ffffffff812c6fed>] drm_gem_handle_create+0x2d/0xa0
     [<ffffffff812e0d60>] i915_gem_create_ioctl+0x60/0xc0
     [<ffffffff812c5c74>] drm_ioctl+0x184/0x3b0
     [<ffffffff8110c6dc>] vfs_ioctl+0x7c/0xa0
     [<ffffffff8110cbaa>] do_vfs_ioctl+0x8a/0x5a0
     [<ffffffff8110d141>] sys_ioctl+0x81/0xa0
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800b5537ce0 (size 544):
   comm "cairo-dock", pid 5012, jiffies 4296487097
   backtrace:
     [<ffffffff814ac755>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f4b8b>] kmem_cache_alloc+0xfb/0x180
     [<ffffffff8122404f>] idr_pre_get+0x5f/0x90
     [<ffffffff812c6fed>] drm_gem_handle_create+0x2d/0xa0
     [<ffffffff812e0d60>] i915_gem_create_ioctl+0x60/0xc0
     [<ffffffff812c5c74>] drm_ioctl+0x184/0x3b0
     [<ffffffff8110c6dc>] vfs_ioctl+0x7c/0xa0
     [<ffffffff8110cbaa>] do_vfs_ioctl+0x8a/0x5a0
     [<ffffffff8110d141>] sys_ioctl+0x81/0xa0
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8801090b04d0 (size 544):
   comm "cairo-dock", pid 5012, jiffies 4296487097
   backtrace:
     [<ffffffff814ac755>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f4b8b>] kmem_cache_alloc+0xfb/0x180
     [<ffffffff8122404f>] idr_pre_get+0x5f/0x90
     [<ffffffff812c6fed>] drm_gem_handle_create+0x2d/0xa0
     [<ffffffff812c75f2>] drm_gem_open_ioctl+0xa2/0x100
     [<ffffffff812c5c74>] drm_ioctl+0x184/0x3b0
     [<ffffffff8110c6dc>] vfs_ioctl+0x7c/0xa0
     [<ffffffff8110cbaa>] do_vfs_ioctl+0x8a/0x5a0
     [<ffffffff8110d141>] sys_ioctl+0x81/0xa0
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88010cc37ce0 (size 544):
   comm "cairo-dock", pid 5012, jiffies 4296487197
   backtrace:
     [<ffffffff814ac755>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f4b8b>] kmem_cache_alloc+0xfb/0x180
     [<ffffffff8122404f>] idr_pre_get+0x5f/0x90
     [<ffffffff812c6fed>] drm_gem_handle_create+0x2d/0xa0
     [<ffffffff812e0d60>] i915_gem_create_ioctl+0x60/0xc0
     [<ffffffff812c5c74>] drm_ioctl+0x184/0x3b0
     [<ffffffff8110c6dc>] vfs_ioctl+0x7c/0xa0
     [<ffffffff8110cbaa>] do_vfs_ioctl+0x8a/0x5a0
     [<ffffffff8110d141>] sys_ioctl+0x81/0xa0
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800a64224d0 (size 544):
   comm "cairo-dock", pid 5012, jiffies 4296487685
   backtrace:
     [<ffffffff814ac755>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f4b8b>] kmem_cache_alloc+0xfb/0x180
     [<ffffffff8122404f>] idr_pre_get+0x5f/0x90
     [<ffffffff812c6fed>] drm_gem_handle_create+0x2d/0xa0
     [<ffffffff812e0d60>] i915_gem_create_ioctl+0x60/0xc0
     [<ffffffff812c5c74>] drm_ioctl+0x184/0x3b0
     [<ffffffff8110c6dc>] vfs_ioctl+0x7c/0xa0
     [<ffffffff8110cbaa>] do_vfs_ioctl+0x8a/0x5a0
     [<ffffffff8110d141>] sys_ioctl+0x81/0xa0
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88010a9d0268 (size 544):
   comm "glxgears", pid 7062, jiffies 4297149744
   backtrace:
     [<ffffffff814ac755>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f4b8b>] kmem_cache_alloc+0xfb/0x180
     [<ffffffff8122404f>] idr_pre_get+0x5f/0x90
     [<ffffffff812c6fed>] drm_gem_handle_create+0x2d/0xa0
     [<ffffffff812e0d60>] i915_gem_create_ioctl+0x60/0xc0
     [<ffffffff812c5c74>] drm_ioctl+0x184/0x3b0
     [<ffffffff8110c6dc>] vfs_ioctl+0x7c/0xa0
     [<ffffffff8110cbaa>] do_vfs_ioctl+0x8a/0x5a0
     [<ffffffff8110d141>] sys_ioctl+0x81/0xa0
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88010a9d0000 (size 544):
   comm "glxgears", pid 7062, jiffies 4297149744
   backtrace:
     [<ffffffff814ac755>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f4b8b>] kmem_cache_alloc+0xfb/0x180
     [<ffffffff8122404f>] idr_pre_get+0x5f/0x90
     [<ffffffff812c6fed>] drm_gem_handle_create+0x2d/0xa0
     [<ffffffff812e0d60>] i915_gem_create_ioctl+0x60/0xc0
     [<ffffffff812c5c74>] drm_ioctl+0x184/0x3b0
     [<ffffffff8110c6dc>] vfs_ioctl+0x7c/0xa0
     [<ffffffff8110cbaa>] do_vfs_ioctl+0x8a/0x5a0
     [<ffffffff8110d141>] sys_ioctl+0x81/0xa0
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800a6423ce0 (size 544):
   comm "glxgears", pid 7062, jiffies 4297149756
   backtrace:
     [<ffffffff814ac755>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f4b8b>] kmem_cache_alloc+0xfb/0x180
     [<ffffffff8122404f>] idr_pre_get+0x5f/0x90
     [<ffffffff812c6fed>] drm_gem_handle_create+0x2d/0xa0
     [<ffffffff812c75f2>] drm_gem_open_ioctl+0xa2/0x100
     [<ffffffff812c5c74>] drm_ioctl+0x184/0x3b0
     [<ffffffff8110c6dc>] vfs_ioctl+0x7c/0xa0
     [<ffffffff8110cbaa>] do_vfs_ioctl+0x8a/0x5a0
     [<ffffffff8110d141>] sys_ioctl+0x81/0xa0
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8801090b0268 (size 544):
   comm "cairo-dock", pid 7118, jiffies 4297167990
   backtrace:
     [<ffffffff814ac755>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f4b8b>] kmem_cache_alloc+0xfb/0x180
     [<ffffffff8122404f>] idr_pre_get+0x5f/0x90
     [<ffffffff812c6fed>] drm_gem_handle_create+0x2d/0xa0
     [<ffffffff812e0d60>] i915_gem_create_ioctl+0x60/0xc0
     [<ffffffff812c5c74>] drm_ioctl+0x184/0x3b0
     [<ffffffff8110c6dc>] vfs_ioctl+0x7c/0xa0
     [<ffffffff8110cbaa>] do_vfs_ioctl+0x8a/0x5a0
     [<ffffffff8110d141>] sys_ioctl+0x81/0xa0
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8801090b1810 (size 544):
   comm "cairo-dock", pid 7118, jiffies 4297167990
   backtrace:
     [<ffffffff814ac755>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f4b8b>] kmem_cache_alloc+0xfb/0x180
     [<ffffffff8122404f>] idr_pre_get+0x5f/0x90
     [<ffffffff812c6fed>] drm_gem_handle_create+0x2d/0xa0
     [<ffffffff812e0d60>] i915_gem_create_ioctl+0x60/0xc0
     [<ffffffff812c5c74>] drm_ioctl+0x184/0x3b0
     [<ffffffff8110c6dc>] vfs_ioctl+0x7c/0xa0
     [<ffffffff8110cbaa>] do_vfs_ioctl+0x8a/0x5a0
     [<ffffffff8110d141>] sys_ioctl+0x81/0xa0
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88009bc544d0 (size 544):
   comm "cairo-dock", pid 7118, jiffies 4297168089
   backtrace:
     [<ffffffff814ac755>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f4b8b>] kmem_cache_alloc+0xfb/0x180
     [<ffffffff8122404f>] idr_pre_get+0x5f/0x90
     [<ffffffff812c6fed>] drm_gem_handle_create+0x2d/0xa0
     [<ffffffff812e0d60>] i915_gem_create_ioctl+0x60/0xc0
     [<ffffffff812c5c74>] drm_ioctl+0x184/0x3b0
     [<ffffffff8110c6dc>] vfs_ioctl+0x7c/0xa0
     [<ffffffff8110cbaa>] do_vfs_ioctl+0x8a/0x5a0
     [<ffffffff8110d141>] sys_ioctl+0x81/0xa0
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88009bc54c08 (size 544):
   comm "cairo-dock", pid 7118, jiffies 4297168139
   backtrace:
     [<ffffffff814ac755>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f4b8b>] kmem_cache_alloc+0xfb/0x180
     [<ffffffff8122404f>] idr_pre_get+0x5f/0x90
     [<ffffffff812c6fed>] drm_gem_handle_create+0x2d/0xa0
     [<ffffffff812e0d60>] i915_gem_create_ioctl+0x60/0xc0
     [<ffffffff812c5c74>] drm_ioctl+0x184/0x3b0
     [<ffffffff8110c6dc>] vfs_ioctl+0x7c/0xa0
     [<ffffffff8110cbaa>] do_vfs_ioctl+0x8a/0x5a0
     [<ffffffff8110d141>] sys_ioctl+0x81/0xa0
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88009bc550d8 (size 544):
   comm "cairo-dock", pid 7118, jiffies 4297168465
   backtrace:
     [<ffffffff814ac755>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f4b8b>] kmem_cache_alloc+0xfb/0x180
     [<ffffffff8122404f>] idr_pre_get+0x5f/0x90
     [<ffffffff812c6fed>] drm_gem_handle_create+0x2d/0xa0
     [<ffffffff812e0d60>] i915_gem_create_ioctl+0x60/0xc0
     [<ffffffff812c5c74>] drm_ioctl+0x184/0x3b0
     [<ffffffff8110c6dc>] vfs_ioctl+0x7c/0xa0
     [<ffffffff8110cbaa>] do_vfs_ioctl+0x8a/0x5a0
     [<ffffffff8110d141>] sys_ioctl+0x81/0xa0
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800b5536000 (size 544):
   comm "glxgears", pid 7315, jiffies 4297211016
   backtrace:
     [<ffffffff814ac755>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f4b8b>] kmem_cache_alloc+0xfb/0x180
     [<ffffffff8122404f>] idr_pre_get+0x5f/0x90
     [<ffffffff812c6fed>] drm_gem_handle_create+0x2d/0xa0
     [<ffffffff812e0d60>] i915_gem_create_ioctl+0x60/0xc0
     [<ffffffff812c5c74>] drm_ioctl+0x184/0x3b0
     [<ffffffff8110c6dc>] vfs_ioctl+0x7c/0xa0
     [<ffffffff8110cbaa>] do_vfs_ioctl+0x8a/0x5a0
     [<ffffffff8110d141>] sys_ioctl+0x81/0xa0
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800b5536738 (size 544):
   comm "glxgears", pid 7315, jiffies 4297211016
   backtrace:
     [<ffffffff814ac755>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f4b8b>] kmem_cache_alloc+0xfb/0x180
     [<ffffffff8122404f>] idr_pre_get+0x5f/0x90
     [<ffffffff812c6fed>] drm_gem_handle_create+0x2d/0xa0
     [<ffffffff812e0d60>] i915_gem_create_ioctl+0x60/0xc0
     [<ffffffff812c5c74>] drm_ioctl+0x184/0x3b0
     [<ffffffff8110c6dc>] vfs_ioctl+0x7c/0xa0
     [<ffffffff8110cbaa>] do_vfs_ioctl+0x8a/0x5a0
     [<ffffffff8110d141>] sys_ioctl+0x81/0xa0
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800b5536c08 (size 544):
   comm "glxgears", pid 7315, jiffies 4297211018
   backtrace:
     [<ffffffff814ac755>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f4b8b>] kmem_cache_alloc+0xfb/0x180
     [<ffffffff8122404f>] idr_pre_get+0x5f/0x90
     [<ffffffff812c6fed>] drm_gem_handle_create+0x2d/0xa0
     [<ffffffff812c75f2>] drm_gem_open_ioctl+0xa2/0x100
     [<ffffffff812c5c74>] drm_ioctl+0x184/0x3b0
     [<ffffffff8110c6dc>] vfs_ioctl+0x7c/0xa0
     [<ffffffff8110cbaa>] do_vfs_ioctl+0x8a/0x5a0
     [<ffffffff8110d141>] sys_ioctl+0x81/0xa0
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880090486e70 (size 544):
   comm "glxinfo", pid 7446, jiffies 4297234600
   backtrace:
     [<ffffffff814ac755>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f4b8b>] kmem_cache_alloc+0xfb/0x180
     [<ffffffff8122404f>] idr_pre_get+0x5f/0x90
     [<ffffffff812c6fed>] drm_gem_handle_create+0x2d/0xa0
     [<ffffffff812e0d60>] i915_gem_create_ioctl+0x60/0xc0
     [<ffffffff812c5c74>] drm_ioctl+0x184/0x3b0
     [<ffffffff8110c6dc>] vfs_ioctl+0x7c/0xa0
     [<ffffffff8110cbaa>] do_vfs_ioctl+0x8a/0x5a0
     [<ffffffff8110d141>] sys_ioctl+0x81/0xa0
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880090487ce0 (size 544):
   comm "glxinfo", pid 7448, jiffies 4297234607
   backtrace:
     [<ffffffff814ac755>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f4b8b>] kmem_cache_alloc+0xfb/0x180
     [<ffffffff8122404f>] idr_pre_get+0x5f/0x90
     [<ffffffff812c6fed>] drm_gem_handle_create+0x2d/0xa0
     [<ffffffff812e0d60>] i915_gem_create_ioctl+0x60/0xc0
     [<ffffffff812c5c74>] drm_ioctl+0x184/0x3b0
     [<ffffffff8110c6dc>] vfs_ioctl+0x7c/0xa0
     [<ffffffff8110cbaa>] do_vfs_ioctl+0x8a/0x5a0
     [<ffffffff8110d141>] sys_ioctl+0x81/0xa0
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880090486c08 (size 544):
   comm "glxinfo", pid 7458, jiffies 4297234624
   backtrace:
     [<ffffffff814ac755>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f4b8b>] kmem_cache_alloc+0xfb/0x180
     [<ffffffff8122404f>] idr_pre_get+0x5f/0x90
     [<ffffffff812c6fed>] drm_gem_handle_create+0x2d/0xa0
     [<ffffffff812e0d60>] i915_gem_create_ioctl+0x60/0xc0
     [<ffffffff812c5c74>] drm_ioctl+0x184/0x3b0
     [<ffffffff8110c6dc>] vfs_ioctl+0x7c/0xa0
     [<ffffffff8110cbaa>] do_vfs_ioctl+0x8a/0x5a0
     [<ffffffff8110d141>] sys_ioctl+0x81/0xa0
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800619d75a8 (size 544):
   comm "glxinfo", pid 7471, jiffies 4297234637
   backtrace:
     [<ffffffff814ac755>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f4b8b>] kmem_cache_alloc+0xfb/0x180
     [<ffffffff8122404f>] idr_pre_get+0x5f/0x90
     [<ffffffff812c6fed>] drm_gem_handle_create+0x2d/0xa0
     [<ffffffff812e0d60>] i915_gem_create_ioctl+0x60/0xc0
     [<ffffffff812c5c74>] drm_ioctl+0x184/0x3b0
     [<ffffffff8110c6dc>] vfs_ioctl+0x7c/0xa0
     [<ffffffff8110cbaa>] do_vfs_ioctl+0x8a/0x5a0
     [<ffffffff8110d141>] sys_ioctl+0x81/0xa0
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800904875a8 (size 544):
   comm "glxinfo", pid 7475, jiffies 4297234651
   backtrace:
     [<ffffffff814ac755>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f4b8b>] kmem_cache_alloc+0xfb/0x180
     [<ffffffff8122404f>] idr_pre_get+0x5f/0x90
     [<ffffffff812c6fed>] drm_gem_handle_create+0x2d/0xa0
     [<ffffffff812e0d60>] i915_gem_create_ioctl+0x60/0xc0
     [<ffffffff812c5c74>] drm_ioctl+0x184/0x3b0
     [<ffffffff8110c6dc>] vfs_ioctl+0x7c/0xa0
     [<ffffffff8110cbaa>] do_vfs_ioctl+0x8a/0x5a0
     [<ffffffff8110d141>] sys_ioctl+0x81/0xa0
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800619d7ce0 (size 544):
   comm "compiz.real", pid 7479, jiffies 4297234957
   backtrace:
     [<ffffffff814ac755>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f4b8b>] kmem_cache_alloc+0xfb/0x180
     [<ffffffff8122404f>] idr_pre_get+0x5f/0x90
     [<ffffffff812c6fed>] drm_gem_handle_create+0x2d/0xa0
     [<ffffffff812e0d60>] i915_gem_create_ioctl+0x60/0xc0
     [<ffffffff812c5c74>] drm_ioctl+0x184/0x3b0
     [<ffffffff8110c6dc>] vfs_ioctl+0x7c/0xa0
     [<ffffffff8110cbaa>] do_vfs_ioctl+0x8a/0x5a0
     [<ffffffff8110d141>] sys_ioctl+0x81/0xa0
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800619d7810 (size 544):
   comm "compiz.real", pid 7479, jiffies 4297234957
   backtrace:
     [<ffffffff814ac755>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f4b8b>] kmem_cache_alloc+0xfb/0x180
     [<ffffffff8122404f>] idr_pre_get+0x5f/0x90
     [<ffffffff812c6fed>] drm_gem_handle_create+0x2d/0xa0
     [<ffffffff812e0d60>] i915_gem_create_ioctl+0x60/0xc0
     [<ffffffff812c5c74>] drm_ioctl+0x184/0x3b0
     [<ffffffff8110c6dc>] vfs_ioctl+0x7c/0xa0
     [<ffffffff8110cbaa>] do_vfs_ioctl+0x8a/0x5a0
     [<ffffffff8110d141>] sys_ioctl+0x81/0xa0
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880061120000 (size 544):
   comm "compiz.real", pid 7479, jiffies 4297235612
   backtrace:
     [<ffffffff814ac755>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f4b8b>] kmem_cache_alloc+0xfb/0x180
     [<ffffffff8122404f>] idr_pre_get+0x5f/0x90
     [<ffffffff812c6fed>] drm_gem_handle_create+0x2d/0xa0
     [<ffffffff812e0d60>] i915_gem_create_ioctl+0x60/0xc0
     [<ffffffff812c5c74>] drm_ioctl+0x184/0x3b0
     [<ffffffff8110c6dc>] vfs_ioctl+0x7c/0xa0
     [<ffffffff8110cbaa>] do_vfs_ioctl+0x8a/0x5a0
     [<ffffffff8110d141>] sys_ioctl+0x81/0xa0
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880090486000 (size 544):
   comm "glxgears", pid 7624, jiffies 4297237801
   backtrace:
     [<ffffffff814ac755>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f4b8b>] kmem_cache_alloc+0xfb/0x180
     [<ffffffff8122404f>] idr_pre_get+0x5f/0x90
     [<ffffffff812c6fed>] drm_gem_handle_create+0x2d/0xa0
     [<ffffffff812e0d60>] i915_gem_create_ioctl+0x60/0xc0
     [<ffffffff812c5c74>] drm_ioctl+0x184/0x3b0
     [<ffffffff8110c6dc>] vfs_ioctl+0x7c/0xa0
     [<ffffffff8110cbaa>] do_vfs_ioctl+0x8a/0x5a0
     [<ffffffff8110d141>] sys_ioctl+0x81/0xa0
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88009bc54e70 (size 544):
   comm "compiz.real", pid 7479, jiffies 4297251730
   backtrace:
     [<ffffffff814ac755>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f4b8b>] kmem_cache_alloc+0xfb/0x180
     [<ffffffff8122404f>] idr_pre_get+0x5f/0x90
     [<ffffffff812c6fed>] drm_gem_handle_create+0x2d/0xa0
     [<ffffffff812c75f2>] drm_gem_open_ioctl+0xa2/0x100
     [<ffffffff812c5c74>] drm_ioctl+0x184/0x3b0
     [<ffffffff8110c6dc>] vfs_ioctl+0x7c/0xa0
     [<ffffffff8110cbaa>] do_vfs_ioctl+0x8a/0x5a0
     [<ffffffff8110d141>] sys_ioctl+0x81/0xa0
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880061121a78 (size 544):
   comm "glxinfo", pid 8645, jiffies 4297259392
   backtrace:
     [<ffffffff814ac755>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f4b8b>] kmem_cache_alloc+0xfb/0x180
     [<ffffffff8122404f>] idr_pre_get+0x5f/0x90
     [<ffffffff812c6fed>] drm_gem_handle_create+0x2d/0xa0
     [<ffffffff812e0d60>] i915_gem_create_ioctl+0x60/0xc0
     [<ffffffff812c5c74>] drm_ioctl+0x184/0x3b0
     [<ffffffff8110c6dc>] vfs_ioctl+0x7c/0xa0
     [<ffffffff8110cbaa>] do_vfs_ioctl+0x8a/0x5a0
     [<ffffffff8110d141>] sys_ioctl+0x81/0xa0
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8801090b0000 (size 544):
   comm "glxinfo", pid 8647, jiffies 4297259397
   backtrace:
     [<ffffffff814ac755>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f4b8b>] kmem_cache_alloc+0xfb/0x180
     [<ffffffff8122404f>] idr_pre_get+0x5f/0x90
     [<ffffffff812c6fed>] drm_gem_handle_create+0x2d/0xa0
     [<ffffffff812e0d60>] i915_gem_create_ioctl+0x60/0xc0
     [<ffffffff812c5c74>] drm_ioctl+0x184/0x3b0
     [<ffffffff8110c6dc>] vfs_ioctl+0x7c/0xa0
     [<ffffffff8110cbaa>] do_vfs_ioctl+0x8a/0x5a0
     [<ffffffff8110d141>] sys_ioctl+0x81/0xa0
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8801270ac000 (size 544):
   comm "glxinfo", pid 8657, jiffies 4297259407
   backtrace:
     [<ffffffff814ac755>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f4b8b>] kmem_cache_alloc+0xfb/0x180
     [<ffffffff8122404f>] idr_pre_get+0x5f/0x90
     [<ffffffff812c6fed>] drm_gem_handle_create+0x2d/0xa0
     [<ffffffff812e0d60>] i915_gem_create_ioctl+0x60/0xc0
     [<ffffffff812c5c74>] drm_ioctl+0x184/0x3b0
     [<ffffffff8110c6dc>] vfs_ioctl+0x7c/0xa0
     [<ffffffff8110cbaa>] do_vfs_ioctl+0x8a/0x5a0
     [<ffffffff8110d141>] sys_ioctl+0x81/0xa0
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800a6423a78 (size 544):
   comm "glxinfo", pid 8670, jiffies 4297259417
   backtrace:
     [<ffffffff814ac755>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f4b8b>] kmem_cache_alloc+0xfb/0x180
     [<ffffffff8122404f>] idr_pre_get+0x5f/0x90
     [<ffffffff812c6fed>] drm_gem_handle_create+0x2d/0xa0
     [<ffffffff812e0d60>] i915_gem_create_ioctl+0x60/0xc0
     [<ffffffff812c5c74>] drm_ioctl+0x184/0x3b0
     [<ffffffff8110c6dc>] vfs_ioctl+0x7c/0xa0
     [<ffffffff8110cbaa>] do_vfs_ioctl+0x8a/0x5a0
     [<ffffffff8110d141>] sys_ioctl+0x81/0xa0
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800b55375a8 (size 544):
   comm "glxinfo", pid 8674, jiffies 4297259424
   backtrace:
     [<ffffffff814ac755>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f4b8b>] kmem_cache_alloc+0xfb/0x180
     [<ffffffff8122404f>] idr_pre_get+0x5f/0x90
     [<ffffffff812c6fed>] drm_gem_handle_create+0x2d/0xa0
     [<ffffffff812e0d60>] i915_gem_create_ioctl+0x60/0xc0
     [<ffffffff812c5c74>] drm_ioctl+0x184/0x3b0
     [<ffffffff8110c6dc>] vfs_ioctl+0x7c/0xa0
     [<ffffffff8110cbaa>] do_vfs_ioctl+0x8a/0x5a0
     [<ffffffff8110d141>] sys_ioctl+0x81/0xa0
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880090455340 (size 544):
   comm "glxgears", pid 8903, jiffies 4297267454
   backtrace:
     [<ffffffff814ac755>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f4b8b>] kmem_cache_alloc+0xfb/0x180
     [<ffffffff8122404f>] idr_pre_get+0x5f/0x90
     [<ffffffff812c6fed>] drm_gem_handle_create+0x2d/0xa0
     [<ffffffff812e0d60>] i915_gem_create_ioctl+0x60/0xc0
     [<ffffffff812c5c74>] drm_ioctl+0x184/0x3b0
     [<ffffffff8110c6dc>] vfs_ioctl+0x7c/0xa0
     [<ffffffff8110cbaa>] do_vfs_ioctl+0x8a/0x5a0
     [<ffffffff8110d141>] sys_ioctl+0x81/0xa0
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88008716da50 (size 192):
   comm "dbus-daemon", pid 2702, jiffies 4297288472
   backtrace:
     [<ffffffff814ac755>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f596b>] __kmalloc+0x11b/0x210
     [<ffffffff8110e4ef>] do_sys_poll+0xbf/0x500
     [<ffffffff8110eb17>] sys_poll+0x77/0x110
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
