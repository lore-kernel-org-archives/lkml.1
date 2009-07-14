Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838AbZGNO21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbZGNO21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 10:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754811AbZGNO20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 10:28:26 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:44072 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754792AbZGNO2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 10:28:25 -0400
Subject: Re: possible memory leak on i915_gem_create_ioctl
From: Catalin Marinas <catalin.marinas@arm.com>
To: Alexey Fisher <bug-track@fisher-privat.net>
Cc: "kernel-testers-owner@vger.kernel.org" 
	<kernel-testers-owner@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>
In-Reply-To: <4A5C93AD.5050403@fisher-privat.net>
References: <4A5C93AD.5050403@fisher-privat.net>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 14 Jul 2009 15:28:20 +0100
Message-Id: <1247581700.28240.106.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jul 2009 14:28:21.0759 (UTC) FILETIME=[56DC40F0:01CA048F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-14 at 16:18 +0200, Alexey Fisher wrote:
> kmemleak report a lot of possible memory leaks if using any glxrelated 
> applications like glxgears, glxinfo, compiz, cairo-dock with g45 graphic.
> 
> Here is a trace from /sys/kernel/debug/kmemleak:
> 
> unreferenced object 0xffff8800b298e000 (size 544):
>    comm "openarena", pid 5002, jiffies 4296480664
>    backtrace:
>      [<ffffffff814ac755>] kmemleak_alloc+0x25/0x60
>      [<ffffffff810f4b8b>] kmem_cache_alloc+0xfb/0x180
>      [<ffffffff8122404f>] idr_pre_get+0x5f/0x90
>      [<ffffffff812c6fed>] drm_gem_handle_create+0x2d/0xa0
>      [<ffffffff812e0d60>] i915_gem_create_ioctl+0x60/0xc0
>      [<ffffffff812c5c74>] drm_ioctl+0x184/0x3b0
>      [<ffffffff8110c6dc>] vfs_ioctl+0x7c/0xa0
>      [<ffffffff8110cbaa>] do_vfs_ioctl+0x8a/0x5a0
>      [<ffffffff8110d141>] sys_ioctl+0x81/0xa0
>      [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
>      [<ffffffffffffffff>] 0xffffffffffffffff

I already reported these - http://lkml.org/lkml/2009/7/9/110.

They look like real leaks but someone who understands the code better
would need to look at them.

-- 
Catalin

