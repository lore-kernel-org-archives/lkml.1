Return-Path: <linux-kernel-owner+w=401wt.eu-S1757447AbYBQEz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447AbYBQEz2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 23:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753261AbYBQEzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 23:55:20 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46957 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754202AbYBQEzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 23:55:19 -0500
Date: Sat, 16 Feb 2008 20:55:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] h8300 setup.c initrd support fix
Message-Id: <20080216205502.686f1cef.akpm@linux-foundation.org>
In-Reply-To: <87abm02o42.wl%ysato@users.sourceforge.jp>
References: <87bq6ho2cu.wl%ysato@users.sourceforge.jp>
	<20080215222949.a22ca18e.akpm@linux-foundation.org>
	<87abm02o42.wl%ysato@users.sourceforge.jp>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2008 23:39:09 -0500 Yoshinori Sato <ysato@users.sourceforge.jp> wrote:

> At Fri, 15 Feb 2008 22:29:49 -0800,
> Andrew Morton wrote:
> > 
> > On Sat, 16 Feb 2008 01:13:37 -0500 Yoshinori Sato <ysato@users.sourceforge.jp> wrote:
> > 
> > > initrd setting fix.
> > > 
> > >  arch/h8300/kernel/setup.c |    5 +++--
> > >  1 files changed, 3 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arch/h8300/kernel/setup.c b/arch/h8300/kernel/setup.c
> > > index b1f25c2..75712ec 100644
> > > --- a/arch/h8300/kernel/setup.c
> > > +++ b/arch/h8300/kernel/setup.c
> > > @@ -57,6 +57,7 @@ extern int _stext, _etext, _sdata, _edata, _sbss, _ebss, _end;
> > >  extern int _ramstart, _ramend;
> > >  extern char _target_name[];
> > >  extern void h8300_gpio_init(void);
> > > +extern void *initrd_start, *initrd_end;
> > >  
> > >  #if (defined(CONFIG_H8300H_SIM) || defined(CONFIG_H8S_SIM)) \
> > >      && defined(CONFIG_GDB_MAGICPRINT)
> > > @@ -99,8 +100,8 @@ void __init setup_arch(char **cmdline_p)
> > >  	/* allow for ROMFS on the end of the kernel */
> > >  	if (memcmp((void *)memory_start, "-rom1fs-", 8) == 0) {
> > >  #if defined(CONFIG_BLK_DEV_INITRD)
> > > -		initrd_start = memory_start;
> > > -		initrd_end = memory_start += be32_to_cpu(((unsigned long *) (memory_start))[2]);
> > > +		initrd_start = (void *)memory_start;
> > > +		initrd_end = (void *)(memory_start += be32_to_cpu(((unsigned long *) (memory_start))[2]));
> > >  #else
> > >  		memory_start += be32_to_cpu(((unsigned long *) memory_start)[2]);
> > >  #endif
> > 
> > But include/linux/initrd.h declares:
> > 
> > 	extern unsigned long initrd_start, initrd_end;
> > 
> 
> fix it.

I assume this new patch is an addition to the previous one quoted above?

> Signed-off-by: Yoshinori Sato <ysato@users.sourceforge.jp>
> 
>  arch/h8300/kernel/setup.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/h8300/kernel/setup.c b/arch/h8300/kernel/setup.c
> index 75712ec..4dd744f 100644
> --- a/arch/h8300/kernel/setup.c
> +++ b/arch/h8300/kernel/setup.c
> @@ -30,6 +30,7 @@
>  #include <linux/bootmem.h>
>  #include <linux/seq_file.h>
>  #include <linux/init.h>
> +#include <linux/initrd.h>
>  
>  #include <asm/setup.h>
>  #include <asm/irq.h>
> @@ -57,7 +58,6 @@ extern int _stext, _etext, _sdata, _edata, _sbss, _ebss, _end;
>  extern int _ramstart, _ramend;
>  extern char _target_name[];
>  extern void h8300_gpio_init(void);
> -extern void *initrd_start, *initrd_end;
>  
>  #if (defined(CONFIG_H8300H_SIM) || defined(CONFIG_H8S_SIM)) \
>      && defined(CONFIG_GDB_MAGICPRINT)

If so then surely it generated a warning when assigning a void* to an
unsigned long.

So please send a complete new fully tested patch.  Please also include a
changelog which describes what is being fixed, and how it is fixed.  The
text "initrd setting fix." and "fit it" is not sufficient - it doesn't
tell us what was wrong with the old code, nor how the change improved it.

Thanks.
