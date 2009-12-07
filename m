Return-Path: <linux-kernel-owner+w=401wt.eu-S1759056AbZLGIcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759056AbZLGIcG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 03:32:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759068AbZLGIcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 03:32:03 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:54452 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759086AbZLGIcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 03:32:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=cAKWeY1/1gR+Z7R4ztQcXL7p55TCBO5vYhZRmtctn15/9iLaxp7T18FP5iMtobLg9M
         HX6lfktOdcievGdTv9Ps8107GSoe53nREYOmBSS1wjp08reFA9GAvrn3H91ij330x72Q
         tnmFtZ8MDfcb5he3r4dfG872+c7rWjUeYX3Ls=
MIME-Version: 1.0
In-Reply-To: <E1NHUfg-0007xZ-R1@ZenIV.linux.org.uk>
References: <E1NHUfg-0007xZ-R1@ZenIV.linux.org.uk>
Date: Mon, 7 Dec 2009 09:32:05 +0100
X-Google-Sender-Auth: 246c45d86a29a762
Message-ID: <10f740e80912070032j3ef3e9b2n55199d38abf710d2@mail.gmail.com>
Subject: Re: [PATCH 13/19] Unify sys_mmap*
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: linux-arch@vger.kernel.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id nB78WN16015453

On Mon, Dec 7, 2009 at 04:54, Al Viro <viro@ftp.linux.org.uk> wrote:>> New helper - sys_mmap_pgoff(); switch syscalls to using it.>> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>> --->  arch/alpha/kernel/osf_sys.c               |   19 ++----->  arch/arm/kernel/entry-common.S            |    4 +->  arch/arm/kernel/sys_arm.c                 |   30 +---------->  arch/avr32/include/asm/syscalls.h         |    4 -->  arch/avr32/kernel/sys_avr32.c             |   31 ----------->  arch/avr32/kernel/syscall-stubs.S         |    2 +->  arch/blackfin/kernel/sys_bfin.c           |   33 ----------->  arch/blackfin/mach-common/entry.S         |    2 +->  arch/cris/kernel/sys_cris.c               |   30 +--------->  arch/frv/kernel/sys_frv.c                 |   66 +---------------------->  arch/h8300/kernel/sys_h8300.c             |   83 +---------------------------->  arch/h8300/kernel/syscalls.S              |    2 +->  arch/ia64/kernel/sys_ia64.c               |   37 +------------>  arch/m32r/kernel/sys_m32r.c               |   24 -------->  arch/m32r/kernel/syscall_table.S          |    2 +->  arch/m68k/kernel/sys_m68k.c               |   79 ++-------------------------->  arch/m68knommu/kernel/sys_m68k.c          |   38 +------------>  arch/m68knommu/kernel/syscalltable.S      |    2 +->  arch/microblaze/kernel/sys_microblaze.c   |   38 +------------>  arch/microblaze/kernel/syscall_table.S    |    2 +->  arch/mips/kernel/linux32.c                |   19 +------>  arch/mips/kernel/syscall.c                |   29 +--------->  arch/mn10300/kernel/entry.S               |    2 +->  arch/mn10300/kernel/sys_mn10300.c         |   31 +---------->  arch/parisc/kernel/sys_parisc.c           |   30 ++--------->  arch/powerpc/kernel/syscalls.c            |   15 +----->  arch/s390/kernel/compat_linux.c           |   32 +---------->  arch/s390/kernel/sys_s390.c               |   30 +---------->  arch/score/kernel/sys_score.c             |   21 +------>  arch/sh/kernel/sys_sh.c                   |   28 +--------->  arch/sparc/kernel/sys_sparc_32.c          |   31 ++--------->  arch/sparc/kernel/sys_sparc_64.c          |   22 ++------>  arch/um/kernel/syscall.c                  |   28 +--------->  arch/um/sys-i386/shared/sysdep/syscalls.h |    4 -->  arch/x86/ia32/ia32entry.S                 |    2 +->  arch/x86/ia32/sys_ia32.c                  |   43 +--------------->  arch/x86/include/asm/sys_ia32.h           |    3 ->  arch/x86/include/asm/syscalls.h           |    2 ->  arch/x86/kernel/sys_i386_32.c             |   27 +--------->  arch/x86/kernel/sys_x86_64.c              |   17 +------>  arch/x86/kernel/syscall_table_32.S        |    2 +->  arch/xtensa/include/asm/syscall.h         |    2 ->  arch/xtensa/include/asm/unistd.h          |    2 +->  arch/xtensa/kernel/syscall.c              |   25 --------->  include/linux/syscalls.h                  |    4 ++>  mm/util.c                                 |   29 ++++++++++>  46 files changed, 105 insertions(+), 903 deletions(-)>
> diff --git a/arch/m68k/kernel/sys_m68k.c b/arch/m68k/kernel/sys_m68k.c> index 7deb402..fdab0f0 100644> --- a/arch/m68k/kernel/sys_m68k.c> +++ b/arch/m68k/kernel/sys_m68k.c> @@ -29,37 +29,12 @@>  #include <asm/page.h>>  #include <asm/unistd.h>>> -/* common code for old and new mmaps */> -static inline long do_mmap2(> -       unsigned long addr, unsigned long len,> -       unsigned long prot, unsigned long flags,> -       unsigned long fd, unsigned long pgoff)> -{> -       int error = -EBADF;> -       struct file * file = NULL;> -> -       flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);> -       if (!(flags & MAP_ANONYMOUS)) {> -               file = fget(fd);> -               if (!file)> -                       goto out;> -       }> -> -       down_write(&current->mm->mmap_sem);> -       error = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);> -       up_write(&current->mm->mmap_sem);> -> -       if (file)> -               fput(file);> -out:> -       return error;> -}> ->  asmlinkage long sys_mmap2(unsigned long addr, unsigned long len,>        unsigned long prot, unsigned long flags,>        unsigned long fd, unsigned long pgoff)>  {> -       return do_mmap2(addr, len, prot, flags, fd, pgoff);> +       /* this is wrong for sun3, BTW */
Can you please add the why part to the comment?Thanks!
> +       return sys_mmap_pgoff(addr, len, prot, flags, fd, pgoff);>  }>>  /*> @@ -90,57 +65,11 @@ asmlinkage int old_mmap(struct mmap_arg_struct __user *arg)>        if (a.offset & ~PAGE_MASK)>                goto out;>> -       a.flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);> -> -       error = do_mmap2(a.addr, a.len, a.prot, a.flags, a.fd, a.offset >> PAGE_SHIFT);> -out:> -       return error;> -}> -> -#if 0> -struct mmap_arg_struct64 {> -       __u32 addr;> -       __u32 len;> -       __u32 prot;> -       __u32 flags;> -       __u64 offset; /* 64 bits */> -       __u32 fd;> -};> -> -asmlinkage long sys_mmap64(struct mmap_arg_struct64 *arg)> -{> -       int error = -EFAULT;> -       struct file * file = NULL;> -       struct mmap_arg_struct64 a;> -       unsigned long pgoff;> -> -       if (copy_from_user(&a, arg, sizeof(a)))> -               return -EFAULT;> -> -       if ((long)a.offset & ~PAGE_MASK)> -               return -EINVAL;> -> -       pgoff = a.offset >> PAGE_SHIFT;> -       if ((a.offset >> PAGE_SHIFT) != pgoff)> -               return -EINVAL;> -> -       if (!(a.flags & MAP_ANONYMOUS)) {> -               error = -EBADF;> -               file = fget(a.fd);> -               if (!file)> -                       goto out;> -       }> -       a.flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);> -> -       down_write(&current->mm->mmap_sem);> -       error = do_mmap_pgoff(file, a.addr, a.len, a.prot, a.flags, pgoff);> -       up_write(&current->mm->mmap_sem);> -       if (file)> -               fput(file);> +       error = sys_mmap_pgoff(a.addr, a.len, a.prot, a.flags, a.fd,> +                              a.offset >> PAGE_SHIFT);>  out:>        return error;>  }> -#endif>>  struct sel_arg_struct {>        unsigned long n;
Gr{oetje,eeting}s,
						Geert
--Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
In personal conversations with technical people, I call myself a hacker. Butwhen I'm talking to journalists I just say "programmer" or something like that.							    -- Linus Torvalds���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
