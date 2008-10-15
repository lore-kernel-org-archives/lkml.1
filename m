Return-Path: <linux-kernel-owner+w=401wt.eu-S1754434AbYJONpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434AbYJONpc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 09:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbYJONpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 09:45:23 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:49202 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753465AbYJONpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 09:45:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqwEAAeQ9UhMQWq+/2dsb2JhbACBcr9rgWs
Date: Wed, 15 Oct 2008 09:45:19 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip/tracing/markers] markers: remove exported symbol
	marker_probe_cb_noarg()
Message-ID: <20081015134519.GC29281@Krystal>
References: <48F5942A.2060705@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <48F5942A.2060705@cn.fujitsu.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:44:59 up 132 days, 18:25,  9 users,  load average: 0.20, 0.44,
	0.51
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
> 
> marker_probe_cb_noarg() should not be seen by outer code.
> this patch remove it.
> 

Yep, good idea. Thanks!

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/include/linux/marker.h b/include/linux/marker.h
> index 38e32e7..4aca94a 100644
> --- a/include/linux/marker.h
> +++ b/include/linux/marker.h
> @@ -137,8 +137,6 @@ extern marker_probe_func __mark_empty_function;
>  
>  extern void marker_probe_cb(const struct marker *mdata,
>  	void *call_private, ...);
> -extern void marker_probe_cb_noarg(const struct marker *mdata,
> -	void *call_private, ...);
>  
>  /*
>   * Connect a probe to a marker.
> diff --git a/kernel/marker.c b/kernel/marker.c
> index ef43c86..0f2a944 100644
> --- a/kernel/marker.c
> +++ b/kernel/marker.c
> @@ -157,7 +157,7 @@ EXPORT_SYMBOL_GPL(marker_probe_cb);
>   *
>   * Should be connected to markers "MARK_NOARGS".
>   */
> -void marker_probe_cb_noarg(const struct marker *mdata, void *call_private, ...)
> +static void marker_probe_cb_noarg(const struct marker *mdata, void *call_private, ...)
>  {
>  	va_list args;	/* not initialized */
>  	char ptype;
> @@ -197,7 +197,6 @@ void marker_probe_cb_noarg(const struct marker *mdata, void *call_private, ...)
>  	}
>  	rcu_read_unlock_sched();
>  }
> -EXPORT_SYMBOL_GPL(marker_probe_cb_noarg);
>  
>  static void free_old_closure(struct rcu_head *head)
>  {
> 
> 
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
