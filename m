Return-Path: <linux-kernel-owner+w=401wt.eu-S1752334AbYE2FXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334AbYE2FXa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 01:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751070AbYE2FXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 01:23:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:11549 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbYE2FXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 01:23:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VBPMMg7CS1SAWZb8h4xufC6rxlS0UZ39RmOyqjfpqlcEM5PsVMBh7p4j2e91+yWxMdMigfyufaCTh05e8jKKoTUdqbYga34A/hEizZM98eQb0rj45OnmxJ4YW9hz9R1n6nrdYv+fzJcdj3xfq5+VAHsWaJArOAKqTFCERlETwU4=
Message-ID: <21d7e9970805282223i75cb37f8v4883454c08b2ba6e@mail.gmail.com>
Date: Thu, 29 May 2008 15:23:16 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: in-kernel DRM tree move around....
Cc: "kernel list" <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.sourceforge.net>
In-Reply-To: <20080529042335.GA10636@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <21d7e9970805281746k71b47ed2i79c06288d2dca022@mail.gmail.com>
	 <20080529042335.GA10636@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 2:23 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Thu, May 29, 2008 at 10:46:22AM +1000, Dave Airlie wrote:
>> Hi,
>>
>> So I've been growing more annoyed with the current layout of the drm
>> tree in the kernel,
>>
>> a) it lives under char.
>> b) everything in one directory.
>> c) header files in one directory.
>> d) no header files exposed to userspace.
>>
>> http://git.kernel.org/?p=linux/kernel/git/airlied/drm-2.6.git;a=commitdiff;h=7df9a948d0f849466e3de259cccb49bc54cbad68
>>
>> is a proposal to create drivers/gpu/drm, (I may move AGP in there as
>> well later). It also creates per-driver subdirs.
>
> Like it.
>>
>> This to me solves the a-d problems.
>>
>> There is also an out-of-tree kernel drm which I'll probably give some
>> more thought later.
>
> Makefie bits:
> 5 EXTRA_CFLAGS = -Iinclude/drm
> Use ccflags-y :=  -Iinclude/drm
> I assume this is a temporary workaround and you plan to fix
> up all includes to use "#include <drm/fo.h>"

I'd rather not do that due the fact that a lot of these files are
shared with other OSes upstream and I'd rather not diverge too far but
maybe later.

>
> 6 drm-objs    :=  drm_auth.o drm_bufs.o drm_context.o drm_dma.o drm_drawable.o \
> 7                 drm_drv.o drm_fops.o drm_ioctl.o drm_irq.o \
> 8                 drm_lock.o drm_memory.o drm_proc.o drm_stub.o drm_vm.o \
> 9                 drm_agpsupport.o drm_scatter.o ati_pcigart.o drm_pci.o \
> 10                 drm_sysfs.o drm_hashtab.o drm_sman.o drm_mm.o
>
> Use drm-y := ....

cool.. I just re-used the old Makefiles so I'll fix that up in the new ones.

>
> 11
> 12 ifeq ($(CONFIG_COMPAT),y)
> 13 drm-objs    += drm_ioc32.o
> 14 endif
> So you can do:
> drm-$(CONFIG_COMPAT) += drm_ioc32.o
>
> Take the above as general input for all your Makefiles.

Also came from just reusing the old ones, will fix that bit up.

Dave.
