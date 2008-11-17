Return-Path: <linux-kernel-owner+w=401wt.eu-S1756633AbYKQFjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633AbYKQFjs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 00:39:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbYKQFjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 00:39:40 -0500
Received: from tomts13.bellnexxia.net ([209.226.175.34]:55458 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751140AbYKQFjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 00:39:39 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhIFAMuRIElMQW5N/2dsb2JhbACBbMwrgnk
Date: Mon, 17 Nov 2008 00:39:36 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH] markers/tracpoints: fix non-modular build
Message-ID: <20081117053936.GC28750@Krystal>
References: <20081114224733.364965865@polymtl.ca> <20081114224947.972705093@polymtl.ca> <20081116085254.GA25657@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081116085254.GA25657@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 00:38:46 up  6:19,  2 users,  load average: 0.21, 0.13, 0.10
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Use module notifiers instead of adding a hook in module.c.
> > 
> > Impact: cleanup.
> > 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > CC: 'Ingo Molnar' <mingo@elte.hu>
> > CC: Lai Jiangshan <laijs@cn.fujitsu.com>
> > ---
> >  kernel/marker.c |   29 +++++++++++++++++++++++++++++
> >  kernel/module.c |    4 ----
> >  2 files changed, 29 insertions(+), 4 deletions(-)
> 
> From 227a837567e339c74d9d4243d03a29bd943a018c Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Sun, 16 Nov 2008 09:50:34 +0100
> Subject: [PATCH] markers/tracpoints: fix non-modular build
> 
> fix:
> 
>  kernel/marker.c: In function 'marker_module_notify':
>  kernel/marker.c:905: error: 'MODULE_STATE_COMING' undeclared (first use in this function)
>  [...]
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Yes, that's needed. Thanks for preparing this patch.

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

> ---
>  kernel/marker.c     |    4 ++++
>  kernel/tracepoint.c |    4 ++++
>  2 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/marker.c b/kernel/marker.c
> index c14ec26..ea54f26 100644
> --- a/kernel/marker.c
> +++ b/kernel/marker.c
> @@ -896,6 +896,8 @@ void *marker_get_private_data(const char *name, marker_probe_func *probe,
>  }
>  EXPORT_SYMBOL_GPL(marker_get_private_data);
>  
> +#ifdef CONFIG_MODULES
> +
>  int marker_module_notify(struct notifier_block *self,
>  			 unsigned long val, void *data)
>  {
> @@ -924,3 +926,5 @@ static int init_markers(void)
>  	return register_module_notifier(&marker_module_nb);
>  }
>  __initcall(init_markers);
> +
> +#endif /* CONFIG_MODULES */
> diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> index 94ac4e3..7960274 100644
> --- a/kernel/tracepoint.c
> +++ b/kernel/tracepoint.c
> @@ -542,6 +542,8 @@ void tracepoint_iter_reset(struct tracepoint_iter *iter)
>  }
>  EXPORT_SYMBOL_GPL(tracepoint_iter_reset);
>  
> +#ifdef CONFIG_MODULES
> +
>  int tracepoint_module_notify(struct notifier_block *self,
>  			     unsigned long val, void *data)
>  {
> @@ -570,3 +572,5 @@ static int init_tracepoints(void)
>  	return register_module_notifier(&tracepoint_module_nb);
>  }
>  __initcall(init_tracepoints);
> +
> +#endif /* CONFIG_MODULES */

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
