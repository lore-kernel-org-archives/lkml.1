Return-Path: <linux-kernel-owner+w=401wt.eu-S1757580AbYBQF1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580AbYBQF1b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 00:27:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbYBQF1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 00:27:21 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55680 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751735AbYBQF1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 00:27:20 -0500
Date: Sat, 16 Feb 2008 21:27:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] h8300 setup.c initrd support fix
Message-Id: <20080216212708.d032b290.akpm@linux-foundation.org>
In-Reply-To: <877ih42mp0.wl%ysato@users.sourceforge.jp>
References: <87bq6ho2cu.wl%ysato@users.sourceforge.jp>
	<20080215222949.a22ca18e.akpm@linux-foundation.org>
	<87abm02o42.wl%ysato@users.sourceforge.jp>
	<20080216205502.686f1cef.akpm@linux-foundation.org>
	<877ih42mp0.wl%ysato@users.sourceforge.jp>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Feb 2008 00:09:47 -0500 Yoshinori Sato <ysato@users.sourceforge.jp> wrote:

> 
> Sorry. I mistake orign.
> Signed-off-by: Yoshinori Sato <ysato@users.sourceforge.jp>
> 

Please include a full description of your patches!

> 
> diff --git a/arch/h8300/kernel/setup.c b/arch/h8300/kernel/setup.c
> index b1f25c2..4dd744f 100644
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

This is still wrong.

initrd_start and initrd_end have type `unsigned long'.  But the
right-hand-side of these assignemtns has type void*.  THe compiler will
warn.


