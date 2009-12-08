Return-Path: <linux-kernel-owner+w=401wt.eu-S965419AbZLHCgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965419AbZLHCgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 21:36:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965405AbZLHCgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 21:36:48 -0500
Received: from 124-219-29-227.vdslpro.static.apol.com.tw ([124.219.29.227]:55942
	"EHLO mswedge2.sunplus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S965390AbZLHCgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 21:36:47 -0500
In-Reply-To: <E1NHUfg-0007xZ-R1@ZenIV.linux.org.uk>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: linux-arch@vger.kernel.org, linux-arch-owner@vger.kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: Re: [PATCH 13/19] Unify sys_mmap*
X-Mailer: Lotus Notes Release 7.0.3 September 26, 2007
Message-ID: <OFB4F0BC92.C5E0A391-ON48257686.000CDDCF-48257686.000E5459@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Tue, 8 Dec 2009 10:36:29 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/12/08 ?? 10:36:30,
	Serialize complete at 2009/12/08 ?? 10:36:30
Content-Type: text/plain; charset="GB2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id nB82b416023371

linux-arch-owner@vger.kernel.org Ğ´ÓÚ 2009-12-07 11:54:00:
> 
> New helper - sys_mmap_pgoff(); switch syscalls to using it.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  arch/alpha/kernel/osf_sys.c               |   19 ++-----
>  arch/arm/kernel/entry-common.S            |    4 +-
>  arch/arm/kernel/sys_arm.c                 |   30 +----------
>  arch/avr32/include/asm/syscalls.h         |    4 --
>  arch/avr32/kernel/sys_avr32.c             |   31 -----------
>  arch/avr32/kernel/syscall-stubs.S         |    2 +-
>  arch/blackfin/kernel/sys_bfin.c           |   33 -----------
>  arch/blackfin/mach-common/entry.S         |    2 +-
>  arch/cris/kernel/sys_cris.c               |   30 +---------
>  arch/frv/kernel/sys_frv.c                 |   66 
+----------------------
>  arch/h8300/kernel/sys_h8300.c             |   83 
+----------------------------
>  arch/h8300/kernel/syscalls.S              |    2 +-
>  arch/ia64/kernel/sys_ia64.c               |   37 +------------
>  arch/m32r/kernel/sys_m32r.c               |   24 --------
>  arch/m32r/kernel/syscall_table.S          |    2 +-
>  arch/m68k/kernel/sys_m68k.c               |   79 
++--------------------------
>  arch/m68knommu/kernel/sys_m68k.c          |   38 +------------
>  arch/m68knommu/kernel/syscalltable.S      |    2 +-
>  arch/microblaze/kernel/sys_microblaze.c   |   38 +------------
>  arch/microblaze/kernel/syscall_table.S    |    2 +-
>  arch/mips/kernel/linux32.c                |   19 +------
>  arch/mips/kernel/syscall.c                |   29 +---------
>  arch/mn10300/kernel/entry.S               |    2 +-
>  arch/mn10300/kernel/sys_mn10300.c         |   31 +----------
>  arch/parisc/kernel/sys_parisc.c           |   30 ++---------
>  arch/powerpc/kernel/syscalls.c            |   15 +-----
>  arch/s390/kernel/compat_linux.c           |   32 +----------
>  arch/s390/kernel/sys_s390.c               |   30 +----------
>  arch/score/kernel/sys_score.c             |   21 +------
>  arch/sh/kernel/sys_sh.c                   |   28 +---------
>  arch/sparc/kernel/sys_sparc_32.c          |   31 ++---------
>  arch/sparc/kernel/sys_sparc_64.c          |   22 ++------
>  arch/um/kernel/syscall.c                  |   28 +---------
>  arch/um/sys-i386/shared/sysdep/syscalls.h |    4 --
>  arch/x86/ia32/ia32entry.S                 |    2 +-
>  arch/x86/ia32/sys_ia32.c                  |   43 +---------------
>  arch/x86/include/asm/sys_ia32.h           |    3 -
>  arch/x86/include/asm/syscalls.h           |    2 -
>  arch/x86/kernel/sys_i386_32.c             |   27 +---------
>  arch/x86/kernel/sys_x86_64.c              |   17 +------
>  arch/x86/kernel/syscall_table_32.S        |    2 +-
>  arch/xtensa/include/asm/syscall.h         |    2 -
>  arch/xtensa/include/asm/unistd.h          |    2 +-
>  arch/xtensa/kernel/syscall.c              |   25 ---------
>  include/linux/syscalls.h                  |    4 ++
>  mm/util.c                                 |   29 ++++++++++
>  46 files changed, 105 insertions(+), 903 deletions(-)
> 
> diff --git a/arch/score/kernel/sys_score.c 
b/arch/score/kernel/sys_score.c
> index 0012494..5299a47 100644
> --- a/arch/score/kernel/sys_score.c
> +++ b/arch/score/kernel/sys_score.c
> @@ -36,33 +36,18 @@ asmlinkage long
>  sys_mmap2(unsigned long addr, unsigned long len, unsigned long prot,
>       unsigned long flags, unsigned long fd, unsigned long pgoff)
>  {
> -   int error = -EBADF;
> -   struct file *file = NULL;
> -
>     if (pgoff & (~PAGE_MASK >> 12))
>        return -EINVAL;
> 
> -   flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
> -   if (!(flags & MAP_ANONYMOUS)) {
> -      file = fget(fd);
> -      if (!file)
> -         return error;
> -   }
> -
> -   down_write(&current->mm->mmap_sem);
> -   error = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
> -   up_write(&current->mm->mmap_sem);
> -
> -   if (file)
> -      fput(file);
> -
> -   return error;
> +   return sys_mmap_pgoff(addr, len, prot, flags, fd, pgoff);
> +   /* sic - almost certainly should shift pgoff as well */
>  }
> 
>  asmlinkage long
>  sys_mmap(unsigned long addr, unsigned long len, unsigned long prot,
>     unsigned long flags, unsigned long fd, off_t pgoff)
>  {
> +   /* where's the alignment check? */
>     return sys_mmap2(addr, len, prot, flags, fd, pgoff >> PAGE_SHIFT);
>  }
> 

It's ok for your update, even 
     if (pgoff & (~PAGE_MASK >> 12))
        return -EINVAL;
code haven't use anymore, you could remove it.

In addition, the sys_mmap should like this.

asmlinkage long
sys_mmap(unsigned long addr, unsigned long len, unsigned long prot,
    unsigned long flags, unsigned long fd, off_t pgoff)
{
        unsigned long result;

        result = -EINVAL;
        if (pgoff & ~PAGE_MASK)
                goto out;

        result = sys_mmap2(addr, len, prot, flags, fd, pgoff >> 
PAGE_SHIFT);
out:
        return result;
} 

Thanks
                liqin


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
