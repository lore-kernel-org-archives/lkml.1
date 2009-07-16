Return-Path: <linux-kernel-owner+w=401wt.eu-S1754038AbZGPIrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbZGPIrB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 04:47:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbZGPIrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 04:47:01 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:47382 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752590AbZGPIrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 04:47:00 -0400
Subject: Re: Memory leak issues in drm
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Dave Airlie <airlied@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, airlied@gmail.com,
       LKML <linux-kernel@vger.kernel.org>, Eric Anholt <eric@anholt.net>
In-Reply-To: <1247728158.2543.4.camel@ht.satnam>
References: <1247720877.2532.4.camel@ht.satnam>
	 <1247728158.2543.4.camel@ht.satnam>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 16 Jul 2009 09:44:48 +0100
Message-Id: <1247733888.24965.3.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jul 2009 08:44:48.0986 (UTC) FILETIME=[AD8433A0:01CA05F1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-16 at 12:39 +0530, Jaswinder Singh Rajput wrote:
> On Thu, 2009-07-16 at 10:37 +0530, Jaswinder Singh Rajput wrote:
> > On linus tree, while investigating kmemleak issues in drm :
> > 
> > unreferenced object 0xf571dea0 (size 32):
> >   comm "Xorg", pid 1992, jiffies 4294703188
> >   backtrace:
> >     [<c1096655>] create_object+0x140/0x210
> >     [<c10967f2>] kmemleak_alloc+0x25/0x4b
> >     [<c1093b63>] __kmalloc+0xcb/0x153
> >     [<c11ae939>] drm_setversion+0x154/0x1f6
> >     [<c11ad0b1>] drm_ioctl+0x211/0x296
> >     [<c10a2dc9>] vfs_ioctl+0x50/0x69
> >     [<c10a3321>] do_vfs_ioctl+0x49b/0x4d5
> >     [<c10a3387>] sys_ioctl+0x2c/0x45
> >     [<c1002988>] sysenter_do_call+0x12/0x36
> >     [<ffffffff>] 0xffffffff
> > 
> 
> This fixes above memory leak in drm because it was allocating again on
> dev->devname without freeing previous instance and more memory related
> issues, hope this will be helpful:

Thanks for looking into this (I haven't tried the patch yet but it seems
that you found the cause of the leak).

In case you have time, I reported this as well and another in the drm
code - http://lkml.org/lkml/2009/7/9/110 - which happens when a graphics
application exits.

-- 
Catalin

