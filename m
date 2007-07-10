Return-Path: <linux-kernel-owner+w=401wt.eu-S1763173AbXGJVmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763173AbXGJVmw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 17:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759238AbXGJVmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 17:42:44 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:57332 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758110AbXGJVmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 17:42:43 -0400
Date: Tue, 10 Jul 2007 23:43:15 +0200
From: Adrian Bunk <bunk@stusta.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Segher Boessenkool <segher@kernel.crashing.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [x86 setup 13/33] Header file to produce 16-bit code with gcc
Message-ID: <20070710214315.GD3492@stusta.de>
References: <11840359321823-git-send-email-hpa@zytor.com> <11840373002601-git-send-email-hpa@zytor.com> <108510B6-B9BE-49D4-BDCA-E25CA20CB29B@kernel.crashing.org> <200707101721.58937.ak@suse.de> <D6BECE27-25FA-4914-B293-4070392258D2@kernel.crashing.org> <4693EF48.1080209@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4693EF48.1080209@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 01:42:48PM -0700, H. Peter Anvin wrote:
> Segher Boessenkool wrote:
> > 
> > Well at least with -fno-toplevel-reorder it is guaranteed
> > to work (not the same thing as "is working", heh, but fairly
> > close).
> > 
> > It seems to me GCC should grow an option to insert .code16gcc
> > by itself (-m16 perhaps?)  Or GAS could get a flag to include
> > a file as a prelude before the main thing.  Neither will help
> > Linux right now of course.
> 
> -m16 is the right thing, and it also provides a proper hook for 
> eventually having a real 16-bit backend (there are at least two 
> projects for doing that.)
> 
> For now, I have:

Can't you use the global CFLAGS and append your specific ones?

> CFLAGS          := $(LINUXINCLUDE) -g -Os -D_SETUP -D__KERNEL__ \

-g ???

>                    $(cflags-$(ARCH)) \
>                    -Wall -Wstrict-prototypes \
>                    -march=i386 -mregparm=3 \

Why -march=i386 ?

>                    -include $(srctree)/$(src)/code16gcc.h \
>                    -fno-strict-aliasing -fomit-frame-pointer \
>                    $(call cc-option, -ffreestanding) \

No need to test, -ffreestanding is supported by all gcc versions we 
support.

>                    $(call cc-option, -fno-unit-at-a-time) \
>                    $(call cc-option, -fno-toplevel-reorder) \
>                    $(call cc-option, -fno-stack-protector) \
>                    $(call cc-option, -mpreferred-stack-boundary=2)
> 
> ... since that will require less violence to eventually hack in the
> proper -m16 option if/when it becomes available.
> 
> 	-hpa

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

