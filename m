Return-Path: <linux-kernel-owner+w=401wt.eu-S1754390AbYE2EXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbYE2EXH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 00:23:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751106AbYE2EWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 00:22:55 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:46050 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbYE2EWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 00:22:55 -0400
Date: Thu, 29 May 2008 06:23:35 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Dave Airlie <airlied@gmail.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.sourceforge.net>
Subject: Re: in-kernel DRM tree move around....
Message-ID: <20080529042335.GA10636@uranus.ravnborg.org>
References: <21d7e9970805281746k71b47ed2i79c06288d2dca022@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d7e9970805281746k71b47ed2i79c06288d2dca022@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 10:46:22AM +1000, Dave Airlie wrote:
> Hi,
> 
> So I've been growing more annoyed with the current layout of the drm
> tree in the kernel,
> 
> a) it lives under char.
> b) everything in one directory.
> c) header files in one directory.
> d) no header files exposed to userspace.
> 
> http://git.kernel.org/?p=linux/kernel/git/airlied/drm-2.6.git;a=commitdiff;h=7df9a948d0f849466e3de259cccb49bc54cbad68
> 
> is a proposal to create drivers/gpu/drm, (I may move AGP in there as
> well later). It also creates per-driver subdirs.

Like it.
> 
> This to me solves the a-d problems.
> 
> There is also an out-of-tree kernel drm which I'll probably give some
> more thought later.

Makefie bits:
5 EXTRA_CFLAGS = -Iinclude/drm
Use ccflags-y :=  -Iinclude/drm
I assume this is a temporary workaround and you plan to fix
up all includes to use "#include <drm/fo.h>"

6 drm-objs    :=  drm_auth.o drm_bufs.o drm_context.o drm_dma.o drm_drawable.o \
7                 drm_drv.o drm_fops.o drm_ioctl.o drm_irq.o \
8                 drm_lock.o drm_memory.o drm_proc.o drm_stub.o drm_vm.o \
9                 drm_agpsupport.o drm_scatter.o ati_pcigart.o drm_pci.o \
10                 drm_sysfs.o drm_hashtab.o drm_sman.o drm_mm.o

Use drm-y := ....

11
12 ifeq ($(CONFIG_COMPAT),y)
13 drm-objs    += drm_ioc32.o
14 endif
So you can do:
drm-$(CONFIG_COMPAT) += drm_ioc32.o

Take the above as general input for all your Makefiles.

