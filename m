Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbZLBIfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbZLBIfK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 03:35:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754459AbZLBIfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 03:35:09 -0500
Received: from ernst.netinsight.se ([194.16.221.21]:43262 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752501AbZLBIfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 03:35:08 -0500
Date: Wed, 2 Dec 2009 09:35:08 +0100
From: Simon Kagstrom <simon.kagstrom@netinsight.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwm2@infradead.org>,
       Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCH -next] kmsg_dump: fix build for CONFIG_PRINTK=n
Message-ID: <20091202093508.1f174b6b@marrow.netinsight.se>
In-Reply-To: <4B1565D2.2030505@oracle.com>
References: <20091201190301.0fb7abad.sfr@canb.auug.org.au>
	<4B1565D2.2030505@oracle.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 Dec 2009 10:52:02 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> kmsg_dump() fails to build when CONFIG_PRINTK=n; provide stubs
> for the kmsg_dump*() functions when CONFIG_PRINTK=n.
> 
> kernel/printk.c: In function 'kmsg_dump':
> kernel/printk.c:1501: error: 'log_buf_len' undeclared (first use in this function)
> kernel/printk.c:1502: error: 'logged_chars' undeclared (first use in this function)
> kernel/printk.c:1506: error: 'log_buf' undeclared (first use in this function)
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Acked-by: Simon Kagstrom <simon.kagstrom@netinsight.net>

David/Artem: Will you take Randys patch
(http://lkml.org/lkml/2009/12/1/313) into your tree as well?

// Simon

> Cc: Simon Kagstrom <simon.kagstrom@netinsight.net>
> ---
>  include/linux/kmsg_dump.h |   16 ++++++++++++++++
>  kernel/printk.c           |    2 +-
>  2 files changed, 17 insertions(+), 1 deletion(-)
> 
> --- linux-next-20091201.orig/kernel/printk.c
> +++ linux-next-20091201/kernel/printk.c
> @@ -1406,7 +1406,6 @@ bool printk_timed_ratelimit(unsigned lon
>  	return false;
>  }
>  EXPORT_SYMBOL(printk_timed_ratelimit);
> -#endif
>  
>  static DEFINE_SPINLOCK(dump_list_lock);
>  static LIST_HEAD(dump_list);
> @@ -1525,3 +1524,4 @@ void kmsg_dump(enum kmsg_dump_reason rea
>  		dumper->dump(dumper, reason, s1, l1, s2, l2);
>  	spin_unlock_irqrestore(&dump_list_lock, flags);
>  }
> +#endif
> --- linux-next-20091201.orig/include/linux/kmsg_dump.h
> +++ linux-next-20091201/include/linux/kmsg_dump.h
> @@ -35,10 +35,26 @@ struct kmsg_dumper {
>  	int registered;
>  };
>  
> +#ifdef CONFIG_PRINTK
>  void kmsg_dump(enum kmsg_dump_reason reason);
>  
>  int kmsg_dump_register(struct kmsg_dumper *dumper);
>  
>  int kmsg_dump_unregister(struct kmsg_dumper *dumper);
> +#else
> +static inline void kmsg_dump(enum kmsg_dump_reason reason)
> +{
> +}
> +
> +static inline int kmsg_dump_register(struct kmsg_dumper *dumper)
> +{
> +	return -EINVAL;
> +}
> +
> +static inline int kmsg_dump_unregister(struct kmsg_dumper *dumper)
> +{
> +	return -EINVAL;
> +}
> +#endif
>  
>  #endif /* _LINUX_KMSG_DUMP_H */

