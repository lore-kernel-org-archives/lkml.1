Return-Path: <linux-kernel-owner+w=401wt.eu-S933946AbZHEJaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933946AbZHEJaM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 05:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933853AbZHEJaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 05:30:10 -0400
Received: from mail.free-electrons.com ([88.191.76.200]:53219 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933813AbZHEJaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 05:30:09 -0400
Date: Wed, 5 Aug 2009 11:29:56 +0200
From: Albin Tonnerre <albin.tonnerre@free-electrons.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: sam@ravnborg.org, hpa@zytor.com, linux@arm.linux.org.uk, alain@knaff.lu,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
Subject: Re: [PATCH 2/6] include/linux/unaligned/{l,b}e_byteshift.h: Fix
 usage for compressed kernels
Message-ID: <20090805092956.GD5854@laptop>
References: <20090731093107.GA29704@merkur.ravnborg.org>
 <1249311501-23102-1-git-send-email-albin.tonnerre@free-electrons.com>
 <1249311501-23102-2-git-send-email-albin.tonnerre@free-electrons.com>
 <20090804155550.3203f5f4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090804155550.3203f5f4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 04, 2009 at 03:55:50PM -0700, Andrew Morton wrote :
> On Mon,  3 Aug 2009 16:58:17 +0200
> Albin Tonnerre <albin.tonnerre@free-electrons.com> wrote:

> > When unaligned accesses are required for uncompressing a kernel (such as
> > for LZO decompression on ARM in a patch that follows), including
> > <linux/kernel.h> causes issues as it brings in a lot of things that are
> > not available in the decompression environment.
> > However, those files apparently use nothing from <linux/kernel.h>, all
> > they need is the declaration of types such as u32 or u64, so
> > <linux/types.h> should be enough

> Again, please provide a full description of thes "issues" which a patch
> addresses so that the patch's importance can be understood by others,
> thanks.

linux/kernel.h brings at least:
extern int console_printk[];
extern const char hex_asc[];
which causes errors at link-time as they are not available when
compiling the pre-boot environement. There are also a few others:

arch/arm/boot/compressed/misc.o: In function `valid_user_regs':
/home/albin/devel/free-electrons/gits/linux-2.6/arch/arm/include/asm/ptrace.h:158: undefined reference to `elf_hwcap'
arch/arm/boot/compressed/misc.o: In function `console_silent':
/home/albin/devel/free-electrons/gits/linux-2.6/include/linux/kernel.h:292: undefined reference to `console_printk'
arch/arm/boot/compressed/misc.o: In function `console_verbose':
/home/albin/devel/free-electrons/gits/linux-2.6/include/linux/kernel.h:297: undefined reference to `console_printk'
arch/arm/boot/compressed/misc.o: In function `pack_hex_byte':
/home/albin/devel/free-electrons/gits/linux-2.6/include/linux/kernel.h:360: undefined reference to `hex_asc'
arch/arm/boot/compressed/misc.o: In function `hweight_long':
/home/albin/devel/free-electrons/gits/linux-2.6/include/linux/bitops.h:45: undefined reference to `hweight32'
arch/arm/boot/compressed/misc.o: In function `__cmpxchg_local_generic':
/home/albin/devel/free-electrons/gits/linux-2.6/include/asm-generic/cmpxchg-local.h:21: undefined reference to `wrong_size_cmpxchg'
/home/albin/devel/free-electrons/gits/linux-2.6/include/asm-generic/cmpxchg-local.h:42: undefined reference to `wrong_size_cmpxchg'
arch/arm/boot/compressed/misc.o: In function `__xchg':
/home/albin/devel/free-electrons/gits/linux-2.6/arch/arm/include/asm/system.h:309: undefined reference to `__bad_xchg'
make[2]: *** [arch/arm/boot/compressed/vmlinux] Error 1
make[1]: *** [arch/arm/boot/compressed/vmlinux] Error 2

Regards,
-- 
Albin Tonnerre, Free Electrons
Kernel, drivers and embedded Linux development,
consulting, training and support.
http://free-electrons.com
