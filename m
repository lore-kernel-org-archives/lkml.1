Return-Path: <linux-kernel-owner+w=401wt.eu-S1754861AbZJ1QAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbZJ1QAZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 12:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754842AbZJ1QAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 12:00:21 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:35782 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757AbZJ1QAT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 12:00:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XTPhwtSw28hZ/XpxvNIqZ7TObblHCXF0IF5zJtPmi5046+WNVh5AJKcW8R5lf/6FCn
         4wiMc7k16K/oG3V9ubzSCzuMENUu1lIarMZfOsUErn4S4ew2Af4ywvASobyDGWS8h+jd
         tRA4+R51o+6UobEvCDtqmiHEtVW0AQjBE+UjY=
MIME-Version: 1.0
In-Reply-To: <7b6bb4a50910272007i2c931012y13d204402d65a589@mail.gmail.com>
References: <55e03a0a0910271350r6900aaf3qed4cbf31b6359727@mail.gmail.com>
	 <7b6bb4a50910272007i2c931012y13d204402d65a589@mail.gmail.com>
Date: Wed, 28 Oct 2009 12:00:22 -0400
Message-ID: <55e03a0a0910280900m55f8939ci987b7f21bb10bcda@mail.gmail.com>
Subject: Re: 2.6.32-rc5-git3 compile problems
From: Alex <mysqlstudent@gmail.com>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Try this patch, thanks.

I believe your patch to rcutree_plugin.h and rcutree.h worked, but I'm
now still having difficulty with con_init():

  GEN     .version
  CHK     include/linux/compile.h
  UPD     include/linux/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
drivers/built-in.o: In function `con_init':
vt.c:(.init.text+0x3a6b): undefined reference to `.L1626'
make: *** [.tmp_vmlinux1] Error 1

Is this also a bug, or am I doing something wrong? Is there something
I can do to produce more debugging info, or troubleshoot it further?

This is 2.6.32-rc5-git3, gcc-3.4.4, glibc-2.3.6, and binutils-2.20.51.0.2.

Thanks,
Alex

> ---
> index b40ac57..04a4272 100644
> --- a/kernel/rcutree.h
> +++ b/kernel/rcutree.h
> @@ -292,8 +292,24 @@ DECLARE_PER_CPU(struct rcu_data, rcu_preempt_data);
>
>  #else /* #ifdef RCU_TREE_NONCORE */
>
> -/* Forward declarations for rcutree_plugin.h */
> -static inline void rcu_bootup_announce(void);
> +#ifdef CONFIG_TREE_PREEMPT_RCU
> +/*
> + * Tell them what RCU they are running.
> + */
> +static inline void rcu_bootup_announce(void)
> +{
> +        printk(KERN_INFO
> +               "Experimental preemptable hierarchical RCU implementation.\n");
> +}
> +#else
> +/*
> + * Tell them what RCU they are running.
> + */
