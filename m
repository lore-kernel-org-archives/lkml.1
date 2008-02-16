Return-Path: <linux-kernel-owner+w=401wt.eu-S1760431AbYBPGaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760431AbYBPGaT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 01:30:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbYBPGaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 01:30:05 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57332 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752410AbYBPGaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 01:30:03 -0500
Date: Fri, 15 Feb 2008 22:29:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] h8300 setup.c initrd support fix
Message-Id: <20080215222949.a22ca18e.akpm@linux-foundation.org>
In-Reply-To: <87bq6ho2cu.wl%ysato@users.sourceforge.jp>
References: <87bq6ho2cu.wl%ysato@users.sourceforge.jp>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2008 01:13:37 -0500 Yoshinori Sato <ysato@users.sourceforge.jp> wrote:

> initrd setting fix.
> 
>  arch/h8300/kernel/setup.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/h8300/kernel/setup.c b/arch/h8300/kernel/setup.c
> index b1f25c2..75712ec 100644
> --- a/arch/h8300/kernel/setup.c
> +++ b/arch/h8300/kernel/setup.c
> @@ -57,6 +57,7 @@ extern int _stext, _etext, _sdata, _edata, _sbss, _ebss, _end;
>  extern int _ramstart, _ramend;
>  extern char _target_name[];
>  extern void h8300_gpio_init(void);
> +extern void *initrd_start, *initrd_end;
>  
>  #if (defined(CONFIG_H8300H_SIM) || defined(CONFIG_H8S_SIM)) \
>      && defined(CONFIG_GDB_MAGICPRINT)
> @@ -99,8 +100,8 @@ void __init setup_arch(char **cmdline_p)
>  	/* allow for ROMFS on the end of the kernel */
>  	if (memcmp((void *)memory_start, "-rom1fs-", 8) == 0) {
>  #if defined(CONFIG_BLK_DEV_INITRD)
> -		initrd_start = memory_start;
> -		initrd_end = memory_start += be32_to_cpu(((unsigned long *) (memory_start))[2]);
> +		initrd_start = (void *)memory_start;
> +		initrd_end = (void *)(memory_start += be32_to_cpu(((unsigned long *) (memory_start))[2]));
>  #else
>  		memory_start += be32_to_cpu(((unsigned long *) memory_start)[2]);
>  #endif

But include/linux/initrd.h declares:

	extern unsigned long initrd_start, initrd_end;

