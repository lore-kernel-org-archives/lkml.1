Return-Path: <linux-kernel-owner+w=401wt.eu-S1756084AbYDZORW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084AbYDZORW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 10:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbYDZORN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 10:17:13 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:42319 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752112AbYDZORM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 10:17:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: At0EADvWEkhMROPA/2dsb2JhbACBU6kM
Date: Sat, 26 Apr 2008 10:17:10 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Jason Baron <jbaron@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Adrian Bunk <bunk@stusta.de>, Andi Kleen <andi@firstfloor.org>,
       Christoph Hellwig <hch@infradead.org>, akpm@osdl.org
Subject: Re: [patch 13/37] Immediate Values - Architecture Independent Code
Message-ID: <20080426141710.GA11939@Krystal>
References: <20080424150324.802695381@polymtl.ca> <20080424151357.576697846@polymtl.ca> <20080425145552.GA20351@elte.hu> <20080426093641.GA10060@elte.hu> <20080426110901.GA31497@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080426110901.GA31497@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:14:48 up 57 days, 10:25,  3 users,  load average: 0.39, 0.45,
	0.41
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > randconfig testing in sched-devel caught a build bug - fixed by the 
> > > patch below.
> > 
> > found another build failure - the better fix is the one below.
> 
> or rather the one below ...
> 
> ------------>
> Subject: markers: fix2
> From: Ingo Molnar <mingo@elte.hu>
> Date: Sat Apr 26 11:19:00 CEST 2008
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Good catch, thanks!

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

> ---
>  include/linux/module.h |   13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> Index: linux/include/linux/module.h
> ===================================================================
> --- linux.orig/include/linux/module.h
> +++ linux/include/linux/module.h
> @@ -472,9 +472,6 @@ extern void print_modules(void);
>  
>  extern void module_update_markers(void);
>  
> -extern void _module_imv_update(void);
> -extern void module_imv_update(void);
> -
>  #else /* !CONFIG_MODULES... */
>  #define EXPORT_SYMBOL(sym)
>  #define EXPORT_SYMBOL_GPL(sym)
> @@ -579,15 +576,19 @@ static inline void module_update_markers
>  {
>  }
>  
> +#endif /* CONFIG_MODULES */
> +
> +#if defined(CONFIG_MODULES) && defined(CONFIG_IMMEDIATE)
> +extern void _module_imv_update(void);
> +extern void module_imv_update(void);
> +#else
>  static inline void _module_imv_update(void)
>  {
>  }
> -
>  static inline void module_imv_update(void)
>  {
>  }
> -
> -#endif /* CONFIG_MODULES */
> +#endif
>  
>  struct device_driver;
>  #ifdef CONFIG_SYSFS

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
